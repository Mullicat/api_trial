// lib/services/edge_detect_service.dart
//
// PURPOSE
// -------
// Card edge detection & perspective warp utilities using opencv_dart.
// - Accepts camera preview grayscale (Y plane) and finds the most "card-like"
//   quadrilateral (doc-scanner style).
// - Optionally restricts search to an ROI (preview-space rect).
// - Warps a captured full-resolution JPEG to a rectified, front-on card image.
//
// HOW TO READ THIS FILE
// ---------------------
// • PUBLIC API
//   - EdgeDetectService.detectCardQuadOnGrayU8(...)  -> finds a quad (TL,TR,BR,BL)
//   - EdgeDetectService.warpAndWriteJpeg(...)        -> perspective-corrects to JPEG
//
// • IMPLEMENTATION SECTIONS
//   1) Imports & Class
//   2) Quad Detection (public)              <-- start here
//   3) Warping / Rectification (public)
//   4) Helpers (private)
//   5) Lightweight Rect class (non-UI)
//
// NOTES
// -----
// - This file purposely DOES NOT import flutter:ui Rect to avoid transitive
//   Flutter framework dependency in this low-level service.
// - All Mats/Vecs allocated must be disposed to avoid native memory leaks.
// - All coordinates for detection are in PREVIEW SPACE (width x height).
//

// === 1) IMPORTS & CLASS ======================================================

import 'dart:ffi';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:io';

import 'package:ffi/ffi.dart' as ffi;
import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'package:path_provider/path_provider.dart';

/// Public service for edge detection and perspective warp.
class EdgeDetectService {
  // === 2) QUAD DETECTION (PUBLIC) ===========================================
  //
  // Detect the best card-like quadrilateral on a grayscale (8UC1) frame.
  // INPUT
  //  - gray: Y-plane bytes of preview frame
  //  - width/height: preview dimensions
  //  - roi (optional): preview-space rect to bias/limit detection
  // OUTPUT
  //  - List<cv.Point2f> of 4 points in clockwise order (TL, TR, BR, BL), or null
  //
  List<cv.Point2f>? detectCardQuadOnGrayU8({
    required Uint8List gray,
    required int width,
    required int height,
    Rect? roi, // preview-space ROI (optional)
  }) {
    cv.Mat? matGray;
    cv.Mat? blurred;
    cv.Mat? edges;
    cv.Mat? edgesDil;
    cv.Mat? edgesClose;
    cv.Mat? kernel3;
    cv.Mat? kernel5;

    // Create a native buffer to wrap into a Mat (and then clone).
    final int byteCount = width * height;
    final Pointer<Uint8> native = ffi.calloc<Uint8>(byteCount);

    try {
      // Copy Dart bytes → native buffer
      native.asTypedList(byteCount).setAll(0, gray);

      // Wrap the native buffer (no-copy), then clone to an owned Mat.
      final temp = cv.Mat.fromBuffer(
        height,
        width,
        cv.MatType.CV_8UC1,
        native.cast(),
      );
      matGray = temp.clone();
      temp.dispose();

      // (A) DENOISE: gentle blur to help Canny detect consistent edges.
      blurred = cv.gaussianBlur(matGray, (5, 5), 1.2, sigmaY: 0);

      // (B) ADAPTIVE CANNY: derive thresholds from Otsu (proxy for contrast).
      final otsu = _otsuThresholdValue(blurred);
      final t1 = (0.5 * otsu).clamp(10, 80).toInt();
      final t2 = (1.5 * otsu).clamp(80, 220).toInt();
      edges = cv.canny(blurred, t1.toDouble(), t2.toDouble());

      // (C) MORPHOLOGY: close gaps → light dilate to reinforce contours.
      kernel3 = cv.getStructuringElement(cv.MORPH_RECT, (3, 3));
      kernel5 = cv.getStructuringElement(cv.MORPH_RECT, (5, 5));
      edgesClose = cv.morphologyEx(edges, cv.MORPH_CLOSE, kernel3);
      edgesDil = cv.dilate(edgesClose, kernel3);

      // (D) CONTOURS: consider external contours only.
      final (contours, _) = cv.findContours(
        edgesDil,
        cv.RETR_EXTERNAL,
        cv.CHAIN_APPROX_SIMPLE,
      );

      // Define ROI (if not provided we use a generous inset box).
      final imgArea = (width * height).toDouble();
      final roiRect =
          roi ??
          Rect.fromLTWH(
            width * 0.07,
            height * 0.07,
            width * 0.86,
            height * 0.86,
          );
      final roiArea = roiRect.width * roiRect.height;

      double bestScore = 0.0;
      List<cv.Point2f>? bestQuad;

      for (final cnt in contours) {
        // (1) AREA CHECK: require a reasonable minimum.
        final area = cv.contourArea(cnt).abs();
        final minArea = roi == null ? imgArea * 0.02 : roiArea * 0.01;
        if (area < minArea) continue;

        // (2) POLY APPROXIMATION: prefer convex quads.
        final peri = cv.arcLength(cnt, true);
        final approx = cv.approxPolyDP(cnt, 0.02 * peri, true);
        if (approx.length != 4) continue;
        if (!cv.isContourConvex(approx)) continue;

        // Convert to Point2f and order (TL,TR,BR,BL).
        final quad = <cv.Point2f>[
          for (var i = 0; i < approx.length; i++)
            cv.Point2f(approx[i].x.toDouble(), approx[i].y.toDouble()),
        ];
        final ordered = _orderQuad(quad);

        // (3) ASPECT CHECK: trading card ~63x88mm → ~0.716 (width/height).
        final w = _distance(ordered[0], ordered[1]);
        final h = _distance(ordered[1], ordered[2]);
        if (w <= 1 || h <= 1) continue;

        final ratio = w / h; // width / height
        // Flexible band to allow tilt/crop/sleeves:
        if (ratio < 0.58 || ratio > 0.85) continue;

        // (4) ANGLE CHECK: ensure near-rectangular corners (allow perspective).
        final cosMax = _maxCosine(ordered); // 0 → perfect right angle
        if (cosMax > 0.35) continue;

        // (5) RECTANGULARITY: favor contours close to their min-area-rect.
        final rect = cv.minAreaRect(cnt);
        final rectArea = (rect.size.width * rect.size.height).abs();
        if (rectArea <= 0) continue;
        final rectangularity = (area / rectArea).clamp(0.0, 1.0);

        // (6) ROI BIAS: prefer quads inside the guide/ROI.
        final bounds = cv.boundingRect(cnt);
        final bx = bounds.x.toDouble();
        final by = bounds.y.toDouble();
        final bw = bounds.width.toDouble();
        final bh = bounds.height.toDouble();
        final iou = _rectIoU(Rect.fromLTWH(bx, by, bw, bh), roiRect);

        // (7) SCORE: area * rectangularity * roiWeight
        final roiWeight = roi == null ? 1.0 : (0.6 + 0.4 * iou); // 0.6..1.0
        final score = area * rectangularity * roiWeight;

        if (score > bestScore) {
          bestScore = score;
          bestQuad = ordered;
        }
      }

      return bestQuad;
    } catch (_) {
      // Swallow and return null—callers treat as "no detection this frame".
      return null;
    } finally {
      // Always free native memory & Mats.
      ffi.calloc.free(native);
      kernel5?.dispose();
      kernel3?.dispose();
      edgesClose?.dispose();
      edgesDil?.dispose();
      edges?.dispose();
      blurred?.dispose();
      matGray?.dispose();
    }
  }

  // === 3) WARPING / RECTIFICATION (PUBLIC) ===================================
  //
  // Warp a full-resolution color JPEG to a rectified card image.
  // INPUT
  //  - srcJpeg: captured still photo (color)
  //  - quad: the 4 source corners (same coordinate space as srcJpeg)
  //  - outWidth/outHeight: output dimensions (default ~63x88 @ 10px/mm)
  // OUTPUT
  //  - File pointing to newly written JPEG in app temp directory, or null
  //
  Future<File?> warpAndWriteJpeg({
    required File srcJpeg,
    required List<cv.Point2f> quad,
    int outWidth = 630,
    int outHeight = 880,
  }) async {
    cv.Mat? src;
    cv.Mat? warped;
    cv.Mat? M;
    cv.VecPoint2f? srcPts;
    cv.VecPoint2f? dstPts;

    try {
      // Read color JPEG to Mat.
      final bytes = await srcJpeg.readAsBytes();
      src = cv.imdecode(bytes, cv.IMREAD_COLOR);
      if (src.isEmpty) return null;

      // Prepare perspective transform.
      srcPts = cv.VecPoint2f.fromList(quad);
      dstPts = cv.VecPoint2f.fromList(<cv.Point2f>[
        cv.Point2f(0, 0),
        cv.Point2f(outWidth - 1.0, 0),
        cv.Point2f(outWidth - 1.0, outHeight - 1.0),
        cv.Point2f(0, outHeight - 1.0),
      ]);

      M = cv.getPerspectiveTransform(
        srcPts as cv.VecPoint,
        dstPts as cv.VecPoint,
      );

      // Warp to a front-on card image.
      warped = cv.warpPerspective(src, M, (
        outWidth,
        outHeight,
      ), flags: cv.INTER_CUBIC);

      // Write to temp file.
      final dir = await getTemporaryDirectory();
      final outPath =
          '${dir.path}/card_${DateTime.now().millisecondsSinceEpoch}.jpg';
      cv.imwrite(outPath, warped);

      return File(outPath);
    } catch (_) {
      return null;
    } finally {
      // Dispose native resources.
      dstPts?.dispose();
      srcPts?.dispose();
      M?.dispose();
      warped?.dispose();
      src?.dispose();
    }
  }

  // === 4) HELPERS (PRIVATE) ==================================================

  /// Compute Otsu threshold value (0..255) without caring about the result mask.
  int _otsuThresholdValue(cv.Mat srcGray) {
    // cv.threshold returns (ret, dst). We keep 'ret' and dispose 'dst'.
    final result = cv.threshold(
      srcGray,
      0,
      255,
      cv.THRESH_BINARY | cv.THRESH_OTSU,
    );
    try {
      final threshValue = result.$1.toInt();
      result.$2.dispose();
      return threshValue;
    } catch (_) {
      result.$2.dispose();
      return 100; // reasonable fallback
    }
  }

  /// Euclidean distance between two points.
  double _distance(cv.Point2f a, cv.Point2f b) {
    final dx = a.x - b.x;
    final dy = a.y - b.y;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Maximum cosine among internal angles of the quad (0 = perfect right angle).
  double _maxCosine(List<cv.Point2f> q) {
    double maxCos = 0;
    for (int i = 0; i < 4; i++) {
      final p0 = q[i];
      final p1 = q[(i + 1) % 4];
      final p2 = q[(i + 2) % 4];

      final v1x = p1.x - p0.x, v1y = p1.y - p0.y;
      final v2x = p2.x - p1.x, v2y = p2.y - p1.y;

      final dot = (v1x * v2x + v1y * v2y);
      final n1 = math.sqrt(v1x * v1x + v1y * v1y);
      final n2 = math.sqrt(v2x * v2x + v2y * v2y);
      if (n1 == 0 || n2 == 0) continue;

      final cos = (dot / (n1 * n2)).abs();
      if (cos > maxCos) maxCos = cos;
    }
    return maxCos;
  }

  /// Intersection-over-Union between two preview-space rects.
  double _rectIoU(Rect a, Rect b) {
    final ix = math.max(a.left, b.left);
    final iy = math.max(a.top, b.top);
    final ax = math.min(a.right, b.right);
    final ay = math.min(a.bottom, b.bottom);
    final iw = math.max(0.0, ax - ix);
    final ih = math.max(0.0, ay - iy);
    final inter = iw * ih;
    final uni = a.width * a.height + b.width * b.height - inter;
    if (uni <= 0) return 0;
    return inter / uni;
  }

  /// Orders 4 points clockwise starting from top-left via sum/diff heuristic.
  List<cv.Point2f> _orderQuad(List<cv.Point2f> pts) {
    cv.Point2f tl = pts.first, tr = pts.first, br = pts.first, bl = pts.first;
    double minSum = 1e9, maxSum = -1e9, minDiff = 1e9, maxDiff = -1e9;

    for (final p in pts) {
      final sum = p.x + p.y;
      final diff = p.x - p.y;
      if (sum < minSum) {
        minSum = sum;
        tl = p;
      }
      if (sum > maxSum) {
        maxSum = sum;
        br = p;
      }
      if (diff < minDiff) {
        minDiff = diff;
        bl = p;
      }
      if (diff > maxDiff) {
        maxDiff = diff;
        tr = p;
      }
    }
    return [tl, tr, br, bl];
  }
}

// === 5) LIGHTWEIGHT RECT (NON-UI) ===========================================
//
// Simple rectangle class (preview-space). We avoid importing flutter:ui Rect
// to keep this service framework-agnostic.
//
class Rect {
  final double left, top, width, height;
  const Rect.fromLTWH(this.left, this.top, this.width, this.height);

  double get right => left + width;
  double get bottom => top + height;
}

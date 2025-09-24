// lib/services/edge_detect_service.dart
import 'dart:ffi';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:io';
import 'package:ffi/ffi.dart' as ffi;
import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'package:path_provider/path_provider.dart';

/// Card edge detection & perspective warp utilities using opencv_dart.
/// Now supports an optional ROI (preview-space rect) to focus detection.
class EdgeDetectService {
  /// Detect the best card-like quadrilateral on a **grayscale** (8UC1) frame.
  ///
  /// [gray] is grayscale Y plane (width×height).
  /// [roi] is optional and expressed in **preview pixels** (same space as [width]/[height]).
  /// Returns 4 points in clockwise order (TL, TR, BR, BL) or `null`.
  List<cv.Point2f>? detectCardQuadOnGrayU8({
    required Uint8List gray,
    required int width,
    required int height,
    Rect? roi, // <-- NEW (preview space)
  }) {
    cv.Mat? matGray;
    cv.Mat? blurred;
    cv.Mat? edges;
    cv.Mat? edgesDil;
    cv.Mat? edgesClose;
    cv.Mat? kernel3;
    cv.Mat? kernel5;

    // Native buffer → Mat clone
    final int byteCount = width * height;
    final Pointer<Uint8> native = ffi.calloc<Uint8>(byteCount);
    try {
      native.asTypedList(byteCount).setAll(0, gray);
      final temp = cv.Mat.fromBuffer(
        height,
        width,
        cv.MatType.CV_8UC1,
        native.cast(),
      );
      matGray = temp.clone();
      temp.dispose();

      // 1) Blur (denoise but preserve edges decently)
      blurred = cv.gaussianBlur(matGray, (5, 5), 1.2, sigmaY: 0);

      // 2) Auto Canny thresholds using Otsu
      // We run a dummy threshold to get the Otsu value (works as a contrast proxy).
      final otsu = _otsuThresholdValue(blurred);
      final t1 = (0.5 * otsu).clamp(10, 80).toInt();
      final t2 = (1.5 * otsu).clamp(80, 220).toInt();

      edges = cv.canny(blurred, t1 as double, t2 as double);

      // 3) Morphology: close small gaps then dilate lightly
      kernel3 = cv.getStructuringElement(cv.MORPH_RECT, (3, 3));
      kernel5 = cv.getStructuringElement(cv.MORPH_RECT, (5, 5));
      edgesClose = cv.morphologyEx(edges, cv.MORPH_CLOSE, kernel3);
      edgesDil = cv.dilate(edgesClose, kernel3);

      // 4) Find contours
      final (contours, _) = cv.findContours(
        edgesDil,
        cv.RETR_EXTERNAL,
        cv.CHAIN_APPROX_SIMPLE,
      );

      // Precompute ROI and area limits
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
        final area = cv.contourArea(cnt).abs();
        // Lower min area if ROI given (we're zoomed-in)
        final minArea = roi == null ? imgArea * 0.02 : roiArea * 0.01;
        if (area < minArea) continue;

        final peri = cv.arcLength(cnt, true);
        final approx = cv.approxPolyDP(cnt, 0.02 * peri, true);
        if (approx.length != 4) continue;
        if (!cv.isContourConvex(approx)) continue;

        // Convert to Point2f & order
        final quad = <cv.Point2f>[
          for (var i = 0; i < approx.length; i++)
            cv.Point2f(approx[i].x.toDouble(), approx[i].y.toDouble()),
        ];
        final ordered = _orderQuad(quad);

        // Aspect: trading card ≈ 63×88 → width/height ≈ 0.716
        final w = _distance(ordered[0], ordered[1]);
        final h = _distance(ordered[1], ordered[2]);
        if (w <= 1 || h <= 1) continue;

        final ratio = w / h; // width / height
        // More flexible band: 0.58..0.85 (handles tilt/crop and sleeves)
        if (ratio < 0.58 || ratio > 0.85) continue;

        // Angle sanity: near-rect (allow perspective)
        final cosMax = _maxCosine(ordered);
        if (cosMax > 0.35) continue; // 0 = perfect right angles, 1 = line

        // Rectangularity
        final rect = cv.minAreaRect(cnt);
        final rectArea = (rect.size.width * rect.size.height).abs();
        if (rectArea <= 0) continue;
        final rectangularity = (area / rectArea).clamp(0.0, 1.0);

        // ROI overlap (prefer inside guide)
        final bounds = cv.boundingRect(cnt);
        final bx = bounds.x.toDouble();
        final by = bounds.y.toDouble();
        final bw = bounds.width.toDouble();
        final bh = bounds.height.toDouble();
        final iou = _rectIoU(Rect.fromLTWH(bx, by, bw, bh), roiRect);

        // Score: area * rectangularity * roiWeight
        final roiWeight = roi == null ? 1.0 : (0.6 + 0.4 * iou); // 0.6..1.0
        final score = area * rectangularity * roiWeight;

        if (score > bestScore) {
          bestScore = score;
          bestQuad = ordered;
        }
      }

      return bestQuad;
    } catch (_) {
      return null;
    } finally {
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

  /// Warp a full-res JPEG to a rectified card image (kept same API).
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
      final bytes = await srcJpeg.readAsBytes();
      src = cv.imdecode(bytes, cv.IMREAD_COLOR);
      if (src.isEmpty) return null;

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
      warped = cv.warpPerspective(src, M, (
        outWidth,
        outHeight,
      ), flags: cv.INTER_CUBIC);

      final dir = await getTemporaryDirectory();
      final outPath =
          '${dir.path}/card_${DateTime.now().millisecondsSinceEpoch}.jpg';
      cv.imwrite(outPath, warped);
      return File(outPath);
    } catch (_) {
      return null;
    } finally {
      dstPts?.dispose();
      srcPts?.dispose();
      M?.dispose();
      warped?.dispose();
      src?.dispose();
    }
  }

  // -------- helpers --------

  // Returns Otsu threshold value (0..255).
  int _otsuThresholdValue(cv.Mat srcGray) {
    // cv.threshold returns (ret, dst). We only need the ret.
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
      // fallback
      result.$2.dispose();
      return 100;
    }
  }

  double _distance(cv.Point2f a, cv.Point2f b) {
    final dx = a.x - b.x;
    final dy = a.y - b.y;
    return math.sqrt(dx * dx + dy * dy);
  }

  // Max cosine of the internal angles (0 is perfect rectangle)
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

  /// Orders 4 points clockwise starting from top-left.
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

/// Simple rect model to avoid bringing flutter:ui into this file.
class Rect {
  final double left, top, width, height;
  const Rect.fromLTWH(this.left, this.top, this.width, this.height);
  double get right => left + width;
  double get bottom => top + height;
}

// lib/services/edge_detect_service.dart
import 'dart:ffi';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:ffi/ffi.dart' as ffi;

import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'package:path_provider/path_provider.dart';

/// Card edge detection & perspective warp utilities using opencv_dart.
///
/// API notes:
/// - Build Mats from raw bytes with `Mat.fromBuffer(h, w, MatType.CV_8UC1, Pointer<Void>)`.
///   (Allocate native memory, copy from Dart bytes, then clone the Mat and free the pointer.)
/// - Use tuple sizes `(w, h)` where required (e.g., gaussianBlur, warpPerspective).
/// - `findContours` returns `(contours, hierarchy)`.
/// - Use `Mat.isEmpty` to check emptiness.
/// - `getPerspectiveTransform` may be typed to `VecPoint`; casting `VecPoint2f` is OK.
class EdgeDetectService {
  /// Detect the best card-like quadrilateral on a **grayscale** (8UC1) frame.
  ///
  /// [gray] is a grayscale buffer of size [width]×[height].
  /// Returns 4 points in clockwise order (top-left, top-right, bottom-right, bottom-left),
  /// or `null` if nothing card-like is found.
  List<cv.Point2f>? detectCardQuadOnGrayU8({
    required Uint8List gray,
    required int width,
    required int height,
  }) {
    cv.Mat? matGray; // owned clone
    cv.Mat? blurred;
    cv.Mat? edges;
    cv.Mat? edgesDil;
    cv.Mat? kernel;

    // Build a Mat safely from Dart bytes via a native buffer.
    final int byteCount = width * height; // 8UC1
    final Pointer<Uint8> native = ffi.calloc<Uint8>(byteCount);
    try {
      native.asTypedList(byteCount).setAll(0, gray);

      // Wrap the native buffer (no copy), then immediately clone so we can free it.
      final temp = cv.Mat.fromBuffer(
        height,
        width,
        cv.MatType.CV_8UC1,
        native.cast<Void>(),
      );
      matGray = temp.clone();
      temp.dispose();

      // 1) Light blur to reduce noise
      blurred = cv.gaussianBlur(matGray, (5, 5), 1.2, sigmaY: 0);

      // 2) Canny edges
      edges = cv.canny(blurred, 50, 150);

      // 3) Dilate slightly to close gaps
      kernel = cv.getStructuringElement(cv.MORPH_RECT, (3, 3));
      edgesDil = cv.dilate(edges, kernel);

      // 4) Find external contours
      final (contours, _) = cv.findContours(
        edgesDil,
        cv.RETR_EXTERNAL,
        cv.CHAIN_APPROX_SIMPLE,
      );

      double bestScore = 0.0;
      List<cv.Point2f>? bestQuad;

      for (final cnt in contours) {
        final area = cv.contourArea(cnt);
        if (area < (width * height) * 0.05) continue; // too small for a card

        final peri = cv.arcLength(cnt, true);
        final approx = cv.approxPolyDP(cnt, 0.02 * peri, true);
        if (approx.length != 4) continue; // need a quad
        if (!cv.isContourConvex(approx)) continue;

        // Convert quad to Point2f for geometry checks
        final quadF = <cv.Point2f>[
          for (var i = 0; i < approx.length; i++)
            cv.Point2f(approx[i].x.toDouble(), approx[i].y.toDouble()),
        ];

        final ordered = _orderQuad(quadF);
        final w = _distance(ordered[0], ordered[1]);
        final h = _distance(ordered[1], ordered[2]);
        if (w <= 1 || h <= 1) continue;

        // Trading card aspect ~ 63×88 mm => ~0.716
        final aspect = math.min(w, h) / math.max(w, h);
        if (aspect < 0.60 || aspect > 0.80) continue;

        // Rectangularity: contour area vs min-area-rect area
        final rect = cv.minAreaRect(cnt);
        final rectArea = rect.size.width * rect.size.height;
        if (rectArea <= 0) continue;

        final rectangularity = area / rectArea;
        final score = rectangularity * area; // prefer larger & more rectangular

        if (score > bestScore) {
          bestScore = score;
          bestQuad = ordered;
        }
      }

      return bestQuad;
    } catch (_) {
      return null;
    } finally {
      // Free native buffer now that matGray is an owned clone.
      ffi.calloc.free(native);

      // Clean up Mats we created
      kernel?.dispose();
      edgesDil?.dispose();
      edges?.dispose();
      blurred?.dispose();
      matGray?.dispose();
    }
  }

  /// Warp a full-res JPEG (captured still) to a rectified card.
  ///
  /// [srcJpeg] is the original still image (color).
  /// [quad] are the **source** card corners (Point2f) in the same coordinate space as [srcJpeg].
  /// [outWidth]/[outHeight] set the target size (defaults roughly to 63×88 @ ~10 px/mm).
  /// Returns a new temp JPEG file, or null on failure.
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
      if (src.isEmpty) {
        return null;
      }

      // Source and destination quads
      srcPts = cv.VecPoint2f.fromList(quad);
      dstPts = cv.VecPoint2f.fromList(<cv.Point2f>[
        cv.Point2f(0, 0),
        cv.Point2f(outWidth - 1.0, 0),
        cv.Point2f(outWidth - 1.0, outHeight - 1.0),
        cv.Point2f(0, outHeight - 1.0),
      ]);

      // Perspective transform + warp
      M = cv.getPerspectiveTransform(
        srcPts as cv.VecPoint,
        dstPts as cv.VecPoint,
      );
      warped = cv.warpPerspective(src, M, (
        outWidth,
        outHeight,
      ), flags: cv.INTER_CUBIC);

      // Write to a temp JPEG path
      final dir = await getTemporaryDirectory();
      final outPath =
          '${dir.path}/card_${DateTime.now().millisecondsSinceEpoch}.jpg';
      cv.imwrite(outPath, warped);

      return File(outPath);
    } catch (_) {
      return null;
    } finally {
      // Dispose mats/vecs
      dstPts?.dispose();
      srcPts?.dispose();
      M?.dispose();
      warped?.dispose();
      src?.dispose();
    }
  }

  // ---------- helpers ----------

  double _distance(cv.Point2f a, cv.Point2f b) {
    final dx = a.x - b.x;
    final dy = a.y - b.y;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Orders 4 points clockwise starting from top-left.
  List<cv.Point2f> _orderQuad(List<cv.Point2f> pts) {
    // sum/diff trick
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

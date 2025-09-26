// ============================================================================
// FILE: edge_detecting_service_manual.dart
// PURPOSE: Encapsulate OpenCV preprocessing for live camera preview overlays.
// Pipeline (configurable):
//   Gray (Y) → [GaussianBlur] → [Morph Close] → [Dilate] → [Canny / Auto Otsu]
// Returns encoded JPG for overlay + (optional) best card-like quad.
// NOTES:
//   - Quad detection prefers a near-rect using minAreaRect/boxPoints,
//     which is robust to rounded corners on trading cards.
// ============================================================================
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:math' as math;

import 'package:ffi/ffi.dart' as ffi;
import 'package:opencv_dart/opencv_dart.dart' as cv;

class EdgeParams {
  // Gaussian Blur
  final bool useBlur;
  final int blurKernel; // odd
  final double blurSigma;

  // Morph Close
  final bool useMorphClose;
  final int closeKernel; // odd

  // Dilate
  final bool useMorphDilate;
  final int dilateKernel; // odd

  // Canny
  final bool useCanny;
  final bool cannyAuto; // Otsu
  final double cannyLow; // manual
  final double cannyHigh;

  const EdgeParams({
    this.useBlur = true,
    this.blurKernel = 5,
    this.blurSigma = 1.2,
    this.useMorphClose = true,
    this.closeKernel = 3,
    this.useMorphDilate = true,
    this.dilateKernel = 3,
    this.useCanny = true,
    this.cannyAuto = true,
    this.cannyLow = 50,
    this.cannyHigh = 150,
  });

  int _odd(int v) => v.isOdd ? v : (v + 1);
  int clampOdd(int v, int min, int max) => _odd(v.clamp(min, max));
}

class EdgeDetectServiceManual {
  /// Original entry-point kept for backward-compat: returns only JPG bytes.
  Future<Uint8List> processForOverlay({
    required Uint8List gray,
    required int width,
    required int height,
    required EdgeParams params,
  }) async {
    final (bytes, _) = await processForOverlayAndQuad(
      gray: gray,
      width: width,
      height: height,
      params: params,
    );
    return bytes;
  }

  /// New entry-point: returns JPG bytes AND an optional best card-like quad.
  ///
  /// Quad is expressed in the same pixel space as [width]×[height] (the input
  /// grayscale frame). If no plausible card is found, quad is null.
  Future<(Uint8List, List<List<double>>?)> processForOverlayAndQuad({
    required Uint8List gray,
    required int width,
    required int height,
    required EdgeParams params,
  }) async {
    final int byteCount = width * height;
    final Pointer<Uint8> native = ffi.calloc<Uint8>(byteCount);

    cv.Mat? stage; // working mat through the pipeline
    cv.Mat? edgesForFind; // binary edges for contour search (owned)
    List<List<double>>? bestQuad;

    try {
      // Load into Mat (8UC1)
      native.asTypedList(byteCount).setAll(0, gray);
      final temp = cv.Mat.fromBuffer(
        height,
        width,
        cv.MatType.CV_8UC1,
        native.cast<Void>(),
      );
      stage = temp.clone();
      temp.dispose();

      // Gaussian Blur
      if (params.useBlur) {
        final k = params.clampOdd(params.blurKernel, 1, 15);
        final b = cv.gaussianBlur(stage, (k, k), params.blurSigma, sigmaY: 0);
        stage.dispose();
        stage = b;
      }

      // Morph Close
      if (params.useMorphClose) {
        final k = params.clampOdd(params.closeKernel, 1, 15);
        final kernel = cv.getStructuringElement(cv.MORPH_RECT, (k, k));
        final m = cv.morphologyEx(stage, cv.MORPH_CLOSE, kernel);
        kernel.dispose();
        stage.dispose();
        stage = m;
      }

      // Dilate
      if (params.useMorphDilate) {
        final k = params.clampOdd(params.dilateKernel, 1, 15);
        final kernel = cv.getStructuringElement(cv.MORPH_RECT, (k, k));
        final m = cv.dilate(stage, kernel);
        kernel.dispose();
        stage.dispose();
        stage = m;
      }

      // Canny (for visualization AND findContours)
      if (params.useCanny) {
        double low, high;
        if (params.cannyAuto) {
          final (l, h) = _autoCanny(stage);
          low = l;
          high = h;
        } else {
          low = params.cannyLow;
          high = math.max(params.cannyLow + 1, params.cannyHigh);
        }
        final e = cv.canny(stage, low, high);
        stage.dispose();
        stage = e;
      }

      // Keep a copy for findContours (stage may be 8UC1 binary now)
      edgesForFind = stage.clone();

      // Detect best card-like quad (robust to rounded corners)
      bestQuad = _detectBestCardQuad(edgesForFind, width, height);

      // Encode the stage (grayscale/binary) to JPG
      final (ok, bytes) = cv.imencode('.jpg', stage);
      if (!ok) {
        throw 'imencode failed';
      }
      return (bytes, bestQuad);
    } finally {
      edgesForFind?.dispose();
      stage?.dispose();
      ffi.calloc.free(native);
    }
  }

  /// Otsu-driven Canny thresholds
  (double, double) _autoCanny(cv.Mat src) {
    final r = cv.threshold(src, 0, 255, cv.THRESH_BINARY | cv.THRESH_OTSU);
    final otsu = r.$1;
    r.$2.dispose();
    final low = otsu * 0.5;
    final high = otsu * 1.5;
    return (low.clamp(5, 120), high.clamp(40, 220));
  }

  /// Find the best card-like quad using minAreaRect (handles rounded corners well).
  ///
  /// Returns 4 points as [[x0,y0],[x1,y1],[x2,y2],[x3,y3]] in clockwise order
  /// starting from the top-left-ish corner.
  List<List<double>>? _detectBestCardQuad(cv.Mat edges, int w, int h) {
    // Find external contours on edges
    final (contours, _) = cv.findContours(
      edges,
      cv.RETR_EXTERNAL,
      cv.CHAIN_APPROX_SIMPLE,
    );

    if (contours.isEmpty) return null;

    final imgArea = (w * h).toDouble();
    List<List<double>>? best;
    double bestScore = 0.0;

    for (final cnt in contours) {
      final area = cv.contourArea(cnt).abs();
      if (area < imgArea * 0.02) continue; // ignore tiny

      // minAreaRect (robust for rounded corners); convert to 4 points
      final rect = cv.minAreaRect(cnt);
      final rectArea = (rect.size.width * rect.size.height).abs();
      if (rectArea <= 0) continue;

      final box = cv.boxPoints(rect); // VecPoint2f (4)
      final boxList = <cv.Point2f>[
        for (int i = 0; i < box.length; i++)
          cv.Point2f(box[i].x.toDouble(), box[i].y.toDouble()),
      ];
      // Order the quad
      final ordered = _orderQuad(boxList);

      // Aspect check: trading card ≈ 63×88 → ~0.716 (width/height)
      final widthLen = _dist(ordered[0], ordered[1]);
      final heightLen = _dist(ordered[1], ordered[2]);
      if (widthLen <= 1 || heightLen <= 1) continue;
      final aspect = widthLen / heightLen;
      // Allow tilt/crop sleeves etc.
      if (aspect < 0.58 || aspect > 0.85) continue;

      // Rectangularity proxy: contour area vs. rect area (rounded edges reduce slightly)
      final rectangularity = (area / rectArea).clamp(0.0, 1.0);

      // Score: prefer large + rectangular + aspect near card
      final aspectTarget = 63.0 / 88.0;
      final aspectPenalty = (1.0 - (1.0 - ((aspect - aspectTarget).abs())))
          .clamp(0.0, 1.0);
      final score = area * rectangularity * (1.0 - 0.5 * aspectPenalty);

      if (score > bestScore) {
        bestScore = score;
        best = [
          [ordered[0].x.toDouble(), ordered[0].y.toDouble()],
          [ordered[1].x.toDouble(), ordered[1].y.toDouble()],
          [ordered[2].x.toDouble(), ordered[2].y.toDouble()],
          [ordered[3].x.toDouble(), ordered[3].y.toDouble()],
        ];
      }
    }

    return best;
  }

  double _dist(cv.Point2f a, cv.Point2f b) {
    final dx = a.x - b.x;
    final dy = a.y - b.y;
    return math.sqrt(dx * dx + dy * dy);
  }

  /// Orders 4 points clockwise starting roughly from top-left.
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

// ============================================================================
// FILE: edge_detect_service_manual.dart
// PURPOSE: Encapsulate OpenCV preprocessing for live camera preview overlays.
// Pipeline (configurable):
//   Gray (Y) → [GaussianBlur] → [Morph Close] → [Dilate] → [Canny / Auto Otsu]
// Returns an encoded JPG (Uint8List) ready to draw as an overlay.
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
  /// Process a grayscale frame (WxH, 8UC1) using params; returns JPG bytes.
  Future<Uint8List> processForOverlay({
    required Uint8List gray,
    required int width,
    required int height,
    required EdgeParams params,
  }) async {
    final int byteCount = width * height;
    final Pointer<Uint8> native = ffi.calloc<Uint8>(byteCount);

    cv.Mat? stage;

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

      // Canny
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

      final (ok, bytes) = cv.imencode('.jpg', stage);
      if (!ok) {
        throw 'imencode failed';
      }
      return bytes;
    } finally {
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
}

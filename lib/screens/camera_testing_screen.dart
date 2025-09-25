// ============================================================================
// FILE: camera_testing_screen.dart
// PURPOSE: Minimal live camera processing (OpenCV) with accumulating filters.
//   • Pipeline: Gray (Y plane) → [GaussianBlur] → [Canny]
//   • Filters accumulate in that order (toggle each on/off).
//   • Shows CameraPreview + processed overlay (perfectly aligned 1:1).
//   • Portrait-only; overlay rotated to match preview.
//   • Stream watchdog and "Restart stream" button if frames don't arrive.
//   • Fills all available space (no black bars) except SafeArea bottom.
// ============================================================================

import 'dart:async';
import 'dart:typed_data';
import 'dart:ffi';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ffi/ffi.dart' as ffi;
import 'package:opencv_dart/opencv_dart.dart' as cv;

class CameraTestingScreen extends StatefulWidget {
  const CameraTestingScreen({super.key});

  @override
  State<CameraTestingScreen> createState() => _CameraTestingScreenState();
}

class _CameraTestingScreenState extends State<CameraTestingScreen> {
  // --- camera / stream ---
  CameraController? _controller;
  bool _ready = false;
  bool _inProcess = false;
  int _frameStride = 1;
  int _frameCount = 0;

  // --- processed preview (overlay) ---
  Uint8List? _overlayBytes; // encoded JPG (processed)
  int _srcW = 0, _srcH = 0; // raw Y-plane size

  // --- filters (accumulative) ---
  bool _useBlur = true;
  bool _useCanny = true;

  // --- watchdog ---
  Timer? _watchdog;
  DateTime? _lastFrameTs;
  String? _lastError;

  @override
  void initState() {
    super.initState();
    // Lock this screen to portrait
    SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
    _initCamera();
  }

  @override
  void dispose() {
    _watchdog?.cancel();
    _controller?.dispose();
    // Restore orientations
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  Future<void> _initCamera() async {
    try {
      final cams = await availableCameras();
      if (cams.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('No camera available')));
          Navigator.maybePop(context);
        }
        return;
      }

      final CameraDescription cam = cams.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cams.first,
      );

      _controller = CameraController(
        cam,
        ResolutionPreset.medium, // keep same feel as before
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _controller!.initialize();
      if (!mounted) return;

      await _controller!.startImageStream(_onPreviewFrame);
      _startWatchdog();
      setState(() {
        _ready = true;
        _lastError = null;
      });
    } on CameraException catch (e) {
      if (!mounted) return;
      setState(() => _lastError = 'Camera error: ${e.code} ${e.description}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_lastError!)));
      Navigator.maybePop(context);
    }
  }

  // If frames stop coming (some OEMs), offer a restart.
  void _startWatchdog() {
    _watchdog?.cancel();
    _lastFrameTs = DateTime.now();
    _watchdog = Timer.periodic(const Duration(seconds: 3), (_) {
      final last = _lastFrameTs;
      if (!mounted || last == null) return;
      final diff = DateTime.now().difference(last);
      if (diff.inSeconds >= 3) {
        setState(() {
          _lastError = 'No frames detected. You can try "Restart stream".';
        });
      }
    });
  }

  Future<void> _restartStream() async {
    if (_controller == null) return;
    try {
      await _controller!.stopImageStream();
    } catch (_) {}
    try {
      await _controller!.startImageStream(_onPreviewFrame);
      _startWatchdog();
      setState(() => _lastError = null);
    } catch (e) {
      setState(() => _lastError = 'Restart failed: $e');
    }
  }

  // Build a contiguous WxH grayscale buffer from the Y plane (bytesPerRow safe)
  Uint8List _packYPlane(CameraImage img) {
    final plane = img.planes.first; // Y
    final src = plane.bytes;
    final rowStride = plane.bytesPerRow;
    final w = img.width, h = img.height;

    if (rowStride == w) {
      return src.length >= w * h ? src.sublist(0, w * h) : Uint8List(0);
    }
    final out = Uint8List(w * h);
    int di = 0, si = 0;
    for (int r = 0; r < h; r++) {
      out.setRange(di, di + w, src, si);
      di += w;
      si += rowStride;
    }
    return out;
  }

  // STREAM: Gray → [Blur] → [Canny], encode to JPG and display as overlay
  Future<void> _onPreviewFrame(CameraImage img) async {
    _lastFrameTs = DateTime.now();
    if ((_frameCount++ % _frameStride) != 0) return;
    if (_inProcess) return;
    _inProcess = true;

    try {
      _srcW = img.width;
      _srcH = img.height;

      final y = _packYPlane(img);
      if (y.isEmpty) return;

      final int byteCount = _srcW * _srcH;
      final Pointer<Uint8> native = ffi.calloc<Uint8>(byteCount);
      cv.Mat? stage;

      try {
        native.asTypedList(byteCount).setAll(0, y);

        // Gray Mat (8UC1)
        final temp = cv.Mat.fromBuffer(
          _srcH,
          _srcW,
          cv.MatType.CV_8UC1,
          native.cast<Void>(),
        );
        stage = temp.clone();
        temp.dispose();

        // Optional Gaussian Blur
        if (_useBlur) {
          final b = cv.gaussianBlur(stage, (5, 5), 1.2, sigmaY: 0);
          stage.dispose();
          stage = b;
        }

        // Optional Canny
        if (_useCanny) {
          final e = cv.canny(stage, 50, 150);
          stage.dispose();
          stage = e;
        }

        // Encode from current (grayscale) stage to JPG.
        final (ok, bytes) = cv.imencode('.jpg', stage);
        if (!ok) throw 'imencode failed';

        if (mounted) {
          setState(() => _overlayBytes = bytes);
        }
      } catch (e) {
        if (mounted) setState(() => _lastError = 'Process error: $e');
      } finally {
        stage?.dispose();
        ffi.calloc.free(native);
      }
    } finally {
      _inProcess = false;
    }
  }

  // --- UI -------------------------------------------------------------------

  // Crisp, layout-aware rotation for the overlay (90° steps).
  int _overlayQuarterTurns() {
    if (_controller == null) return 0;
    final deg = _controller!.description.sensorOrientation; // 0/90/180/270
    return ((deg ~/ 90) % 4);
  }

  // A shared "cover" wrapper so both camera & overlay scale IDENTICALLY.
  // We use the preview's native size as the content size, and BoxFit.cover
  // to fill all available space without letterboxing.
  Widget _covered(Widget child) {
    final ps = _controller!.value.previewSize!;
    final w = ps.width;
    final h = ps.height;
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(width: w, height: h, child: child),
    );
  }

  Widget _buildControls() {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        FilterChip(
          label: const Text('Gaussian Blur'),
          selected: _useBlur,
          onSelected: (v) => setState(() => _useBlur = v),
        ),
        FilterChip(
          label: const Text('Canny Edges'),
          selected: _useCanny,
          onSelected: (v) => setState(() => _useCanny = v),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Stride'),
            const SizedBox(width: 8),
            DropdownButton<int>(
              value: _frameStride,
              items: const [
                DropdownMenuItem(value: 1, child: Text('1 (max FPS)')),
                DropdownMenuItem(value: 2, child: Text('2')),
                DropdownMenuItem(value: 3, child: Text('3')),
                DropdownMenuItem(value: 4, child: Text('4')),
              ],
              onChanged: (v) => setState(() => _frameStride = v ?? 2),
            ),
          ],
        ),
        if (_lastError != null)
          TextButton.icon(
            onPressed: _restartStream,
            icon: const Icon(Icons.restart_alt),
            label: const Text('Restart stream'),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text('Camera Testing (OpenCV)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: _buildControls(),
            ),

            // FULL-FILL PREVIEW + OVERLAY (no black bars):
            // Both layers share EXACTLY the same cover box and scaling.
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Camera
                  _covered(CameraPreview(_controller!)),

                  // Overlay (rotated & covered the same way)
                  if (_overlayBytes != null)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: _covered(
                          RotatedBox(
                            quarterTurns: _overlayQuarterTurns(),
                            child: Image.memory(
                              _overlayBytes!,
                              fit: BoxFit
                                  .fill, // fill the SizedBox(w,h); cover happens outside
                              alignment: Alignment.center,
                              gaplessPlayback: true,
                              opacity: const AlwaysStoppedAnimation(0.75),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 8),
              child: Text(
                'size: ${_srcW}x$_srcH • stride=$_frameStride • blur=${_useBlur ? "on" : "off"} • canny=${_useCanny ? "on" : "off"}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

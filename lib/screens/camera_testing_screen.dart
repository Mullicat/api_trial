// ============================================================================
// FILE: camera_testing_screen.dart
// PURPOSE: Minimal live camera processing (OpenCV) with accumulating filters.
//   • Pipeline: Gray (Y) → [GaussianBlur] → [Morph Close] → [Dilate] → [Canny]
//   • All stages are tunable from a collapsible on-screen menu.
//   • Preview + processed overlay aligned 1:1 (same fit & rotation).
//   • Portrait-only for this screen. "Fill screen (crop)" toggle included.
//   • Stream watchdog + "Restart stream" button if frames stall.
//   • OpenCV logic moved to EdgeDetectServiceManual.
// ============================================================================

import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:api_trial/services/edge_detecting_service_manual.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ffi/ffi.dart' as ffi;

class CameraTestingScreen extends StatefulWidget {
  const CameraTestingScreen({super.key});

  @override
  State<CameraTestingScreen> createState() => _CameraTestingScreenState();
}

class _CameraTestingScreenState extends State<CameraTestingScreen> {
  // camera / stream
  CameraController? _controller;
  bool _ready = false;
  bool _inProcess = false;
  int _frameStride = 1;
  int _frameCount = 0;

  // overlay (encoded JPG)
  Uint8List? _overlayBytes;
  int _srcW = 0, _srcH = 0;

  // params (same defaults as your preferred version)
  bool _useBlur = true;
  int _blurKernel = 5;
  double _blurSigma = 1.2;

  bool _useMorphClose = true;
  int _closeKernel = 3;

  bool _useMorphDilate = true;
  int _dilateKernel = 3;

  bool _useCanny = true;
  bool _cannyAuto = true;
  double _cannyLow = 50;
  double _cannyHigh = 150;

  // layout
  bool _fillScreenCrop = false;
  bool _showMenu = true;

  // watchdog
  Timer? _watchdog;
  DateTime? _lastFrameTs;
  String? _lastError;

  // service
  final _edge = EdgeDetectServiceManual();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
    _initCamera();
  }

  @override
  void dispose() {
    _watchdog?.cancel();
    _controller?.dispose();
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
        ResolutionPreset.medium,
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

  void _startWatchdog() {
    _watchdog?.cancel();
    _lastFrameTs = DateTime.now();
    _watchdog = Timer.periodic(const Duration(seconds: 3), (_) {
      final last = _lastFrameTs;
      if (!mounted || last == null) return;
      if (DateTime.now().difference(last).inSeconds >= 3) {
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

  // === Processing ============================================================

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

      final params = EdgeParams(
        useBlur: _useBlur,
        blurKernel: _blurKernel,
        blurSigma: _blurSigma,
        useMorphClose: _useMorphClose,
        closeKernel: _closeKernel,
        useMorphDilate: _useMorphDilate,
        dilateKernel: _dilateKernel,
        useCanny: _useCanny,
        cannyAuto: _cannyAuto,
        cannyLow: _cannyLow,
        cannyHigh: _cannyHigh,
      );

      // Let the service do all OpenCV work and give us JPG bytes
      final bytes = await _edge.processForOverlay(
        gray: y,
        width: _srcW,
        height: _srcH,
        params: params,
      );

      if (mounted) setState(() => _overlayBytes = bytes);
    } catch (e) {
      if (mounted) setState(() => _lastError = 'Process error: $e');
    } finally {
      _inProcess = false;
    }
  }

  // === View helpers ==========================================================

  // Rotation to match preview (90° steps)
  int _overlayQuarterTurns() {
    if (_controller == null) return 0;
    final deg = _controller!.description.sensorOrientation; // 0/90/180/270
    return ((deg ~/ 90) % 4);
  }

  // Shared wrapper so both camera & overlay scale IDENTICALLY
  Widget _fitBox(Widget child, {required BoxFit fit}) {
    final ps = _controller!.value.previewSize!;
    final w = ps.width;
    final h = ps.height;
    return FittedBox(
      fit: fit,
      alignment: Alignment.center,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(width: w, height: h, child: child),
    );
  }

  // === Collapsible Menu ======================================================

  Widget _menuPanel() {
    return AnimatedCrossFade(
      crossFadeState: _showMenu
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 200),
      firstCurve: Curves.easeOut,
      secondCurve: Curves.easeIn,
      sizeCurve: Curves.easeInOut,
      firstChild: _buildMenuCard(),
      secondChild: _collapsedHandle(),
    );
  }

  Widget _collapsedHandle() {
    return GestureDetector(
      onTap: () => setState(() => _showMenu = true),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.45),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.tune, size: 16, color: Colors.white70),
              SizedBox(width: 6),
              Text('Show menu', style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard() {
    final fitText = _fillScreenCrop ? 'cover (crop)' : 'contain (no crop)';
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        color: Colors.black.withOpacity(0.6),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header row
                Row(
                  children: [
                    const Icon(Icons.tune, color: Colors.white70, size: 18),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Preprocessing Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Hide menu',
                      icon: const Icon(
                        Icons.expand_less,
                        color: Colors.white70,
                      ),
                      onPressed: () => setState(() => _showMenu = false),
                    ),
                  ],
                ),
                const Divider(height: 12, color: Colors.white24),

                // Row: stride + fill/contain + restart (if needed)
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Stride',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          dropdownColor: Colors.grey[900],
                          value: _frameStride,
                          items: const [
                            DropdownMenuItem(
                              value: 1,
                              child: Text('1 (max FPS)'),
                            ),
                            DropdownMenuItem(value: 2, child: Text('2')),
                            DropdownMenuItem(value: 3, child: Text('3')),
                            DropdownMenuItem(value: 4, child: Text('4')),
                          ],
                          onChanged: (v) =>
                              setState(() => _frameStride = v ?? 2),
                        ),
                      ],
                    ),
                    FilterChip(
                      label: Text('Fill screen: $fitText'),
                      selected: _fillScreenCrop,
                      onSelected: (v) => setState(() => _fillScreenCrop = v),
                    ),
                    if (_lastError != null)
                      TextButton.icon(
                        onPressed: _restartStream,
                        icon: const Icon(
                          Icons.restart_alt,
                          color: Colors.white70,
                        ),
                        label: const Text(
                          'Restart stream',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 6),
                _sectionLabel('Gaussian Blur'),
                SwitchListTile(
                  dense: true,
                  value: _useBlur,
                  onChanged: (v) => setState(() => _useBlur = v),
                  title: const Text(
                    'Enable',
                    style: TextStyle(color: Colors.white),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                if (_useBlur)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 6,
                    ),
                    child: Column(
                      children: [
                        _LabeledSlider(
                          label: 'Kernel (odd)',
                          value: _blurKernel.toDouble(),
                          min: 1,
                          max: 15,
                          divisions: 7, // 1,3,5,...,15
                          display: '${_clampOdd(_blurKernel, 1, 15)}',
                          onChanged: (v) =>
                              setState(() => _blurKernel = v.round()),
                        ),
                        _LabeledSlider(
                          label: 'Sigma',
                          value: _blurSigma,
                          min: 0,
                          max: 3,
                          divisions: 30,
                          display: _blurSigma.toStringAsFixed(2),
                          onChanged: (v) => setState(() => _blurSigma = v),
                        ),
                      ],
                    ),
                  ),

                _sectionLabel('Morphology'),
                SwitchListTile(
                  dense: true,
                  value: _useMorphClose,
                  onChanged: (v) => setState(() => _useMorphClose = v),
                  title: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                if (_useMorphClose)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _LabeledSlider(
                      label: 'Close Kernel (odd)',
                      value: _closeKernel.toDouble(),
                      min: 1,
                      max: 15,
                      divisions: 7,
                      display: '${_clampOdd(_closeKernel, 1, 15)}',
                      onChanged: (v) =>
                          setState(() => _closeKernel = v.round()),
                    ),
                  ),
                SwitchListTile(
                  dense: true,
                  value: _useMorphDilate,
                  onChanged: (v) => setState(() => _useMorphDilate = v),
                  title: const Text(
                    'Dilate',
                    style: TextStyle(color: Colors.white),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                if (_useMorphDilate)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _LabeledSlider(
                      label: 'Dilate Kernel (odd)',
                      value: _dilateKernel.toDouble(),
                      min: 1,
                      max: 15,
                      divisions: 7,
                      display: '${_clampOdd(_dilateKernel, 1, 15)}',
                      onChanged: (v) =>
                          setState(() => _dilateKernel = v.round()),
                    ),
                  ),

                _sectionLabel('Canny Edges'),
                SwitchListTile(
                  dense: true,
                  value: _useCanny,
                  onChanged: (v) => setState(() => _useCanny = v),
                  title: const Text(
                    'Enable',
                    style: TextStyle(color: Colors.white),
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                if (_useCanny)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 6,
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                            'Auto thresholds (Otsu)',
                            style: TextStyle(color: Colors.white),
                          ),
                          value: _cannyAuto,
                          onChanged: (v) => setState(() => _cannyAuto = v),
                        ),
                        if (!_cannyAuto) ...[
                          _LabeledSlider(
                            label: 'Low',
                            value: _cannyLow,
                            min: 0,
                            max: 255,
                            divisions: 255,
                            display: _cannyLow.toStringAsFixed(0),
                            onChanged: (v) => setState(() => _cannyLow = v),
                          ),
                          _LabeledSlider(
                            label: 'High',
                            value: _cannyHigh,
                            min: 1,
                            max: 255,
                            divisions: 255,
                            display: _cannyHigh.toStringAsFixed(0),
                            onChanged: (v) => setState(() => _cannyHigh = v),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 2),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  int _odd(int v) => v.isOdd ? v : (v + 1);
  int _clampOdd(int v, int min, int max) => _odd(v.clamp(min, max));

  // === Build ================================================================

  @override
  Widget build(BuildContext context) {
    if (!_ready || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final fit = _fillScreenCrop ? BoxFit.cover : BoxFit.contain;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text('Camera Testing (OpenCV)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          IconButton(
            tooltip: _showMenu ? 'Hide menu' : 'Show menu',
            icon: Icon(_showMenu ? Icons.expand_less : Icons.tune),
            onPressed: () => setState(() => _showMenu = !_showMenu),
          ),
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: Stack(
          children: [
            // PREVIEW + OVERLAY with identical scaling behavior:
            Positioned.fill(
              child: _fitBox(
                Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(child: CameraPreview(_controller!)),

                    if (_overlayBytes != null)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: RotatedBox(
                            quarterTurns: _overlayQuarterTurns(),
                            child: Image.memory(
                              _overlayBytes!,
                              fit: BoxFit.fill, // fills inner SizedBox
                              alignment: Alignment.center,
                              gaplessPlayback: true,
                              opacity: const AlwaysStoppedAnimation(0.75),
                            ),
                          ),
                        ),
                      )
                    else
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
                fit: fit,
              ),
            ),

            // Collapsible menu panel (top overlay)
            Positioned(left: 0, right: 0, top: 0, child: _menuPanel()),

            // HUD
            Positioned(
              left: 12,
              right: 12,
              bottom: 10,
              child: Text(
                'size: ${_srcW}x$_srcH • stride=$_frameStride • fit=${_fillScreenCrop ? "cover" : "contain"} • '
                'blur=${_useBlur ? "${_clampOdd(_blurKernel, 1, 15)}@${_blurSigma.toStringAsFixed(2)}" : "off"} • '
                'mClose=${_useMorphClose ? _clampOdd(_closeKernel, 1, 15) : "off"} • '
                'dilate=${_useMorphDilate ? _clampOdd(_dilateKernel, 1, 15) : "off"} • '
                'canny=${_useCanny ? (_cannyAuto ? "auto" : "${_cannyLow.toStringAsFixed(0)}/${_cannyHigh.toStringAsFixed(0)}") : "off"}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Small labeled slider helper
class _LabeledSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String display;
  final ValueChanged<double> onChanged;

  const _LabeledSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.display,
    required this.onChanged,
    this.divisions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(label, style: const TextStyle(color: Colors.white70)),
        ),
        Expanded(
          child: Slider(
            min: min,
            max: max,
            divisions: divisions,
            value: value.clamp(min, max),
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 52,
          child: Text(
            display,
            textAlign: TextAlign.right,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }
}

// lib/screens/multi_scan_camera_screen.dart
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show Rect, RRect;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

import '../models/card.dart';
import '../services/edge_detect_service.dart';
import '../services/ocr_service.dart';
import '../services/game_detection_service.dart';
import '../services/onepiece_service.dart';

enum _DetectState { searching, stable, capturedCooldown, waitingChange }

class MultiScanCameraScreen extends StatefulWidget {
  const MultiScanCameraScreen({super.key});

  @override
  State<MultiScanCameraScreen> createState() => _MultiScanCameraScreenState();
}

class _MultiScanCameraScreenState extends State<MultiScanCameraScreen> {
  CameraController? _controller;
  bool _ready = false;
  bool _takingShot = false;

  final _edge = EdgeDetectService();
  final _ocr = OcrService();
  final _gameDetect = GameDetectionService();
  late OnePieceTcgService _onePiece;

  final List<TCGCard> _picked = [];

  // FSM
  _DetectState _state = _DetectState.searching;
  List<List<double>>? _stableQuadPrev;
  int _stableCount = 0;
  int _cooldownFrames = 0;
  int _changedFrames = 0;

  // motion baseline
  Uint8List? _prevY;
  int _frameSkip = 0;

  // preview meta
  int _pvWidth = 0;
  int _pvHeight = 0;

  // overlay
  List<cv.Point2f>? _lastQuadPreview;
  bool _flashOverlay = false;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    try {
      _onePiece = await OnePieceTcgService.create();
      final cams = await availableCameras();
      if (cams.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('No camera available')));
          Navigator.pop(context);
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
      setState(() => _ready = true);
    } on CameraException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera error: ${e.code} ${e.description}')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    // clean up preview points
    _lastQuadPreview?.forEach((p) => p.dispose());
    super.dispose();
  }

  // == Preview processing ==
  Future<void> _onPreviewFrame(CameraImage img) async {
    if (_takingShot) return;
    // gentle throttle
    if ((_frameSkip++ % 1) != 0) return;

    final pvW = img.width;
    final pvH = img.height;
    _pvWidth = pvW;
    _pvHeight = pvH;

    final yBytes = img.planes.first.bytes;

    // Let the detector scan the whole frame (no ROI) to behave like a doc scanner.
    final quad = _edge.detectCardQuadOnGrayU8(
      gray: yBytes,
      width: pvW,
      height: pvH,
      // roi: null  // intentionally not set
    );

    _maybeUpdateOverlay(quad);

    final moved = _detectMotion(yBytes);

    switch (_state) {
      case _DetectState.searching:
        if (quad != null) {
          if (_isSameQuad(quad, _stableQuadPrev)) {
            _stableCount++;
          } else {
            _stableCount = 1;
            _stableQuadPrev = _toDoubleQuad(quad);
          }
          if (_stableCount >= 8) {
            _state = _DetectState.stable;
            setState(() {});
          } else {
            setState(() {});
          }
        } else {
          if (_stableCount != 0 || _stableQuadPrev != null) {
            _stableCount = 0;
            _stableQuadPrev = null;
            setState(() {});
          }
        }
        break;

      case _DetectState.stable:
        if (_stableQuadPrev != null) {
          _triggerCaptureWithQuad(_stableQuadPrev!);
        }
        _state = _DetectState.capturedCooldown;
        _cooldownFrames = 10;
        setState(() {});
        break;

      case _DetectState.capturedCooldown:
        _cooldownFrames--;
        if (_cooldownFrames <= 0) {
          _state = _DetectState.waitingChange;
          _changedFrames = 0;
          setState(() {});
        }
        break;

      case _DetectState.waitingChange:
        if (moved) {
          _changedFrames++;
          if (_changedFrames >= 4) {
            _state = _DetectState.searching;
            _stableCount = 0;
            _stableQuadPrev = null;
            setState(() {});
          }
        } else {
          if (_changedFrames != 0) {
            _changedFrames = 0;
            setState(() {});
          }
        }
        break;
    }
  }

  bool _isSameQuad(List<cv.Point2f> q, List<List<double>>? prev) {
    if (prev == null || prev.length != 4) return false;
    double sum = 0;
    for (var i = 0; i < 4; i++) {
      final dx = q[i].x - prev[i][0];
      final dy = q[i].y - prev[i][1];
      sum += (dx * dx + dy * dy);
    }
    return sum < 200.0; // preview-pixel threshold
  }

  List<List<double>> _toDoubleQuad(List<cv.Point2f> q) =>
      q.map((p) => [p.x.toDouble(), p.y.toDouble()]).toList();

  bool _detectMotion(Uint8List y) {
    if (_prevY == null || _prevY!.length != y.length) {
      _prevY = Uint8List.fromList(y);
      return false;
    }
    const step = 16;
    int count = 0;
    double acc = 0;
    for (int i = 0; i < y.length; i += step) {
      final d = (y[i] - _prevY![i]).abs();
      acc += d.toDouble();
      count++;
    }
    _prevY!.setAll(0, y);
    final avg = acc / count; // 0..255
    return avg > 3.5;
  }

  Future<void> _triggerCaptureWithQuad(List<List<double>> quadPreview) async {
    if (_takingShot || _controller == null) return;
    setState(() => _takingShot = true);

    _flash();

    try {
      final x = await _controller!.takePicture();
      final still = File(x.path);

      // preview->still map
      final pvW = _pvWidth.toDouble();
      final pvH = _pvHeight.toDouble();

      final decoded = await still.readAsBytes();
      final mat = cv.imdecode(decoded, cv.IMREAD_GRAYSCALE);
      final stW = mat.cols.toDouble();
      final stH = mat.rows.toDouble();
      mat.dispose();

      final sx = stW / pvW;
      final sy = stH / pvH;

      final quadStill = quadPreview
          .map((p) => cv.Point2f(p[0] * sx, p[1] * sy))
          .toList();

      final warped = await _edge.warpAndWriteJpeg(
        srcJpeg: still,
        quad: quadStill,
        outWidth: 700,
        outHeight: 980,
      );

      final cardFile = warped ?? still;

      // OCR + game detect
      final ocr = await _ocr.processImageWithAutoDetect(cardFile, true);
      final blocks =
          (ocr['textBlocks'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      final joined =
          (ocr['joinedText'] as String?) ??
          blocks.map((b) => b['text']?.toString() ?? '').join(' ');

      final game = _gameDetect.detectGame(blocks, joined, true, 'YuGiOh');
      if (!game.toLowerCase().contains('one piece')) {
        _toast('Detected $game — not supported yet.');
        return;
      }

      final code = _ocr.extractOnePieceGameCode(
        textBlocks: blocks,
        joinedText: joined,
      );

      if (code == null) {
        _toast('No One Piece code found. Try again.');
        return;
      }

      final matches = await _onePiece.getCardsByGameCodeFromDatabase(
        gameCode: code,
      );

      if (matches.isEmpty) {
        _toast('No cards for $code. Try again.');
      } else if (matches.length == 1) {
        _addPicked(matches.first);
        _banner(matches.first);
      } else {
        final chosen = await _pickFromMany(matches, code);
        if (chosen != null) {
          _addPicked(chosen);
          _banner(chosen);
        }
      }
    } catch (e) {
      _toast('Capture error: $e');
    } finally {
      if (mounted) setState(() => _takingShot = false);
    }
  }

  void _flash() async {
    if (!mounted) return;
    setState(() => _flashOverlay = true);
    await Future.delayed(const Duration(milliseconds: 120));
    if (!mounted) return;
    setState(() => _flashOverlay = false);
  }

  void _addPicked(TCGCard c) {
    final key = c.id ?? c.gameCode ?? '';
    if (_picked.any((x) => (x.id ?? x.gameCode) == key)) return;
    _picked.add(c);
    setState(() {});
  }

  Future<TCGCard?> _pickFromMany(List<TCGCard> cards, String code) async {
    return showModalBottomSheet<TCGCard>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text(
              'Multiple matches for $code',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: cards.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final c = cards[i];
                  return ListTile(
                    leading: (c.imageRefSmall?.isNotEmpty ?? false)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              c.imageRefSmall!,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(c.name ?? 'Unknown'),
                    subtitle: Text(c.setName ?? ''),
                    onTap: () => Navigator.pop<TCGCard>(context, c),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _banner(TCGCard card) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        content: Row(
          children: [
            if (card.imageRefSmall?.isNotEmpty ?? false)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  card.imageRefSmall!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '${card.name ?? 'Unknown'} saved  •  total ${_picked.length}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // === overlay plumbing ===
  void _maybeUpdateOverlay(List<cv.Point2f>? quad) {
    final changed = !_sameQuadPoints(_lastQuadPreview, quad);
    if (changed) {
      _lastQuadPreview?.forEach((p) => p.dispose());
      _lastQuadPreview = quad == null ? null : List<cv.Point2f>.from(quad);
      if (mounted) setState(() {});
    }
  }

  bool _sameQuadPoints(List<cv.Point2f>? a, List<cv.Point2f>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null || a.length != b.length) return false;
    double sum = 0;
    for (int i = 0; i < a.length; i++) {
      final dx = a[i].x - b[i].x;
      final dy = a[i].y - b[i].y;
      sum += dx * dx + dy * dy;
    }
    return sum < 1e-2;
  }

  String get _statusText {
    switch (_state) {
      case _DetectState.searching:
        return _lastQuadPreview == null ? 'Searching' : 'Hold still…';
      case _DetectState.stable:
        return 'Capturing…';
      case _DetectState.capturedCooldown:
        return 'Processing…';
      case _DetectState.waitingChange:
        return 'Replace card to continue';
    }
  }

  Color get _statusColor {
    switch (_state) {
      case _DetectState.searching:
        return _lastQuadPreview == null
            ? Colors.orangeAccent
            : Colors.yellowAccent;
      case _DetectState.stable:
        return Colors.lightGreenAccent;
      case _DetectState.capturedCooldown:
        return Colors.blueAccent;
      case _DetectState.waitingChange:
        return Colors.amberAccent;
    }
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
        title: const Text('Scan, Detect & Save'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop<List<TCGCard>>(
              context,
              List<TCGCard>.from(_picked),
            ),
            child: const Text('Done', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenW = constraints.maxWidth;
          final screenH = constraints.maxHeight;

          return Stack(
            children: [
              Positioned.fill(child: CameraPreview(_controller!)),

              // Overlay: detected quad + guide hint
              Positioned.fill(
                child: CustomPaint(
                  painter: _QuadPainter(
                    pvW: _pvWidth,
                    pvH: _pvHeight,
                    canvasW: screenW,
                    canvasH: screenH,
                    quadPreview: _lastQuadPreview,
                    state: _state,
                    drawGuideBox: true, // purely visual hint
                  ),
                ),
              ),

              // Flash overlay on capture
              if (_flashOverlay)
                Positioned.fill(
                  child: Container(color: Colors.white.withOpacity(0.35)),
                ),

              // Status chip (top-center)
              Positioned(
                top: 12,
                left: 0,
                right: 0,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _statusColor, width: 1.2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _state == _DetectState.searching
                              ? Icons.search
                              : _state == _DetectState.stable
                              ? Icons.center_focus_strong
                              : _state == _DetectState.capturedCooldown
                              ? Icons.hourglass_top
                              : Icons.swipe,
                          size: 18,
                          color: _statusColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _statusText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom hint (SafeArea so it's not glued to the bottom edge)
              Positioned(
                left: 0,
                right: 0,
                bottom: 12,
                child: SafeArea(
                  minimum: const EdgeInsets.only(bottom: 12),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _lastQuadPreview == null
                            ? 'Place the card anywhere—edges will be detected automatically'
                            : 'Edges found! Hold steady…',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// === Painter for overlay & guide box ===
class _QuadPainter extends CustomPainter {
  final int pvW, pvH;
  final double canvasW, canvasH;
  final List<cv.Point2f>? quadPreview; // in preview space
  final _DetectState state;
  final bool drawGuideBox;

  _QuadPainter({
    required this.pvW,
    required this.pvH,
    required this.canvasW,
    required this.canvasH,
    required this.quadPreview,
    required this.state,
    required this.drawGuideBox,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Visual guide box with true card aspect (63x88mm => 0.7159)
    if (drawGuideBox) {
      const aspect = 63.0 / 88.0; // width / height
      final maxW = canvasW * 0.8;
      final maxH = canvasH * 0.8;
      double gw = maxW;
      double gh = gw / aspect;
      if (gh > maxH) {
        gh = maxH;
        gw = gh * aspect;
      }

      final cx = canvasW / 2;
      final cy = canvasH / 2;
      final guideRect = ui.RRect.fromRectAndRadius(
        ui.Rect.fromLTWH(cx - gw / 2, cy - gh / 2, gw, gh),
        const Radius.circular(12),
      );
      // dashed border look
      final guide = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white70;
      canvas.drawRRect(guideRect, guide);
    }

    if (quadPreview == null || pvW == 0 || pvH == 0) return;

    // Convert preview-space quad → canvas space
    final sx = canvasW / pvW;
    final sy = canvasH / pvH;
    final pts = quadPreview!
        .map((p) => Offset(p.x * sx, p.y * sy))
        .toList(growable: false);

    final path = Path()
      ..moveTo(pts[0].dx, pts[0].dy)
      ..lineTo(pts[1].dx, pts[1].dy)
      ..lineTo(pts[2].dx, pts[2].dy)
      ..lineTo(pts[3].dx, pts[3].dy)
      ..close();

    // Semi-transparent fill (silhouette)
    final baseColor = state == _DetectState.stable
        ? Colors.lightGreenAccent
        : Colors.orangeAccent;
    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = baseColor.withOpacity(0.16);
    canvas.drawPath(path, fill);

    // Outline
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = baseColor;
    canvas.drawPath(path, line);

    // Corner dots
    final dot = Paint()..color = baseColor;
    for (final p in pts) {
      canvas.drawCircle(p, 4.5, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _QuadPainter old) {
    return old.quadPreview != quadPreview ||
        old.state != state ||
        old.canvasW != canvasW ||
        old.canvasH != canvasH ||
        old.pvW != pvW ||
        old.pvH != pvH ||
        old.drawGuideBox != drawGuideBox;
  }
}

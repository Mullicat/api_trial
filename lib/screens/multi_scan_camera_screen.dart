// ============================================================================
// FILE: multi_scan_camera_screen.dart
// PURPOSE: Live camera-based multi-scan workflow.
//          1) Continuously detect a card-shaped quadrilateral (doc-scanner style)
//          2) Show a translucent silhouette overlay for UX
//          3) When stable, capture → warp → OCR → detect game → find One Piece card
//          4) Collect chosen cards and return to caller
//
// MAIN PIECES:
//   - MultiScanCameraScreen (Stateful): camera + detection FSM + UX
//   - _QuadPainter: draws the detected quad & a visual guide (card aspect)
//
// DEPENDENCIES:
//   - camera: live preview + still capture
//   - opencv_dart: edge detection + perspective warp
//   - ML/OCR services (OcrService, GameDetectionService, OnePieceTcgService)
//
// FSM STATES:
//   - searching        : no stable quad yet; look for edges
//   - stable           : quad persisted ~8 frames; trigger capture
//   - capturedCooldown : brief pause after capture to avoid duplicates
//   - waitingChange    : wait for scene motion (user replaces card)
// ============================================================================

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

// ----------------------------------------------------------------------------
// FSM enum
// ----------------------------------------------------------------------------
enum _DetectState { searching, stable, capturedCooldown, waitingChange }

// ----------------------------------------------------------------------------
// WIDGET: MultiScanCameraScreen
// ----------------------------------------------------------------------------
class MultiScanCameraScreen extends StatefulWidget {
  const MultiScanCameraScreen({super.key});

  @override
  State<MultiScanCameraScreen> createState() => _MultiScanCameraScreenState();
}

// ----------------------------------------------------------------------------
// STATE: _MultiScanCameraScreenState
// STATE VARS (groups):
//   Camera: _controller, _ready, _takingShot
//   Services: _edge, _ocr, _gameDetect, _onePiece
//   Results: _picked (accumulated cards)
//   FSM: _state, _stableQuadPrev, counters (_stableCount/_cooldownFrames/_changedFrames)
//   Motion: _prevY (Y-plane baseline), _frameSkip (throttling)
//   Preview meta: _pvWidth/_pvHeight
//   Overlay: _lastQuadPreview (for painter), _flashOverlay (flash effect)
// ----------------------------------------------------------------------------
class _MultiScanCameraScreenState extends State<MultiScanCameraScreen> {
  // --- camera lifecycle ---
  CameraController? _controller;
  bool _ready = false;
  bool _takingShot = false;

  // --- services ---
  final _edge = EdgeDetectService();
  final _ocr = OcrService();
  final _gameDetect = GameDetectionService();
  late OnePieceTcgService _onePiece;

  // --- results / collected cards ---
  final List<TCGCard> _picked = [];

  // --- FSM ---
  _DetectState _state = _DetectState.searching;
  List<List<double>>? _stableQuadPrev; // last stable quad in PREVIEW space
  int _stableCount = 0;
  int _cooldownFrames = 0;
  int _changedFrames = 0;

  // --- motion baseline ---
  Uint8List? _prevY; // previous Y plane for simple diff
  int _frameSkip = 0; // throttle factor

  // --- preview meta (mapping preview → still) ---
  int _pvWidth = 0;
  int _pvHeight = 0;

  // --- overlay state ---
  List<cv.Point2f>? _lastQuadPreview; // painter input (preview coords)
  bool _flashOverlay = false;

  // --------------------------------------------------------------------------
  // LIFECYCLE: init / dispose
  // --------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    try {
      // 1) services ready
      _onePiece = await OnePieceTcgService.create();

      // 2) choose a camera (prefer back)
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

      // 3) controller + init + stream
      _controller = CameraController(
        cam,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420, // we use Y plane
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
    _lastQuadPreview?.forEach((p) => p.dispose());
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // STREAM: _onPreviewFrame
  // - Consume preview frames (YUV420), detect card-like quad on Y plane.
  // - Update FSM & overlay silhouette + UX hints.
  // --------------------------------------------------------------------------
  Future<void> _onPreviewFrame(CameraImage img) async {
    if (_takingShot) return;
    // Optional throttle (every Nth frame)
    if ((_frameSkip++ % 1) != 0) return;

    // Cache preview dims for mapping
    final pvW = img.width;
    final pvH = img.height;
    _pvWidth = pvW;
    _pvHeight = pvH;

    // Gray (Y) plane
    final yBytes = img.planes.first.bytes;

    // Edge detection on full frame (doc scanner-like)
    final quad = _edge.detectCardQuadOnGrayU8(
      gray: yBytes,
      width: pvW,
      height: pvH,
      // roi: null
    );

    // Update overlay points (painter)
    _maybeUpdateOverlay(quad);

    // Global motion (simple absolute diff)
    final moved = _detectMotion(yBytes);

    // ---------- FSM ----------
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
        // Fire capture once when stable
        if (_stableQuadPrev != null) {
          _triggerCaptureWithQuad(_stableQuadPrev!);
        }
        _state = _DetectState.capturedCooldown;
        _cooldownFrames = 10; // brief pause
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
        // Wait for scene to change (user removes/replaces card)
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

  // --------------------------------------------------------------------------
  // GEOMETRY/UTILITY: quad comparisons & conversions
  // --------------------------------------------------------------------------
  bool _isSameQuad(List<cv.Point2f> q, List<List<double>>? prev) {
    if (prev == null || prev.length != 4) return false;
    double sum = 0;
    for (var i = 0; i < 4; i++) {
      final dx = q[i].x - prev[i][0];
      final dy = q[i].y - prev[i][1];
      sum += dx * dx + dy * dy;
    }
    return sum < 200.0; // preview-pixel threshold
  }

  List<List<double>> _toDoubleQuad(List<cv.Point2f> q) =>
      q.map((p) => [p.x.toDouble(), p.y.toDouble()]).toList();

  // --------------------------------------------------------------------------
  // MOTION: simple mean absolute difference over subsampled Y bytes
  // --------------------------------------------------------------------------
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

  // --------------------------------------------------------------------------
  // CAPTURE: takePicture → map preview→still → warp → OCR → OnePiece lookup
  // --------------------------------------------------------------------------
  Future<void> _triggerCaptureWithQuad(List<List<double>> quadPreview) async {
    if (_takingShot || _controller == null) return;
    setState(() => _takingShot = true);

    _flash(); // quick visual confirmation

    try {
      // 1) High-res still
      final x = await _controller!.takePicture();
      final still = File(x.path);

      // 2) Preview→still mapping factors
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

      // 3) Perspective warp (rectified card)
      final warped = await _edge.warpAndWriteJpeg(
        srcJpeg: still,
        quad: quadStill,
        outWidth: 700,
        outHeight: 980,
      );
      final cardFile = warped ?? still;

      // 4) OCR + game detect
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

      // 5) Extract code → Supabase search
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

  // --------------------------------------------------------------------------
  // UX HELPERS: flash, toasts, picker for multi-matches, banner confirmation
  // --------------------------------------------------------------------------
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

  // --------------------------------------------------------------------------
  // OVERLAY: maintain last preview-quad for painter, with cheap change check
  // --------------------------------------------------------------------------
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

  // --------------------------------------------------------------------------
  // STATUS CHIP CONTENT
  // --------------------------------------------------------------------------
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

  // --------------------------------------------------------------------------
  // BUILD: camera preview + overlay + chip + bottom hint + "Done" action
  // --------------------------------------------------------------------------
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
              // Camera feed
              Positioned.fill(child: CameraPreview(_controller!)),

              // Overlay (quad + guide)
              Positioned.fill(
                child: CustomPaint(
                  painter: _QuadPainter(
                    pvW: _pvWidth,
                    pvH: _pvHeight,
                    canvasW: screenW,
                    canvasH: screenH,
                    quadPreview: _lastQuadPreview,
                    state: _state,
                    drawGuideBox: true, // visual guidance with card aspect
                  ),
                ),
              ),

              // Flash overlay
              if (_flashOverlay)
                Positioned.fill(
                  child: Container(color: Colors.white.withOpacity(0.35)),
                ),

              // Status chip (top-center, inside safe area)
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

              // Bottom hint (safe area spacing)
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

// ============================================================================
// PAINTER: _QuadPainter
// DRAWS:
//   - Visual guide box with true card aspect (~63x88mm ≈ 0.716)
//   - Semi-transparent silhouette of detected quad
//   - Outline & corner dots for clarity
// INPUTS:
//   - pvW/pvH: preview dimensions for coordinate mapping
//   - canvasW/canvasH: paint area size
//   - quadPreview: 4 points in PREVIEW space
//   - state: FSM (for color)
//   - drawGuideBox: toggle guide
// ============================================================================
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
    // --- Guide box (card aspect 63:88) --------------------------------------
    if (drawGuideBox) {
      const aspect = 63.0 / 88.0; // width / height ≈ 0.716
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

      final guide = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white70;

      canvas.drawRRect(guideRect, guide);
    }

    // --- Nothing to draw yet ------------------------------------------------
    if (quadPreview == null || pvW == 0 || pvH == 0) return;

    // --- Map preview → canvas ----------------------------------------------
    final sx = canvasW / pvW;
    final sy = canvasH / pvH;
    final pts = quadPreview!
        .map((p) => Offset(p.x * sx, p.y * sy))
        .toList(growable: false);

    // Quad path
    final path = Path()
      ..moveTo(pts[0].dx, pts[0].dy)
      ..lineTo(pts[1].dx, pts[1].dy)
      ..lineTo(pts[2].dx, pts[2].dy)
      ..lineTo(pts[3].dx, pts[3].dy)
      ..close();

    // Fill color depends on stability for quick feedback
    final baseColor = state == _DetectState.stable
        ? Colors.lightGreenAccent
        : Colors.orangeAccent;

    // Semi-transparent silhouette
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

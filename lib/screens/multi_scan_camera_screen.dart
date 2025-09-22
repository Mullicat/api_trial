// lib/screens/multi_scan_camera_screen.dart
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

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
  List<List<double>>? _stableQuadPrev; // last stable quad (preview space)
  int _stableCount = 0;
  int _cooldownFrames = 0;
  int _changedFrames = 0;

  // motion baseline
  Uint8List? _prevY; // previous Y plane, downsampled
  int _frameSkip = 0;

  // current preview meta (for mapping preview→still)
  int _pvWidth = 0;
  int _pvHeight = 0;

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

      // prefer back camera
      final CameraDescription cam = cams.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cams.first,
      );

      _controller = CameraController(
        cam,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420, // we’ll use Y
      );

      await _controller!.initialize();
      if (!mounted) return;

      // Start stream
      _controller!.startImageStream(_onPreviewFrame);

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
    super.dispose();
  }

  // == Preview processing ==
  Future<void> _onPreviewFrame(CameraImage img) async {
    if (_takingShot) return; // pause detection while capturing/processing
    // throttle to ~10–12 fps
    if ((_frameSkip++ % 2) != 0) return;

    // Y plane only (grayscale)
    final yPlane = img.planes.first;
    final yBytes = yPlane.bytes;
    final pvW = img.width;
    final pvH = img.height;
    _pvWidth = pvW;
    _pvHeight = pvH;

    // Detect quad on Y
    final quad = _edge.detectCardQuadOnGrayU8(
      gray: yBytes,
      width: pvW,
      height: pvH,
    );

    // Compute motion outside of the last ROI (cheap global diff)
    final moved = _detectMotion(yBytes);

    switch (_state) {
      case _DetectState.searching:
        if (quad != null) {
          // If similar to last frame quad, increment stableCount, else reset
          if (_isSameQuad(quad, _stableQuadPrev)) {
            _stableCount++;
          } else {
            _stableCount = 1;
            _stableQuadPrev = _toDoubleQuad(quad);
          }
          // Require persistence
          if (_stableCount >= 8) {
            _state = _DetectState.stable;
          }
        } else {
          _stableCount = 0;
          _stableQuadPrev = null;
        }
        break;

      case _DetectState.stable:
        // Immediately capture once when stable (and sharp enough ideally).
        // To keep it simple here, we trigger right away.
        _triggerCaptureWithQuad(_stableQuadPrev!);
        _state = _DetectState.capturedCooldown;
        _cooldownFrames = 10; // ~0.3–0.5s depending on throttle
        break;

      case _DetectState.capturedCooldown:
        _cooldownFrames--;
        if (_cooldownFrames <= 0) {
          _state = _DetectState.waitingChange;
          _changedFrames = 0;
        }
        break;

      case _DetectState.waitingChange:
        // Wait for scene change (hand replaces card)
        if (moved) {
          _changedFrames++;
          if (_changedFrames >= 4) {
            _state = _DetectState.searching;
            _stableCount = 0;
            _stableQuadPrev = null;
          }
        } else {
          _changedFrames = 0;
        }
        break;
    }
  }

  bool _isSameQuad(List<cv.Point2f> q, List<List<double>>? prev) {
    if (prev == null) return false;
    if (prev.length != 4) return false;
    double sum = 0;
    for (var i = 0; i < 4; i++) {
      final dx = q[i].x - prev[i][0];
      final dy = q[i].y - prev[i][1];
      sum += (dx * dx + dy * dy);
    }
    // threshold in preview pixels
    return sum < 200.0;
  }

  List<List<double>> _toDoubleQuad(List<cv.Point2f> q) =>
      q.map((p) => [p.x.toDouble(), p.y.toDouble()]).toList();

  bool _detectMotion(Uint8List y) {
    if (_prevY == null || _prevY!.length != y.length) {
      _prevY = Uint8List.fromList(y);
      return false;
    }
    // quick MSE on subsampled pixels
    const step = 16;
    int count = 0;
    double acc = 0;
    for (int i = 0; i < y.length; i += step) {
      final d = (y[i] - _prevY![i]).abs();
      acc += d.toDouble();
      count++;
    }
    _prevY!.setAll(0, y);
    final avg = acc / count; // ~0–255
    return avg > 3.5; // small threshold
  }

  Future<void> _triggerCaptureWithQuad(List<List<double>> quadPreview) async {
    if (_takingShot || _controller == null) return;
    setState(() => _takingShot = true);

    try {
      // 1) Take full-res still
      final x = await _controller!.takePicture();
      final still = File(x.path);

      // 2) Map preview quad → still coordinates.
      //    Simple scale by ratios (works if aspect matches).
      //    If you see drift, you can refine via view transforms.
      final pvW = _pvWidth.toDouble();
      final pvH = _pvHeight.toDouble();

      // get still size to compute scale
      final decoded = await still.readAsBytes();
      // Lazy parse JPEG size: load with opencv (fast) to get width/height
      final mat = cv.imdecode(decoded, cv.IMREAD_GRAYSCALE);
      final stW = mat.cols.toDouble();
      final stH = mat.rows.toDouble();
      mat.dispose();

      final sx = stW / pvW;
      final sy = stH / pvH;

      final quadStill = quadPreview
          .map((p) => cv.Point2f((p[0] * sx), (p[1] * sy)))
          .toList();

      // 3) Warp to rectified card JPEG for OCR
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

      // 5) Extract code + Supabase lookup
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
      body: Stack(
        children: [
          Positioned.fill(child: CameraPreview(_controller!)),
          // simple guide
          IgnorePointer(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // bottom hint
          Positioned(
            left: 0,
            right: 0,
            bottom: 18,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _state == _DetectState.searching
                      ? 'Place card in frame'
                      : _state == _DetectState.stable
                      ? 'Capturing...'
                      : _state == _DetectState.capturedCooldown
                      ? 'Processing...'
                      : 'Replace card to continue',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

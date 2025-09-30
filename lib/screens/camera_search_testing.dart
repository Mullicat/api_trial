// ============================================================================
// FILE: camera_search_testing.dart
// PURPOSE: Live OpenCV preview + capture flow (manual/auto, single/multi).
//   • Pipeline: Gray (Y) → [GaussianBlur] → [Morph Close] → [Dilate] → [Canny]
//   • Portrait-only, overlays aligned 1:1 with preview (stretched fill).
//   • Auto-capture: fires when a detected card-like quad is stable N frames.
//   • Manual-capture: centered FAB button.
//   • Single/Multi toggle. Finish returns {'files': List<File>, 'cards': List<TCGCard>} (captured JPEGs and found cards).
//   • Stream watchdog + restart.
//   • Uses EdgeDetectServiceManual for overlay + quad.
//   • On capture, performs OCR + search for card via One Piece game code.
//   • Notifications: Top-positioned SnackBar with card image, name, game code, rarity.
//   • Multiple Results: Shows a modal dialog with a list of cards for user selection.
//   • Scanned Cards Dialog: Shows unique cards (by UUID), with -/+ count, delete, and clear options.
// ============================================================================

import 'dart:async';
import 'dart:ffi' hide Size;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' hide Size;

import 'package:api_trial/services/edge_detecting_service_manual.dart';
import 'package:api_trial/services/ocr_service.dart';
import 'package:api_trial/services/onepiece_service.dart';
import 'package:api_trial/models/card.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide Size;
import 'package:ffi/ffi.dart' as ffi;
import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CameraSearchTestingScreen extends StatefulWidget {
  const CameraSearchTestingScreen({super.key});

  @override
  State<CameraSearchTestingScreen> createState() =>
      _CameraSearchTestingScreenState();
}

class _CameraSearchTestingScreenState extends State<CameraSearchTestingScreen> {
  // camera / stream
  CameraController? _controller;
  bool _ready = false;
  bool _inProcess = false;
  int _frameStride = 1;
  int _frameCount = 0;

  // primary overlay (encoded JPG of processed frame)
  Uint8List? _overlayBytes;
  int _srcW = 0, _srcH = 0;

  // second overlay: detected quad in SOURCE coordinates
  List<Offset>? _quadOverlay;

  // capture state
  bool _autoCapture = true; // ON by default
  bool _multiCapture = true;
  bool _captureBusy = false;
  List<File> _captures = [];
  List<TCGCard?> _foundCards = []; // New: found cards from search

  // auto-capture stability
  static const int _stableNeeded = 20; // ~1s at 20fps
  static const double _maxCornerDelta = 8.0; // px per corner avg
  int _stableCount = 0;
  List<Offset>? _lastQuad;
  DateTime _lastAutoShot = DateTime.fromMillisecondsSinceEpoch(0);
  Duration _autoCooldown = const Duration(seconds: 2);

  // quad loss detection
  bool _requireQuadLoss = false; // After capture, require quad loss before next
  int _quadLostCount = 0; // Consecutive frames without quad
  static const int _quadLossThreshold =
      5; // Frames to confirm loss (~0.25s at 20fps)

  // params
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

  bool _exiting = false;

  // layout
  bool _fillScreenCrop = false;
  bool _showMenu = false;

  // watchdog
  Timer? _watchdog;
  DateTime? _lastFrameTs;
  String? _lastError;

  // resolution
  ResolutionPreset _preset = ResolutionPreset.medium;
  bool _reconfiguring = false;

  // services
  final _edge = EdgeDetectServiceManual();
  final _ocr = OcrService();
  late final OnePieceTcgService _service;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(const [DeviceOrientation.portraitUp]);
    _initService();
    _initCamera();
  }

  Future<void> _initService() async {
    _service = await OnePieceTcgService.create();
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
        _preset,
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

  Future<void> _changeResolution(ResolutionPreset p) async {
    if (_preset == p || _reconfiguring) return;
    setState(() {
      _preset = p;
      _reconfiguring = true;
    });

    try {
      try {
        await _controller?.stopImageStream();
      } catch (_) {}
      await _controller?.dispose();

      final cams = await availableCameras();
      final cam = cams.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cams.first,
      );

      _controller = CameraController(
        cam,
        _preset,
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
    } finally {
      if (mounted) setState(() => _reconfiguring = false);
    }
  }

  Future<void> _finishAndReturn() async {
    if (_exiting) return;
    _exiting = true;

    try {
      print('Starting _finishAndReturn');
      _watchdog?.cancel();
      _watchdog = null;

      // Stop stream with timeout
      if (_controller != null) {
        try {
          await _controller!.stopImageStream().timeout(
            const Duration(seconds: 2),
            onTimeout: () {
              print('Stream stop timed out');
              return;
            },
          );
        } catch (e) {
          print('Error stopping stream: $e');
        }
      }

      // Dispose controller with timeout
      if (_controller != null) {
        try {
          await _controller!.dispose().timeout(
            const Duration(seconds: 2),
            onTimeout: () {
              print('Controller dispose timed out');
              return;
            },
          );
        } catch (e) {
          print('Error disposing controller: $e');
        }
        _controller = null;
      }

      // Ensure state is updated before pop
      if (mounted) {
        print(
          'Popping result: ${_captures.length} files, ${_foundCards.length} cards',
        );
        final nonNullCards = _foundCards
            .where((c) => c != null)
            .cast<TCGCard>()
            .toList();
        Navigator.of(context).pop<Map<String, dynamic>>({
          'files': _captures,
          'cards': nonNullCards,
        });
      }
    } catch (e) {
      print('Error in _finishAndReturn: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error exiting: $e')));
        final nonNullCards = _foundCards
            .where((c) => c != null)
            .cast<TCGCard>()
            .toList();
        Navigator.of(context).pop<Map<String, dynamic>>({
          'files': _captures,
          'cards': nonNullCards,
        });
      }
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

  double _avgCornerDelta(List<Offset> a, List<Offset> b) {
    if (a.length != 4 || b.length != 4) return 1e9;
    double d = 0;
    for (int i = 0; i < 4; i++) {
      d += (a[i] - b[i]).distance;
    }
    return d / 4.0;
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

      final (bytes, quadD) = await _edge.processForOverlayAndQuad(
        gray: y,
        width: _srcW,
        height: _srcH,
        params: params,
      );

      List<Offset>? quad;
      if (quadD != null && quadD.length == 4) {
        quad = quadD
            .map((p) => Offset(p[0].toDouble(), p[1].toDouble()))
            .toList(growable: false);
      }

      // Auto-capture stability tracking
      if (_autoCapture && !_captureBusy && quad != null) {
        if (_requireQuadLoss) {
          // Quad is present, but we need loss first - do nothing
          _quadLostCount = 0; // Reset loss if quad seen
        } else {
          final now = DateTime.now();
          final cooldownOk = now.difference(_lastAutoShot) >= _autoCooldown;

          if (_lastQuad != null) {
            final delta = _avgCornerDelta(_lastQuad!, quad);
            if (delta <= _maxCornerDelta) {
              _stableCount++;
            } else {
              _stableCount = 0;
            }
          } else {
            _stableCount = 0;
          }
          _lastQuad = quad;

          // Fire
          if (cooldownOk && _stableCount >= _stableNeeded) {
            _stableCount = 0;
            _lastAutoShot = now;
            unawaited(_captureStill());
            _requireQuadLoss = true; // After capture, require loss
          }
        }
      } else {
        // No quad
        _stableCount = 0;
        _lastQuad = null;

        if (_requireQuadLoss) {
          _quadLostCount++;
          if (_quadLostCount >= _quadLossThreshold) {
            _requireQuadLoss = false; // Loss confirmed, re-arm
            _quadLostCount = 0;
          }
        }
      }

      if (mounted) {
        setState(() {
          _overlayBytes = bytes;
          _quadOverlay = quad;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _lastError = 'Process error: $e');
    } finally {
      _inProcess = false;
    }
  }

  // === Capture ===============================================================

  Future<void> _captureStill() async {
    if (_controller == null || _captureBusy) return;
    if (!_multiCapture && _captures.isNotEmpty) {
      _captures.clear();
      _foundCards.clear();
    }

    _captureBusy = true;
    try {
      // Capture full still (stop stream for reliability)
      try {
        await _controller!.stopImageStream();
      } catch (_) {}

      final XFile shot = await _controller!.takePicture();

      // Load captured bytes and process with OpenCV
      final Uint8List bytes = await File(shot.path).readAsBytes();
      cv.Mat? src;
      File? processedFile;
      try {
        src = cv.imdecode(bytes, cv.IMREAD_COLOR);
        final int capW = src.cols;
        final int capH = src.rows;

        if (_quadOverlay != null && _quadOverlay!.length == 4) {
          // Scale quad from preview to capture resolution
          final double sx = capW / _srcW.toDouble();
          final double sy = capH / _srcH.toDouble();
          final List<cv.Point2f> srcPtsList = _quadOverlay!
              .map((o) => cv.Point2f(o.dx * sx, o.dy * sy))
              .toList();
          final cv.VecPoint2f srcPts = cv.VecPoint2f.fromList(srcPtsList);

          // Target rectangle (card aspect 63:88)
          const double cardAspect = 63.0 / 88.0;
          const int tgtW = 700;
          final int tgtH = (tgtW / cardAspect).round();
          final cv.VecPoint2f dstPts = cv.VecPoint2f.fromList([
            cv.Point2f(0, 0),
            cv.Point2f(tgtW.toDouble(), 0),
            cv.Point2f(tgtW.toDouble(), tgtH.toDouble()),
            cv.Point2f(0, tgtH.toDouble()),
          ]);

          // Get transform and warp
          final cv.Mat m = cv.getPerspectiveTransform2f(srcPts, dstPts);
          final cv.Mat warped = cv.warpPerspective(src, m, (tgtW, tgtH));

          // Encode to JPEG
          final (bool ok, Uint8List jpg) = cv.imencode('.jpg', warped);
          if (ok) {
            // Temp dir for output
            final dir = await getTemporaryDirectory();
            final String outPath =
                '${dir.path}/warped_${DateTime.now().millisecondsSinceEpoch}.jpg';
            processedFile = await File(outPath).writeAsBytes(jpg);
          }

          // Cleanup
          m.dispose();
          warped.dispose();
        } else {
          // Fallback: no quad, use full image
          processedFile = File(shot.path);
        }

        if (processedFile != null) {
          // Copy to final temp path (or use directly)
          final dir = await getTemporaryDirectory();
          final out = File(
            '${dir.path}/shot_${DateTime.now().millisecondsSinceEpoch}.jpg',
          );
          await processedFile.copy(out.path);
          _captures.add(out);

          // Perform OCR + search on processed file
          await _searchCapturedCard(out);

          if (mounted) setState(() {});
        } else {
          throw Exception('Processing failed');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Capture process failed: $e')));
        }
      } finally {
        src?.dispose();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Capture failed: $e')));
      }
    } finally {
      // Restart stream
      try {
        await _controller!.startImageStream(_onPreviewFrame);
        _startWatchdog();
      } catch (e) {
        setState(() => _lastError = 'Stream restart failed: $e');
      }
      _captureBusy = false;
    }
  }

  Future<void> _searchCapturedCard(File imageFile) async {
    try {
      // OCR (assuming auto-detect)
      final ocrResult = await _ocr.processImageWithAutoDetect(imageFile, true);
      final textBlocks = ocrResult['textBlocks'] as List<Map<String, dynamic>>;
      final joinedText = ocrResult['joinedText'] as String?;

      // Extract game code
      final code = _ocr.extractOnePieceGameCode(
        textBlocks: textBlocks,
        joinedText: joinedText,
      );

      if (code == null) {
        _foundCards.add(null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
            content: const Row(
              children: [
                Icon(Icons.image_not_supported, size: 40, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No game code found, try again',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }

      // Query Supabase
      final cards = await _service.getCardsByGameCodeFromDatabase(
        gameCode: code,
      );

      if (cards.isEmpty) {
        _foundCards.add(null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
            content: const Row(
              children: [
                Icon(Icons.image_not_supported, size: 40, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'No card found, try again',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      } else if (cards.length == 1) {
        final card = cards.first;
        _foundCards.add(card);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
            content: Row(
              children: [
                if (card.imageRefSmall != null &&
                    card.imageRefSmall!.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: card.imageRefSmall!,
                    width: 40,
                    height: 56,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const SizedBox(
                      width: 40,
                      height: 56,
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: Colors.white,
                    ),
                  )
                else
                  const Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.white,
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        card.name ?? 'Unknown',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Code: ${card.gameCode ?? 'N/A'}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Rarity: ${card.rarity ?? 'N/A'}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.blueGrey,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        // Multiple cards found, show selection dialog
        if (mounted) {
          final selectedCard = await showDialog<TCGCard>(
            context: context,
            barrierDismissible: true,
            builder: (context) => Dialog(
              insetPadding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        'Multiple Cards Found (${cards.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: cards.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final c = cards[index];
                          final subtitle = [
                            if (c.setName != null && c.setName!.isNotEmpty)
                              c.setName!,
                            if (c.rarity != null && c.rarity!.isNotEmpty)
                              c.rarity!,
                            if (c.gameCode != null && c.gameCode!.isNotEmpty)
                              c.gameCode!,
                          ].join(' • ');
                          return ListTile(
                            leading:
                                (c.imageRefSmall != null &&
                                    c.imageRefSmall!.isNotEmpty)
                                ? CachedNetworkImage(
                                    imageUrl: c.imageRefSmall!,
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.broken_image),
                                  )
                                : const Icon(Icons.image_not_supported),
                            title: Text(c.name ?? 'Unknown'),
                            subtitle: Text(subtitle),
                            onTap: () => Navigator.of(context).pop(c),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(null),
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

          if (selectedCard != null) {
            _foundCards.add(selectedCard);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                content: Row(
                  children: [
                    if (selectedCard.imageRefSmall != null &&
                        selectedCard.imageRefSmall!.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: selectedCard.imageRefSmall!,
                        width: 40,
                        height: 56,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const SizedBox(
                          width: 40,
                          height: 56,
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.white,
                        ),
                      )
                    else
                      const Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.white,
                      ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectedCard.name ?? 'Unknown',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Code: ${selectedCard.gameCode ?? 'N/A'}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          Text(
                            'Rarity: ${selectedCard.rarity ?? 'N/A'}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.blueGrey,
                duration: const Duration(seconds: 3),
              ),
            );
          } else {
            // User canceled, add null
            _foundCards.add(null);
          }
        }
      }
    } catch (e) {
      _foundCards.add(null);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
          content: Row(
            children: [
              const Icon(Icons.error, size: 40, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Search failed: $e',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // === View helpers ==========================================================

  int _overlayQuarterTurns() {
    if (_controller == null) return 0;
    final deg = _controller!.description.sensorOrientation; // 0/90/180/270
    return ((deg ~/ 90) % 4);
  }

  Size _currentSourceSize() {
    if (_srcW > 0 && _srcH > 0) {
      return Size(_srcW.toDouble(), _srcH.toDouble());
    }
    final ps = _controller!.value.previewSize!;
    return Size(ps.width, ps.height);
  }

  // === UI (menu helpers) =====================================================

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
      secondChild: const SizedBox.shrink(), // No collapsed handle
    );
  }

  Widget _buildMenuCard() {
    final maxH = MediaQuery.of(context).size.height * 0.55;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        color: Colors.black.withOpacity(0.6),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: SizedBox(
            height: maxH,
            child: SingleChildScrollView(
              child: Column(
                children: [
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

                  // Capture mode controls
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      FilterChip(
                        label: Text(
                          _autoCapture
                              ? 'Auto-capture: ON'
                              : 'Auto-capture: OFF',
                        ),
                        selected: _autoCapture,
                        onSelected: (v) => setState(() => _autoCapture = v),
                      ),
                      FilterChip(
                        label: Text(
                          _multiCapture ? 'Mode: Multiple' : 'Mode: Single',
                        ),
                        selected: _multiCapture,
                        onSelected: (v) => setState(() => _multiCapture = v),
                      ),
                      Text(
                        'Captured: ${_captures.length}'
                        '${_autoCapture ? '  •  Stable: $_stableCount/$_stableNeeded' : ''}',
                        style: const TextStyle(color: Colors.white70),
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
                          LabeledSlider(
                            label: 'Kernel (odd)',
                            value: _blurKernel.toDouble(),
                            min: 1,
                            max: 15,
                            divisions: 7,
                            display: '${_clampOdd(_blurKernel, 1, 15)}',
                            onChanged: (v) =>
                                setState(() => _blurKernel = v.round()),
                          ),
                          LabeledSlider(
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
                      child: LabeledSlider(
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
                    value: _useMorphClose,
                    onChanged: (v) => setState(() => _useMorphClose = v),
                    title: const Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (_useMorphDilate)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: LabeledSlider(
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
                            LabeledSlider(
                              label: 'Low',
                              value: _cannyLow,
                              min: 0,
                              max: 255,
                              divisions: 255,
                              display: _cannyLow.toStringAsFixed(0),
                              onChanged: (v) => setState(() => _cannyLow = v),
                            ),
                            LabeledSlider(
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

  // === Scanned Cards Dialog ==================================================

  Future<void> _showScannedCardsDialog() async {
    // Group by unique ID (UUID)
    final Map<String, List<int>> groups = {};
    for (int i = 0; i < _foundCards.length; i++) {
      final c = _foundCards[i];
      if (c != null) {
        final key = c.id ?? 'unknown_${i}'; // Unique ID, fallback if no ID
        groups.putIfAbsent(key, () => []).add(i);
      }
    }

    if (groups.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No cards scanned yet')));
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog(
        insetPadding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(dialogContext).size.height * 0.7,
            maxWidth: MediaQuery.of(dialogContext).size.width * 0.9,
          ),
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              // Rebuild groups for dialog state
              final Map<String, List<int>> dialogGroups = {};
              for (int i = 0; i < _foundCards.length; i++) {
                final c = _foundCards[i];
                if (c != null) {
                  final key = c.id ?? 'unknown_${i}';
                  dialogGroups.putIfAbsent(key, () => []).add(i);
                }
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Scanned Cards',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: dialogGroups.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, groupIndex) {
                        final entry = dialogGroups.entries.elementAt(
                          groupIndex,
                        );
                        final key = entry.key;
                        final indices = entry.value;
                        final card = _foundCards[indices.first]!;
                        final count = indices.length;

                        final subtitle = [
                          if (card.setName != null && card.setName!.isNotEmpty)
                            card.setName!,
                          if (card.rarity != null && card.rarity!.isNotEmpty)
                            card.rarity!,
                          if (card.gameCode != null &&
                              card.gameCode!.isNotEmpty)
                            card.gameCode!,
                        ].join(' • ');

                        return ListTile(
                          leading:
                              (card.imageRefSmall != null &&
                                  card.imageRefSmall!.isNotEmpty)
                              ? CachedNetworkImage(
                                  imageUrl: card.imageRefSmall!,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.broken_image),
                                )
                              : const Icon(Icons.image_not_supported),
                          title: Text(card.name ?? 'Unknown'),
                          subtitle: Text(subtitle),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: count > 1
                                    ? () {
                                        _adjustCount(key, -1);
                                        setDialogState(() {});
                                        setState(() {}); // Update main UI
                                      }
                                    : null,
                              ),
                              Text('$count'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  _adjustCount(key, 1);
                                  setDialogState(() {});
                                  setState(() {}); // Update main UI
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteCard(key);
                                  setDialogState(() {});
                                  setState(() {}); // Update main UI
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        _clearAll();
                        setDialogState(() {});
                        setState(() {}); // Update main UI
                        Navigator.of(context).pop(); // Close dialog
                      },
                      child: const Text('Clear'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Adjust count for a card: +1 duplicates last entry, -1 removes last entry
  Future<void> _adjustCount(String key, int delta) async {
    final indices = _getGroupIndices(key);
    if (indices.isEmpty) return;

    if (delta > 0) {
      // Duplicate last entry
      final lastIndex = indices.last;
      final card = _foundCards[lastIndex]!;
      final file = _captures[lastIndex];
      final dir = await getTemporaryDirectory();
      final newFilePath =
          '${dir.path}/dupe_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await file.copy(newFilePath);
      final newFile = File(newFilePath);
      setState(() {
        _foundCards.add(card);
        _captures.add(newFile);
      });
    } else if (delta < 0 && indices.length > 1) {
      // Remove last entry
      final lastIndex = indices.last;
      setState(() {
        _foundCards.removeAt(lastIndex);
        final file = _captures.removeAt(lastIndex);
        file.deleteSync();
      });
    }
  }

  // Delete all entries for a card
  void _deleteCard(String key) {
    final indices = _getGroupIndices(key);
    if (indices.isEmpty) return;

    indices.sort(
      (a, b) => b.compareTo(a),
    ); // Descending to remove without shifting indices

    setState(() {
      for (final index in indices) {
        _foundCards.removeAt(index);
        final file = _captures.removeAt(index);
        file.deleteSync();
      }
    });
  }

  // Clear all captures and cards
  void _clearAll() {
    setState(() {
      for (final file in _captures) {
        file.deleteSync();
      }
      _captures.clear();
      _foundCards.clear();
    });
  }

  // Helper to get indices for a group
  List<int> _getGroupIndices(String key) {
    final List<int> indices = [];
    for (int i = 0; i < _foundCards.length; i++) {
      final c = _foundCards[i];
      if (c != null && (c.id ?? 'unknown_$i') == key) {
        indices.add(i);
      }
    }
    return indices;
  }

  // === Build ================================================================

  @override
  Widget build(BuildContext context) {
    if (!_ready || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final srcSize = _currentSourceSize();
    final int cardCount = _foundCards.where((c) => c != null).length;

    return WillPopScope(
      onWillPop: () async {
        await _finishAndReturn();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: const Text('Camera Search Testing (OpenCV)'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _finishAndReturn,
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
              // Camera preview
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: SizedBox(
                    width: srcSize.width,
                    height: srcSize.height,
                    child: CameraPreview(_controller!),
                  ),
                ),
              ),

              // Overlays
              if (_srcW > 0 && _srcH > 0)
                Positioned.fill(
                  child: IgnorePointer(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: RotatedBox(
                        quarterTurns: _overlayQuarterTurns(),
                        child: SizedBox(
                          width: _srcW.toDouble(),
                          height: _srcH.toDouble(),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              if (_overlayBytes != null)
                                Image.memory(
                                  _overlayBytes!,
                                  fit: BoxFit.fill,
                                  gaplessPlayback: true,
                                  opacity: const AlwaysStoppedAnimation(0.75),
                                )
                              else
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              if (_quadOverlay != null)
                                CustomPaint(
                                  size: Size(
                                    _srcW.toDouble(),
                                    _srcH.toDouble(),
                                  ),
                                  painter: _QuadPainter(_quadOverlay!),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Bottom controls
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => _showScannedCardsDialog(),
                          child: Text(
                            'Cards: $cardCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        FloatingActionButton(
                          onPressed: _captureBusy ? null : _captureStill,
                          backgroundColor: Colors.white,
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: _finishAndReturn,
                          child: const Text(
                            'Finish',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Collapsible menu panel (top overlay)
              Positioned(left: 0, right: 0, top: 0, child: _menuPanel()),
            ],
          ),
        ),
      ),
    );
  }
}

// Small labeled slider helper
class LabeledSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final String display;
  final ValueChanged<double> onChanged;

  const LabeledSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.display,
    required this.onChanged,
    this.divisions,
    super.key,
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

// Painter for card-like quad (expects SOURCE-space coordinates)
class _QuadPainter extends CustomPainter {
  final List<Offset> quad; // length == 4

  _QuadPainter(this.quad);

  @override
  void paint(Canvas canvas, Size size) {
    if (quad.length != 4) return;

    final path = Path()
      ..moveTo(quad[0].dx, quad[0].dy)
      ..lineTo(quad[1].dx, quad[1].dy)
      ..lineTo(quad[2].dx, quad[2].dy)
      ..lineTo(quad[3].dx, quad[3].dy)
      ..close();

    final fill = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.lightGreenAccent.withOpacity(0.15);
    canvas.drawPath(path, fill);

    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.lightGreenAccent;
    canvas.drawPath(path, line);

    final dot = Paint()..color = Colors.lightGreenAccent;
    for (final p in quad) {
      canvas.drawCircle(p, 4.0, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _QuadPainter old) {
    if (old.quad.length != quad.length) return true;
    for (int i = 0; i < quad.length; i++) {
      if (old.quad[i] != quad[i]) return true;
    }
    return false;
  }
}

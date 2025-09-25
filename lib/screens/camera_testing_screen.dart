// ============================================================================
// FILE: camera_testing_screen.dart
// PURPOSE: Live camera-based multi-scan workflow.
//          1) Continuously detect a card-shaped quadrilateral (doc-scanner style)
//          2) Show a translucent silhouette overlay for UX
//          3) When stable, capture → warp → OCR → detect game → find One Piece card
//          4) Collect chosen cards and return to caller
//
// MAIN PIECES:
//   - CameraTestingScreen (Stateful): camera + detection FSM + UX
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
class CameraTestingScreen extends StatefulWidget {
  const CameraTestingScreen({super.key});

  @override
  State<CameraTestingScreen> createState() => _CameraTestingScreenState();
}

class _CameraTestingScreenState extends State<CameraTestingScreen> {
  // --- camera lifecycle ---
  CameraController? _controller;
  bool _ready = false;
  bool _takingShot = false;

  // --- services ---
  final _edge = EdgeDetectService();
  final _ocr = OcrService();
  final _gameDetect = GameDetectionService();
  late OnePieceTcgService _onePiece;

  // --- overlay state ---
  List<cv.Point2f>? _lastQuadPreview; // painter input (preview coords)
  bool _flashOverlay = false;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  // --------------------------------------------------------------------------
  // LIFECYCLE: init / dispose
  // --------------------------------------------------------------------------
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
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready || _controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold();
  }
}

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:api_trial/services/ocr_service.dart';
import 'package:api_trial/services/game_detection_service.dart';
import 'package:api_trial/services/onepiece_service.dart';
import 'package:api_trial/models/card.dart';

class MultiScanCameraScreen extends StatefulWidget {
  const MultiScanCameraScreen({super.key});

  @override
  State<MultiScanCameraScreen> createState() => _MultiScanCameraScreenState();
}

class _MultiScanCameraScreenState extends State<MultiScanCameraScreen> {
  CameraController? _controller;
  bool _ready = false;
  bool _busy = false;

  final OcrService _ocr = OcrService();
  final GameDetectionService _gameDetector = GameDetectionService();
  OnePieceTcgService? _onePieceService;

  final List<TCGCard> _selectedCards = [];

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    try {
      final cams = await availableCameras();
      if (cams.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No camera available')),
        );
        Navigator.pop(context);
        return;
      }
      _controller = CameraController(
        cams.first,
        ResolutionPreset.medium,
        imageFormatGroup: ImageFormatGroup.jpeg,
        enableAudio: false,
      );
      await _controller!.initialize();
      _onePieceService = await OnePieceTcgService.create();
      if (!mounted) return;
      setState(() => _ready = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera init error: $e')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  bool _isOnePiece(String game) => game.toLowerCase().contains('one piece');

  Future<void> _captureAndProcess() async {
    if (!_ready || _busy) return;
    setState(() => _busy = true);

    try {
      final xFile = await _controller!.takePicture();
      final file = File(xFile.path);
      if (!await file.exists()) {
        _toast('Capture failed, please try again.');
        return;
      }

      // OCR (Latin auto-detect on, same defaults as your flow)
      final ocrResult = await _ocr.processImageWithAutoDetect(file, true);
      final blocks = (ocrResult['textBlocks'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      final joined = (ocrResult['joinedText'] as String?) ?? '';

      // Game detection (reuse your service logic)
      final detectedGame = _gameDetector.detectGame(
        blocks,
        joined,
        true,   // tcgAutoDetectEnabled
        'YuGiOh', // default fallback
      );

      if (!_isOnePiece(detectedGame)) {
        _toast('Detected $detectedGame — support in progress.');
        return;
      }

      // Extract One Piece code
      final code = _ocr.extractOnePieceGameCode(
        textBlocks: blocks,
        joinedText: joined.isEmpty ? null : joined,
      );

      if (code == null) {
        _toast('No One Piece code found. Try again.');
        return;
      }

      // Query Supabase for One Piece cards by code
      final service = _onePieceService!;
      final results = await service.getCardsByGameCodeFromDatabase(gameCode: code);

      if (results.isEmpty) {
        _toast('No cards for $code. Try again.');
        return;
      }

      if (results.length == 1) {
        _addCard(results.first);
        _banner(results.first);
        return;
      }

      // Multiple – let user pick from a bottom sheet
      if (!mounted) return;
      final chosen = await showModalBottomSheet<TCGCard>(
        context: context,
        isScrollControlled: true,
        builder: (_) => _PickCardSheet(cards: results),
      );

      if (chosen != null) {
        _addCard(chosen);
        _banner(chosen);
      }
    } catch (e) {
      _toast('Scan error: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _addCard(TCGCard card) {
    // Avoid duplicates by id (or gameCode fallback)
    final idKey = card.id ?? card.gameCode;
    final exists = _selectedCards.any((c) => (c.id ?? c.gameCode) == idKey);
    if (!exists) {
      _selectedCards.add(card);
      setState(() {}); // refresh counter
    }
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _banner(TCGCard card) {
    if (!mounted) return;
    final image = card.imageRefSmall;
    final text = card.name ?? 'Unknown';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        content: Row(
          children: [
            if (image != null && image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: image,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: 12),
            Expanded(child: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            Text('+${_selectedCards.length}'),
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
      body: Stack(
        children: [
          // Preview
          Positioned.fill(child: CameraPreview(_controller!)),

          // Top bar – count + close
          SafeArea(
            child: Row(
              children: [
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Saved: ${_selectedCards.length}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: _busy ? null : () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),

          // Bottom controls
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              minimum: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Capture button
                  GestureDetector(
                    onTap: _busy ? null : _captureAndProcess,
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _busy ? Colors.white24 : Colors.white,
                        border: Border.all(width: 4, color: Colors.black54),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Done button
                  ElevatedButton.icon(
                    onPressed: _busy
                        ? null
                        : () => Navigator.pop<List<TCGCard>>(context, List<TCGCard>.from(_selectedCards)),
                    icon: const Icon(Icons.check),
                    label: const Text('Done'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PickCardSheet extends StatelessWidget {
  final List<TCGCard> cards;
  const _PickCardSheet({required this.cards});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (context, scroll) => Material(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: ListView.separated(
          controller: scroll,
          padding: const EdgeInsets.all(12),
          itemCount: cards.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final c = cards[i];
            return ListTile(
              leading: (c.imageRefSmall?.isNotEmpty ?? false)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(
                        imageUrl: c.imageRefSmall!,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(Icons.image_not_supported),
              title: Text(c.name ?? 'Unknown'),
              subtitle: Text(c.setName ?? ''),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pop<TCGCard>(context, c),
            );
          },
        ),
      ),
    );
  }
}

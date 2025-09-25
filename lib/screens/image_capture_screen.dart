// ============================================================================
// FILE: image_capture_screen.dart
// PURPOSE: UI to pick/scan/upload images and perform OCR + TCG detection.
// ARCHITECTURE: MVVM with Provider. UI binds to ImageCaptureViewModel state.
// NAVIGATION: Can open ScreenSingle (card detail), ScanResultsScreen (multi),
//             and MultiScanCameraScreen (live multi-scan).
// NOTES:
// - Comments are organized in big, skimmable sections so anyone can orient fast.
// - Code is unchanged; only documentation and section markers are added.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:api_trial/viewmodels/image_capture_viewmodel.dart';
import 'package:api_trial/services/onepiece_service.dart';

import 'package:api_trial/screens/screen_single.dart';
import 'package:api_trial/constants/enums/game_type.dart';
import 'package:api_trial/screens/scan_results.dart';
import 'package:api_trial/models/card.dart';
import 'package:api_trial/screens/multi_scan_camera_screen.dart';

// ============================================================================
// WIDGET: ImageCaptureScreen
// ROLE: Entry point. Provides ImageCaptureViewModel and renders the full UI.
// ============================================================================
class ImageCaptureScreen extends StatelessWidget {
  const ImageCaptureScreen({super.key});

  // -- Helper: tolerant "One Piece" check (e.g., "One Piece" / "One Piece TCG")
  bool _isOnePieceDetected(String detectedGame) {
    return detectedGame.toLowerCase().contains('one piece');
  }

  @override
  Widget build(BuildContext context) {
    // ------------------------------------------------------------------------
    // PROVIDER SCOPE:
    // This screen owns the ImageCaptureViewModel lifetime via ChangeNotifierProvider.
    // If you provide the VM higher in the tree, remove this and just use Consumer.
    // ------------------------------------------------------------------------
    return ChangeNotifierProvider(
      create: (_) => ImageCaptureViewModel(),
      child: Consumer<ImageCaptureViewModel>(
        // =====================================================================
        // CONSUMER<ImageCaptureViewModel>
        // Exposes `viewModel` state + actions to build the UI reactively.
        // =====================================================================
        builder: (context, viewModel, child) {
          // ------------------------------------------------------------------
          // DERIVED STATE: Is Latin script currently detected by OCR?
          // Used to conditionally show the "Latin-Language auto detect" toggle.
          // ------------------------------------------------------------------
          final isLatinSelected =
              viewModel.recognizedTextBlocks.isNotEmpty &&
              viewModel.recognizedTextBlocks.any(
                (block) =>
                    block['script'] == 'Latin' ||
                    block['script'].toString().startsWith('Language detected:'),
              );

          // ===================================================================
          // HANDLER: Scan + Detect by ID (One Piece specific flow)
          // Orchestrates:
          //  1) Scan (camera-based doc scanner)
          //  2) Game detection (guard: One Piece supported path)
          //  3) Extract code (OP##-### / ST##-### / P-###)
          //  4) Supabase lookup by game_code
          //  5) Navigate to detail screen or results list
          // ===================================================================
          Future<void> _scanAndDetectById() async {
            if (viewModel.isLoading) return;
            ScaffoldMessenger.of(context).clearSnackBars();

            await viewModel.scanSingle();

            // Gate: Only One Piece supported in this path for now
            if (!_isOnePieceDetected(viewModel.detectedGame)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${viewModel.detectedGame} detection is still under development.',
                  ),
                ),
              );
              return;
            }

            // Extract One Piece code from OCR result
            final code = viewModel.extractOnePieceGameCode();
            if (code == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No game code found. Please rescan.'),
                ),
              );
              return;
            }

            // Supabase query by game code
            final service = await OnePieceTcgService.create();
            late final List<TCGCard> cards;
            try {
              cards = await service.getCardsByGameCodeFromDatabase(
                gameCode: code,
              );
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Search error: $e')));
              return;
            }

            // Navigate based on cardinality
            if (cards.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No cards found. Please rescan.')),
              );
            } else if (cards.length == 1) {
              final card = cards.first;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ScreenSingle(
                    id: card.id!, // Supabase UUID preferred
                    gameType: GameType.onePiece,
                    service: service,
                    getCardType: GetCardType.fromSupabase,
                  ),
                ),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ScanResultsScreen(
                    title: 'Scan Results ($code)',
                    cards: cards,
                    service: service,
                  ),
                ),
              );
            }
          }

          // ===================================================================
          // SCAFFOLD: The full UI
          //  - Header preview of either confirmedImage (from uploads) or local file
          //  - Detection toggles
          //  - OCR blocks (debug/info)
          //  - Action buttons: camera/gallery/upload/search/scan/multi-scan
          //  - Uploaded images list & confirm flow
          // ===================================================================
          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),

                // =================================================================
                // COLUMN: Main content
                // =================================================================
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ------------------------------------------------------------
                    // PREVIEW AREA
                    // Shows either the confirmed uploaded image, the local image
                    // from pick/scan, or a placeholder message.
                    // ------------------------------------------------------------
                    if (viewModel.confirmedImage != null)
                      Image.network(
                        viewModel.confirmedImage!.url ?? '',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error, size: 50),
                      ),
                    if (viewModel.imageFile != null)
                      Image.file(
                        viewModel.imageFile!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error, size: 50),
                      ),
                    if (viewModel.imageFile == null &&
                        viewModel.confirmedImage == null)
                      const Text('No image uploaded yet.'),

                    const SizedBox(height: 20),

                    // ------------------------------------------------------------
                    // DETECTED GAME SUMMARY (live label)
                    // ------------------------------------------------------------
                    Text(
                      'Detected Game: ${viewModel.detectedGame}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ------------------------------------------------------------
                    // DETECTION OPTIONS (toggles)
                    // - Language auto-detect
                    // - Latin-language auto-detect (if Latin detected)
                    // - TCG auto-detect
                    // ------------------------------------------------------------
                    SizedBox(
                      width: double.infinity,
                      child: ExpansionTile(
                        title: const Text(
                          'Detection Options',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: [
                          SwitchListTile(
                            title: const Text('Language auto-detect'),
                            value: viewModel.autoDetectEnabled,
                            onChanged: viewModel.isLoading
                                ? null
                                : (value) => viewModel.toggleAutoDetect(value),
                          ),
                          if (viewModel.autoDetectEnabled && isLatinSelected)
                            SwitchListTile(
                              title: const Text('Latin-Language auto detect'),
                              value: viewModel.latinLanguageAutoDetectEnabled,
                              onChanged: viewModel.isLoading
                                  ? null
                                  : (value) => viewModel
                                        .toggleLatinLanguageAutoDetect(value),
                            ),
                          SwitchListTile(
                            title: const Text('TCG auto-detect'),
                            value: viewModel.tcgAutoDetectEnabled,
                            onChanged: viewModel.isLoading
                                ? null
                                : (value) =>
                                      viewModel.toggleTcgAutoDetect(value),
                          ),
                        ],
                      ),
                    ),

                    // ------------------------------------------------------------
                    // MANUAL GAME SELECTION (only when TCG auto-detect is off
                    // and there's a local image available to analyze)
                    // ------------------------------------------------------------
                    if (!viewModel.tcgAutoDetectEnabled &&
                        viewModel.imageFile != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Card's game:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          DropdownButton<String>(
                            value: viewModel.selectedGame,
                            items:
                                [
                                      'YuGiOh',
                                      'Pokemon TCG',
                                      'Magic The Gathering',
                                      'One Piece TCG',
                                    ]
                                    .map(
                                      (game) => DropdownMenuItem(
                                        value: game,
                                        child: Text(game),
                                      ),
                                    )
                                    .toList(),
                            onChanged: viewModel.isLoading
                                ? null
                                : (value) {
                                    if (value != null) {
                                      viewModel.setSelectedGame(value);
                                    }
                                  },
                          ),
                        ],
                      ),

                    const SizedBox(height: 20),

                    // ------------------------------------------------------------
                    // OCR DEBUG PANEL
                    // Shows recognized text blocks and normalized bounding boxes.
                    // Useful during development and QA.
                    // ------------------------------------------------------------
                    if (viewModel.recognizedTextBlocks.isNotEmpty)
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Recognized Text Blocks:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    viewModel.recognizedTextBlocks.length,
                                itemBuilder: (context, index) {
                                  final block =
                                      viewModel.recognizedTextBlocks[index];
                                  return ListTile(
                                    title: Text(
                                      '${block['script']}: ${block['text']}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    subtitle: Text(
                                      'Normalized Bounding Box: '
                                      'L:${block['normalizedBoundingBox']['left'].toStringAsFixed(2)}, '
                                      'T:${block['normalizedBoundingBox']['top'].toStringAsFixed(2)}, '
                                      'R:${block['normalizedBoundingBox']['right'].toStringAsFixed(2)}, '
                                      'B:${block['normalizedBoundingBox']['bottom'].toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: viewModel.isLoading
                                  ? null
                                  : viewModel.clearOcrResults,
                              child: const Text('Clear OCR Results'),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    // ------------------------------------------------------------
                    // STATUS INDICATORS
                    // ------------------------------------------------------------
                    if (viewModel.isLoading) const CircularProgressIndicator(),
                    if (viewModel.errorMessage != null)
                      Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),

                    const SizedBox(height: 20),

                    // ------------------------------------------------------------
                    // ACTIONS: Capture/Pick/Upload/Search/Scan
                    // ------------------------------------------------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: viewModel.isLoading
                              ? null
                              : () => viewModel.pickImage(ImageSource.camera),
                          child: const Text('Take Photo'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: viewModel.isLoading
                              ? null
                              : () => viewModel.pickImage(ImageSource.gallery),
                          child: const Text('Pick from Gallery'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed:
                          viewModel.isLoading || viewModel.imageFile == null
                          ? null
                          : viewModel.uploadCurrentImage,
                      child: const Text('Upload Photo'),
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : viewModel.toggleUploadedImages,
                      child: const Text('Search Uploaded Photos'),
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : viewModel.scanSingle,
                      child: const Text('Scan Card'),
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : _scanAndDetectById,
                      child: const Text('Scan & Detect Card (by ID)'),
                    ),

                    // ------------------------------------------------------------
                    // MULTI-SCAN (live camera) — navigates to MultiScanCameraScreen
                    // Returns a list of TCGCard, which we then store in VM.
                    // ------------------------------------------------------------
                    ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : () async {
                              final result =
                                  await Navigator.push<List<TCGCard>>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const MultiScanCameraScreen(),
                                    ),
                                  );
                              if (result != null && result.isNotEmpty) {
                                viewModel.setMultiScannedCards(result);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Saved ${result.length} card(s)',
                                    ),
                                  ),
                                );
                              }
                            },
                      child: const Text('Scan, Detect & Save (multi)'),
                    ),

                    // ------------------------------------------------------------
                    // MULTI-SCAN RESULTS LIST
                    // Tapping a card navigates to ScreenSingle (detail).
                    // ------------------------------------------------------------
                    if (viewModel.multiScannedCards.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          const Text(
                            'Multi-Scan Saved Cards:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: viewModel.multiScannedCards.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, i) {
                              final c = viewModel.multiScannedCards[i];
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
                                onTap: () async {
                                  final service =
                                      await OnePieceTcgService.create();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ScreenSingle(
                                        id: (c.id ?? c.gameCode)!,
                                        gameType: GameType.onePiece,
                                        service: service,
                                        getCardType: GetCardType.fromSupabase,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),

                    // ------------------------------------------------------------
                    // UPLOADED IMAGES BROWSER
                    // Allows selecting an uploaded image and confirming it.
                    // ------------------------------------------------------------
                    if (viewModel.showUploadedImages)
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: viewModel.uploadedImages.length,
                          itemBuilder: (context, index) {
                            final image = viewModel.uploadedImages[index];
                            final isSelected = viewModel.selectedImage == image;
                            return ListTile(
                              title: Text(image.name ?? 'Unknown'),
                              leading: Image.network(
                                image.url ?? '',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error, size: 50),
                              ),
                              tileColor: isSelected
                                  ? Colors.blue.withOpacity(0.2)
                                  : null,
                              onTap: () => viewModel.selectImage(image),
                            );
                          },
                        ),
                      ),

                    if (viewModel.showUploadedImages &&
                        viewModel.selectedImage != null)
                      ElevatedButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : viewModel.confirmSelectedImage,
                        child: const Text('Confirm'),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

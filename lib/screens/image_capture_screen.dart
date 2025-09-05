import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../viewmodels/image_capture_viewmodel.dart';

class ImageCaptureScreen extends StatelessWidget {
  const ImageCaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ImageCaptureViewModel(),
      child: Consumer<ImageCaptureViewModel>(
        builder: (context, viewModel, child) {
          // Check if Latin is the selected script
          final isLatinSelected =
              viewModel.recognizedTextBlocks.isNotEmpty &&
              viewModel.recognizedTextBlocks.any(
                (block) =>
                    block['script'] == 'Latin' ||
                    block['script'].startsWith('Language detected:'),
              );

          return Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Display confirmed image from Supabase
                    if (viewModel.confirmedImage != null)
                      Image.network(
                        viewModel.confirmedImage!.url ?? '',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error, size: 50),
                      ),
                    // Display current image file
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
                    // Detected game display
                    Text(
                      'Detected Game: ${viewModel.detectedGame}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Detection options dropdown menu
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
                    // Card's game dropdown (visible when TCG auto-detect is OFF)
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
                    // Display OCR results
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
                              height:
                                  200, // Constrain height for scrollable list
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
                                      'Normalized Bounding Box: L:${block['normalizedBoundingBox']['left'].toStringAsFixed(2)}, '
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
                    // Loading and error indicators
                    if (viewModel.isLoading) const CircularProgressIndicator(),
                    if (viewModel.errorMessage != null)
                      Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 20),
                    // Action buttons
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
                    // Uploaded images list
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
                    const SizedBox(
                      height: 20,
                    ), // Extra padding for scrollability
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

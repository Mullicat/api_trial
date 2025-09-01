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
          return Scaffold(
            appBar: AppBar(title: const Text('Captura de Imagen')),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (viewModel.confirmedImage != null)
                      Image.network(
                        viewModel.confirmedImage!.url ?? '',
                        height: 300,
                        width: 300,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error, size: 50),
                      ),
                    if (viewModel.imageFile != null)
                      Image.file(
                        viewModel.imageFile!,
                        height: 300,
                        width: 300,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error, size: 50),
                      ),
                    if (viewModel.imageFile == null &&
                        viewModel.confirmedImage == null)
                      const Text('No image uploaded yet.'),
                    const SizedBox(height: 20),
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
                                      'Bounding Box: L:${block['boundingBox']['left'].toStringAsFixed(0)}, '
                                      'T:${block['boundingBox']['top'].toStringAsFixed(0)}, '
                                      'R:${block['boundingBox']['right'].toStringAsFixed(0)}, '
                                      'B:${block['boundingBox']['bottom'].toStringAsFixed(0)}',
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
                    if (viewModel.isLoading) const CircularProgressIndicator(),
                    if (viewModel.errorMessage != null)
                      Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 20),
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

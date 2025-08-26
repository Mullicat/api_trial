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
            appBar: AppBar(title: Text('Captura de Imagen')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (viewModel.uploadedImage != null)
                    Image.network(
                      viewModel.uploadedImage!.url,
                      height: 600,
                      width: 600,
                      fit: BoxFit.cover,
                    )
                  else
                    Text('No image uploaded yet'),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : () => viewModel.chooseAndUploadImage(
                                ImageSource.camera,
                              ),
                        child: Text('Take Photo'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : () => viewModel.chooseAndUploadImage(
                                ImageSource.gallery,
                              ),
                        child: Text('Pick from Gallery'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

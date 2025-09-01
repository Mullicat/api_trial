import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as OpenAppSettings;
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../data/repositories/supabase_repository.dart';
import '../models/image_model.dart';

class ImageCaptureViewModel with ChangeNotifier {
  final SupabaseRepository _repository = SupabaseRepository();
  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  UploadedImage? _uploadedImage;
  List<UploadedImage> _uploadedImages = [];
  UploadedImage? _selectedImage;
  UploadedImage? _confirmedImage;
  bool _isLoading = false;
  bool _showUploadedImages = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _recognizedTextBlocks = [];

  File? get imageFile => _imageFile;
  UploadedImage? get uploadedImage => _uploadedImage;
  List<UploadedImage> get uploadedImages => _uploadedImages;
  UploadedImage? get selectedImage => _selectedImage;
  UploadedImage? get confirmedImage => _confirmedImage;
  bool get isLoading => _isLoading;
  bool get showUploadedImages => _showUploadedImages;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get recognizedTextBlocks => _recognizedTextBlocks;

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _setErrorMessage(null);
  }

  void clearOcrResults() {
    _recognizedTextBlocks = [];
    notifyListeners();
  }

  Future<void> toggleUploadedImages() async {
    _setShowUploadedImages(!_showUploadedImages);
    if (_showUploadedImages) {
      await fetchUploadedImages();
    } else {
      _selectedImage = null;
    }
    notifyListeners();
  }

  void _setShowUploadedImages(bool value) {
    _showUploadedImages = value;
    notifyListeners();
  }

  void selectImage(UploadedImage image) {
    _selectedImage = image;
    notifyListeners();
  }

  void confirmSelectedImage() {
    _confirmedImage = _selectedImage;
    _imageFile = null;
    clearOcrResults();
    _showUploadedImages = false;
    notifyListeners();
  }

  Future<void> fetchUploadedImages() async {
    _setLoading(true);
    try {
      print('Fetching uploaded images from Supabase...');
      _uploadedImages = await _repository.getUploadedImages();
      print('Fetched images: ${_uploadedImages.length} items');
      if (_uploadedImages.isEmpty) {
        _setErrorMessage('No uploaded images found in the database.');
      } else {
        print('Image URLs: ${_uploadedImages.map((img) => img.url).toList()}');
        _setErrorMessage(null);
      }
      notifyListeners();
    } catch (e) {
      _setErrorMessage('Error fetching images: $e');
      print('Fetch images error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    Permission permission;
    if (source == ImageSource.camera) {
      permission = Permission.camera;
    } else {
      permission = Platform.isAndroid ? Permission.photos : Permission.photos;
    }

    final status = await permission.request();
    if (status.isPermanentlyDenied) {
      _setErrorMessage(
        'Permission permanently denied. Please enable in settings.',
      );
      await OpenAppSettings.openAppSettings();
      return;
    } else if (status.isDenied) {
      _setErrorMessage('Permission denied');
      return;
    }

    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 600,
      );
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        print(
          'Picked file path: ${pickedFile.path}, exists: ${await file.exists()}',
        );
        if (await file.exists()) {
          _imageFile = file;
          clearOcrResults();
          _setErrorMessage(null);
          notifyListeners();
        } else {
          _setErrorMessage('File does not exist: ${pickedFile.path}');
        }
      } else {
        _setErrorMessage('No image selected');
      }
    } catch (e) {
      _setErrorMessage('Error picking image: $e');
      print('Pick image error: $e');
    }
  }

  Future<void> uploadCurrentImage() async {
    if (_imageFile == null) {
      _setErrorMessage('Please select an image first');
      return;
    }

    _setLoading(true);
    try {
      print(
        'Uploading file: ${_imageFile!.path}, exists: ${await _imageFile!.exists()}',
      );
      if (await _imageFile!.exists()) {
        final fileName =
            DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
        final image = await _repository.uploadImage(_imageFile!, fileName);
        if (image != null) {
          _uploadedImage = await _repository.saveImageMetadata(image);
          await fetchUploadedImages();
          _setErrorMessage(null);
          notifyListeners();
        } else {
          _setErrorMessage('Image upload failed');
        }
      } else {
        _setErrorMessage('File does not exist: ${_imageFile!.path}');
      }
    } catch (e) {
      _setErrorMessage('Error uploading image: $e');
      print('Upload error: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<File?> _copyToAppStorage(String sourcePath) async {
    try {
      print('Copying file from: $sourcePath');
      final tempDir = await getTemporaryDirectory();
      final newFileName =
          DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
      final newFilePath = '${tempDir.path}/$newFileName';
      final newFile = await File(sourcePath).copy(newFilePath);
      print('Copied to: $newFilePath, exists: ${await newFile.exists()}');
      if (await newFile.exists()) {
        return newFile;
      } else {
        print('Copied file does not exist: $newFilePath');
        return null;
      }
    } catch (e) {
      print('Error copying file to app storage: $e');
      return null;
    }
  }

  Future<void> scanSingle() async {
    final status = await Permission.camera.request();
    if (status.isPermanentlyDenied) {
      _setErrorMessage(
        'Camera permission permanently denied. Please enable in settings.',
      );
      await OpenAppSettings.openAppSettings();
      return;
    } else if (status.isDenied) {
      _setErrorMessage('Camera permission denied');
      return;
    }

    _setLoading(true);
    try {
      print('Starting single scan...');
      final scannedDocuments = await CunningDocumentScanner.getPictures(
        noOfPages: 1,
      );
      print('Scanned documents: $scannedDocuments');
      if (scannedDocuments != null && scannedDocuments.isNotEmpty) {
        final path = scannedDocuments[0];
        print('Scanned file path: $path, exists: ${await File(path).exists()}');
        File? imageFile = File(path);
        if (await imageFile.exists()) {
          // Copy to app storage for reliability
          imageFile = await _copyToAppStorage(path) ?? imageFile;
          if (!await imageFile.exists()) {
            _setErrorMessage('Scanned file does not exist at path: $path');
            return;
          }

          // Perform OCR on the scanned image
          final inputImage = InputImage.fromFilePath(imageFile.path);
          final textRecognizerLatin = TextRecognizer(
            script: TextRecognitionScript.latin,
          );
          final textRecognizerChinese = TextRecognizer(
            script: TextRecognitionScript.chinese,
          );
          final textRecognizerJapanese = TextRecognizer(
            script: TextRecognitionScript.japanese,
          );
          final textRecognizerKorean = TextRecognizer(
            script: TextRecognitionScript.korean,
          );

          try {
            final recognizedTextLatin = await textRecognizerLatin.processImage(
              inputImage,
            );
            final recognizedTextChinese = await textRecognizerChinese
                .processImage(inputImage);
            final recognizedTextJapanese = await textRecognizerJapanese
                .processImage(inputImage);
            final recognizedTextKorean = await textRecognizerKorean
                .processImage(inputImage);

            _recognizedTextBlocks = [];
            void addTextBlocks(List<TextBlock> blocks, String script) {
              for (final block in blocks) {
                final blockData = {
                  'script': script,
                  'text': block.text,
                  'boundingBox': {
                    'left': block.boundingBox.left,
                    'top': block.boundingBox.top,
                    'right': block.boundingBox.right,
                    'bottom': block.boundingBox.bottom,
                  },
                  'cornerPoints': block.cornerPoints
                      .map((p) => {'x': p.x, 'y': p.y})
                      .toList(),
                };
                _recognizedTextBlocks.add(blockData);
              }
            }

            addTextBlocks(recognizedTextLatin.blocks, 'Latin');
            addTextBlocks(recognizedTextChinese.blocks, 'Chinese');
            addTextBlocks(recognizedTextJapanese.blocks, 'Japanese');
            addTextBlocks(recognizedTextKorean.blocks, 'Korean');

            print('Recognized text blocks: $_recognizedTextBlocks');

            _imageFile = imageFile;
            _setErrorMessage(
              _recognizedTextBlocks.isEmpty ? 'No text recognized' : null,
            );
            notifyListeners();
          } finally {
            await textRecognizerLatin.close();
            await textRecognizerChinese.close();
            await textRecognizerJapanese.close();
            await textRecognizerKorean.close();
          }
        } else {
          _setErrorMessage('Scanned file does not exist at path: $path');
        }
      } else {
        _setErrorMessage('No document scanned or user cancelled');
      }
    } on PlatformException catch (e) {
      _setErrorMessage('Failed to scan document: ${e.message}');
      print('PlatformException in scanSingle: $e');
    } catch (e) {
      _setErrorMessage('Error scanning document: $e');
      print('Error in scanSingle: $e');
    } finally {
      _setLoading(false);
    }
  }
}

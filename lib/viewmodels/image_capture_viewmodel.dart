import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as OpenAppSettings;
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
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

  File? get imageFile => _imageFile;
  UploadedImage? get uploadedImage => _uploadedImage;
  List<UploadedImage> get uploadedImages => _uploadedImages;
  UploadedImage? get selectedImage => _selectedImage;
  UploadedImage? get confirmedImage => _confirmedImage;
  bool get isLoading => _isLoading;
  bool get showUploadedImages => _showUploadedImages;
  String? get errorMessage => _errorMessage;

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

  Future<void> toggleUploadedImages() async {
    _setShowUploadedImages(!_showUploadedImages);
    if (_showUploadedImages) {
      await fetchUploadedImages();
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

  Future<void> uploadImage() async {
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
          _imageFile = null;
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
      final tempDir = await getTemporaryDirectory();
      final newFileName =
          DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
      final newFilePath = '${tempDir.path}/$newFileName';
      final newFile = await File(sourcePath).copy(newFilePath);
      if (await newFile.exists()) {
        return newFile;
      } else {
        developer.log('Copied file does not exist: $newFilePath');
        return null;
      }
    } catch (e) {
      developer.log('Error copying file to app storage: $e');
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
      final scannedDocuments = await CunningDocumentScanner.getPictures(
        noOfPages: 1,
      );
      developer.log('Scanned documents: $scannedDocuments');
      if (scannedDocuments != null && scannedDocuments.isNotEmpty) {
        final path = scannedDocuments[0];
        developer.log(
          'Scanned file path: $path, exists: ${await File(path).exists()}',
        );
        File? imageFile = File(path);
        if (await imageFile.exists()) {
          imageFile = await _copyToAppStorage(path) ?? imageFile;
          if (!await imageFile.exists()) {
            _setErrorMessage('Scanned file does not exist at path: $path');
            return;
          }
          _imageFile = imageFile;
          _setErrorMessage(null);
          notifyListeners();
          // Se sube automatico
          await uploadImage();
        } else {
          _setErrorMessage('Scanned file does not exist at path: $path');
        }
      } else {
        _setErrorMessage('No document scanned or user cancelled');
      }
    } on PlatformException catch (e) {
      _setErrorMessage('Failed to scan document: ${e.message}');
      developer.log('PlatformException in scanSingle: $e');
    } catch (e) {
      _setErrorMessage('Error scanning document: $e');
      developer.log('Error in scanSingle: $e');
    } finally {
      _setLoading(false);
    }
  }
}

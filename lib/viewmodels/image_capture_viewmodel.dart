// lib/viewmodels/image_capture_viewmodel.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as OpenAppSettings;
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
      _uploadedImages = await _repository.getUploadedImages();
      notifyListeners();
    } catch (e) {
      _setErrorMessage('Error fetching images: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    if (Platform.isAndroid) {
      final status = await Permission.photos.request();
      if (status.isPermanentlyDenied) {
        _setErrorMessage(
          'Permission permanently denied. Please enable in settings.',
        );
        await OpenAppSettings.openAppSettings();
        return;
      } else if (status.isDenied) {
        _setErrorMessage('Permission denied to access photos');
        return;
      }
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
        if (await file.exists()) {
          _imageFile = file;
          _setErrorMessage(null);
          notifyListeners();
        } else {
          _setErrorMessage('File does not exist');
        }
      } else {
        _setErrorMessage('No image selected');
      }
    } catch (e) {
      _setErrorMessage('Error picking image: $e');
    }
  }

  Future<void> uploadImage() async {
    if (_imageFile == null) {
      _setErrorMessage('Please select an image first');
      return;
    }

    _setLoading(true);
    try {
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
    } catch (e) {
      _setErrorMessage('Error uploading image: $e');
    } finally {
      _setLoading(false);
    }
  }
}

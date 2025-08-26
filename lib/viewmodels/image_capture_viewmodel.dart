import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/repositories/supabase_repository.dart';
import '../models/image_model.dart';

class ImageCaptureViewModel with ChangeNotifier {
  final SupabaseRepository _repository = SupabaseRepository();
  final ImagePicker _picker = ImagePicker();

  UploadedImage? _uploadedImage;
  bool _isLoading = false;
  String? _errorMessage;

  UploadedImage? get uploadedImage => _uploadedImage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setloading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _setErrorMessage(null);
  }

  Future<void> chooseAndUploadImage(ImageSource source, String name) async {
    _setloading(true);

    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null) {
        final image = await _repository.uploadImage(pickedFile, name);
        if (image != null) {
          _uploadedImage = await _repository.saveImageMetadata(image);
          notifyListeners();
          _setErrorMessage(null);
        } else {
          _setErrorMessage('Image upload failed');
        }
      }
    } catch (e) {
      _setErrorMessage('Error: $e');
    } finally {
      _setloading(false);
    }
  }
}

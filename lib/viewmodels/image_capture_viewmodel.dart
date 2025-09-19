import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_service.dart';
import '../services/ocr_service.dart';
import '../services/game_detection_service.dart';
import '../models/image_model.dart';
import '../models/card.dart';

// View model for managing image capture, OCR, and game detection UI state.
class ImageCaptureViewModel with ChangeNotifier {
  final ImageService _imageService = ImageService();
  final OcrService _ocrService = OcrService();
  final GameDetectionService _gameDetectionService = GameDetectionService();

  File? _imageFile;
  UploadedImage? _uploadedImage;
  List<UploadedImage> _uploadedImages = [];
  UploadedImage? _selectedImage;
  UploadedImage? _confirmedImage;
  bool _isLoading = false;
  bool _showUploadedImages = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _recognizedTextBlocks = [];
  bool _autoDetectEnabled = true;
  bool _latinLanguageAutoDetectEnabled = true;
  bool _tcgAutoDetectEnabled = true;
  String _detectedGame = 'Other Game';
  String _selectedGame = 'YuGiOh';
  List<TCGCard> _multiScannedCards = [];

  // Getters for UI state
  File? get imageFile => _imageFile;
  UploadedImage? get uploadedImage => _uploadedImage;
  List<UploadedImage> get uploadedImages => _uploadedImages;
  UploadedImage? get selectedImage => _selectedImage;
  UploadedImage? get confirmedImage => _confirmedImage;
  bool get isLoading => _isLoading;
  bool get showUploadedImages => _showUploadedImages;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get recognizedTextBlocks => _recognizedTextBlocks;
  bool get autoDetectEnabled => _autoDetectEnabled;
  bool get latinLanguageAutoDetectEnabled => _latinLanguageAutoDetectEnabled;
  bool get tcgAutoDetectEnabled => _tcgAutoDetectEnabled;
  String get detectedGame => _detectedGame;
  String get selectedGame => _selectedGame;
  List<TCGCard> get multiScannedCards => _multiScannedCards;

  // Sets the error message and notifies listeners.
  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Sets the loading state and notifies listeners.
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Clears the error message.
  void clearError() {
    _setErrorMessage(null);
  }

  // Clears OCR results and resets game selection.
  void clearOcrResults() {
    _recognizedTextBlocks = [];
    _detectedGame = 'Other Game';
    _selectedGame = 'YuGiOh';
    notifyListeners();
  }

  // Toggles automatic script detection and reprocesses if needed.
  void toggleAutoDetect(bool value) {
    _autoDetectEnabled = value;
    if (_imageFile != null && !value) {
      reprocessWithScript('Latin');
    }
    notifyListeners();
  }

  // Toggles Latin language auto-detection and reprocesses if needed.
  void toggleLatinLanguageAutoDetect(bool value) {
    _latinLanguageAutoDetectEnabled = value;
    if (_imageFile != null) {
      reprocessWithScript('Latin');
    }
    notifyListeners();
  }

  // Toggles TCG auto-detection and updates game selection.
  void toggleTcgAutoDetect(bool value) {
    _tcgAutoDetectEnabled = value;
    if (_imageFile != null) {
      _detectedGame = _gameDetectionService.detectGame(
        _recognizedTextBlocks,
        null,
        _tcgAutoDetectEnabled,
        _selectedGame,
      );
      if (!_tcgAutoDetectEnabled) {
        _selectedGame = 'YuGiOh';
        _detectedGame = _selectedGame;
      }
      notifyListeners();
    }
  }

  // Sets the manually selected game.
  void setSelectedGame(String game) {
    _selectedGame = game;
    _detectedGame = game;
    notifyListeners();
  }

  // Toggles the display of uploaded images.
  void _setShowUploadedImages(bool value) {
    _showUploadedImages = value;
    notifyListeners();
  }

  // Selects an uploaded image.
  void selectImage(UploadedImage image) {
    _selectedImage = image;
    notifyListeners();
  }

  void setMultiScannedCards(List<TCGCard> cards) {
  _multiScannedCards = List<TCGCard>.from(cards);
  notifyListeners();
  }

  void clearMultiScannedCards() {
    _multiScannedCards.clear();
    notifyListeners();
  }

  // Confirms the selected image and resets state.
  void confirmSelectedImage() {
    _confirmedImage = _selectedImage;
    _imageFile = null;
    clearOcrResults();
    _autoDetectEnabled = true;
    _latinLanguageAutoDetectEnabled = true;
    _tcgAutoDetectEnabled = true;
    _showUploadedImages = false;
    notifyListeners();
  }

  // Toggles the uploaded images list and fetches images if shown.
  Future<void> toggleUploadedImages() async {
    _setShowUploadedImages(!_showUploadedImages);
    if (_showUploadedImages) {
      await fetchUploadedImages();
    } else {
      _selectedImage = null;
    }
    notifyListeners();
  }

  // Fetches uploaded images from Supabase.
  Future<void> fetchUploadedImages() async {
    _setLoading(true);
    try {
      _uploadedImages = await _imageService.fetchUploadedImages();
      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage('Error fetching images: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Picks an image from camera or gallery.
  Future<void> pickImage(ImageSource source) async {
    _setLoading(true);
    try {
      _imageFile = await _imageService.pickImage(source);
      _autoDetectEnabled = true;
      _latinLanguageAutoDetectEnabled = true;
      _tcgAutoDetectEnabled = true;
      clearOcrResults();
      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Uploads the current image to Supabase.
  Future<void> uploadCurrentImage() async {
    if (_imageFile == null) {
      _setErrorMessage('Please select an image first');
      return;
    }

    _setLoading(true);
    try {
      final fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
      _uploadedImage = await _imageService.uploadImage(_imageFile!, fileName);
      await fetchUploadedImages();
      _setErrorMessage(null);
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Scans a single card and processes it for OCR and game detection.
  Future<void> scanSingle() async {
    _setLoading(true);
    try {
      _imageFile = await _imageService.scanSingle();
      _recognizedTextBlocks = [];
      _detectedGame = 'Other Game';
      _selectedGame = 'YuGiOh';

      if (_imageFile == null || !await _imageFile!.exists()) {
        _setErrorMessage('Image file is null or does not exist');
        return;
      }

      Map<String, dynamic> ocrResult;
      if (_autoDetectEnabled) {
        ocrResult = await _ocrService.processImageWithAutoDetect(
          _imageFile!,
          _latinLanguageAutoDetectEnabled,
        );
      } else {
        ocrResult = await _ocrService.processImageWithScript(
          _imageFile!,
          'Latin',
          _latinLanguageAutoDetectEnabled,
        );
      }

      _recognizedTextBlocks = ocrResult['textBlocks'];
      _detectedGame = _gameDetectionService.detectGame(
        _recognizedTextBlocks,
        ocrResult['joinedText'],
        _tcgAutoDetectEnabled,
        _selectedGame,
      );

      _setErrorMessage(
        _recognizedTextBlocks.isEmpty ? 'No text recognized' : null,
      );
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Reprocesses the current image with a specific script.
  Future<void> reprocessWithScript(String script) async {
    if (_imageFile == null) {
      _setErrorMessage('No image available to reprocess');
      return;
    }

    _setLoading(true);
    try {
      final ocrResult = await _ocrService.processImageWithScript(
        _imageFile!,
        script,
        _latinLanguageAutoDetectEnabled,
      );
      _recognizedTextBlocks = ocrResult['textBlocks'];
      _detectedGame = _gameDetectionService.detectGame(
        _recognizedTextBlocks,
        ocrResult['joinedText'],
        _tcgAutoDetectEnabled,
        _selectedGame,
      );
      _setErrorMessage(
        _recognizedTextBlocks.isEmpty ? 'No text recognized' : null,
      );
    } catch (e) {
      _setErrorMessage(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  /// Returns a normalized One Piece game code (e.g., OP05-119, ST10-004, P-001) if present in OCR,
  /// otherwise returns null.
  String? extractOnePieceGameCode() {
    return _ocrService.extractOnePieceGameCode(
      textBlocks: _recognizedTextBlocks,
      joinedText: _recognizedTextBlocks.isEmpty
          ? null
          : _recognizedTextBlocks
                .map((b) => b['text']?.toString() ?? '')
                .join(' '),
    );
  }
}

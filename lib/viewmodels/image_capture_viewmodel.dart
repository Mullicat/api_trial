import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as OpenAppSettings;
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
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
  List<Map<String, dynamic>> _recognizedTextBlocks =
      []; // Stores OCR text blocks with script and coordinates
  List<Map<String, dynamic>> _textCoordinates =
      []; // Kept for compatibility, can be removed if unused
  bool _autoDetectEnabled = true; // Toggle for auto-detect
  bool _latinLanguageAutoDetectEnabled =
      true; // Second toggle for Latin language auto-detect

  File? get imageFile => _imageFile;
  UploadedImage? get uploadedImage => _uploadedImage;
  List<UploadedImage> get uploadedImages => _uploadedImages;
  UploadedImage? get selectedImage => _selectedImage;
  UploadedImage? get confirmedImage => _confirmedImage;
  bool get isLoading => _isLoading;
  bool get showUploadedImages => _showUploadedImages;
  String? get errorMessage => _errorMessage;
  List<Map<String, dynamic>> get recognizedTextBlocks => _recognizedTextBlocks;
  List<Map<String, dynamic>> get textCoordinates => _textCoordinates;
  bool get autoDetectEnabled => _autoDetectEnabled;
  bool get latinLanguageAutoDetectEnabled => _latinLanguageAutoDetectEnabled;

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
    _textCoordinates = [];
    notifyListeners();
  }

  void toggleAutoDetect(bool value) {
    _autoDetectEnabled = value;
    if (_imageFile != null && !value) {
      // Reprocess with Latin if switching to manual
      reprocessWithScript('Latin');
    }
    notifyListeners();
  }

  void toggleLatinLanguageAutoDetect(bool value) {
    _latinLanguageAutoDetectEnabled = value;
    if (_imageFile != null) {
      // Reprocess to apply changes
      reprocessWithScript('Latin');
    }
    notifyListeners();
  }

  Future<void> toggleUploadedImages() async {
    _setShowUploadedImages(!_showUploadedImages);
    if (_showUploadedImages) {
      await fetchUploadedImages();
    } else {
      _selectedImage = null; // Clear selected image when closing the list
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
    _imageFile = null; // Clear current image
    clearOcrResults(); // Clear OCR results
    _autoDetectEnabled = true; // Reset to auto-detect
    _latinLanguageAutoDetectEnabled = true; // Reset second toggle
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
          _autoDetectEnabled = true; // Reset to auto-detect
          _latinLanguageAutoDetectEnabled = true; // Reset second toggle
          clearOcrResults(); // Clear OCR results
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
          // Do not clear _imageFile or OCR results
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

  int countScriptSymbols(String text, String script) {
    int count = 0;
    for (var char in text.runes) {
      if (script == 'Latin') {
        // Latin: U+0000–U+007F (Basic Latin), U+0080–U+00FF (Latin-1 Supplement)
        if ((char >= 0x0000 && char <= 0x00FF)) {
          count++;
        }
      } else if (script == 'Japanese') {
        // Japanese: Hiragana (U+3040–U+309F), Katakana (U+30A0–U+30FF)
        if ((char >= 0x3040 && char <= 0x309F) ||
            (char >= 0x30A0 && char <= 0x30FF)) {
          count++;
        }
      } else if (script == 'Chinese') {
        // Chinese: Han (CJK Unified Ideographs): U+4E00–U+9FFF
        if (char >= 0x4E00 && char <= 0x9FFF) {
          count++;
        }
      } else if (script == 'Korean') {
        // Korean: Hangul (U+AC00–U+D7A3)
        if (char >= 0xAC00 && char <= 0xD7A3) {
          count++;
        }
      }
    }
    return count;
  }

  Future<String> detectLatinLanguage(String joinedText) async {
    if (joinedText.isEmpty) {
      print('Joined text is empty, falling back to Latin');
      return 'Latin';
    }
    final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
    try {
      final possibleLanguages = await languageIdentifier
          .identifyPossibleLanguages(joinedText);
      print('Possible languages: $possibleLanguages');
      if (possibleLanguages.isNotEmpty &&
          possibleLanguages.first.confidence > 0.5) {
        final code = possibleLanguages.first.languageTag;
        switch (code) {
          case 'en':
            return 'Language detected: English';
          case 'es':
            return 'Language detected: Spanish';
          case 'fr':
            return 'Language detected: French';
          case 'de':
            return 'Language detected: German';
          case 'it':
            return 'Language detected: Italian';
          case 'pt':
            return 'Language detected: Portuguese';
          default:
            print('Unsupported language code: $code, falling back to Latin');
            return 'Latin';
        }
      } else {
        print(
          'No languages detected with confidence >0.5, falling back to Latin',
        );
        return 'Latin';
      }
    } catch (e) {
      print('Language detection error: $e');
      return 'Latin';
    } finally {
      await languageIdentifier.close();
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

          _imageFile = imageFile;
          _recognizedTextBlocks = [];
          _textCoordinates = [];

          if (_imageFile == null || !await _imageFile!.exists()) {
            _setErrorMessage('Image file is null or does not exist');
            return;
          }

          final inputImage = InputImage.fromFilePath(_imageFile!.path);

          if (_autoDetectEnabled) {
            // Auto-detect: Process with all recognizers
            final scripts = [
              {
                'name': 'Latin',
                'recognizer': TextRecognizer(
                  script: TextRecognitionScript.latin,
                ),
              },
              {
                'name': 'Chinese',
                'recognizer': TextRecognizer(
                  script: TextRecognitionScript.chinese,
                ),
              },
              {
                'name': 'Japanese',
                'recognizer': TextRecognizer(
                  script: TextRecognitionScript.japanese,
                ),
              },
              {
                'name': 'Korean',
                'recognizer': TextRecognizer(
                  script: TextRecognitionScript.korean,
                ),
              },
            ];

            String selectedScript = 'Latin';
            int maxNonLatinSymbolCount = -1;
            List<Map<String, dynamic>> selectedBlocks = [];
            String? latinJoinedText;

            for (var script in scripts) {
              final scriptName = script['name'] as String?;
              final recognizer = script['recognizer'] as TextRecognizer?;
              if (scriptName == null || recognizer == null) {
                print('Invalid script or recognizer: $script');
                continue;
              }

              try {
                final recognizedText = await recognizer.processImage(
                  inputImage,
                );
                List<Map<String, dynamic>> blocks = [];
                // Join all block texts into a single string
                final joinedText = recognizedText.blocks
                    .map((block) => block.text)
                    .join(' ');
                final symbolCount = countScriptSymbols(joinedText, scriptName);

                for (final block in recognizedText.blocks) {
                  final blockData = {
                    'script': scriptName,
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
                  blocks.add(blockData);
                }

                print(
                  'Script: $scriptName, Symbol count: $symbolCount, Joined text: $joinedText',
                );

                // Select non-Latin script with >7 symbols, prefer highest count
                if (scriptName != 'Latin' && symbolCount > 7) {
                  if (symbolCount > maxNonLatinSymbolCount) {
                    maxNonLatinSymbolCount = symbolCount;
                    selectedScript = scriptName;
                    selectedBlocks = blocks;
                  }
                } else if (scriptName == 'Latin' &&
                    maxNonLatinSymbolCount == -1) {
                  // Store Latin results as fallback
                  selectedBlocks = blocks;
                  latinJoinedText = joinedText;
                }
              } catch (e) {
                print('Error processing $scriptName: $e');
                _setErrorMessage('Error processing $scriptName: $e');
              } finally {
                await recognizer.close();
              }
            }

            // Apply Latin language detection if enabled and Latin is selected
            if (selectedScript == 'Latin' &&
                _latinLanguageAutoDetectEnabled &&
                latinJoinedText != null) {
              final detectedLanguage = await detectLatinLanguage(
                latinJoinedText,
              );
              selectedBlocks = selectedBlocks.map((block) {
                return {...block, 'script': detectedLanguage};
              }).toList();
              selectedScript = detectedLanguage;
            }

            _recognizedTextBlocks = selectedBlocks;
            _textCoordinates = selectedBlocks; // Duplicate for compatibility
            print(
              'Selected script: $selectedScript, Blocks: $_recognizedTextBlocks',
            );
          } else {
            // Manual mode: Process with Latin only
            final textRecognizer = TextRecognizer(
              script: TextRecognitionScript.latin,
            );
            try {
              final recognizedText = await textRecognizer.processImage(
                inputImage,
              );
              String scriptLabel = 'Latin';
              final joinedText = recognizedText.blocks
                  .map((block) => block.text)
                  .join(' ');
              if (_latinLanguageAutoDetectEnabled) {
                scriptLabel = await detectLatinLanguage(joinedText);
              }
              for (final block in recognizedText.blocks) {
                final blockData = {
                  'script': scriptLabel,
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
                _textCoordinates.add(blockData); // Duplicate for compatibility
              }
              print(
                'Recognized text blocks ($scriptLabel): $_recognizedTextBlocks',
              );
            } catch (e) {
              print('Error processing Latin: $e');
              _setErrorMessage('Error processing Latin: $e');
            } finally {
              await textRecognizer.close();
            }
          }

          _setErrorMessage(
            _recognizedTextBlocks.isEmpty ? 'No text recognized' : null,
          );
          notifyListeners();
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

  Future<void> reprocessWithScript(String script) async {
    if (_imageFile == null) {
      _setErrorMessage('No image available to reprocess');
      return;
    }

    _setLoading(true);
    try {
      final inputImage = InputImage.fromFilePath(_imageFile!.path);
      TextRecognizer textRecognizer;
      switch (script) {
        case 'Chinese':
          textRecognizer = TextRecognizer(
            script: TextRecognitionScript.chinese,
          );
          break;
        case 'Japanese':
          textRecognizer = TextRecognizer(
            script: TextRecognitionScript.japanese,
          );
          break;
        case 'Korean':
          textRecognizer = TextRecognizer(script: TextRecognitionScript.korean);
          break;
        case 'Latin':
        default:
          textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      }

      try {
        final recognizedText = await textRecognizer.processImage(inputImage);
        _recognizedTextBlocks = [];
        _textCoordinates = [];
        String scriptLabel = script;
        final joinedText = recognizedText.blocks
            .map((block) => block.text)
            .join(' ');
        if (script == 'Latin' && _latinLanguageAutoDetectEnabled) {
          scriptLabel = await detectLatinLanguage(joinedText);
        }
        for (final block in recognizedText.blocks) {
          final blockData = {
            'script': scriptLabel,
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
          _textCoordinates.add(blockData); // Duplicate for compatibility
        }

        print(
          'Reprocessed text blocks with $scriptLabel: $_recognizedTextBlocks',
        );
        _setErrorMessage(
          _recognizedTextBlocks.isEmpty ? 'No text recognized' : null,
        );
        notifyListeners();
      } catch (e) {
        _setErrorMessage('Error reprocessing $script: $e');
        print('Reprocess error: $e');
      } finally {
        await textRecognizer.close();
      }
    } catch (e) {
      _setErrorMessage('Error creating input image: $e');
      print('Reprocess input image error: $e');
    } finally {
      _setLoading(false);
    }
  }
}

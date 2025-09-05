import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'image_service.dart';

// Service for OCR (text recognition) and language detection.
class OcrService {
  final ImageService _imageService = ImageService();

  // Counts symbols in a text string for a specific script.
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

  // Detects the language of a Latin-based text.
  Future<String> detectLatinLanguage(String joinedText) async {
    if (joinedText.isEmpty) {
      return 'Latin';
    }
    final languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
    try {
      final possibleLanguages = await languageIdentifier
          .identifyPossibleLanguages(joinedText);
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
            return 'Latin';
        }
      }
      return 'Latin';
    } catch (e) {
      return 'Latin';
    } finally {
      await languageIdentifier.close();
    }
  }

  // Processes an image for text recognition with automatic script detection.
  Future<Map<String, dynamic>> processImageWithAutoDetect(
    File imageFile,
    bool latinLanguageAutoDetectEnabled,
  ) async {
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final dimensions = await _imageService.getImageDimensions(imageFile);
    final imageWidth = dimensions['width']!.toDouble();
    final imageHeight = dimensions['height']!.toDouble();

    final scripts = [
      {
        'name': 'Latin',
        'recognizer': TextRecognizer(script: TextRecognitionScript.latin),
      },
      {
        'name': 'Chinese',
        'recognizer': TextRecognizer(script: TextRecognitionScript.chinese),
      },
      {
        'name': 'Japanese',
        'recognizer': TextRecognizer(script: TextRecognitionScript.japanese),
      },
      {
        'name': 'Korean',
        'recognizer': TextRecognizer(script: TextRecognitionScript.korean),
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
        continue;
      }

      try {
        final recognizedText = await recognizer.processImage(inputImage);
        final joinedText = recognizedText.blocks
            .map((block) => block.text)
            .join(' ');
        final symbolCount = countScriptSymbols(joinedText, scriptName);

        List<Map<String, dynamic>> blocks = recognizedText.blocks
            .map(
              (block) => ({
                'script': scriptName,
                'text': block.text,
                'boundingBox': {
                  'left': block.boundingBox.left,
                  'top': block.boundingBox.top,
                  'right': block.boundingBox.right,
                  'bottom': block.boundingBox.bottom,
                },
                'normalizedBoundingBox': {
                  'left': block.boundingBox.left / imageWidth,
                  'top': block.boundingBox.top / imageHeight,
                  'right': block.boundingBox.right / imageWidth,
                  'bottom': block.boundingBox.bottom / imageHeight,
                },
                'cornerPoints': block.cornerPoints
                    .map((p) => {'x': p.x, 'y': p.y})
                    .toList(),
              }),
            )
            .toList();

        if (scriptName != 'Latin' && symbolCount > 7) {
          if (symbolCount > maxNonLatinSymbolCount) {
            maxNonLatinSymbolCount = symbolCount;
            selectedScript = scriptName;
            selectedBlocks = blocks;
          }
        } else if (scriptName == 'Latin' && maxNonLatinSymbolCount == -1) {
          selectedBlocks = blocks;
          latinJoinedText = joinedText;
        }
      } finally {
        await recognizer.close();
      }
    }

    if (selectedScript == 'Latin' &&
        latinLanguageAutoDetectEnabled &&
        latinJoinedText != null) {
      final detectedLanguage = await detectLatinLanguage(latinJoinedText);
      selectedBlocks = selectedBlocks
          .map((block) => ({...block, 'script': detectedLanguage}))
          .toList();
      selectedScript = detectedLanguage;
    }

    return {'textBlocks': selectedBlocks, 'joinedText': latinJoinedText};
  }

  // Processes an image for text recognition with a specific script.
  Future<Map<String, dynamic>> processImageWithScript(
    File imageFile,
    String script,
    bool latinLanguageAutoDetectEnabled,
  ) async {
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final dimensions = await _imageService.getImageDimensions(imageFile);
    final imageWidth = dimensions['width']!.toDouble();
    final imageHeight = dimensions['height']!.toDouble();

    TextRecognizer textRecognizer;
    switch (script) {
      case 'Chinese':
        textRecognizer = TextRecognizer(script: TextRecognitionScript.chinese);
        break;
      case 'Japanese':
        textRecognizer = TextRecognizer(script: TextRecognitionScript.japanese);
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
      final joinedText = recognizedText.blocks
          .map((block) => block.text)
          .join(' ');
      String scriptLabel = script;
      if (script == 'Latin' && latinLanguageAutoDetectEnabled) {
        scriptLabel = await detectLatinLanguage(joinedText);
      }

      final textBlocks = recognizedText.blocks
          .map(
            (block) => ({
              'script': scriptLabel,
              'text': block.text,
              'boundingBox': {
                'left': block.boundingBox.left,
                'top': block.boundingBox.top,
                'right': block.boundingBox.right,
                'bottom': block.boundingBox.bottom,
              },
              'normalizedBoundingBox': {
                'left': block.boundingBox.left / imageWidth,
                'top': block.boundingBox.top / imageHeight,
                'right': block.boundingBox.right / imageWidth,
                'bottom': block.boundingBox.bottom / imageHeight,
              },
              'cornerPoints': block.cornerPoints
                  .map((p) => {'x': p.x, 'y': p.y})
                  .toList(),
            }),
          )
          .toList();

      return {'textBlocks': textBlocks, 'joinedText': joinedText};
    } finally {
      await textRecognizer.close();
    }
  }
}

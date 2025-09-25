// lib/services/ocr_services.dart
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'image_service.dart';

// Service for OCR (text recognition) and language detection.
class OcrService {
  final ImageService _imageService = ImageService();

  // COMP 1: Counts symbols in a text string for a specific script.
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

  // COMP 2: Detects the language of a Latin-based text.
  Future<String> detectLatinLanguage(String joinedText) async {
    if (joinedText.isEmpty) {
      return 'Text not recognized';
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
            return 'Language detected: Latin derivative';
        }
      }
      return 'Language detected: Latin derivative2';
    } catch (_) {
      return 'Language detected: Latin derivative3';
    } finally {
      await languageIdentifier.close();
    }
  }

  // FUNC 1: Processes an image for text recognition with automatic script detection.
  Future<Map<String, dynamic>> processImageWithAutoDetect(
    File imageFile,
    bool latinLanguageAutoDetectEnabled,
  ) async {
    // Step 1: Get dimensions
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final dimensions = await _imageService.getImageDimensions(imageFile);
    final imageWidth = dimensions['width']!.toDouble();
    final imageHeight = dimensions['height']!.toDouble();

    // Step 2: Define scripts for language recognition (TODO: Define outside of the function)
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

    // Step 3: Define variables to detect
    String selectedScript = 'Latin';
    int maxNonLatinSymbolCount = -1;
    List<Map<String, dynamic>> selectedBlocks = [];
    String? latinJoinedText;

    // Step 4: Try to detect symbols for all scripts
    for (var script in scripts) {
      final scriptName = script['name'] as String?;
      final recognizer = script['recognizer'] as TextRecognizer?;
      if (scriptName == null || recognizer == null) continue;

      try {
        // Step 5: Detect text
        final recognizedText = await recognizer.processImage(inputImage);
        // Step 6: Join text
        final joinedText = recognizedText.blocks
            .map((block) => block.text)
            .join(' ');
        // Step 7: Count symbols
        final symbolCount = countScriptSymbols(joinedText, scriptName);
        // Step 8: Define blocks of texts and identified positions
        final blocks = recognizedText.blocks
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
        // Step 9: Define variables when non latin language found
        if (scriptName != 'Latin' && symbolCount > 7) {
          if (symbolCount > maxNonLatinSymbolCount) {
            maxNonLatinSymbolCount = symbolCount;
            selectedScript = scriptName;
            selectedBlocks = blocks;
          }
          // Step 10: Define variables when latin language found
        } else if (scriptName == 'Latin' && maxNonLatinSymbolCount == -1) {
          selectedBlocks = blocks;
          latinJoinedText = joinedText;
        }
      } finally {
        await recognizer.close();
      }
    }
    // Step 11: If detect language available, save identified langage
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

  // FUNC 1.a: Processes an image for text recognition with a specific script. (Same process as previous, less steps)
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

  /// FUNC 2: Extract One Piece game code (OP##-###, ST##-###, or P-###) from recognized text.
  /// - Tolerates spaces/hyphens around tokens.
  /// - Pads OP/ST set number to 2 digits if it’s a single digit.
  /// Returns the normalized code (e.g., "OP05-119", "ST10-004", "P-001") or null.
  String? extractOnePieceGameCode({
    required List<Map<String, dynamic>> textBlocks,
    String? joinedText,
  }) {
    // Step 1: Combine joinedText & textBlocks to ensure it's found (TODO: Use only one, probably joined text)
    final combined = (joinedText != null && joinedText.trim().isNotEmpty)
        ? joinedText
        : textBlocks.map((b) => b['text']?.toString() ?? '').join(' ');
    final upper = combined.toUpperCase();

    // Step 2: Find all potential matches with their indices so we can pick the earliest.
    final matches = <_FoundMatch>[];

    // Step 3: OP pattern Identification
    final opRe = RegExp(r'OP\s*-?\s*(\d{1,3})\s*-\s*(\d{3})');
    for (final m in opRe.allMatches(upper)) {
      final setDigits = m.group(1)!; // 1-3 digits
      final cardDigits = m.group(2)!; // 3 digits
      final normalizedSet = setDigits.length == 1
          ? '0$setDigits'
          : setDigits.padLeft(2, '0');
      matches.add(_FoundMatch(m.start, 'OP$normalizedSet-$cardDigits'));
    }

    // Step 4: ST pattern Identification
    final stRe = RegExp(r'ST\s*-?\s*(\d{1,3})\s*-\s*(\d{3})');
    for (final m in stRe.allMatches(upper)) {
      final setDigits = m.group(1)!;
      final cardDigits = m.group(2)!;
      final normalizedSet = setDigits.length == 1
          ? '0$setDigits'
          : setDigits.padLeft(2, '0');
      matches.add(_FoundMatch(m.start, 'ST$normalizedSet-$cardDigits'));
    }

    // Step 5: Promo pattern P-### Identification
    final pRe = RegExp(r'\bP\s*-\s*(\d{3})\b');
    for (final m in pRe.allMatches(upper)) {
      final cardDigits = m.group(1)!;
      matches.add(_FoundMatch(m.start, 'P-$cardDigits'));
    }

    // Step 6: Not found match for ID
    if (matches.isEmpty) return null;
    matches.sort((a, b) => a.index.compareTo(b.index));
    return matches.first.normalized;
  }
}

class _FoundMatch {
  final int index;
  final String normalized;
  _FoundMatch(this.index, this.normalized);
}

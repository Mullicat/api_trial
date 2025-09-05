import '../constants/game_detection_constants.dart';

// Service for detecting trading card games based on OCR text and bounding boxes.
class GameDetectionService {
  // Detects the trading card game from recognized text blocks and joined text.
  String detectGame(
    List<Map<String, dynamic>> textBlocks,
    String? joinedText,
    bool tcgAutoDetectEnabled,
    String selectedGame,
  ) {
    if (!tcgAutoDetectEnabled) {
      return selectedGame;
    }

    // One Piece TCG detection
    for (final block in textBlocks) {
      final text = block['text'].toString().toUpperCase();
      final box = block['normalizedBoundingBox'] as Map<String, dynamic>;
      final left = box['left'] as double;
      final top = box['top'] as double;
      final right = box['right'] as double;
      final bottom = box['bottom'] as double;

      bool inRange =
          left >= GameDetectionConstants.onePieceLeftRange[0] &&
          left <= GameDetectionConstants.onePieceLeftRange[1] &&
          top >= GameDetectionConstants.onePieceTopRange[0] &&
          top <= GameDetectionConstants.onePieceTopRange[1] &&
          right >= GameDetectionConstants.onePieceRightRange[0] &&
          right <= GameDetectionConstants.onePieceRightRange[1] &&
          bottom >= GameDetectionConstants.onePieceBottomRange[0] &&
          bottom <= GameDetectionConstants.onePieceBottomRange[1];

      bool hasKeyword = GameDetectionConstants.onePieceKeywords.any(
        (keyword) => text.contains(keyword),
      );

      if (inRange && hasKeyword) {
        return 'One Piece TCG';
      }
    }

    if (joinedText == null) {
      return 'Other Game';
    }

    final upperText = joinedText.toUpperCase();

    // YuGiOh detection (specific keywords)
    if (GameDetectionConstants.yugiohKeywords.any(
      (keyword) => upperText.contains(keyword),
    )) {
      return 'YuGiOh';
    }

    // Pokémon TCG detection
    bool hasWeakness = GameDetectionConstants.pokemonWeaknessKeywords.any(
      (keyword) => upperText.contains(keyword),
    );
    bool hasResistance = GameDetectionConstants.pokemonResistanceKeywords.any(
      (keyword) => upperText.contains(keyword),
    );
    bool hasTrainer = GameDetectionConstants.pokemonTrainerKeywords.any(
      (keyword) => upperText.contains(keyword),
    );
    bool hasTrainerType = GameDetectionConstants.pokemonTrainerTypes.any(
      (keyword) => upperText.contains(keyword),
    );
    bool hasEnergy = GameDetectionConstants.pokemonEnergyKeywords.any(
      (keyword) => upperText.contains(keyword),
    );

    int energyCount = 0;
    for (var keyword in GameDetectionConstants.pokemonEnergyKeywords) {
      final pattern = RegExp(
        '\\b$keyword\\b',
        caseSensitive: keyword.contains(RegExp(r'[\u4E00-\u9FFF]')),
      );
      energyCount += pattern.allMatches(joinedText).length;
    }

    if (hasWeakness && hasResistance ||
        hasTrainer && hasTrainerType ||
        hasEnergy &&
            !hasWeakness &&
            !hasResistance &&
            !hasTrainer &&
            !hasTrainerType ||
        energyCount > 3) {
      return 'Pokemon TCG';
    }

    // Magic: The Gathering detection
    for (final block in textBlocks) {
      final text = block['text'].toString();
      final upperBlockText = text.toUpperCase();
      final box = block['normalizedBoundingBox'] as Map<String, dynamic>;
      final left = box['left'] as double;
      final top = box['top'] as double;
      final bottom = box['bottom'] as double;

      bool inRange =
          left >= GameDetectionConstants.mtgLeftRange[0] &&
          left <= GameDetectionConstants.mtgLeftRange[1] &&
          top >= GameDetectionConstants.mtgTopRange[0] &&
          top <= GameDetectionConstants.mtgTopRange[1] &&
          bottom >= GameDetectionConstants.mtgBottomRange[0] &&
          bottom <= GameDetectionConstants.mtgBottomRange[1];

      bool hasKeyword = GameDetectionConstants.mtgKeywords.any(
        (keyword) => keyword.contains(RegExp(r'[\u4E00-\u9FFF]'))
            ? text.contains(keyword)
            : upperBlockText.contains(keyword),
      );

      bool hasSummon = GameDetectionConstants.mtgSummonKeywords.any(
        (keyword) => keyword.contains(RegExp(r'[\u4E00-\u9FFF]'))
            ? text.contains(keyword)
            : upperBlockText.contains(keyword),
      );

      if (inRange && (hasKeyword || hasSummon)) {
        return 'Magic: The Gathering';
      }
    }

    // YuGiOh detection (CARD, USED, TOKEN)
    bool hasCard = GameDetectionConstants.yugiohCardKeywords.any(
      (keyword) => keyword.contains(RegExp(r'[\u4E00-\u9FFF]'))
          ? joinedText.contains(keyword)
          : upperText.contains(keyword),
    );
    bool hasUsed = GameDetectionConstants.yugiohUsedKeywords.any(
      (keyword) => keyword.contains(RegExp(r'[\u4E00-\u9FFF]'))
          ? joinedText.contains(keyword)
          : upperText.contains(keyword),
    );
    bool hasToken = GameDetectionConstants.yugiohTokenKeywords.any(
      (keyword) => keyword.contains(RegExp(r'[\u4E00-\u9FFF]'))
          ? joinedText.contains(keyword)
          : upperText.contains(keyword),
    );

    if (hasCard && hasUsed && hasToken) {
      return 'YuGiOh';
    }

    return 'Other Game';
  }
}

// lib/constants/game_detection_constants.dart
// Constants for trading card game detection, including keywords and bounding box ranges.
class GameDetectionConstants {
  // Keywords for One Piece TCG detection
  static const onePieceKeywords = [
    'LEADER',
    'DON!! EVENT',
    'STAGE',
    'STACE',
    'CHARACTER',
    'D0N!! CARD',
  ];

  // Bounding box ranges for One Piece TCG detection
  static const onePieceLeftRange = [0.37, 0.46];
  static const onePieceTopRange = [0.83, 0.88];
  static const onePieceRightRange = [0.53, 0.62];
  static const onePieceBottomRange = [0.86, 0.90];

  // Keywords for YuGiOh detection (specific card attributes)
  static const yugiohKeywords = [
    'ATK',
    'DEF',
    'TRAP CARD',
    'SPELL CARD',
    'CARTA DE TRAMPA',
    'CARTA MÁGICA',
    'CARTE MAGIE',
    'CARTE PIÈGE',
    'CARTA TRAPPOLA',
    'CARTA MAGIA',
    'CARD DE MAGIA',
    'CARD DE ARMADILHA',
    'ZAUBERKARTE',
    'FALLENKARTE',
  ];

  // Keywords for YuGiOh detection (additional CARD, USED, TOKEN check)
  static const yugiohCardKeywords = [
    'CARD',
    'CARTA',
    'CARTE',
    'KARTE',
    'カード',
    '卡',
  ];

  static const yugiohUsedKeywords = [
    'USED',
    'USADO',
    'USATO',
    'UTILISÉ',
    'VERWENDET',
    '使用',
  ];

  static const yugiohTokenKeywords = [
    'TOKEN',
    'FICHA',
    'SEGNALINO',
    'JETON',
    'SPIELMARKE',
    'トークン',
    '衍生物',
  ];

  // Keywords for Pokémon TCG detection
  static const pokemonWeaknessKeywords = [
    'WEAKNESS',
    'FAIBLESSE',
    'SCHWÄCHE',
    'DEBOLEZZA',
    'DEBILIDAD',
    'FRAQUEZA',
    '弱点',
  ];

  static const pokemonResistanceKeywords = [
    'RESISTANCE',
    'RÉSISTANCE',
    'RESISTENZ',
    'RESISTENZA',
    'RESISTENCIA',
    'RESISTÊNCIA',
    '抵抗',
  ];

  static const pokemonTrainerKeywords = [
    'TRAINER',
    'DRESSEUR',
    'ALLENATORE',
    'ENTRENADOR',
    'TREINADOR',
    'トレーナー',
    '训练家',
  ];

  static const pokemonTrainerTypes = [
    'ITEM',
    'OBJET',
    'STRUMENTO',
    'OBJETO',
    'グッズ',
    '道具',
    'SUPPORTER',
    'UNTERSTÜTZER',
    'SOSTENITORE',
    'PARTIDARIO',
    'APOIADOR',
    'サポーター',
    '支援者',
    'STADIUM',
    'STADE',
    'STADION',
    'STADIO',
    'ESTADIO',
    'ESTÁDIO',
    'スタジアム',
    '竞技场',
  ];

  static const pokemonEnergyKeywords = [
    'ENERGY',
    'ÉNERGIE',
    'ENERGIA',
    'ENERGÍA',
    'エネルギー',
    '能量',
  ];

  // Keywords for Magic: The Gathering detection
  static const mtgKeywords = [
    'ENCHANTMENT',
    'ENCANTAMIENTO',
    'ENCANTAMENTO',
    'INCANTESIMO',
    'ENCHANTEMENT',
    'VERZAUBERUNG',
    'エンチャント',
    '结界',
    'INSTANT',
    'INSTANTÁNEO',
    'INSTANTÂNEO',
    'ISTANTANEO',
    'INSTANTANÉ',
    'SOFORTZAUBER',
    'インスタント',
    '瞬间',
    'SORCERY',
    'CONJURO',
    'FEITIÇO',
    'RITUALE',
    'ZAUBEREI',
    'ソーサリー',
    '巫术',
    'CREATURE',
    'CRIATURA',
    'CREATURA',
    'CRÉATURE',
    'KREATUR',
    'クリーチャー',
    '生物',
    'LAND',
    'TIERRA',
    'TERRA',
    'TERRAIN',
    '土地',
    '地',
    'ARTIFACT',
    'ARTEFACTO',
    'ARTEFATO',
    'ARTEFATTO',
    'ARTEFACT',
    'ARTEFAKT',
    'アーティファクト',
    '神器',
    'PLANESWALKER',
    'CAMINANTE DE PLANOS',
    'PLANINAUTA',
    'ARPENTEUR',
    'プレインズウォーカー',
    '鹏洛客',
    'SUMMON',
    'CONVOCAR',
    'EVOCARE',
    'INVOCATION',
    'BESCHWÖRUNG',
    '召喚',
    '召唤',
  ];

  static const mtgSummonKeywords = [
    'SUMMON',
    'CONVOCAR',
    'EVOCARE',
    'INVOCATION',
    'BESCHWÖRUNG',
    '召喚',
    '召唤',
  ];

  // Bounding box ranges for Magic: The Gathering detection
  static const mtgLeftRange = [0.02, 0.12];
  static const mtgTopRange = [0.55, 0.59];
  static const mtgBottomRange = [0.59, 0.64];
}

//lib/enums/game_type.dart

// Enum for different card game types with their API paths
enum GameType {
  onePiece('one-piece'),
  pokemon('pokemon'),
  dragonBall('dragon-ball-fusion'),
  digimon('digimon'),
  unionArena('union-arena'),
  gundam('gundam'),
  magic('magic'),
  yugioh('yugioh');

  // API path for each game type
  final String apiPath;
  // Constructor to initialize apiPath
  const GameType(this.apiPath);
}

// Enum for card retrieval sources
enum GetCardType {
  fromAPI('fromAPI'),
  fromSupabase('fromSupabase'),
  fromAPICards('fromAPICards');

  // String value for each source type
  final String value;
  // Constructor to initialize value
  const GetCardType(this.value);
}

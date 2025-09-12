enum GameType {
  onePiece('one-piece'),
  pokemon('pokemon'),
  dragonBall('dragon-ball-fusion'),
  digimon('digimon'),
  unionArena('union-arena'),
  gundam('gundam'),
  magic('magic'),
  yugioh('yugioh');

  final String apiPath;
  const GameType(this.apiPath);
}

enum GetCardType {
  fromAPI('fromAPI'),
  fromSupabase('fromSupabase'),
  fromAPICards('fromAPICards');

  final String value;
  const GetCardType(this.value);
}

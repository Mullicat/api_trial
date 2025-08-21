import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_model_pokemon.freezed.dart';
part 'card_model_pokemon.g.dart';

@freezed
class Card with _$Card {
  const factory Card({
    String? id,
    String? name,
    String? supertype,
    List<String>? subtypes,
    String? hp,
    List<String>? types,
    String? evolvesFrom,
    List<Ability>? abilities,
    List<Attack>? attacks,
    List<Weakness>? weaknesses,
    List<String>? retreatCost,
    int? convertedRetreatCost,
    Set? set,
    String? number,
    String? artist,
    String? rarity,
    String? flavorText,
    List<int>? nationalPokedexNumbers,
    Legalities? legalities,
    Images? images,
    Tcgplayer? tcgplayer,
    Cardmarket? cardmarket,
  }) = _Card;

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);
}

@freezed
class Set with _$Set {
  const factory Set({
    String? id,
    String? name,
    String? series,
    int? printedTotal,
    int? total,
    Legalities? legalities,
    String? ptcgoCode,
    String? releaseDate,
    String? updatedAt,
    Images? images,
  }) = _Set;

  factory Set.fromJson(Map<String, dynamic> json) => _$SetFromJson(json);
}

@freezed
class Ability with _$Ability {
  const factory Ability({String? name, String? text, String? type}) = _Ability;

  factory Ability.fromJson(Map<String, dynamic> json) =>
      _$AbilityFromJson(json);
}

@freezed
class Attack with _$Attack {
  const factory Attack({
    String? name,
    String? text,
    List<String>? cost,
    int? convertedEnergyCost,
    String? damage,
  }) = _Attack;

  factory Attack.fromJson(Map<String, dynamic> json) => _$AttackFromJson(json);
}

@freezed
class Weakness with _$Weakness {
  const factory Weakness({String? type, String? value}) = _Weakness;

  factory Weakness.fromJson(Map<String, dynamic> json) =>
      _$WeaknessFromJson(json);
}

@freezed
class Legalities with _$Legalities {
  const factory Legalities({
    String? unlimited,
    String? standard,
    String? expanded,
  }) = _Legalities;

  factory Legalities.fromJson(Map<String, dynamic> json) =>
      _$LegalitiesFromJson(json);
}

@freezed
class Images with _$Images {
  const factory Images({String? small, String? large}) = _Images;

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);
}

@freezed
class Tcgplayer with _$Tcgplayer {
  const factory Tcgplayer({
    String? url,
    String? updatedAt,
    TcgplayerPrices? prices,
  }) = _Tcgplayer;

  factory Tcgplayer.fromJson(Map<String, dynamic> json) =>
      _$TcgplayerFromJson(json);
}

@freezed
class TcgplayerPrices with _$TcgplayerPrices {
  const factory TcgplayerPrices({
    double? low,
    double? mid,
    double? high,
    double? market,
    double? directLow,
  }) = _TcgplayerPrices;

  factory TcgplayerPrices.fromJson(Map<String, dynamic> json) =>
      _$TcgplayerPricesFromJson(json);
}

@freezed
class Cardmarket with _$Cardmarket {
  const factory Cardmarket({
    String? url,
    String? updatedAt,
    CardmarketPrices? prices,
  }) = _Cardmarket;

  factory Cardmarket.fromJson(Map<String, dynamic> json) =>
      _$CardmarketFromJson(json);
}

@freezed
class CardmarketPrices with _$CardmarketPrices {
  const factory CardmarketPrices({
    double? averageSellPrice,
    double? lowPrice,
    double? trendPrice,
  }) = _CardmarketPrices;

  factory CardmarketPrices.fromJson(Map<String, dynamic> json) =>
      _$CardmarketPricesFromJson(json);
}

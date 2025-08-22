// lib/models/card_model_api_apitcg.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_model_api_apitcg.freezed.dart';
part 'card_model_api_apitcg.g.dart';

@freezed
class OnePieceCard with _$OnePieceCard {
  const factory OnePieceCard({
    required String id,
    required String code,
    required String rarity,
    required String type,
    required String name,
    required Map<String, String> images,
    required int cost,
    Attribute? attribute,
    int? power,
    required String counter,
    required String color,
    required String family,
    required String ability,
    required String trigger,
    required SetInfo set,
    required List<String> notes,
  }) = _OnePieceCard;

  factory OnePieceCard.fromJson(Map<String, dynamic> json) =>
      _$OnePieceCardFromJson(json);
}

@freezed
class Attribute with _$Attribute {
  const factory Attribute({required String name, required String image}) =
      _Attribute;

  factory Attribute.fromJson(Map<String, dynamic> json) =>
      _$AttributeFromJson(json);
}

@freezed
class SetInfo with _$SetInfo {
  const factory SetInfo({required String name, String? id}) = _SetInfo;

  factory SetInfo.fromJson(Map<String, dynamic> json) =>
      _$SetInfoFromJson(json);
}

@freezed
class PokemonCard with _$PokemonCard {
  const factory PokemonCard({
    required String id,
    required String name,
    required String supertype,
    required List<String> subtypes,
    String? level,
    required String hp,
    required List<String> types,
    String? evolvesFrom,
    List<Ability>? abilities,
    List<Attack>? attacks,
    List<Weakness>? weaknesses,
    List<Resistance>? resistances,
    List<String>? retreatCost,
    int? convertedRetreatCost,
    required String number,
    required String artist,
    required String rarity,
    String? flavorText,
    List<int>? nationalPokedexNumbers,
    Map<String, String>? legalities,
    required Map<String, String> images,
  }) = _PokemonCard;

  factory PokemonCard.fromJson(Map<String, dynamic> json) =>
      _$PokemonCardFromJson(json);
}

@freezed
class Ability with _$Ability {
  const factory Ability({
    required String name,
    required String text,
    required String type,
  }) = _Ability;

  factory Ability.fromJson(Map<String, dynamic> json) =>
      _$AbilityFromJson(json);
}

@freezed
class Attack with _$Attack {
  const factory Attack({
    required String name,
    required List<String> cost,
    required int convertedEnergyCost,
    required String damage,
    required String text,
  }) = _Attack;

  factory Attack.fromJson(Map<String, dynamic> json) => _$AttackFromJson(json);
}

@freezed
class Weakness with _$Weakness {
  const factory Weakness({required String type, required String value}) =
      _Weakness;

  factory Weakness.fromJson(Map<String, dynamic> json) =>
      _$WeaknessFromJson(json);
}

@freezed
class Resistance with _$Resistance {
  const factory Resistance({required String type, required String value}) =
      _Resistance;

  factory Resistance.fromJson(Map<String, dynamic> json) =>
      _$ResistanceFromJson(json);
}

@freezed
class DragonBallCard with _$DragonBallCard {
  const factory DragonBallCard({
    required String id,
    required String code,
    required String rarity,
    required String name,
    required String color,
    required Map<String, String> images,
    required String cardType,
    required String cost,
    required String specifiedCost,
    required String power,
    required String comboPower,
    required String features,
    required String effect,
    required String getIt,
    required SetInfo set,
  }) = _DragonBallCard;

  factory DragonBallCard.fromJson(Map<String, dynamic> json) =>
      _$DragonBallCardFromJson(json);
}

@freezed
class DigimonCard with _$DigimonCard {
  const factory DigimonCard({
    required String id,
    required String code,
    String? rarity,
    required String name,
    String? level,
    required List<String> colors,
    required Map<String, String> images,
    required String cardType,
    String? form,
    String? attribute,
    required String type,
    required String dp,
    required String playCost,
    required String digivolveCost1,
    required String digivolveCost2,
    required String effect,
    required String inheritedEffect,
    required String securityEffect,
    required String notes,
    required SetInfo set,
  }) = _DigimonCard;

  factory DigimonCard.fromJson(Map<String, dynamic> json) =>
      _$DigimonCardFromJson(json);
}

@freezed
class UnionArenaCard with _$UnionArenaCard {
  const factory UnionArenaCard({
    required String id,
    required String code,
    required String url,
    required String name,
    required String rarity,
    required String ap,
    required String type,
    required String bp,
    required String affinity,
    required String effect,
    required String trigger,
    required Map<String, String> images,
    required SetInfo set,
    NeedEnergy? needEnergy,
  }) = _UnionArenaCard;

  factory UnionArenaCard.fromJson(Map<String, dynamic> json) =>
      _$UnionArenaCardFromJson(json);
}

@freezed
class NeedEnergy with _$NeedEnergy {
  const factory NeedEnergy({required String value, required String logo}) =
      _NeedEnergy;

  factory NeedEnergy.fromJson(Map<String, dynamic> json) =>
      _$NeedEnergyFromJson(json);
}

@freezed
class GundamCard with _$GundamCard {
  const factory GundamCard({
    required String id,
    required String code,
    required String rarity,
    required String name,
    required Map<String, String> images,
    required String level,
    required String cost,
    required String color,
    required String cardType,
    required String effect,
    required String zone,
    required String trait,
    required String link,
    required String ap,
    required String hp,
    required String sourceTitle,
    required String getIt,
    required SetInfo set,
  }) = _GundamCard;

  factory GundamCard.fromJson(Map<String, dynamic> json) =>
      _$GundamCardFromJson(json);
}

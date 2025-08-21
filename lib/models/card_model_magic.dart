// lib/models/card_model_magic.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:developer' as developer;

part 'card_model_magic.freezed.dart';
part 'card_model_magic.g.dart';

class StringToIntConverter implements JsonConverter<int?, dynamic> {
  const StringToIntConverter();

  @override
  int? fromJson(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed == null) {
        developer.log('Failed to parse int from string: $value');
        return null;
      }
      return parsed;
    }
    developer.log(
      'Unsupported type for conversion: ${value.runtimeType}, value: $value',
    );
    return null;
  }

  @override
  String? toJson(int? value) {
    return value?.toString();
  }
}

@freezed
class Card with _$Card {
  const factory Card({
    String? name,
    List<String>? names,
    String? manaCost,
    @StringToIntConverter() int? cmc, // Use updated converter
    List<String>? colors,
    List<String>? colorIdentity,
    String? type,
    List<String>? supertypes,
    List<String>? types,
    List<String>? subtypes,
    String? rarity,
    String? set,
    String? setName,
    String? text,
    String? artist,
    String? number,
    String? power,
    String? toughness,
    String? layout,
    @StringToIntConverter() int? multiverseid, // Use updated converter
    String? imageUrl,
    List<Ruling>? rulings,
    List<ForeignName>? foreignNames,
    List<String>? printings,
    String? originalText,
    String? originalType,
    String? id,
  }) = _Card;

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);
}

@freezed
class Ruling with _$Ruling {
  const factory Ruling({String? date, String? text}) = _Ruling;

  factory Ruling.fromJson(Map<String, dynamic> json) => _$RulingFromJson(json);
}

@freezed
class ForeignName with _$ForeignName {
  const factory ForeignName({
    String? name,
    String? language,
    @StringToIntConverter() int? multiverseid, // Use updated converter
  }) = _ForeignName;

  factory ForeignName.fromJson(Map<String, dynamic> json) =>
      _$ForeignNameFromJson(json);
}

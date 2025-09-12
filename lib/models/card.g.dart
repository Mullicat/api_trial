// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TCGCard _$TCGCardFromJson(Map<String, dynamic> json) => _TCGCard(
  id: json['id'] as String?,
  gameCode: json['game_code'] as String?,
  name: json['name'] as String?,
  gameType: json['game_type'] as String?,
  version: json['version'] as String?,
  setName: json['set_name'] as String?,
  rarity: json['rarity'] as String?,
  imageRefSmall: json['image_ref_small'] as String?,
  imageRefLarge: json['image_ref_large'] as String?,
  imageEmbedding: (json['image_embedding'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList(),
  textEmbedding: (json['text_embedding'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList(),
  gameSpecificData: json['game_specific_data'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$TCGCardToJson(_TCGCard instance) => <String, dynamic>{
  'id': instance.id,
  'game_code': instance.gameCode,
  'name': instance.name,
  'game_type': instance.gameType,
  'version': instance.version,
  'set_name': instance.setName,
  'rarity': instance.rarity,
  'image_ref_small': instance.imageRefSmall,
  'image_ref_large': instance.imageRefLarge,
  'image_embedding': instance.imageEmbedding,
  'text_embedding': instance.textEmbedding,
  'game_specific_data': instance.gameSpecificData,
};

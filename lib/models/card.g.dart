// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TCGCard _$TCGCardFromJson(Map<String, dynamic> json) => _TCGCard(
  id: json['id'] as String,
  gameCode: json['gameCode'] as String,
  name: json['name'] as String,
  gameType: json['gameType'] as String,
  version: json['version'] as String?,
  setName: json['setName'] as String?,
  rarity: json['rarity'] as String?,
  imageRefSmall: json['imageRefSmall'] as String?,
  imageRefLarge: json['imageRefLarge'] as String?,
  imageEmbedding: (json['imageEmbedding'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList(),
  textEmbedding: (json['textEmbedding'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList(),
  gameSpecificData: json['gameSpecificData'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$TCGCardToJson(_TCGCard instance) => <String, dynamic>{
  'id': instance.id,
  'gameCode': instance.gameCode,
  'name': instance.name,
  'gameType': instance.gameType,
  'version': instance.version,
  'setName': instance.setName,
  'rarity': instance.rarity,
  'imageRefSmall': instance.imageRefSmall,
  'imageRefLarge': instance.imageRefLarge,
  'imageEmbedding': instance.imageEmbedding,
  'textEmbedding': instance.textEmbedding,
  'gameSpecificData': instance.gameSpecificData,
};

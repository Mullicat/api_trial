// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_model_magic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MagicCardImpl _$$MagicCardImplFromJson(
  Map<String, dynamic> json,
) => _$MagicCardImpl(
  name: json['name'] as String?,
  names: (json['names'] as List<dynamic>?)?.map((e) => e as String).toList(),
  manaCost: json['manaCost'] as String?,
  cmc: const StringToIntConverter().fromJson(json['cmc']),
  colors: (json['colors'] as List<dynamic>?)?.map((e) => e as String).toList(),
  colorIdentity: (json['colorIdentity'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  type: json['type'] as String?,
  supertypes: (json['supertypes'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  types: (json['types'] as List<dynamic>?)?.map((e) => e as String).toList(),
  subtypes: (json['subtypes'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  rarity: json['rarity'] as String?,
  set: json['set'] as String?,
  setName: json['setName'] as String?,
  text: json['text'] as String?,
  artist: json['artist'] as String?,
  number: json['number'] as String?,
  power: json['power'] as String?,
  toughness: json['toughness'] as String?,
  layout: json['layout'] as String?,
  multiverseid: const StringToIntConverter().fromJson(json['multiverseid']),
  imageUrl: json['imageUrl'] as String?,
  rulings: (json['rulings'] as List<dynamic>?)
      ?.map((e) => Ruling.fromJson(e as Map<String, dynamic>))
      .toList(),
  foreignNames: (json['foreignNames'] as List<dynamic>?)
      ?.map((e) => ForeignName.fromJson(e as Map<String, dynamic>))
      .toList(),
  printings: (json['printings'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  originalText: json['originalText'] as String?,
  originalType: json['originalType'] as String?,
  id: json['id'] as String?,
);

Map<String, dynamic> _$$MagicCardImplToJson(
  _$MagicCardImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'names': instance.names,
  'manaCost': instance.manaCost,
  'cmc': const StringToIntConverter().toJson(instance.cmc),
  'colors': instance.colors,
  'colorIdentity': instance.colorIdentity,
  'type': instance.type,
  'supertypes': instance.supertypes,
  'types': instance.types,
  'subtypes': instance.subtypes,
  'rarity': instance.rarity,
  'set': instance.set,
  'setName': instance.setName,
  'text': instance.text,
  'artist': instance.artist,
  'number': instance.number,
  'power': instance.power,
  'toughness': instance.toughness,
  'layout': instance.layout,
  'multiverseid': const StringToIntConverter().toJson(instance.multiverseid),
  'imageUrl': instance.imageUrl,
  'rulings': instance.rulings,
  'foreignNames': instance.foreignNames,
  'printings': instance.printings,
  'originalText': instance.originalText,
  'originalType': instance.originalType,
  'id': instance.id,
};

_$RulingImpl _$$RulingImplFromJson(Map<String, dynamic> json) =>
    _$RulingImpl(date: json['date'] as String?, text: json['text'] as String?);

Map<String, dynamic> _$$RulingImplToJson(_$RulingImpl instance) =>
    <String, dynamic>{'date': instance.date, 'text': instance.text};

_$ForeignNameImpl _$$ForeignNameImplFromJson(Map<String, dynamic> json) =>
    _$ForeignNameImpl(
      name: json['name'] as String?,
      language: json['language'] as String?,
      multiverseid: const StringToIntConverter().fromJson(json['multiverseid']),
    );

Map<String, dynamic> _$$ForeignNameImplToJson(
  _$ForeignNameImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'language': instance.language,
  'multiverseid': const StringToIntConverter().toJson(instance.multiverseid),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_model_api_apitcg.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OnePieceCardImpl _$$OnePieceCardImplFromJson(Map<String, dynamic> json) =>
    _$OnePieceCardImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      rarity: json['rarity'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      images: Map<String, String>.from(json['images'] as Map),
      cost: (json['cost'] as num).toInt(),
      attribute: json['attribute'] == null
          ? null
          : Attribute.fromJson(json['attribute'] as Map<String, dynamic>),
      power: (json['power'] as num?)?.toInt(),
      counter: json['counter'] as String,
      color: json['color'] as String,
      family: json['family'] as String,
      ability: json['ability'] as String,
      trigger: json['trigger'] as String,
      set: SetInfo.fromJson(json['set'] as Map<String, dynamic>),
      notes: (json['notes'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$OnePieceCardImplToJson(_$OnePieceCardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'rarity': instance.rarity,
      'type': instance.type,
      'name': instance.name,
      'images': instance.images,
      'cost': instance.cost,
      'attribute': instance.attribute,
      'power': instance.power,
      'counter': instance.counter,
      'color': instance.color,
      'family': instance.family,
      'ability': instance.ability,
      'trigger': instance.trigger,
      'set': instance.set,
      'notes': instance.notes,
    };

_$AttributeImpl _$$AttributeImplFromJson(Map<String, dynamic> json) =>
    _$AttributeImpl(
      name: json['name'] as String,
      image: json['image'] as String,
    );

Map<String, dynamic> _$$AttributeImplToJson(_$AttributeImpl instance) =>
    <String, dynamic>{'name': instance.name, 'image': instance.image};

_$SetInfoImpl _$$SetInfoImplFromJson(Map<String, dynamic> json) =>
    _$SetInfoImpl(name: json['name'] as String, id: json['id'] as String?);

Map<String, dynamic> _$$SetInfoImplToJson(_$SetInfoImpl instance) =>
    <String, dynamic>{'name': instance.name, 'id': instance.id};

_$PokemonCardImpl _$$PokemonCardImplFromJson(Map<String, dynamic> json) =>
    _$PokemonCardImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      supertype: json['supertype'] as String,
      subtypes: (json['subtypes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      level: json['level'] as String?,
      hp: json['hp'] as String,
      types: (json['types'] as List<dynamic>).map((e) => e as String).toList(),
      evolvesFrom: json['evolvesFrom'] as String?,
      abilities: (json['abilities'] as List<dynamic>?)
          ?.map((e) => Ability.fromJson(e as Map<String, dynamic>))
          .toList(),
      attacks: (json['attacks'] as List<dynamic>?)
          ?.map((e) => Attack.fromJson(e as Map<String, dynamic>))
          .toList(),
      weaknesses: (json['weaknesses'] as List<dynamic>?)
          ?.map((e) => Weakness.fromJson(e as Map<String, dynamic>))
          .toList(),
      resistances: (json['resistances'] as List<dynamic>?)
          ?.map((e) => Resistance.fromJson(e as Map<String, dynamic>))
          .toList(),
      retreatCost: (json['retreatCost'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      convertedRetreatCost: (json['convertedRetreatCost'] as num?)?.toInt(),
      number: json['number'] as String,
      artist: json['artist'] as String,
      rarity: json['rarity'] as String,
      flavorText: json['flavorText'] as String?,
      nationalPokedexNumbers: (json['nationalPokedexNumbers'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      legalities: (json['legalities'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      images: Map<String, String>.from(json['images'] as Map),
    );

Map<String, dynamic> _$$PokemonCardImplToJson(_$PokemonCardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'supertype': instance.supertype,
      'subtypes': instance.subtypes,
      'level': instance.level,
      'hp': instance.hp,
      'types': instance.types,
      'evolvesFrom': instance.evolvesFrom,
      'abilities': instance.abilities,
      'attacks': instance.attacks,
      'weaknesses': instance.weaknesses,
      'resistances': instance.resistances,
      'retreatCost': instance.retreatCost,
      'convertedRetreatCost': instance.convertedRetreatCost,
      'number': instance.number,
      'artist': instance.artist,
      'rarity': instance.rarity,
      'flavorText': instance.flavorText,
      'nationalPokedexNumbers': instance.nationalPokedexNumbers,
      'legalities': instance.legalities,
      'images': instance.images,
    };

_$AbilityImpl _$$AbilityImplFromJson(Map<String, dynamic> json) =>
    _$AbilityImpl(
      name: json['name'] as String,
      text: json['text'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$$AbilityImplToJson(_$AbilityImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'text': instance.text,
      'type': instance.type,
    };

_$AttackImpl _$$AttackImplFromJson(Map<String, dynamic> json) => _$AttackImpl(
  name: json['name'] as String,
  cost: (json['cost'] as List<dynamic>).map((e) => e as String).toList(),
  convertedEnergyCost: (json['convertedEnergyCost'] as num).toInt(),
  damage: json['damage'] as String,
  text: json['text'] as String,
);

Map<String, dynamic> _$$AttackImplToJson(_$AttackImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'cost': instance.cost,
      'convertedEnergyCost': instance.convertedEnergyCost,
      'damage': instance.damage,
      'text': instance.text,
    };

_$WeaknessImpl _$$WeaknessImplFromJson(Map<String, dynamic> json) =>
    _$WeaknessImpl(
      type: json['type'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$$WeaknessImplToJson(_$WeaknessImpl instance) =>
    <String, dynamic>{'type': instance.type, 'value': instance.value};

_$ResistanceImpl _$$ResistanceImplFromJson(Map<String, dynamic> json) =>
    _$ResistanceImpl(
      type: json['type'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$$ResistanceImplToJson(_$ResistanceImpl instance) =>
    <String, dynamic>{'type': instance.type, 'value': instance.value};

_$DragonBallCardImpl _$$DragonBallCardImplFromJson(Map<String, dynamic> json) =>
    _$DragonBallCardImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      rarity: json['rarity'] as String,
      name: json['name'] as String,
      color: json['color'] as String,
      images: Map<String, String>.from(json['images'] as Map),
      cardType: json['cardType'] as String,
      cost: json['cost'] as String,
      specifiedCost: json['specifiedCost'] as String,
      power: json['power'] as String,
      comboPower: json['comboPower'] as String,
      features: json['features'] as String,
      effect: json['effect'] as String,
      getIt: json['getIt'] as String,
      set: SetInfo.fromJson(json['set'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DragonBallCardImplToJson(
  _$DragonBallCardImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'rarity': instance.rarity,
  'name': instance.name,
  'color': instance.color,
  'images': instance.images,
  'cardType': instance.cardType,
  'cost': instance.cost,
  'specifiedCost': instance.specifiedCost,
  'power': instance.power,
  'comboPower': instance.comboPower,
  'features': instance.features,
  'effect': instance.effect,
  'getIt': instance.getIt,
  'set': instance.set,
};

_$DigimonCardImpl _$$DigimonCardImplFromJson(Map<String, dynamic> json) =>
    _$DigimonCardImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      rarity: json['rarity'] as String?,
      name: json['name'] as String,
      level: json['level'] as String?,
      colors: (json['colors'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      images: Map<String, String>.from(json['images'] as Map),
      cardType: json['cardType'] as String,
      form: json['form'] as String?,
      attribute: json['attribute'] as String?,
      type: json['type'] as String,
      dp: json['dp'] as String,
      playCost: json['playCost'] as String,
      digivolveCost1: json['digivolveCost1'] as String,
      digivolveCost2: json['digivolveCost2'] as String,
      effect: json['effect'] as String,
      inheritedEffect: json['inheritedEffect'] as String,
      securityEffect: json['securityEffect'] as String,
      notes: json['notes'] as String,
      set: SetInfo.fromJson(json['set'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DigimonCardImplToJson(_$DigimonCardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'rarity': instance.rarity,
      'name': instance.name,
      'level': instance.level,
      'colors': instance.colors,
      'images': instance.images,
      'cardType': instance.cardType,
      'form': instance.form,
      'attribute': instance.attribute,
      'type': instance.type,
      'dp': instance.dp,
      'playCost': instance.playCost,
      'digivolveCost1': instance.digivolveCost1,
      'digivolveCost2': instance.digivolveCost2,
      'effect': instance.effect,
      'inheritedEffect': instance.inheritedEffect,
      'securityEffect': instance.securityEffect,
      'notes': instance.notes,
      'set': instance.set,
    };

_$UnionArenaCardImpl _$$UnionArenaCardImplFromJson(Map<String, dynamic> json) =>
    _$UnionArenaCardImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      url: json['url'] as String,
      name: json['name'] as String,
      rarity: json['rarity'] as String,
      ap: json['ap'] as String,
      type: json['type'] as String,
      bp: json['bp'] as String,
      affinity: json['affinity'] as String,
      effect: json['effect'] as String,
      trigger: json['trigger'] as String,
      images: Map<String, String>.from(json['images'] as Map),
      set: SetInfo.fromJson(json['set'] as Map<String, dynamic>),
      needEnergy: json['needEnergy'] == null
          ? null
          : NeedEnergy.fromJson(json['needEnergy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UnionArenaCardImplToJson(
  _$UnionArenaCardImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'url': instance.url,
  'name': instance.name,
  'rarity': instance.rarity,
  'ap': instance.ap,
  'type': instance.type,
  'bp': instance.bp,
  'affinity': instance.affinity,
  'effect': instance.effect,
  'trigger': instance.trigger,
  'images': instance.images,
  'set': instance.set,
  'needEnergy': instance.needEnergy,
};

_$NeedEnergyImpl _$$NeedEnergyImplFromJson(Map<String, dynamic> json) =>
    _$NeedEnergyImpl(
      value: json['value'] as String,
      logo: json['logo'] as String,
    );

Map<String, dynamic> _$$NeedEnergyImplToJson(_$NeedEnergyImpl instance) =>
    <String, dynamic>{'value': instance.value, 'logo': instance.logo};

_$GundamCardImpl _$$GundamCardImplFromJson(Map<String, dynamic> json) =>
    _$GundamCardImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      rarity: json['rarity'] as String,
      name: json['name'] as String,
      images: Map<String, String>.from(json['images'] as Map),
      level: json['level'] as String,
      cost: json['cost'] as String,
      color: json['color'] as String,
      cardType: json['cardType'] as String,
      effect: json['effect'] as String,
      zone: json['zone'] as String,
      trait: json['trait'] as String,
      link: json['link'] as String,
      ap: json['ap'] as String,
      hp: json['hp'] as String,
      sourceTitle: json['sourceTitle'] as String,
      getIt: json['getIt'] as String,
      set: SetInfo.fromJson(json['set'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GundamCardImplToJson(_$GundamCardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'rarity': instance.rarity,
      'name': instance.name,
      'images': instance.images,
      'level': instance.level,
      'cost': instance.cost,
      'color': instance.color,
      'cardType': instance.cardType,
      'effect': instance.effect,
      'zone': instance.zone,
      'trait': instance.trait,
      'link': instance.link,
      'ap': instance.ap,
      'hp': instance.hp,
      'sourceTitle': instance.sourceTitle,
      'getIt': instance.getIt,
      'set': instance.set,
    };

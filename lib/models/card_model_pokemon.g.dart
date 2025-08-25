// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_model_pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CardImpl _$$CardImplFromJson(Map<String, dynamic> json) => _$CardImpl(
  id: json['id'] as String?,
  name: json['name'] as String?,
  supertype: json['supertype'] as String?,
  subtypes: (json['subtypes'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  hp: json['hp'] as String?,
  types: (json['types'] as List<dynamic>?)?.map((e) => e as String).toList(),
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
  retreatCost: (json['retreatCost'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  convertedRetreatCost: (json['convertedRetreatCost'] as num?)?.toInt(),
  set: json['set'] == null
      ? null
      : Set.fromJson(json['set'] as Map<String, dynamic>),
  number: json['number'] as String?,
  artist: json['artist'] as String?,
  rarity: json['rarity'] as String?,
  flavorText: json['flavorText'] as String?,
  nationalPokedexNumbers: (json['nationalPokedexNumbers'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  legalities: json['legalities'] == null
      ? null
      : Legalities.fromJson(json['legalities'] as Map<String, dynamic>),
  images: json['images'] == null
      ? null
      : Images.fromJson(json['images'] as Map<String, dynamic>),
  tcgplayer: json['tcgplayer'] == null
      ? null
      : Tcgplayer.fromJson(json['tcgplayer'] as Map<String, dynamic>),
  cardmarket: json['cardmarket'] == null
      ? null
      : Cardmarket.fromJson(json['cardmarket'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$CardImplToJson(_$CardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'supertype': instance.supertype,
      'subtypes': instance.subtypes,
      'hp': instance.hp,
      'types': instance.types,
      'evolvesFrom': instance.evolvesFrom,
      'abilities': instance.abilities,
      'attacks': instance.attacks,
      'weaknesses': instance.weaknesses,
      'retreatCost': instance.retreatCost,
      'convertedRetreatCost': instance.convertedRetreatCost,
      'set': instance.set,
      'number': instance.number,
      'artist': instance.artist,
      'rarity': instance.rarity,
      'flavorText': instance.flavorText,
      'nationalPokedexNumbers': instance.nationalPokedexNumbers,
      'legalities': instance.legalities,
      'images': instance.images,
      'tcgplayer': instance.tcgplayer,
      'cardmarket': instance.cardmarket,
    };

_$SetImpl _$$SetImplFromJson(Map<String, dynamic> json) => _$SetImpl(
  id: json['id'] as String?,
  name: json['name'] as String?,
  series: json['series'] as String?,
  printedTotal: (json['printedTotal'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
  legalities: json['legalities'] == null
      ? null
      : Legalities.fromJson(json['legalities'] as Map<String, dynamic>),
  ptcgoCode: json['ptcgoCode'] as String?,
  releaseDate: json['releaseDate'] as String?,
  updatedAt: json['updatedAt'] as String?,
  images: json['images'] == null
      ? null
      : Images.fromJson(json['images'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$SetImplToJson(_$SetImpl instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'series': instance.series,
  'printedTotal': instance.printedTotal,
  'total': instance.total,
  'legalities': instance.legalities,
  'ptcgoCode': instance.ptcgoCode,
  'releaseDate': instance.releaseDate,
  'updatedAt': instance.updatedAt,
  'images': instance.images,
};

_$AbilityImpl _$$AbilityImplFromJson(Map<String, dynamic> json) =>
    _$AbilityImpl(
      name: json['name'] as String?,
      text: json['text'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$$AbilityImplToJson(_$AbilityImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'text': instance.text,
      'type': instance.type,
    };

_$AttackImpl _$$AttackImplFromJson(Map<String, dynamic> json) => _$AttackImpl(
  name: json['name'] as String?,
  text: json['text'] as String?,
  cost: (json['cost'] as List<dynamic>?)?.map((e) => e as String).toList(),
  convertedEnergyCost: (json['convertedEnergyCost'] as num?)?.toInt(),
  damage: json['damage'] as String?,
);

Map<String, dynamic> _$$AttackImplToJson(_$AttackImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'text': instance.text,
      'cost': instance.cost,
      'convertedEnergyCost': instance.convertedEnergyCost,
      'damage': instance.damage,
    };

_$WeaknessImpl _$$WeaknessImplFromJson(Map<String, dynamic> json) =>
    _$WeaknessImpl(
      type: json['type'] as String?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$$WeaknessImplToJson(_$WeaknessImpl instance) =>
    <String, dynamic>{'type': instance.type, 'value': instance.value};

_$LegalitiesImpl _$$LegalitiesImplFromJson(Map<String, dynamic> json) =>
    _$LegalitiesImpl(
      unlimited: json['unlimited'] as String?,
      standard: json['standard'] as String?,
      expanded: json['expanded'] as String?,
    );

Map<String, dynamic> _$$LegalitiesImplToJson(_$LegalitiesImpl instance) =>
    <String, dynamic>{
      'unlimited': instance.unlimited,
      'standard': instance.standard,
      'expanded': instance.expanded,
    };

_$ImagesImpl _$$ImagesImplFromJson(Map<String, dynamic> json) => _$ImagesImpl(
  small: json['small'] as String?,
  large: json['large'] as String?,
);

Map<String, dynamic> _$$ImagesImplToJson(_$ImagesImpl instance) =>
    <String, dynamic>{'small': instance.small, 'large': instance.large};

_$TcgplayerImpl _$$TcgplayerImplFromJson(Map<String, dynamic> json) =>
    _$TcgplayerImpl(
      url: json['url'] as String?,
      updatedAt: json['updatedAt'] as String?,
      prices: json['prices'] == null
          ? null
          : TcgplayerPrices.fromJson(json['prices'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TcgplayerImplToJson(_$TcgplayerImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'updatedAt': instance.updatedAt,
      'prices': instance.prices,
    };

_$TcgplayerPricesImpl _$$TcgplayerPricesImplFromJson(
  Map<String, dynamic> json,
) => _$TcgplayerPricesImpl(
  low: (json['low'] as num?)?.toDouble(),
  mid: (json['mid'] as num?)?.toDouble(),
  high: (json['high'] as num?)?.toDouble(),
  market: (json['market'] as num?)?.toDouble(),
  directLow: (json['directLow'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$TcgplayerPricesImplToJson(
  _$TcgplayerPricesImpl instance,
) => <String, dynamic>{
  'low': instance.low,
  'mid': instance.mid,
  'high': instance.high,
  'market': instance.market,
  'directLow': instance.directLow,
};

_$CardmarketImpl _$$CardmarketImplFromJson(Map<String, dynamic> json) =>
    _$CardmarketImpl(
      url: json['url'] as String?,
      updatedAt: json['updatedAt'] as String?,
      prices: json['prices'] == null
          ? null
          : CardmarketPrices.fromJson(json['prices'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CardmarketImplToJson(_$CardmarketImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'updatedAt': instance.updatedAt,
      'prices': instance.prices,
    };

_$CardmarketPricesImpl _$$CardmarketPricesImplFromJson(
  Map<String, dynamic> json,
) => _$CardmarketPricesImpl(
  averageSellPrice: (json['averageSellPrice'] as num?)?.toDouble(),
  lowPrice: (json['lowPrice'] as num?)?.toDouble(),
  trendPrice: (json['trendPrice'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$CardmarketPricesImplToJson(
  _$CardmarketPricesImpl instance,
) => <String, dynamic>{
  'averageSellPrice': instance.averageSellPrice,
  'lowPrice': instance.lowPrice,
  'trendPrice': instance.trendPrice,
};

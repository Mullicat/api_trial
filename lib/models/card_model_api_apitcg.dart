class OnePieceCard {
  final String id;
  final String code;
  final String rarity;
  final String type;
  final String name;
  final Map<String, String> images;
  final int cost;
  final Attribute? attribute;
  final int? power;
  final String counter;
  final String color;
  final String family;
  final String ability;
  final String trigger;
  final SetInfo set;
  final List<String> notes;

  OnePieceCard({
    required this.id,
    required this.code,
    required this.rarity,
    required this.type,
    required this.name,
    required this.images,
    required this.cost,
    this.attribute,
    this.power,
    required this.counter,
    required this.color,
    required this.family,
    required this.ability,
    required this.trigger,
    required this.set,
    required this.notes,
  });

  factory OnePieceCard.fromJson(Map<String, dynamic> json) {
    return OnePieceCard(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      rarity: json['rarity'] as String? ?? '',
      type: json['type'] as String? ?? '',
      name: json['name'] as String? ?? '',
      images: Map<String, String>.from(json['images'] as Map? ?? {}),
      cost: json['cost'] as int? ?? 0,
      attribute: json['attribute'] != null
          ? Attribute.fromJson(json['attribute'] as Map<String, dynamic>)
          : null,
      power: json['power'] as int?,
      counter: json['counter'] as String? ?? '',
      color: json['color'] as String? ?? '',
      family: json['family'] as String? ?? '',
      ability: json['ability'] as String? ?? '',
      trigger: json['trigger'] as String? ?? '',
      set: SetInfo.fromJson(
        json['set'] as Map<String, dynamic>? ?? {'name': ''},
      ),
      notes: List<String>.from(json['notes'] as List? ?? []),
    );
  }
}

class Attribute {
  final String name;
  final String image;

  Attribute({required this.name, required this.image});

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      name: json['name'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}

class SetInfo {
  final String name;
  final String? id;

  SetInfo({required this.name, this.id});

  factory SetInfo.fromJson(Map<String, dynamic> json) {
    return SetInfo(
      name: json['name'] as String? ?? '',
      id: json['id'] as String?,
    );
  }
}

class PokemonCard {
  final String id;
  final String name;
  final String supertype;
  final List<String> subtypes;
  final String? level;
  final String hp;
  final List<String> types;
  final String? evolvesFrom;
  final List<Ability>? abilities;
  final List<Attack>? attacks;
  final List<Weakness>? weaknesses;
  final List<Resistance>? resistances;
  final List<String>? retreatCost;
  final int? convertedRetreatCost;
  final String number;
  final String artist;
  final String rarity;
  final String? flavorText;
  final List<int>? nationalPokedexNumbers;
  final Map<String, String>? legalities;
  final Map<String, String> images;

  PokemonCard({
    required this.id,
    required this.name,
    required this.supertype,
    required this.subtypes,
    this.level,
    required this.hp,
    required this.types,
    this.evolvesFrom,
    this.abilities,
    this.attacks,
    this.weaknesses,
    this.resistances,
    this.retreatCost,
    this.convertedRetreatCost,
    required this.number,
    required this.artist,
    required this.rarity,
    this.flavorText,
    this.nationalPokedexNumbers,
    this.legalities,
    required this.images,
  });

  factory PokemonCard.fromJson(Map<String, dynamic> json) {
    return PokemonCard(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      supertype: json['supertype'] as String? ?? '',
      subtypes: List<String>.from(json['subtypes'] as List? ?? []),
      level: json['level'] as String?,
      hp: json['hp'] as String? ?? '',
      types: List<String>.from(json['types'] as List? ?? []),
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
      retreatCost: (json['retreatCost'] as List<dynamic>?)?.cast<String>(),
      convertedRetreatCost: json['convertedRetreatCost'] as int?,
      number: json['number'] as String? ?? '',
      artist: json['artist'] as String? ?? '',
      rarity: json['rarity'] as String? ?? '',
      flavorText: json['flavorText'] as String?,
      nationalPokedexNumbers: (json['nationalPokedexNumbers'] as List<dynamic>?)
          ?.cast<int>(),
      legalities: (json['legalities'] as Map<dynamic, dynamic>?)
          ?.cast<String, String>(),
      images: Map<String, String>.from(json['images'] as Map? ?? {}),
    );
  }
}

class Ability {
  final String name;
  final String text;
  final String type;

  Ability({required this.name, required this.text, required this.type});

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      name: json['name'] as String? ?? '',
      text: json['text'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }
}

class Attack {
  final String name;
  final List<String> cost;
  final int convertedEnergyCost;
  final String damage;
  final String text;

  Attack({
    required this.name,
    required this.cost,
    required this.convertedEnergyCost,
    required this.damage,
    required this.text,
  });

  factory Attack.fromJson(Map<String, dynamic> json) {
    return Attack(
      name: json['name'] as String? ?? '',
      cost: List<String>.from(json['cost'] as List? ?? []),
      convertedEnergyCost: json['convertedEnergyCost'] as int? ?? 0,
      damage: json['damage'] as String? ?? '',
      text: json['text'] as String? ?? '',
    );
  }
}

class Weakness {
  final String type;
  final String value;

  Weakness({required this.type, required this.value});

  factory Weakness.fromJson(Map<String, dynamic> json) {
    return Weakness(
      type: json['type'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }
}

class Resistance {
  final String type;
  final String value;

  Resistance({required this.type, required this.value});

  factory Resistance.fromJson(Map<String, dynamic> json) {
    return Resistance(
      type: json['type'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }
}

class DragonBallCard {
  final String id;
  final String code;
  final String rarity;
  final String name;
  final String color;
  final Map<String, String> images;
  final String cardType;
  final String cost;
  final String specifiedCost;
  final String power;
  final String comboPower;
  final String features;
  final String effect;
  final String getIt;
  final SetInfo set;

  DragonBallCard({
    required this.id,
    required this.code,
    required this.rarity,
    required this.name,
    required this.color,
    required this.images,
    required this.cardType,
    required this.cost,
    required this.specifiedCost,
    required this.power,
    required this.comboPower,
    required this.features,
    required this.effect,
    required this.getIt,
    required this.set,
  });

  factory DragonBallCard.fromJson(Map<String, dynamic> json) {
    return DragonBallCard(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      rarity: json['rarity'] as String? ?? '',
      name: json['name'] as String? ?? '',
      color: json['color'] as String? ?? '',
      images: Map<String, String>.from(json['images'] as Map? ?? {}),
      cardType: json['cardType'] as String? ?? '',
      cost: json['cost'] as String? ?? '',
      specifiedCost: json['specifiedCost'] as String? ?? '',
      power: json['power'] as String? ?? '',
      comboPower: json['comboPower'] as String? ?? '',
      features: json['features'] as String? ?? '',
      effect: json['effect'] as String? ?? '',
      getIt: json['getIt'] as String? ?? '',
      set: SetInfo.fromJson(
        json['set'] as Map<String, dynamic>? ?? {'name': ''},
      ),
    );
  }
}

class DigimonCard {
  final String id;
  final String code;
  final String? rarity;
  final String name;
  final String? level;
  final List<String> colors;
  final Map<String, String> images;
  final String cardType;
  final String? form;
  final String? attribute;
  final String type;
  final String dp;
  final String playCost;
  final String digivolveCost1;
  final String digivolveCost2;
  final String effect;
  final String inheritedEffect;
  final String securityEffect;
  final String notes;
  final SetInfo set;

  DigimonCard({
    required this.id,
    required this.code,
    this.rarity,
    required this.name,
    this.level,
    required this.colors,
    required this.images,
    required this.cardType,
    this.form,
    this.attribute,
    required this.type,
    required this.dp,
    required this.playCost,
    required this.digivolveCost1,
    required this.digivolveCost2,
    required this.effect,
    required this.inheritedEffect,
    required this.securityEffect,
    required this.notes,
    required this.set,
  });

  factory DigimonCard.fromJson(Map<String, dynamic> json) {
    return DigimonCard(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      rarity: json['rarity'] as String?,
      name: json['name'] as String? ?? '',
      level: json['level'] as String?,
      colors: List<String>.from(json['colors'] as List? ?? []),
      images: Map<String, String>.from(json['images'] as Map? ?? {}),
      cardType: json['cardType'] as String? ?? '',
      form: json['form'] as String?,
      attribute: json['attribute'] as String?,
      type: json['type'] as String? ?? '',
      dp: json['dp'] as String? ?? '',
      playCost: json['playCost'] as String? ?? '',
      digivolveCost1: json['digivolveCost1'] as String? ?? '',
      digivolveCost2: json['digivolveCost2'] as String? ?? '',
      effect: json['effect'] as String? ?? '',
      inheritedEffect: json['inheritedEffect'] as String? ?? '',
      securityEffect: json['securityEffect'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      set: SetInfo.fromJson(
        json['set'] as Map<String, dynamic>? ?? {'name': ''},
      ),
    );
  }
}

class UnionArenaCard {
  final String id;
  final String code;
  final String url;
  final String name;
  final String rarity;
  final String ap;
  final String type;
  final String bp;
  final String affinity;
  final String effect;
  final String trigger;
  final Map<String, String> images;
  final SetInfo set;
  final NeedEnergy? needEnergy;

  UnionArenaCard({
    required this.id,
    required this.code,
    required this.url,
    required this.name,
    required this.rarity,
    required this.ap,
    required this.type,
    required this.bp,
    required this.affinity,
    required this.effect,
    required this.trigger,
    required this.images,
    required this.set,
    this.needEnergy,
  });

  factory UnionArenaCard.fromJson(Map<String, dynamic> json) {
    return UnionArenaCard(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      url: json['url'] as String? ?? '',
      name: json['name'] as String? ?? '',
      rarity: json['rarity'] as String? ?? '',
      ap: json['ap'] as String? ?? '',
      type: json['type'] as String? ?? '',
      bp: json['bp'] as String? ?? '',
      affinity: json['affinity'] as String? ?? '',
      effect: json['effect'] as String? ?? '',
      trigger: json['trigger'] as String? ?? '',
      images: Map<String, String>.from(json['images'] as Map? ?? {}),
      set: SetInfo.fromJson(
        json['set'] as Map<String, dynamic>? ?? {'name': ''},
      ),
      needEnergy: json['needEnergy'] != null
          ? NeedEnergy.fromJson(json['needEnergy'] as Map<String, dynamic>)
          : null,
    );
  }
}

class NeedEnergy {
  final String value;
  final String logo;

  NeedEnergy({required this.value, required this.logo});

  factory NeedEnergy.fromJson(Map<String, dynamic> json) {
    return NeedEnergy(
      value: json['value'] as String? ?? '',
      logo: json['logo'] as String? ?? '',
    );
  }
}

class GundamCard {
  final String id;
  final String code;
  final String rarity;
  final String name;
  final Map<String, String> images;
  final String level;
  final String cost;
  final String color;
  final String cardType;
  final String effect;
  final String zone;
  final String trait;
  final String link;
  final String ap;
  final String hp;
  final String sourceTitle;
  final String getIt;
  final SetInfo set;

  GundamCard({
    required this.id,
    required this.code,
    required this.rarity,
    required this.name,
    required this.images,
    required this.level,
    required this.cost,
    required this.color,
    required this.cardType,
    required this.effect,
    required this.zone,
    required this.trait,
    required this.link,
    required this.ap,
    required this.hp,
    required this.sourceTitle,
    required this.getIt,
    required this.set,
  });

  factory GundamCard.fromJson(Map<String, dynamic> json) {
    return GundamCard(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      rarity: json['rarity'] as String? ?? '',
      name: json['name'] as String? ?? '',
      images: Map<String, String>.from(json['images'] as Map? ?? {}),
      level: json['level'] as String? ?? '',
      cost: json['cost'] as String? ?? '',
      color: json['color'] as String? ?? '',
      cardType: json['cardType'] as String? ?? '',
      effect: json['effect'] as String? ?? '',
      zone: json['zone'] as String? ?? '',
      trait: json['trait'] as String? ?? '',
      link: json['link'] as String? ?? '',
      ap: json['ap'] as String? ?? '',
      hp: json['hp'] as String? ?? '',
      sourceTitle: json['sourceTitle'] as String? ?? '',
      getIt: json['getIt'] as String? ?? '',
      set: SetInfo.fromJson(
        json['set'] as Map<String, dynamic>? ?? {'name': ''},
      ),
    );
  }
}

class MagicCard {
  final String id;
  final String name;
  final String? manaCost;
  final int cmc;
  final List<String> colors;
  final String type;
  final List<String>? supertypes;
  final List<String> types;
  final List<String>? subtypes;
  final String rarity;
  final String set;
  final String text;
  final String? artist;
  final String? number;
  final String? power;
  final String? toughness;
  final String? layout;
  final int? multiverseId;
  final String? imageUrl;
  final List<Ruling>? rulings;
  final List<ForeignName>? foreignNames;
  final List<String>? printings;

  MagicCard({
    required this.id,
    required this.name,
    this.manaCost,
    required this.cmc,
    required this.colors,
    required this.type,
    this.supertypes,
    required this.types,
    this.subtypes,
    required this.rarity,
    required this.set,
    required this.text,
    this.artist,
    this.number,
    this.power,
    this.toughness,
    this.layout,
    this.multiverseId,
    this.imageUrl,
    this.rulings,
    this.foreignNames,
    this.printings,
  });

  factory MagicCard.fromJson(Map<String, dynamic> json) {
    return MagicCard(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      manaCost: json['manaCost'] as String?,
      cmc: json['cmc'] as int? ?? 0,
      colors: List<String>.from(json['colors'] as List? ?? []),
      type: json['type'] as String? ?? '',
      supertypes: (json['supertypes'] as List<dynamic>?)?.cast<String>(),
      types: List<String>.from(json['types'] as List? ?? []),
      subtypes: (json['subtypes'] as List<dynamic>?)?.cast<String>(),
      rarity: json['rarity'] as String? ?? '',
      set: json['set'] as String? ?? '',
      text: json['text'] as String? ?? '',
      artist: json['artist'] as String?,
      number: json['number'] as String?,
      power: json['power'] as String?,
      toughness: json['toughness'] as String?,
      layout: json['layout'] as String?,
      multiverseId: json['multiverseId'] as int?,
      imageUrl: json['imageUrl'] as String?,
      rulings: (json['rulings'] as List<dynamic>?)
          ?.map((e) => Ruling.fromJson(e as Map<String, dynamic>))
          .toList(),
      foreignNames: (json['foreignNames'] as List<dynamic>?)
          ?.map((e) => ForeignName.fromJson(e as Map<String, dynamic>))
          .toList(),
      printings: (json['printings'] as List<dynamic>?)?.cast<String>(),
    );
  }
}

class Ruling {
  final String date;
  final String text;

  Ruling({required this.date, required this.text});

  factory Ruling.fromJson(Map<String, dynamic> json) {
    return Ruling(
      date: json['date'] as String? ?? '',
      text: json['text'] as String? ?? '',
    );
  }
}

class ForeignName {
  final String name;
  final String language;
  final int? multiverseId;

  ForeignName({required this.name, required this.language, this.multiverseId});

  factory ForeignName.fromJson(Map<String, dynamic> json) {
    return ForeignName(
      name: json['name'] as String? ?? '',
      language: json['language'] as String? ?? '',
      multiverseId: json['multiverseId'] as int?,
    );
  }
}

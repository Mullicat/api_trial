// lib/models/card_model_magic.dart

class Card {
  final String? name;
  final List<String>? names;
  final String? manaCost;
  final num? cmc; // Remains num? to handle int or double after parsing
  final List<String>? colors;
  final List<String>? colorIdentity;
  final String? type;
  final List<String>? supertypes;
  final List<String>? types;
  final List<String>? subtypes;
  final String? rarity;
  final String? set;
  final String? text;
  final String? artist;
  final String? number;
  final String? power;
  final String? toughness;
  final String? layout;
  final num? multiverseid; // Remains num? to handle int or double after parsing
  final String? imageUrl;
  final List<Ruling>? rulings;
  final List<ForeignName>? foreignNames;
  final List<String>? printings;
  final String? originalText;
  final String? originalType;
  final String? id;

  Card({
    this.name,
    this.names,
    this.manaCost,
    this.cmc,
    this.colors,
    this.colorIdentity,
    this.type,
    this.supertypes,
    this.types,
    this.subtypes,
    this.rarity,
    this.set,
    this.text,
    this.artist,
    this.number,
    this.power,
    this.toughness,
    this.layout,
    this.multiverseid,
    this.imageUrl,
    this.rulings,
    this.foreignNames,
    this.printings,
    this.originalText,
    this.originalType,
    this.id,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      name: json['name'] as String?,
      names: (json['names'] as List<dynamic>?)?.cast<String>(),
      manaCost: json['manaCost'] as String?,
      cmc: _parseNum(json['cmc']), // Parse string or num to num?
      colors: (json['colors'] as List<dynamic>?)?.cast<String>(),
      colorIdentity: (json['colorIdentity'] as List<dynamic>?)?.cast<String>(),
      type: json['type'] as String?,
      supertypes: (json['supertypes'] as List<dynamic>?)?.cast<String>(),
      types: (json['types'] as List<dynamic>?)?.cast<String>(),
      subtypes: (json['subtypes'] as List<dynamic>?)?.cast<String>(),
      rarity: json['rarity'] as String?,
      set: json['set'] as String?,
      text: json['text'] as String?,
      artist: json['artist'] as String?,
      number: json['number'] as String?,
      power: json['power'] as String?,
      toughness: json['toughness'] as String?,
      layout: json['layout'] as String?,
      multiverseid: _parseNum(
        json['multiverseid'],
      ), // Parse string or num to num?
      imageUrl: json['imageUrl'] as String?,
      rulings: (json['rulings'] as List<dynamic>?)
          ?.map((r) => Ruling.fromJson(r as Map<String, dynamic>))
          .toList(),
      foreignNames: (json['foreignNames'] as List<dynamic>?)
          ?.map((f) => ForeignName.fromJson(f as Map<String, dynamic>))
          .toList(),
      printings: (json['printings'] as List<dynamic>?)?.cast<String>(),
      originalText: json['originalText'] as String?,
      originalType: json['originalType'] as String?,
      id: json['id'] as String?,
    );
  }

  // Removed _parseNum from here
}

/// Top-level function to parse num from dynamic input
num? _parseNum(dynamic value) {
  if (value == null) return null;
  if (value is num) return value;
  if (value is String) {
    final parsed = double.tryParse(value);
    return parsed != null ? parsed : null; // Return null if parsing fails
  }
  return null; // Fallback for unexpected types
}

class Ruling {
  final String? date;
  final String? text;

  Ruling({this.date, this.text});

  factory Ruling.fromJson(Map<String, dynamic> json) {
    return Ruling(date: json['date'] as String?, text: json['text'] as String?);
  }
}

class ForeignName {
  final String? name;
  final String? language;
  final num? multiverseid; // Remains num? to handle int or double after parsing

  ForeignName({this.name, this.language, this.multiverseid});

  factory ForeignName.fromJson(Map<String, dynamic> json) {
    return ForeignName(
      name: json['name'] as String?,
      language: json['language'] as String?,
      multiverseid: _parseNum(
        json['multiverseid'],
      ), // Parse string or num to num?
    );
  }
}

class CardSet {
  final String? setName;
  final String? setCode;
  final String? setRarity;
  final String? setRarityCode;
  final double? setPrice;

  CardSet({
    this.setName,
    this.setCode,
    this.setRarity,
    this.setRarityCode,
    this.setPrice,
  });

  factory CardSet.fromJson(Map<String, dynamic> json) {
    double? toDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return CardSet(
      setName: json['set_name'] as String?,
      setCode: json['set_code'] as String?,
      setRarity: json['set_rarity'] as String?,
      setRarityCode: json['set_rarity_code'] as String?,
      setPrice: toDouble(json['set_price']),
    );
  }

  Map<String, dynamic> toJson() => {
    'set_name': setName,
    'set_code': setCode,
    'set_rarity': setRarity,
    'set_rarity_code': setRarityCode,
    'set_price': setPrice,
  };
}

class CardImage {
  final int? id;
  final String? imageUrl;
  final String? imageUrlSmall;
  final String? imageUrlCropped;

  CardImage({this.id, this.imageUrl, this.imageUrlSmall, this.imageUrlCropped});

  factory CardImage.fromJson(Map<String, dynamic> json) {
    return CardImage(
      id: json['id'] as int?,
      imageUrl: json['image_url'] as String?,
      imageUrlSmall: json['image_url_small'] as String?,
      imageUrlCropped: json['image_url_cropped'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'image_url': imageUrl,
    'image_url_small': imageUrlSmall,
    'image_url_cropped': imageUrlCropped,
  };
}

class CardPrice {
  final double? cardmarketPrice;
  final double? tcgplayerPrice;
  final double? ebayPrice;
  final double? amazonPrice;
  final double? coolstuffincPrice;

  CardPrice({
    this.cardmarketPrice,
    this.tcgplayerPrice,
    this.ebayPrice,
    this.amazonPrice,
    this.coolstuffincPrice,
  });

  factory CardPrice.fromJson(Map<String, dynamic> json) {
    double? toDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return CardPrice(
      cardmarketPrice: toDouble(json['cardmarket_price']),
      tcgplayerPrice: toDouble(json['tcgplayer_price']),
      ebayPrice: toDouble(json['ebay_price']),
      amazonPrice: toDouble(json['amazon_price']),
      coolstuffincPrice: toDouble(json['coolstuffinc_price']),
    );
  }

  Map<String, dynamic> toJson() => {
    'cardmarket_price': cardmarketPrice,
    'tcgplayer_price': tcgplayerPrice,
    'ebay_price': ebayPrice,
    'amazon_price': amazonPrice,
    'coolstuffinc_price': coolstuffincPrice,
  };
}

class BanlistInfo {
  final String? banTcg;
  final String? banOcg;
  final String? banGoat;

  BanlistInfo({this.banTcg, this.banOcg, this.banGoat});

  factory BanlistInfo.fromJson(Map<String, dynamic> json) {
    return BanlistInfo(
      banTcg: json['ban_tcg'] as String?,
      banOcg: json['ban_ocg'] as String?,
      banGoat: json['ban_goat'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'ban_tcg': banTcg,
    'ban_ocg': banOcg,
    'ban_goat': banGoat,
  };
}

class Card {
  final int? id;
  final String? name;
  final String? type;
  final String? frameType;
  final String? desc;
  final int? atk;
  final int? def;
  final int? level;
  final String? race;
  final String? attribute;
  final String? archetype;
  final List<String>? typeline;
  final String? humanReadableCardType;
  final String? ygoprodeckUrl;
  final int? scale;
  final int? linkval;
  final List<String>? linkmarkers;
  final BanlistInfo? banlistInfo;
  final List<CardSet> cardSets;
  final List<CardImage> cardImages;
  final List<CardPrice> cardPrices;

  Card({
    this.id,
    this.name,
    this.type,
    this.frameType,
    this.desc,
    this.atk,
    this.def,
    this.level,
    this.race,
    this.attribute,
    this.archetype,
    this.typeline = const [],
    this.humanReadableCardType,
    this.ygoprodeckUrl,
    this.scale,
    this.linkval,
    this.linkmarkers = const [],
    this.banlistInfo,
    this.cardSets = const [],
    this.cardImages = const [],
    this.cardPrices = const [],
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      id: json['id'] as int?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      frameType: json['frameType'] as String?,
      desc: json['desc'] as String?,
      atk: json['atk'] as int?,
      def: json['def'] as int?,
      level: json['level'] as int?,
      race: json['race'] as String?,
      attribute: json['attribute'] as String?,
      archetype: json['archetype'] as String?,
      scale: json['scale'] as int?,
      linkval: json['linkval'] as int?,
      linkmarkers: (json['linkmarkers'] as List?)?.cast<String>() ?? const [],
      typeline: (json['typeline'] as List?)?.cast<String>() ?? const [],
      humanReadableCardType: json['humanReadableCardType'] as String?,
      ygoprodeckUrl: json['ygoprodeck_url'] as String?,
      banlistInfo: json['banlist_info'] == null
          ? null
          : BanlistInfo.fromJson(json['banlist_info'] as Map<String, dynamic>),
      cardSets:
          (json['card_sets'] as List<dynamic>?)
              ?.map((e) => CardSet.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      cardImages:
          (json['card_images'] as List<dynamic>?)
              ?.map((e) => CardImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      cardPrices:
          (json['card_prices'] as List<dynamic>?)
              ?.map((e) => CardPrice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'frameType': frameType,
    'desc': desc,
    'atk': atk,
    'def': def,
    'level': level,
    'race': race,
    'attribute': attribute,
    'archetype': archetype,
    'scale': scale,
    'linkval': linkval,
    'linkmarkers': linkmarkers,
    'typeline': typeline,
    'humanReadableCardType': humanReadableCardType,
    'ygoprodeck_url': ygoprodeckUrl,
    'banlist_info': banlistInfo?.toJson(),
    'card_sets': cardSets.map((e) => e.toJson()).toList(),
    'card_images': cardImages.map((e) => e.toJson()).toList(),
    'card_prices': cardPrices.map((e) => e.toJson()).toList(),
  };
}

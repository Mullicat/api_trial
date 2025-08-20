//Functional
class CardmarketPrices {
  final double? averageSellPrice;
  final double? lowPrice;
  final double? trendPrice;
  // Add other fields like avg1, avg7, etc. as double?

  CardmarketPrices({
    this.averageSellPrice,
    this.lowPrice,
    this.trendPrice,
    // Initialize other fields
  });
}

class Cardmarket {
  final String? url;
  final String? updatedAt;
  final CardmarketPrices? prices;

  Cardmarket({this.url, this.updatedAt, this.prices});
}

class TcgplayerPrices {
  final double? low;
  final double? mid;
  final double? high;
  final double? market;
  final double? directLow;
  // Add reverseHolofoil fields as needed

  TcgplayerPrices({
    this.low,
    this.mid,
    this.high,
    this.market,
    this.directLow,
    // Initialize reverseHolofoil fields
  });
}

class Tcgplayer {
  final String? url;
  final String? updatedAt;
  final TcgplayerPrices? prices;

  Tcgplayer({this.url, this.updatedAt, this.prices});
}

class Images {
  final String? small;
  final String? large;

  Images({this.small, this.large});
}

class Legalities {
  final String? unlimited;
  final String? standard;
  final String? expanded;

  Legalities({this.unlimited, this.standard, this.expanded});
}

class Weakness {
  final String? type;
  final String? value;

  Weakness({this.type, this.value});
}

class Attack {
  final String? name;
  final String? text;
  final List<String>? cost;
  final int? convertedEnergyCost;
  final String? damage;

  Attack({
    this.name,
    this.text,
    this.cost,
    this.convertedEnergyCost,
    this.damage,
  });
}

class Ability {
  final String? name;
  final String? text;
  final String? type;

  Ability({this.name, this.text, this.type});
}

class Set {
  final String? id;
  final String? name;
  final String? series;
  final int? printedTotal;
  final int? total;
  final Legalities? legalities;
  final String? ptcgoCode;
  final String? releaseDate;
  final String? updatedAt;
  final Images? images;

  Set({
    this.id,
    this.name,
    this.series,
    this.printedTotal,
    this.total,
    this.legalities,
    this.ptcgoCode,
    this.releaseDate,
    this.updatedAt,
    this.images,
  });
}

class Card {
  final String? id;
  final String? name;
  final String? supertype;
  final List<String>? subtypes;
  final String? hp;
  final List<String>? types;
  final String? evolvesFrom;
  final List<Ability>? abilities;
  final List<Attack>? attacks;
  final List<Weakness>? weaknesses;
  final List<String>? retreatCost;
  final int? convertedRetreatCost;
  final Set? set;
  final String? number;
  final String? artist;
  final String? rarity;
  final String? flavorText;
  final List<int>? nationalPokedexNumbers;
  final Legalities? legalities;
  final Images? images;
  final Tcgplayer? tcgplayer;
  final Cardmarket? cardmarket;

  Card({
    this.id,
    this.name,
    this.supertype,
    this.subtypes,
    this.hp,
    this.types,
    this.evolvesFrom,
    this.abilities,
    this.attacks,
    this.weaknesses,
    this.retreatCost,
    this.convertedRetreatCost,
    this.set,
    this.number,
    this.artist,
    this.rarity,
    this.flavorText,
    this.nationalPokedexNumbers,
    this.legalities,
    this.images,
    this.tcgplayer,
    this.cardmarket,
  });
}

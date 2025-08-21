import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/card_model_pokemon.dart';

//Functional
class PokemonTcgService {
  static Future<void> _loadEnv() async {
    await dotenv.load(fileName: "assets/.env");
  }

  Future<List<Card>> searchCards({
    int? page,
    int? pageSize,
    String? q,
    String? orderBy,
  }) async {
    await _loadEnv();

    final apiKey = dotenv.env['POKEMON_TCG_API_KEY'];
    if (apiKey == null) {
      throw Exception('API key not found in pokemonTCG .env');
    }

    final queryParams = {
      if (page != null) 'page': page.toString(),
      if (pageSize != null) 'pageSize': pageSize.toString(),
      if (q != null) 'q': q,
      if (orderBy != null) 'orderBy': orderBy,
    };

    final uri = Uri.parse(
      'https://api.pokemontcg.io/v2/cards',
    ).replace(queryParameters: queryParams); //Posible area de error

    try {
      final response = await http.get(uri, headers: {'X-Api-Key': apiKey});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cardsJson = data['data'] as List<dynamic>;

        return cardsJson.map((json) {
          return Card(
            id: json['id'] as String?,
            name: json['name'] as String?,
            supertype: json['supertype'] as String?,
            subtypes: (json['subtypes'] as List<dynamic>?)?.cast<String>(),
            hp: json['hp'] as String?,
            types: (json['types'] as List<dynamic>?)?.cast<String>(),
            evolvesFrom: json['evolvesFrom'] as String?,
            abilities: (json['abilities'] as List<dynamic>?)
                ?.map(
                  (a) => Ability(
                    name: a['name'] as String?,
                    text: a['text'] as String?,
                    type: a['type'] as String?,
                  ),
                )
                .toList(),
            attacks: (json['attacks'] as List<dynamic>?)
                ?.map(
                  (a) => Attack(
                    name: a['name'] as String?,
                    text: a['text'] as String?,
                    cost: (a['cost'] as List<dynamic>?)?.cast<String>(),
                    convertedEnergyCost: a['convertedEnergyCost'] as int?,
                    damage: a['damage'] as String?,
                  ),
                )
                .toList(),
            weaknesses: (json['weaknesses'] as List<dynamic>?)
                ?.map(
                  (w) => Weakness(
                    type: w['type'] as String?,
                    value: w['value'] as String?,
                  ),
                )
                .toList(),
            retreatCost: (json['retreatCost'] as List<dynamic>?)
                ?.cast<String>(),
            convertedRetreatCost: json['convertedRetreatCost'] as int?,
            set: json['set'] != null
                ? Set(
                    id: json['set']['id'] as String?,
                    name: json['set']['name'] as String?,
                    series: json['set']['series'] as String?,
                    printedTotal: json['set']['printedTotal'] as int?,
                    total: json['set']['total'] as int?,
                    legalities: json['set']['legalities'] != null
                        ? Legalities(
                            unlimited:
                                json['set']['legalities']['unlimited']
                                    as String?,
                            standard:
                                json['set']['legalities']['standard']
                                    as String?,
                            expanded:
                                json['set']['legalities']['expanded']
                                    as String?,
                          )
                        : null,
                    ptcgoCode: json['set']['ptcgoCode'] as String?,
                    releaseDate: json['set']['releaseDate'] as String?,
                    updatedAt: json['set']['updatedAt'] as String?,
                    images: json['set']['images'] != null
                        ? Images(
                            small: json['set']['images']['small'] as String?,
                            large: json['set']['images']['large'] as String?,
                          )
                        : null,
                  )
                : null,
            number: json['number'] as String?,
            artist: json['artist'] as String?,
            rarity: json['rarity'] as String?,
            flavorText: json['flavorText'] as String?,
            nationalPokedexNumbers:
                (json['nationalPokedexNumbers'] as List<dynamic>?)?.cast<int>(),
            legalities: json['legalities'] != null
                ? Legalities(
                    unlimited: json['legalities']['unlimited'] as String?,
                    standard: json['legalities']['standard'] as String?,
                    expanded: json['legalities']['expanded'] as String?,
                  )
                : null,
            images: json['images'] != null
                ? Images(
                    small: json['images']['small'] as String?,
                    large: json['images']['large'] as String?,
                  )
                : null,
            tcgplayer: json['tcgplayer'] != null
                ? Tcgplayer(
                    url: json['tcgplayer']['url'] as String?,
                    updatedAt: json['tcgplayer']['updatedAt'] as String?,
                    prices: json['tcgplayer']['prices'] != null
                        ? TcgplayerPrices(
                            low: json['tcgplayer']['prices']['low'] as double?,
                            mid: json['tcgplayer']['prices']['mid'] as double?,
                            high:
                                json['tcgplayer']['prices']['high'] as double?,
                            market:
                                json['tcgplayer']['prices']['market']
                                    as double?,
                            directLow:
                                json['tcgplayer']['prices']['directLow']
                                    as double?,
                          )
                        : null,
                  )
                : null,
            cardmarket: json['cardmarket'] != null
                ? Cardmarket(
                    url: json['cardmarket']['url'] as String?,
                    updatedAt: json['cardmarket']['updatedAt'] as String?,
                    prices: json['cardmarket']['prices'] != null
                        ? CardmarketPrices(
                            averageSellPrice:
                                json['cardmarket']['prices']['averageSellPrice']
                                    as double?,
                            lowPrice:
                                json['cardmarket']['prices']['lowPrice']
                                    as double?,
                            trendPrice:
                                json['cardmarket']['prices']['trendPrice']
                                    as double?,
                          )
                        : null,
                  )
                : null,
          );
        }).toList();
      } else {
        throw Exception(
          'Failed to load cards: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching cards: $e');
    }
  }

  Future<Card?> getCard(String cardId) async {
    await _loadEnv();

    final apiKey = dotenv.env['POKEMON_TCG_API_KEY'];
    if (apiKey == null) {
      throw Exception('API key not found in pokemonTCG card .env');
    }

    final uri = Uri.parse('https://api.pokemontcg.io/v2/cards/$cardId');

    try {
      final response = await http.get(uri, headers: {'X-Api-Key': apiKey});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cardJson = data['data'] as Map<String, dynamic>?;

        if (cardJson == null) return null;

        return Card(
          id: cardJson['id'] as String?,
          name: cardJson['name'] as String?,
          supertype: cardJson['supertype'] as String?,
          subtypes: (cardJson['subtypes'] as List<dynamic>?)?.cast<String>(),
          hp: cardJson['hp'] as String?,
          types: (cardJson['types'] as List<dynamic>?)?.cast<String>(),
          evolvesFrom: cardJson['evolvesFrom'] as String?,
          abilities: (cardJson['abilities'] as List<dynamic>?)
              ?.map(
                (a) => Ability(
                  name: a['name'] as String?,
                  text: a['text'] as String?,
                  type: a['type'] as String?,
                ),
              )
              .toList(),
          attacks: (cardJson['attacks'] as List<dynamic>?)
              ?.map(
                (a) => Attack(
                  name: a['name'] as String?,
                  text: a['text'] as String?,
                  cost: (a['cost'] as List<dynamic>?)?.cast<String>(),
                  convertedEnergyCost: a['convertedEnergyCost'] as int?,
                  damage: a['damage'] as String?,
                ),
              )
              .toList(),
          weaknesses: (cardJson['weaknesses'] as List<dynamic>?)
              ?.map(
                (w) => Weakness(
                  type: w['type'] as String?,
                  value: w['value'] as String?,
                ),
              )
              .toList(),
          retreatCost: (cardJson['retreatCost'] as List<dynamic>?)
              ?.cast<String>(),
          convertedRetreatCost: cardJson['convertedRetreatCost'] as int?,
          set: cardJson['set'] != null
              ? Set(
                  id: cardJson['set']['id'] as String?,
                  name: cardJson['set']['name'] as String?,
                  series: cardJson['set']['series'] as String?,
                  printedTotal: cardJson['set']['printedTotal'] as int?,
                  total: cardJson['set']['total'] as int?,
                  legalities: cardJson['set']['legalities'] != null
                      ? Legalities(
                          unlimited:
                              cardJson['set']['legalities']['unlimited']
                                  as String?,
                          standard:
                              cardJson['set']['legalities']['standard']
                                  as String?,
                          expanded:
                              cardJson['set']['legalities']['expanded']
                                  as String?,
                        )
                      : null,
                  ptcgoCode: cardJson['set']['ptcgoCode'] as String?,
                  releaseDate: cardJson['set']['releaseDate'] as String?,
                  updatedAt: cardJson['set']['updatedAt'] as String?,
                  images: cardJson['set']['images'] != null
                      ? Images(
                          small: cardJson['set']['images']['small'] as String?,
                          large: cardJson['set']['images']['large'] as String?,
                        )
                      : null,
                )
              : null,
          number: cardJson['number'] as String?,
          artist: cardJson['artist'] as String?,
          rarity: cardJson['rarity'] as String?,
          flavorText: cardJson['flavorText'] as String?,
          nationalPokedexNumbers:
              (cardJson['nationalPokedexNumbers'] as List<dynamic>?)
                  ?.cast<int>(),
          legalities: cardJson['legalities'] != null
              ? Legalities(
                  unlimited: cardJson['legalities']['unlimited'] as String?,
                  standard: cardJson['legalities']['standard'] as String?,
                  expanded: cardJson['legalities']['expanded'] as String?,
                )
              : null,
          images: cardJson['images'] != null
              ? Images(
                  small: cardJson['images']['small'] as String?,
                  large: cardJson['images']['large'] as String?,
                )
              : null,
          tcgplayer: cardJson['tcgplayer'] != null
              ? Tcgplayer(
                  url: cardJson['tcgplayer']['url'] as String?,
                  updatedAt: cardJson['tcgplayer']['updatedAt'] as String?,
                  prices: cardJson['tcgplayer']['prices'] != null
                      ? TcgplayerPrices(
                          low:
                              cardJson['tcgplayer']['prices']['low'] as double?,
                          mid:
                              cardJson['tcgplayer']['prices']['mid'] as double?,
                          high:
                              cardJson['tcgplayer']['prices']['high']
                                  as double?,
                          market:
                              cardJson['tcgplayer']['prices']['market']
                                  as double?,
                          directLow:
                              cardJson['tcgplayer']['prices']['directLow']
                                  as double?,
                        )
                      : null,
                )
              : null,
          cardmarket: cardJson['cardmarket'] != null
              ? Cardmarket(
                  url: cardJson['cardmarket']['url'] as String?,
                  updatedAt: cardJson['cardmarket']['updatedAt'] as String?,
                  prices: cardJson['cardmarket']['prices'] != null
                      ? CardmarketPrices(
                          averageSellPrice:
                              cardJson['cardmarket']['prices']['averageSellPrice']
                                  as double?,
                          lowPrice:
                              cardJson['cardmarket']['prices']['lowPrice']
                                  as double?,
                          trendPrice:
                              cardJson['cardmarket']['prices']['trendPrice']
                                  as double?,
                        )
                      : null,
                )
              : null,
        );
      } else {
        throw Exception(
          'Failed to load card: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching card: $e');
    }
  }
}

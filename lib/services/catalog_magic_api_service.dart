// lib/services/catalog_magic_api_service.dart
import 'dart:developer' as developer;
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/card_model_magic.dart';

class MagicTcgService {
  static const String baseCardsUrl =
      'https://api.magicthegathering.io/v1/cards';
  static const String baseSetsUrl = 'https://api.magicthegathering.io/v1/sets';

  Future<List<Card>> getCards({
    int? page,
    int? pageSize,
    String? name,
    String? layout,
    int? cmc,
    String? colors,
    String? colorIdentity,
    String? type,
    String? supertypes,
    String? types,
    String? subtypes,
    String? rarity,
    String? set,
    String? text,
    String? flavor,
    String? artist,
    String? number,
    String? power,
    String? toughness,
    String? loyalty,
    String? language,
    String? gameFormat,
    String? legality,
    String? orderBy,
    bool? random,
    String? contains,
    String? id,
    int? multiverseid,
  }) async {
    try {
      final queryParams = <String, String>{
        if (page != null) 'page': page.toString(),
        if (pageSize != null) 'pageSize': pageSize.toString(),
        if (name != null) 'name': name,
        if (layout != null) 'layout': layout,
        if (cmc != null) 'cmc': cmc.toString(),
        if (colors != null) 'colors': colors,
        if (colorIdentity != null) 'colorIdentity': colorIdentity,
        if (type != null) 'type': type,
        if (supertypes != null) 'supertypes': supertypes,
        if (types != null) 'types': types,
        if (subtypes != null) 'subtypes': subtypes,
        if (rarity != null) 'rarity': rarity,
        if (set != null) 'set': set,
        if (text != null) 'text': text,
        if (flavor != null) 'flavor': flavor,
        if (artist != null) 'artist': artist,
        if (number != null) 'number': number,
        if (power != null) 'power': power,
        if (toughness != null) 'toughness': toughness,
        if (loyalty != null) 'loyalty': loyalty,
        if (language != null) 'language': language,
        if (gameFormat != null) 'gameFormat': gameFormat,
        if (legality != null) 'legality': legality,
        if (orderBy != null) 'orderBy': orderBy,
        if (random == true) 'random': 'true',
        if (contains != null) 'contains': contains,
        if (id != null) 'id': id,
        if (multiverseid != null) 'multiverseid': multiverseid.toString(),
      };

      final uri = Uri.parse(
        baseCardsUrl,
      ).replace(queryParameters: queryParams); //Posible area de error
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final cardsJson = data['cards'] as List<dynamic>? ?? [];
        return cardsJson
            .map((json) => Card.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to load cards: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching cards: $e');
    }
  }

  Future<Card?> getCard(String idOrMultiverseid) async {
    try {
      final uri = Uri.parse('$baseCardsUrl/$idOrMultiverseid');
      final response = await http.get(uri);
      developer.log('API Response for getCard: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final cardJson = data['card'] as Map<String, dynamic>?;
        return cardJson != null ? Card.fromJson(cardJson) : null;
      } else {
        throw Exception(
          'Failed to load card: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      developer.log('Error fetching card: $e');
      throw Exception('Error fetching card: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getSets({
    int? page,
    int? pageSize,
    String? name,
    String? block,
  }) async {
    try {
      final queryParams = <String, String>{
        if (page != null) 'page': page.toString(),
        if (pageSize != null) 'pageSize': pageSize.toString(),
        if (name != null) 'name': name,
        if (block != null) 'block': block,
      };

      final uri = Uri.parse(baseSetsUrl).replace(queryParameters: queryParams);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final setsJson = data['sets'] as List<dynamic>? ?? [];
        return setsJson.cast<Map<String, dynamic>>();
      } else {
        throw Exception(
          'Failed to load sets: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching sets: $e');
    }
  }

  Future<Map<String, dynamic>?> getSet(String setCode) async {
    try {
      final uri = Uri.parse('$baseSetsUrl/$setCode');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['set'] as Map<String, dynamic>?;
      } else {
        throw Exception(
          'Failed to load set: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching set: $e');
    }
  }
}

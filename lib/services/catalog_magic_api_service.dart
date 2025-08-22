// lib/services/catalog_magic_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:api_trial/models/card_model_magic.dart';
import 'dart:developer' as developer;

class MagicTcgService {
  static const String baseCardsUrl =
      'https://api.magicthegathering.io/v1/cards';
  static const String baseSetsUrl = 'https://api.magicthegathering.io/v1/sets';

  Future<List<MagicCard>> getCards({
    int page = 1,
    int pageSize = 20,
    Map<String, String> filters = const {},
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'pageSize': pageSize.toString(),
        ...filters,
      };

      final uri = Uri.parse(baseCardsUrl).replace(queryParameters: queryParams);
      developer.log('API Request: $uri with params: $queryParams');
      if (filters.containsKey('orderBy')) {
        developer.log('orderBy filter applied: ${filters['orderBy']}');
      }
      if (filters.containsKey('contains')) {
        developer.log('contains filter applied: ${filters['contains']}');
      }
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        developer.log(
          'API Response: ${response.statusCode} - ${response.body.substring(0, response.body.length.clamp(0, 500))}...',
        );
        final cardsJson = data['cards'] as List<dynamic>? ?? [];
        developer.log('Cards returned: ${cardsJson.length}');
        return cardsJson.map((json) {
          try {
            final cardJson = json as Map<String, dynamic>;
            developer.log(
              'Parsing card: name=${cardJson['name'] ?? 'N/A'}, id=${cardJson['id'] ?? 'N/A'}, multiverseid=${cardJson['multiverseid'] ?? 'N/A'}',
            );
            return MagicCard.fromJson(cardJson);
          } catch (e) {
            developer.log('Error parsing card JSON: $json, Error: $e');
            rethrow;
          }
        }).toList();
      } else {
        developer.log(
          'Failed API Response: ${response.statusCode} - ${response.body}',
        );
        throw Exception(
          'Failed to load cards: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      developer.log('Error fetching cards: $e');
      throw Exception('Error fetching cards: $e');
    }
  }

  Future<MagicCard?> getCard(String multiverseid) async {
    if (multiverseid.isEmpty) {
      developer.log('Invalid multiverseid: empty');
      return null;
    }

    try {
      final uri = Uri.parse('$baseCardsUrl/$multiverseid');
      developer.log('API Request: $uri');
      final response = await http.get(uri);

      developer.log(
        'API Response: ${response.statusCode} - ${response.body.substring(0, response.body.length.clamp(0, 500))}...',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final cardJson = data['card'] as Map<String, dynamic>?;
        if (cardJson == null) {
          developer.log('No card data found for multiverseid: $multiverseid');
          return null;
        }
        try {
          developer.log(
            'Parsing card: name=${cardJson['name'] ?? 'N/A'}, id=${cardJson['id'] ?? 'N/A'}, multiverseid=${cardJson['multiverseid'] ?? 'N/A'}',
          );
          return MagicCard.fromJson(cardJson);
        } catch (e) {
          developer.log('Error parsing card JSON: $cardJson, Error: $e');
          rethrow;
        }
      } else {
        developer.log(
          'Failed API Response: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e) {
      developer.log('Error fetching card: $e');
      return null;
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
      developer.log('API Request: $uri with params: $queryParams');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        developer.log(
          'API Response: ${response.statusCode} - ${response.body.substring(0, response.body.length.clamp(0, 500))}...',
        );
        final setsJson = data['sets'] as List<dynamic>? ?? [];
        developer.log('Sets returned: ${setsJson.length}');
        return setsJson.cast<Map<String, dynamic>>();
      } else {
        developer.log(
          'Failed API Response: ${response.statusCode} - ${response.body}',
        );
        throw Exception(
          'Failed to load sets: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      developer.log('Error fetching sets: $e');
      throw Exception('Error fetching sets: $e');
    }
  }

  Future<Map<String, dynamic>?> getSet(String setCode) async {
    if (setCode.isEmpty) {
      developer.log('Invalid setCode: empty');
      return null;
    }

    try {
      final uri = Uri.parse('$baseSetsUrl/$setCode');
      developer.log('API Request: $uri');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        developer.log(
          'API Response: ${response.statusCode} - ${response.body.substring(0, response.body.length.clamp(0, 500))}...',
        );
        final setJson = data['set'] as Map<String, dynamic>?;
        if (setJson == null) {
          developer.log('No set data found for setCode: $setCode');
          return null;
        }
        return setJson;
      } else {
        developer.log(
          'Failed API Response: ${response.statusCode} - ${response.body}',
        );
        return null;
      }
    } catch (e) {
      developer.log('Error fetching set: $e');
      return null;
    }
  }
}

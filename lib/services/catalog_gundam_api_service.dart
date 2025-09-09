// lib/services/catalog_gundam_api_service.dart
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/card.dart';
import '../constants/enums/game_type.dart';

class GundamTcgService {
  static const String _baseUrl = 'https://apitcg.com/api';
  static const String _gamePath = 'gundam';

  Future<void> _loadEnv() async {
    try {
      await dotenv.load(fileName: 'assets/.env');
      developer.log('Successfully loaded assets/.env for Gundam');
      developer.log(
        'API_TCG_KEY present: ${dotenv.env['API_TCG_KEY'] != null}',
      );
    } catch (e) {
      developer.log('Failed to load assets/.env for Gundam: $e');
      throw Exception('Failed to load assets/.env: $e');
    }
  }

  Future<List<TCGCard>> getCards({
    Map<String, String> filters = const {},
    int page = 1,
    int pageSize = 25,
  }) async {
    try {
      await _loadEnv();
      final apiKey = dotenv.env['API_TCG_KEY'];
      if (apiKey == null) {
        developer.log('API_TCG_KEY not found in assets/.env for Gundam');
        throw Exception('API_TCG_KEY not found in assets/.env');
      }

      final queryParams = <String, String>{};
      if (filters.isNotEmpty) {
        queryParams.addAll(filters);
        developer.log('Applied filters for Gundam: $filters');
      } else {
        queryParams['name'] = '';
        developer.log('No filters applied for Gundam, fetching all cards');
      }
      queryParams['page'] = page.toString();
      queryParams['limit'] = pageSize.toString();

      final uri = Uri.parse(
        '$_baseUrl/$_gamePath/cards',
      ).replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: {'x-api-key': apiKey});
      developer.log('API Request for Gundam: $uri');
      developer.log(
        'API Response for getCards: ${response.statusCode} - ${response.body.substring(0, response.body.length.clamp(0, 500))}...',
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final cardsJson = (json['data'] as List<dynamic>?) ?? [];
        developer.log('Cards returned for Gundam: ${cardsJson.length}');
        return cardsJson.map((card) {
          final cardJson = card as Map<String, dynamic>;
          developer.log(
            'Parsing Gundam card: name=${cardJson['name']}, id=${cardJson['id']}',
          );
          return _parseCard(cardJson);
        }).toList();
      } else {
        String errorMessage =
            'Failed to load Gundam cards: ${response.statusCode} - ${response.body}';
        try {
          final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage =
              'Failed to load Gundam cards: ${response.statusCode} - ${errorJson['message'] ?? response.body}';
        } catch (_) {}
        throw Exception(errorMessage);
      }
    } catch (e) {
      developer.log('Error fetching Gundam cards: $e');
      throw Exception('Error fetching Gundam cards: $e');
    }
  }

  Future<TCGCard?> getCard({required String id}) async {
    try {
      await _loadEnv();
      final apiKey = dotenv.env['API_TCG_KEY'];
      if (apiKey == null) {
        developer.log('API_TCG_KEY not found in assets/.env for Gundam');
        throw Exception('API_TCG_KEY not found in assets/.env');
      }

      final uri = Uri.parse(
        '$_baseUrl/$_gamePath/cards',
      ).replace(queryParameters: {'id': id, 'limit': '1'});
      final response = await http.get(uri, headers: {'x-api-key': apiKey});

      developer.log('API Request for Gundam getCard: $uri');
      developer.log(
        'API Response for getCard: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final cardsJson = (json['data'] as List<dynamic>?) ?? [];
        if (cardsJson.isEmpty) {
          developer.log('No Gundam card found for ID: $id');
          return null;
        }
        final cardJson = cardsJson.first as Map<String, dynamic>;
        developer.log(
          'Parsing Gundam card: name=${cardJson['name']}, id=${cardJson['id']}, rarity=${cardJson['rarity']}',
        );
        return _parseCard(cardJson);
      } else if (response.statusCode == 500 &&
          response.body.contains('Datos no encontrados')) {
        developer.log('Gundam card not found for ID: $id');
        return null;
      } else {
        String errorMessage =
            'Failed to load Gundam card: ${response.statusCode} - ${response.body}';
        try {
          final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage =
              'Failed to load Gundam card: ${response.statusCode} - ${errorJson['message'] ?? response.body}';
        } catch (_) {}
        throw Exception(errorMessage);
      }
    } catch (e) {
      developer.log('Error fetching Gundam card with ID $id: $e');
      return null;
    }
  }

  TCGCard _parseCard(Map<String, dynamic> json) {
    final cardId =
        'gundam-${json['id'] ?? 'unknown-${DateTime.now().millisecondsSinceEpoch}'}';
    final gameSpecificData = Map<String, dynamic>.from(json)
      ..remove('id')
      ..remove('name')
      ..remove('rarity')
      ..remove('set')
      ..remove('images');
    return TCGCard(
      id: cardId,
      gameCode: json['id']?.toString() ?? cardId,
      name: json['name'] ?? 'Unknown Card',
      gameType: 'gundam',
      setName: json['set']?['name'],
      rarity: json['rarity'],
      imageRefSmall: json['images']?['small'],
      imageRefLarge: json['images']?['large'],
      lastUpdated: DateTime.now(),
      imageEmbedding: null,
      textEmbedding: null,
      gameSpecificData: gameSpecificData.isEmpty ? null : gameSpecificData,
    );
  }
}

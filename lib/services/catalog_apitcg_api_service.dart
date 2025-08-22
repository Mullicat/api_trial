// lib/services/catalog_apitcg_api_service.dart
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:api_trial/models/card_model_api_apitcg.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:api_trial/enums/game_type.dart';

class TcgService {
  static const String _baseUrl = 'https://apitcg.com/api';

  static Future<void> _loadEnv() async {
    try {
      await dotenv.load(fileName: 'assets/.env');
      developer.log('Successfully loaded assets/.env');
      developer.log(
        'API_TCG_KEY present: ${dotenv.env['API_TCG_KEY'] != null}',
      );
    } catch (e) {
      developer.log('Failed to load assets/.env: $e');
      throw Exception('Failed to load assets/.env: $e');
    }
  }

  Future<List<T>> getCards<T>({
    required GameType gameType,
    Map<String, String> filters = const {},
    int page = 1,
    int pageSize = 25,
  }) async {
    if (gameType == GameType.magic) {
      throw Exception(
        'Magic: The Gathering not supported in TcgService. Use MagicTcgService.',
      );
    }

    try {
      await _loadEnv();
      final apiKey = dotenv.env['API_TCG_KEY'];
      if (apiKey == null) {
        developer.log('API_TCG_KEY not found in assets/.env');
        throw Exception('API_TCG_KEY not found in assets/.env');
      }

      final queryParams = <String, String>{};
      if (filters.isNotEmpty) {
        queryParams.addAll(filters);
        developer.log('Applied filters for ${gameType.name}: $filters');
      } else {
        queryParams['name'] = ''; // Empty query to fetch all cards
        developer.log(
          'No filters applied for ${gameType.name}, fetching all cards',
        );
      }
      queryParams['page'] = page.toString();
      queryParams['limit'] = pageSize.toString();

      final uri = Uri.parse(
        '$_baseUrl/${gameType.apiPath}/cards',
      ).replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: {'x-api-key': apiKey});
      developer.log('API Request: $uri');
      developer.log(
        'API Response for getCards: ${response.statusCode} - ${response.body.substring(0, response.body.length.clamp(0, 500))}...',
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final cardsJson = (json['data'] as List<dynamic>?) ?? [];
        developer.log(
          'Cards returned for ${gameType.name}: ${cardsJson.length}',
        );
        return cardsJson.map((card) {
          try {
            final cardJson = card as Map<String, dynamic>;
            developer.log(
              'Parsing ${gameType.name} card: name=${cardJson['name']}, id=${cardJson['id']}',
            );
            return _parseCard<T>(cardJson, gameType);
          } catch (e) {
            developer.log('Error parsing card JSON: $card, Error: $e');
            rethrow;
          }
        }).toList();
      } else {
        String errorMessage =
            'Failed to load cards: ${response.statusCode} - ${response.body}';
        try {
          final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage =
              'Failed to load cards: ${response.statusCode} - ${errorJson['message'] ?? response.body}';
        } catch (_) {}
        throw Exception(errorMessage);
      }
    } catch (e) {
      developer.log('Error fetching cards for ${gameType.name}: $e');
      throw Exception('Error fetching cards: $e');
    }
  }

  Future<T?> getCard<T>({
    required GameType gameType,
    required String id,
  }) async {
    if (gameType == GameType.magic) {
      throw Exception(
        'Magic: The Gathering not supported in TcgService. Use MagicTcgService.',
      );
    }

    try {
      await _loadEnv();
      final apiKey = dotenv.env['API_TCG_KEY'];
      if (apiKey == null) {
        developer.log('API_TCG_KEY not found in assets/.env');
        throw Exception('API_TCG_KEY not found in assets/.env');
      }

      final uri = Uri.parse(
        '$_baseUrl/${gameType.apiPath}/cards',
      ).replace(queryParameters: {'id': id, 'limit': '1'});
      final response = await http.get(uri, headers: {'x-api-key': apiKey});

      developer.log('API Request (getCard): $uri');
      developer.log(
        'API Response for getCard: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final cardsJson = (json['data'] as List<dynamic>?) ?? [];
        if (cardsJson.isEmpty) {
          developer.log('No card found for ID: $id in ${gameType.name}');
          return null;
        }
        try {
          final cardJson = cardsJson.first as Map<String, dynamic>;
          developer.log(
            'Parsing ${gameType.name} card: name=${cardJson['name']}, id=${cardJson['id']}, rarity=${cardJson['rarity']}',
          );
          return _parseCard<T>(cardJson, gameType);
        } catch (e) {
          developer.log(
            'Error parsing card JSON: ${cardsJson.first}, Error: $e',
          );
          rethrow;
        }
      } else if (response.statusCode == 500 &&
          response.body.contains('Datos no encontrados')) {
        developer.log('Card not found for ID: $id in ${gameType.name}');
        return null;
      } else {
        String errorMessage =
            'Failed to load card: ${response.statusCode} - ${response.body}';
        try {
          final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage =
              'Failed to load card: ${response.statusCode} - ${errorJson['message'] ?? response.body}';
        } catch (_) {}
        throw Exception(errorMessage);
      }
    } catch (e) {
      developer.log('Error fetching single card for ${gameType.name}: $e');
      return null;
    }
  }

  T _parseCard<T>(Map<String, dynamic> json, GameType gameType) {
    if (gameType == GameType.magic) {
      throw Exception(
        'Magic: The Gathering not supported in TcgService. Use MagicTcgService.',
      );
    }
    switch (gameType) {
      case GameType.onePiece:
        return OnePieceCard.fromJson(json) as T;
      case GameType.pokemon:
        return PokemonCard.fromJson(json) as T;
      case GameType.dragonBall:
        return DragonBallCard.fromJson(json) as T;
      case GameType.digimon:
        return DigimonCard.fromJson(json) as T;
      case GameType.unionArena:
        return UnionArenaCard.fromJson(json) as T;
      case GameType.gundam:
        return GundamCard.fromJson(json) as T;
      case GameType.magic:
        throw UnimplementedError();
    }
  }
}

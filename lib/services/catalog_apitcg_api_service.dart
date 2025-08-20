import 'dart:convert';
import 'dart:developer' as developer;
import 'package:api_trial/models/card_model_api_apitcg.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

enum GameType {
  onePiece('one-piece'),
  pokemon('pokemon'),
  dragonBall('dragon-ball-fusion'),
  digimon('digimon'),
  unionArena('union-arena'),
  gundam('gundam'),
  magic('magic');

  final String apiPath;
  const GameType(this.apiPath);
}

class TcgService {
  static const String _baseUrl = 'https://apitcg.com/api';

  static Future<void> _loadEnv() async {
    try {
      await dotenv.load(fileName: "assets/.env");
      developer.log('Successfully loaded assets/.env');
      developer.log(
        'API_TCG_KEY present: ${dotenv.env['API_TCG_KEY'] != null}',
      );
    } catch (e) {
      developer.log('Failed to load assets/.env: $e');
      throw Exception('Failed to load assets/.env: $e');
    }
  }

  static const Map<GameType, Map<String, String>> _defaultFilters = {
    GameType.onePiece: {'name': 'luffy'},
    GameType.pokemon: {'name': 'charizard'},
    GameType.dragonBall: {'name': 'goku'},
    GameType.digimon: {'name': 'gallantmon'},
    GameType.unionArena: {'name': 'gon'},
    GameType.gundam: {'name': 'strike'},
    GameType.magic: {'name': 'jace'},
  };

  Future<List<T>> getCards<T>({
    required GameType gameType,
    String? property,
    String? value,
    int page = 1,
    int pageSize = 25,
  }) async {
    try {
      await _loadEnv();
      final apiKey = dotenv.env['API_TCG_KEY'];
      if (apiKey == null) {
        developer.log('API_TCG_KEY not found in assets/.env');
        throw Exception('API_TCG_KEY not found in assets/.env');
      }

      final queryParams = <String, String>{};

      if (property == null || value == null) {
        final defaultFilter = _defaultFilters[gameType];
        if (defaultFilter != null) {
          queryParams.addAll(defaultFilter);
          developer.log(
            'Applied default filter for ${gameType.name}: $defaultFilter',
          );
        }
      } else {
        queryParams[property] = value;
        developer.log(
          'Applied custom filter for ${gameType.name}: $property=$value',
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
        'API Response for getCards: ${response.statusCode} - ${response.body}',
      );
      developer.log('Response Headers: ${response.headers}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final cardsJson = json['data'];
        if (cardsJson is List<dynamic>) {
          developer.log(
            'Cards returned for ${gameType.name}: ${cardsJson.length}',
          );
          return cardsJson
              .map((card) => _parseCard<T>(card, gameType))
              .toList();
        } else {
          developer.log('No cards found in response: ${json.toString()}');
          return [];
        }
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
    try {
      await _loadEnv();
      final apiKey = dotenv.env['API_TCG_KEY'];
      if (apiKey == null) {
        developer.log('API_TCG_KEY not found in assets/.env');
        throw Exception('API_TCG_KEY not found in assets/.env');
      }

      final uri = Uri.parse('$_baseUrl/${gameType.apiPath}/cards/$id');
      final response = await http.get(uri, headers: {'x-api-key': apiKey});

      developer.log('API Request (getCard): $uri');
      developer.log(
        'API Response for getCard: ${response.statusCode} - ${response.body}',
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final cardJson = json['data'];
        if (cardJson is Map<String, dynamic>) {
          return _parseCard<T>(cardJson, gameType);
        } else {
          developer.log('No card data found in response: ${json.toString()}');
          return null;
        }
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
      throw Exception('Error fetching card: $e');
    }
  }

  T _parseCard<T>(Map<String, dynamic> json, GameType gameType) {
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
        return MagicCard.fromJson(json) as T;
    }
  }
}

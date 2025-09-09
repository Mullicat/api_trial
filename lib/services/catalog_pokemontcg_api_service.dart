// lib/services/catalog_pokemontcg_api_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:api_trial/models/card.dart'; // Use new TCGCard model
import 'dart:developer' as developer;

class PokemonTcgService {
  Future<void> _loadEnv() async {
    try {
      await dotenv.load(fileName: 'assets/.env');
      developer.log('Successfully loaded assets/.env');
      developer.log(
        'POKEMON_TCG_API_KEY present: ${dotenv.env['POKEMON_TCG_API_KEY'] != null}',
      );
    } catch (e) {
      developer.log('Error loading .env: $e');
      throw Exception('Failed to load .env file: $e');
    }
  }

  Future<List<TCGCard>> searchCards({
    int? page,
    int? pageSize,
    Map<String, String> filters = const {},
    String? orderBy,
  }) async {
    await _loadEnv();

    final apiKey = dotenv.env['POKEMON_TCG_API_KEY'];
    if (apiKey == null) {
      throw Exception('POKEMON_TCG_API_KEY not found in .env');
    }

    // Construct Lucene-like query from filters
    String? q;
    if (filters.isNotEmpty) {
      final queryParts = <String>[];
      filters.forEach((key, value) {
        if (value.isNotEmpty && value != 'None') {
          if (['hp', 'nationalPokedexNumbers'].contains(key)) {
            // Range queries (e.g., hp:[150 TO *])
            queryParts.add('$key:$value');
          } else if (['text', 'flavor', 'artist', 'number'].contains(key)) {
            // Free-text fields with quotes for phrases
            queryParts.add('$key:"$value"');
          } else {
            // Standard fields (e.g., rarity:Rare, types:Fire)
            queryParts.add('$key:$value');
          }
        }
      });
      q = queryParts.join(' ');
      if (q.isEmpty) q = null;
    }
    if (q == null && !filters.containsKey('name')) {
      q = 'set.name:generations'; // Default query
    }

    final queryParams = {
      if (page != null) 'page': page.toString(),
      if (pageSize != null) 'pageSize': pageSize.toString(),
      if (q != null) 'q': q,
      if (orderBy != null) 'orderBy': orderBy,
    };

    final uri = Uri.parse(
      'https://api.pokemontcg.io/v2/cards',
    ).replace(queryParameters: queryParams);
    developer.log('API Request: $uri with params: $queryParams');

    try {
      final response = await http.get(uri, headers: {'X-Api-Key': apiKey});
      developer.log(
        'API Response for searchCards: ${response.statusCode} - ${response.body.substring(0, response.body.length.clamp(0, 500))}...',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cardsJson = data['data'] as List<dynamic>;
        developer.log('Cards returned: ${cardsJson.length}');
        return cardsJson.map((json) {
          final cardJson = json as Map<String, dynamic>;
          developer.log('Parsing JSON for TCGCard: $cardJson');
          // Map Pokémon API fields to TCGCard model
          final cardId =
              'pokemon-${cardJson['id'] ?? 'unknown-${DateTime.now().millisecondsSinceEpoch}'}';
          final gameSpecificData = <String, dynamic>{
            'hp': cardJson['hp'],
            'types': cardJson['types'],
            'supertypes': cardJson['supertypes'],
            'subtypes': cardJson['subtypes'],
            'abilities': cardJson['abilities'],
            'attacks': cardJson['attacks'],
            'weaknesses': cardJson['weaknesses'],
            'retreatCost': cardJson['retreatCost'],
            'convertedRetreatCost': cardJson['convertedRetreatCost'],
            'number': cardJson['number'],
            'artist': cardJson['artist'],
            'flavorText': cardJson['flavorText'],
            'nationalPokedexNumbers': cardJson['nationalPokedexNumbers'],
            'legalities': cardJson['legalities'],
            'tcgplayer': cardJson['tcgplayer'],
            'cardmarket': cardJson['cardmarket'],
          }..removeWhere((key, value) => value == null); // Remove null values
          return TCGCard(
            id: cardId,
            gameCode: cardJson['id']?.toString() ?? cardId,
            name: cardJson['name'] ?? 'Unknown Card',
            gameType: 'pokemon',
            setName: cardJson['set']?['name'],
            rarity: cardJson['rarity'],
            imageRefSmall: cardJson['images']?['small'],
            imageRefLarge: cardJson['images']?['large'],
            lastUpdated: DateTime.now(),
            imageEmbedding: null, // Defer generation
            textEmbedding: null, // Defer generation
            gameSpecificData: cardJson.isEmpty ? null : gameSpecificData,
          );
        }).toList();
      } else {
        throw Exception(
          'Failed to load cards: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      developer.log('Error fetching cards: $e');
      throw Exception('Error fetching cards: $e');
    }
  }

  Future<TCGCard?> getCard(String cardId) async {
    await _loadEnv();

    final apiKey = dotenv.env['POKEMON_TCG_API_KEY'];
    if (apiKey == null) {
      throw Exception('POKEMON_TCG_API_KEY not found in .env');
    }

    final uri = Uri.parse('https://api.pokemontcg.io/v2/cards/$cardId');
    developer.log('API Request: $uri');

    try {
      final response = await http.get(uri, headers: {'X-Api-Key': apiKey});
      developer.log(
        'API Response for getCard: ${response.statusCode} - ${response.body.substring(0, response.body.length.clamp(0, 500))}...',
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cardJson = data['data'] as Map<String, dynamic>?;
        if (cardJson == null) {
          developer.log('No card data found for this card\'s ID');
          return null;
        }
        developer.log('Parsing JSON for TCGCard: $cardJson');
        // Map Pokémon API fields to TCGCard model
        final cardId =
            'pokemon-${cardJson['id'] ?? 'unknown-${DateTime.now().millisecondsSinceEpoch}'}';
        final gameSpecificData = <String, dynamic>{
          'hp': cardJson['hp'],
          'types': cardJson['types'],
          'supertypes': cardJson['supertypes'],
          'subtypes': cardJson['subtypes'],
          'abilities': cardJson['abilities'],
          'attacks': cardJson['attacks'],
          'weaknesses': cardJson['weaknesses'],
          'retreatCost': cardJson['retreatCost'],
          'convertedRetreatCost': cardJson['convertedRetreatCost'],
          'number': cardJson['number'],
          'artist': cardJson['artist'],
          'flavorText': cardJson['flavorText'],
          'nationalPokedexNumbers': cardJson['nationalPokedexNumbers'],
          'legalities': cardJson['legalities'],
          'tcgplayer': cardJson['tcgplayer'],
          'cardmarket': cardJson['cardmarket'],
        }..removeWhere((key, value) => value == null);
        return TCGCard(
          id: cardId,
          gameCode: cardJson['id']?.toString() ?? cardId,
          name: cardJson['name'] ?? 'Unknown Card',
          gameType: 'pokemon',
          setName: cardJson['set']?['name'],
          rarity: cardJson['rarity'],
          imageRefSmall: cardJson['images']?['small'],
          imageRefLarge: cardJson['images']?['large'],
          lastUpdated: DateTime.now(),
          imageEmbedding: null,
          textEmbedding: null,
          gameSpecificData: cardJson.isEmpty ? null : gameSpecificData,
        );
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
}

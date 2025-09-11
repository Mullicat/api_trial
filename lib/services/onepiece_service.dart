import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:api_trial/models/card.dart';
import 'package:api_trial/constants/enums/game_type.dart';
import 'package:api_trial/constants/enums/onepiece_filters.dart';
import 'package:api_trial/data/datasources/supabase_datasource.dart';

class OnePieceTcgService {
  static const String _baseUrl = 'https://apitcg.com/api';
  static const String _gamePath = 'one-piece';
  final SupabaseDataSource _supabaseDataSource;
  List<TCGCard> _cachedCards = []; // Cache for getCardFromAPICards

  OnePieceTcgService._(this._supabaseDataSource);

  static Future<OnePieceTcgService> create() async {
    final supabaseDataSource = await SupabaseDataSource.getInstance();
    return OnePieceTcgService._(supabaseDataSource);
  }

  Future<void> _loadEnv() async {
    try {
      await dotenv.load(fileName: 'assets/.env');
      developer.log('Successfully loaded assets/.env for One Piece');
      developer.log(
        'API_TCG_KEY present: ${dotenv.env['API_TCG_KEY'] != null}',
      );
    } catch (e) {
      developer.log('Failed to load assets/.env for One Piece: $e');
      throw Exception('Failed to load assets/.env: $e');
    }
  }

  // Converts enum-based filters to API query parameters
  Map<String, String> _buildAPIQueryParams({
    String? word,
    SetName? setName,
    Rarity? rarity,
    Cost? cost,
    Type? type,
    Color? color,
    Power? power,
    List<Family>? families,
    Counter? counter,
    Trigger? trigger,
    Ability? ability,
  }) {
    final queryParams = <String, String>{};
    if (word != null && word.isNotEmpty) {
      queryParams['name'] = word;
    }
    if (setName != null) {
      // Extract set code (e.g., 'OP06') from '-WINGS OF THE CAPTAIN- [OP06]'
      final setCode = setName.value.contains('[')
          ? setName.value.split('[').last.replaceAll(']', '')
          : setName.value;
      queryParams['set'] = setCode;
    }
    if (rarity != null) {
      queryParams['rarity'] = rarity.value;
    }
    if (cost != null) {
      queryParams['cost'] = cost.value;
    }
    if (type != null) {
      queryParams['type'] = type.value;
    }
    if (color != null) {
      queryParams['color'] = color.value;
    }
    if (power != null) {
      queryParams['power'] = power.value;
    }
    if (families != null && families.isNotEmpty) {
      queryParams['family'] = families.map((f) => f.value).join(',');
    }
    if (counter != null) {
      queryParams['counter'] = counter.value;
    }
    if (trigger != null) {
      queryParams['has_trigger'] = trigger == Trigger.hasTrigger
          ? 'true'
          : 'false';
    }
    if (ability != null) {
      queryParams['effect'] =
          ability.value; // API uses 'effect' for ability-like filtering
    }
    return queryParams;
  }

  // Converts enum-based filters to Supabase query parameters
  Map<String, String> _buildSupabaseQueryParams({
    String? word,
    SetName? setName,
    Rarity? rarity,
    Cost? cost,
    Type? type,
    Color? color,
    Power? power,
    List<Family>? families,
    Counter? counter,
    Trigger? trigger,
    Ability? ability,
  }) {
    final queryParams = <String, String>{};
    if (word != null && word.isNotEmpty) {
      queryParams['name'] = word;
    }
    if (setName != null) {
      queryParams['set_name'] = setName.value;
    }
    if (rarity != null) {
      queryParams['rarity'] = rarity.value;
    }
    if (cost != null) {
      queryParams['cost'] = cost.value;
    }
    if (type != null) {
      queryParams['type'] = type.value;
    }
    if (color != null) {
      queryParams['color'] = color.value;
    }
    if (power != null) {
      queryParams['power'] = power.value;
    }
    if (counter != null) {
      queryParams['counter'] = counter.value;
    }
    return queryParams; // Families, trigger, and ability are handled in query logic
  }

  // Fetches cards from the API with filters and pagination
  Future<List<TCGCard>> getCardsFromAPI({
    String? word,
    SetName? setName,
    Rarity? rarity,
    Cost? cost,
    Type? type,
    Color? color,
    Power? power,
    List<Family>? families,
    Counter? counter,
    Trigger? trigger,
    Ability? ability,
    int page = 1,
    int pageSize = 100,
  }) async {
    try {
      await _loadEnv();
      final apiKey = dotenv.env['API_TCG_KEY'];
      if (apiKey == null) {
        developer.log('API_TCG_KEY not found in assets/.env for One Piece');
        throw Exception('API_TCG_KEY not found in assets/.env');
      }

      final queryParams = _buildAPIQueryParams(
        word: word,
        setName: setName,
        rarity: rarity,
        cost: cost,
        type: type,
        color: color,
        power: power,
        families: families,
        counter: counter,
        trigger: trigger,
        ability: ability,
      );
      queryParams['page'] = page.toString();
      queryParams['limit'] = (pageSize > 100 ? 100 : pageSize).toString();

      final uri = Uri.parse(
        '$_baseUrl/$_gamePath/cards',
      ).replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: {'x-api-key': apiKey});
      developer.log('API Request for One Piece getCardsFromAPI: $uri');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final cardsJson = (json['data'] as List<dynamic>?) ?? [];
        developer.log('Cards returned for One Piece: ${cardsJson.length}');
        _cachedCards = cardsJson.map((card) {
          final cardJson = card as Map<String, dynamic>;
          developer.log(
            'Parsing One Piece card: name=${cardJson['name'] ?? 'Unknown'}, id=${cardJson['id']}',
          );
          return _parseCard(cardJson);
        }).toList();
        return _cachedCards;
      } else {
        String errorMessage =
            'Failed to load One Piece cards: ${response.statusCode} - ${response.body}';
        try {
          final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage =
              'Failed to load One Piece cards: ${response.statusCode} - ${errorJson['message'] ?? response.body}';
        } catch (_) {}
        throw Exception(errorMessage);
      }
    } catch (e) {
      developer.log('Error fetching One Piece cards from API: $e');
      throw Exception('Error fetching One Piece cards: $e');
    }
  }

  // Fetches cards from Supabase using full-text search and filters
  Future<List<TCGCard>> getCardsFromDatabase({
    String? word,
    SetName? setName,
    Rarity? rarity,
    Cost? cost,
    Type? type,
    Color? color,
    Power? power,
    List<Family>? families,
    Counter? counter,
    Trigger? trigger,
    Ability? ability,
    int page = 1,
    int pageSize = 100,
  }) async {
    try {
      List<Map<String, dynamic>> response;

      if (word != null && word.isNotEmpty) {
        final queryParams = _buildSupabaseQueryParams(
          word: word,
          setName: setName,
          rarity: rarity,
          cost: cost,
          type: type,
          color: color,
          power: power,
          families: families,
          counter: counter,
          trigger: trigger,
          ability: ability,
        );
        response = await _supabaseDataSource.searchCardsByTerm(
          searchTerm: word,
          gameType: 'onepiece',
          setName: setName,
          rarity: rarity,
          cost: cost,
          type: type,
          color: color,
          power: power,
          families: families,
          counter: counter,
          trigger: trigger,
          ability: ability,
          page: page,
          pageSize: pageSize,
        );
      } else {
        var query = _supabaseDataSource.supabase
            .from('cards')
            .select()
            .eq('game_type', 'onepiece');

        if (setName != null) query = query.eq('set_name', setName.value);
        if (rarity != null) query = query.eq('rarity', rarity.value);
        if (cost != null)
          query = query.eq('game_specific_data->>cost', cost.value);
        if (type != null)
          query = query.eq('game_specific_data->>type', type.value);
        if (color != null)
          query = query.eq('game_specific_data->>color', color.value);
        if (power != null)
          query = query.eq('game_specific_data->>power', power.value);
        if (counter != null)
          query = query.eq('game_specific_data->>counter', counter.value);
        if (trigger != null) {
          if (trigger == Trigger.hasTrigger) {
            query = query
                .neq('game_specific_data->>trigger', '')
                .not('game_specific_data->>trigger', 'is', null);
          } else if (trigger == Trigger.noTrigger) {
            query = query.or(
              'game_specific_data->>trigger.eq.,game_specific_data->>trigger.is.null',
            );
          }
        }
        if (ability != null) {
          // Ensure ability is stored as a JSON array and use contains for exact match
          query = query.contains('game_specific_data->ability', [
            ability.value,
          ]);
        }
        if (families != null && families.isNotEmpty) {
          // Ensure family is stored as a JSON array
          query = query.contains(
            'game_specific_data->family',
            families.map((f) => f.value).toList(),
          );
        }

        final offset = (page - 1) * pageSize;
        response = await query.range(
          offset,
          offset + (pageSize > 100 ? 100 : pageSize) - 1,
        );
      }

      developer.log('Fetched ${response.length} cards from Supabase');
      return response.map((json) => TCGCard.fromJson(json)).toList();
    } catch (e) {
      developer.log('Error fetching One Piece cards from Supabase: $e');
      throw Exception('Error fetching One Piece cards from Supabase: $e');
    }
  }

  Future<List<TCGCard>> getCardsUploadCards({
    String? word,
    SetName? setName,
    Rarity? rarity,
    Cost? cost,
    Type? type,
    Color? color,
    Power? power,
    List<Family>? families,
    Counter? counter,
    Trigger? trigger,
    Ability? ability,
    int page = 1,
    int pageSize = 100,
  }) async {
    try {
      final apiCards = await getCardsFromAPI(
        word: word,
        setName: setName,
        rarity: rarity,
        cost: cost,
        type: type,
        color: color,
        power: power,
        families: families,
        counter: counter,
        trigger: trigger,
        ability: ability,
        page: page,
        pageSize: pageSize,
      );

      Future.microtask(() async {
        try {
          final cardsToUpsert = <Map<String, dynamic>>[];
          for (var card in apiCards) {
            final normalizedImageRefSmall =
                card.imageRefSmall?.split('?').first ?? '';
            final existingCards = await _supabaseDataSource.getCardsByGameCode(
              gameCode: card.gameCode!.split('-').first,
              gameType: 'onepiece',
              imageRefSmall: normalizedImageRefSmall,
            );

            bool shouldUpsert = true;
            String newGameCode = card.gameCode!;

            if (existingCards.isNotEmpty) {
              for (var existing in existingCards) {
                if (existing['set_name'] == card.setName &&
                    existing['image_ref_small'] == card.imageRefSmall) {
                  shouldUpsert = false;
                  break;
                }
              }
              if (shouldUpsert) {
                final baseGameCode = card.gameCode!.split('-').first;
                final versionedCards = await _supabaseDataSource.supabase
                    .from('cards')
                    .select('game_code')
                    .eq('game_type', 'onepiece')
                    .like('game_code', '$baseGameCode%');
                int maxVersion = 1;
                for (var vc in versionedCards) {
                  final gc = vc['game_code'] as String;
                  final match = RegExp(r'version(\d+)$').firstMatch(gc);
                  if (match != null) {
                    final version = int.parse(match.group(1)!);
                    maxVersion = version > maxVersion ? version : maxVersion;
                  }
                }
                newGameCode = '$baseGameCode-version${maxVersion + 1}';
              }
            }

            if (shouldUpsert) {
              // Normalize family and ability for Supabase (store as arrays)
              final gameSpecificData = Map<String, dynamic>.from(
                card.gameSpecificData ?? {},
              );
              if (gameSpecificData['family'] != null &&
                  gameSpecificData['family'] is String) {
                gameSpecificData['family'] = [gameSpecificData['family']];
              }
              if (gameSpecificData['ability'] != null &&
                  gameSpecificData['ability'] is String) {
                gameSpecificData['ability'] = [gameSpecificData['ability']];
              }

              cardsToUpsert.add({
                'game_code': newGameCode,
                'game_type': card.gameType,
                'name': card.name,
                'set_name': card.setName,
                'rarity': card.rarity,
                'image_ref_small': card.imageRefSmall?.split('?').first,
                'image_ref_large': card.imageRefLarge?.split('?').first,
                'game_specific_data': gameSpecificData,
              });
            }
          }

          if (cardsToUpsert.isNotEmpty) {
            await _supabaseDataSource.upsertCards(cardsToUpsert);
            developer.log('Upserted ${cardsToUpsert.length} cards to Supabase');
          }
        } catch (e) {
          developer.log('Background upsert error: $e');
        }
      });

      return apiCards;
    } catch (e) {
      developer.log('Error in getCardsUploadCards: $e');
      throw Exception('Error syncing One Piece cards: $e');
    }
  }

  Future<TCGCard?> getCardFromAPI({required String id}) async {
    try {
      await _loadEnv();
      final apiKey = dotenv.env['API_TCG_KEY'];
      if (apiKey == null) {
        developer.log('API_TCG_KEY not found in assets/.env for One Piece');
        throw Exception('API_TCG_KEY not found in assets/.env');
      }

      // Remove 'onepiece-' prefix for API query
      final apiId = id.startsWith('onepiece-')
          ? id.replaceFirst('onepiece-', '')
          : id;
      final uri = Uri.parse(
        '$_baseUrl/$_gamePath/cards',
      ).replace(queryParameters: {'id': apiId, 'limit': '1'});
      final response = await http.get(uri, headers: {'x-api-key': apiKey});
      developer.log('API Request for One Piece getCardFromAPI: $uri');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['data'] == null) {
          developer.log('No One Piece card found for ID: $apiId');
          return null;
        }

        Map<String, dynamic> cardJson;
        if (json['data'] is List<dynamic>) {
          final cardsJson = json['data'] as List<dynamic>;
          if (cardsJson.isEmpty) {
            developer.log('No One Piece card found for ID: $apiId');
            return null;
          }
          cardJson = cardsJson.first as Map<String, dynamic>;
        } else if (json['data'] is Map<String, dynamic>) {
          cardJson = json['data'] as Map<String, dynamic>;
        } else {
          developer.log(
            'Unexpected data format for ID: $apiId, data: ${json['data']}',
          );
          throw Exception(
            'Unexpected data format: ${json['data'].runtimeType}',
          );
        }

        developer.log(
          'Parsing One Piece card: name=${cardJson['name'] ?? 'Unknown'}, id=${cardJson['id']}',
        );
        return _parseCard(cardJson);
      } else {
        String errorMessage =
            'Failed to load One Piece card: ${response.statusCode} - ${response.body}';
        try {
          final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage =
              'Failed to load One Piece card: ${response.statusCode} - ${errorJson['message'] ?? response.body}';
        } catch (_) {}
        throw Exception(errorMessage);
      }
    } catch (e) {
      developer.log('Error fetching One Piece card with ID $id: $e');
      return null;
    }
  }

  Future<TCGCard?> getCardFromSupabase({required String id}) async {
    try {
      final response = await _supabaseDataSource.supabase
          .from('cards')
          .select()
          .eq('id', id)
          .eq('game_type', 'onepiece')
          .maybeSingle();

      if (response == null) {
        developer.log('No One Piece card found in Supabase for ID: $id');
        return null;
      }
      developer.log(
        'Fetched card from Supabase: ${response['name'] ?? 'Unknown'}',
      );
      return TCGCard.fromJson(response);
    } catch (e) {
      developer.log('Error fetching One Piece card from Supabase: $e');
      return null;
    }
  }

  TCGCard? getCardFromAPICards({required String id}) {
    try {
      final card = _cachedCards.firstWhere(
        (card) => card.id == id,
        orElse: () =>
            throw Exception('Card with ID $id not found in cached cards'),
      );
      developer.log('Retrieved card from cache: ${card.name}, id: $id');
      return card;
    } catch (e) {
      developer.log('Error retrieving One Piece card from cache: $e');
      return null;
    }
  }

  TCGCard _parseCard(Map<String, dynamic> json) {
    final cardId =
        'onepiece-${json['id'] ?? 'unknown-${DateTime.now().millisecondsSinceEpoch}'}';
    final gameSpecificData = Map<String, dynamic>.from(json)
      ..remove('id')
      ..remove('name')
      ..remove('rarity')
      ..remove('set')
      ..remove('images');
    if (json['cardType'] != null) {
      gameSpecificData['type'] = json['cardType'];
    } else if (json['types'] != null && json['types'] is List) {
      gameSpecificData['type'] = (json['types'] as List).join(', ');
    } else if (json['type'] != null) {
      gameSpecificData['type'] = json['type'];
    }
    // Normalize family and ability for consistency
    if (json['family'] != null && json['family'] is List) {
      gameSpecificData['family'] = json['family'];
    } else if (json['family'] != null) {
      gameSpecificData['family'] = [json['family'].toString()];
    }
    if (json['effect'] != null) {
      gameSpecificData['ability'] = json['effect'] is List
          ? json['effect']
          : [json['effect'].toString()];
    }
    return TCGCard(
      id: cardId,
      gameCode: json['id']?.toString() ?? cardId,
      name: json['name']?.toString(),
      gameType: 'onepiece',
      setName: json['set']?['name']?.toString(),
      rarity: json['rarity']?.toString(),
      imageRefSmall: json['images']?['small']?.toString().split('?').first,
      imageRefLarge: json['images']?['large']?.toString().split('?').first,
      imageEmbedding: null,
      textEmbedding: null,
      gameSpecificData: gameSpecificData.isEmpty ? null : gameSpecificData,
    );
  }
}

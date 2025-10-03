import 'dart:convert';
import 'dart:developer' as developer;
import 'package:api_trial/data/repositories/supabase_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:api_trial/models/card.dart';
import 'package:api_trial/constants/enums/onepiece_filters.dart';
import 'package:api_trial/data/datasources/supabase_datasource.dart';
import 'package:api_trial/constants/enums/game_type.dart';

class OnePieceTcgService {
  static const String _baseUrl = 'https://apitcg.com/api';
  static const String _gamePath = 'one-piece';
  final SupabaseDataSource _supabaseDataSource;
  final SupabaseRepository _repository = SupabaseRepository();
  List<TCGCard> _cachedCards = []; // Cache for getCardFromAPICards

  // Private constructor with Supabase data source
  OnePieceTcgService._(this._supabaseDataSource);

  // Create instance with initialized Supabase data source
  static Future<OnePieceTcgService> create() async {
    final supabaseDataSource = await SupabaseDataSource.getInstance();
    return OnePieceTcgService._(supabaseDataSource);
  }

  // Load API key from .env file
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

  // Build API params (NOTE: 'set' handled specially; see getCardsFromAPI)
  Map<String, String> _buildAPIQueryParams({
    String? word,
    Rarity? rarity,
    Cost? cost,
    Type? type,
    Color? color,
    Power? power,
    List<Family>? families,
    Counter? counter,
    Ability? ability,
  }) {
    final queryParams = <String, String>{};
    if (word != null && word.isNotEmpty) queryParams['name'] = word;
    if (rarity != null) queryParams['rarity'] = rarity.value;
    if (cost != null) queryParams['cost'] = cost.value;
    if (type != null) queryParams['type'] = type.value;
    if (color != null) queryParams['color'] = color.value;
    if (power != null) queryParams['power'] = power.value;
    if (families != null && families.isNotEmpty) {
      queryParams['family'] = families.map((f) => f.value).join(',');
    }
    if (counter != null) queryParams['counter'] = counter.value;
    if (ability != null) queryParams['ability'] = ability.value;
    return queryParams;
  }

  // Request cards from API
  Future<List<dynamic>> _requestCardsOnce(
    Map<String, String> params, {
    required String apiKey,
  }) async {
    // Step 1. Build API URI with params
    final uri = Uri.parse(
      '$_baseUrl/$_gamePath/cards',
    ).replace(queryParameters: params);
    developer.log('API Request One Piece: $uri');
    // Step 2. Send GET request with API key header
    final response = await http.get(uri, headers: {'x-api-key': apiKey});
    // Step 3. Check response status
    if (response.statusCode != 200) {
      String msg = 'Failed: ${response.statusCode} - ${response.body}';
      try {
        final err = jsonDecode(response.body) as Map<String, dynamic>;
        msg =
            'Failed: ${response.statusCode} - ${err['message'] ?? response.body}';
      } catch (_) {}
      developer.log(msg);
      return const [];
    }
    // Step 4. Parse JSON and return 'data' list
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return (json['data'] as List<dynamic>?) ?? const [];
  }

  // COMP 3: Extract code from enum display: e.g., "[OP03]" or "[OP-11]" -> "OP03"/"OP11"
  String? _extractNormalizedSetPrefix(String raw) {
    // Step 1: Match set code pattern (e.g., [OP03])
    final m = RegExp(r'\[([A-Za-z0-9\-]+)\]').firstMatch(raw);
    // Step 2: Return null if no match
    if (m == null) return null;
    // Step 3: Normalize code (uppercase, remove hyphens)
    var code = m.group(1)!.toUpperCase().replaceAll('-', '');
    // Step 4: Ensure OP codes have two digits (e.g., OP1 -> OP01)
    final op = RegExp(r'^OP(\d+)$').firstMatch(code);
    if (op != null) {
      final digits = op.group(1)!;
      if (digits.length == 1) code = 'OP0$digits';
    }

    return code;
  }

  // FUNC 1: Fetch cards from API with filters and pagination
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
      // Step 1: Load environment variables & API
      await _loadEnv();
      final apiKey = dotenv.env['API_TCG_KEY'];
      if (apiKey == null) {
        developer.log('API_TCG_KEY not found in assets/.env for One Piece');
        throw Exception('API_TCG_KEY not found in assets/.env');
      }
      // Step 2: Build base query parameters
      final base = _buildAPIQueryParams(
        word: word,
        rarity: rarity,
        cost: cost,
        type: type,
        color: color,
        power: power,
        families: families,
        counter: counter,
        ability: ability,
      );
      // Step 3: Add pagination parameters
      base['page'] = page.toString();
      base['limit'] = (pageSize > 100 ? 100 : pageSize).toString();
      // Step 4: Create query variants for set filtering
      final variants = <Map<String, String>>[];
      if (setName != null) {
        final full = setName.value;
        final prefix = _extractNormalizedSetPrefix(full);
        if (prefix != null) {
          final byCode = Map<String, String>.from(base)..['code'] = prefix;
          variants.add(byCode);
        }
        final vSet = Map<String, String>.from(base)..['set'] = full;
        final vSetName = Map<String, String>.from(base)..['setName'] = full;
        final vSetUnderscore = Map<String, String>.from(base)
          ..['set_name'] = full;
        variants.addAll([vSet, vSetName, vSetUnderscore]);
      } else {
        variants.add(base);
      }
      // Step 5: Apply trigger filter to variants
      if (trigger == Trigger.noTrigger) {
        for (final p in variants) {
          p['trigger'] = '';
        }
      } else if (trigger == Trigger.hasTrigger) {
        for (final p in variants) {
          p['trigger'] = '*';
        }
      }
      // Step 6: Try API requests with variants
      List<dynamic> cardsJson = const [];
      for (final params in variants) {
        cardsJson = await _requestCardsOnce(params, apiKey: apiKey);
        if (cardsJson.isNotEmpty) break;
      }
      // Step 7: Retry without trigger if needed (TODO: Optimize for future removal)
      bool appliedClientTrigger = false;
      if (cardsJson.isEmpty && trigger == Trigger.hasTrigger) {
        final variantsNoTrigger = variants.map((p) {
          final q = Map<String, String>.from(p);
          q.remove('trigger');
          return q;
        }).toList();
        for (final params in variantsNoTrigger) {
          cardsJson = await _requestCardsOnce(params, apiKey: apiKey);
          if (cardsJson.isNotEmpty) {
            appliedClientTrigger = true;
            break;
          }
        }
      }
      developer.log('Cards returned (pre-filter): ${cardsJson.length}');

      // Step 8: Parse JSON to TCGCard objects
      final parsed = cardsJson
          .map((c) => _parseCard(c as Map<String, dynamic>))
          .toList();
      // Step 9: Cache parsed cards
      _cachedCards = parsed;
      // Step 10: Apply client-side trigger filter if needed (TODO: Optimize for future removal)
      List<TCGCard> result = parsed;
      if (appliedClientTrigger && trigger == Trigger.hasTrigger) {
        result = parsed.where((card) {
          final t = card.gameSpecificData?['trigger'];
          final s = (t == null) ? '' : t.toString().trim();
          return s.isNotEmpty;
        }).toList();
      }

      // Step 11: Return filtered cards
      developer.log('Cards returned (post-filter): ${result.length}');
      return result;
    } catch (e) {
      developer.log('Error fetching One Piece cards from API: $e');
      throw Exception('Error fetching One Piece cards: $e');
    }
  }

  // FUNC 2: Fetch cards from Supabase with filters and pagination
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
      // Step 2a: Search by term if word provided
      if (word != null && word.isNotEmpty) {
        // Use RPC for One Piece-specific fuzzy search (including game_code)
        response = await _supabaseDataSource.supabase.rpc(
          'search_onepiece_cards_filtered',
          params: {
            'search_term': word,
            'p_set_name': setName?.value,
            'p_rarity': rarity?.value,
            'p_cost': cost?.value,
            'p_type': type?.value,
            'p_color': color?.value,
            'p_power': power?.value,
            'p_families': families?.map((f) => f.value).toList(),
            'p_counter': counter?.value,
            'has_trigger': trigger == Trigger.hasTrigger
                ? true
                : (trigger == Trigger.noTrigger ? false : null),
            'p_ability': ability?.value,
            'p_page': page,
            'p_page_size': pageSize,
          },
        );
      } else {
        // Step 2b: Build query without search term
        var query = _supabaseDataSource.supabase
            .from('cards')
            .select()
            .eq('game_type', 'onepiece');
        // Step 3b: Apply filters
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

        if (families != null && families.isNotEmpty) {
          final fam = families.map((f) => f.value).toList();
          query = query.filter(
            'game_specific_data->family',
            'cs',
            jsonEncode(fam),
          );
        }

        if (counter != null) {
          query = query.eq('game_specific_data->>counter', counter.value);
        }

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
          query = query.ilike(
            'game_specific_data->>ability',
            '%${ability.value}%',
          );
        }

        final offset = (page - 1) * pageSize;
        response = await query.range(
          offset,
          offset + (pageSize > 100 ? 100 : pageSize) - 1,
        );
      }

      developer.log('Fetched ${response.length} cards from Supabase');
      // Step 4: Normalize and parse response to TCGCard
      final normalized = response.map((row) {
        final m = Map<String, dynamic>.from(row);
        final gsd = m['game_specific_data'];
        if (gsd is String) {
          try {
            m['game_specific_data'] = jsonDecode(gsd);
          } catch (_) {}
        }
        return TCGCard.fromJson(m);
      }).toList();
      // Step 5: Return parsed cards
      return normalized;
    } catch (e) {
      developer.log('Error fetching One Piece cards from Supabase: $e');
      throw Exception('Error fetching One Piece cards from Supabase: $e');
    }
  }

  // FUNC 3: Fetch cards by game code from Supabase
  Future<List<TCGCard>> getCardsByGameCodeFromDatabase({
    required String gameCode,
  }) async {
    try {
      // Step 1: Normalize game code
      final base = _baseGameCode(gameCode);
      // Step 2: Fetch cards by game code
      final rows = await _supabaseDataSource.fetchOnePieceCardsByGameCode(base);
      // Step 3: Normalize and parse rows to TCGCard
      final normalized = rows.map((row) {
        final m = Map<String, dynamic>.from(row);
        final gsd = m['game_specific_data'];
        if (gsd is String) {
          try {
            m['game_specific_data'] = jsonDecode(gsd);
          } catch (_) {}
        }
        return TCGCard.fromJson(m);
      }).toList();
      developer.log(
        'Fetched ${normalized.length} One Piece cards by game_code "$base"',
      );
      // Step 5: Return parsed cards
      return normalized;
    } catch (e) {
      developer.log('Error fetching by game code from Supabase: $e');
      throw Exception('Error fetching by game code: $e');
    }
  }

  // FUNC 4: Fetch and upsert cards from API to Supabase
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
      // Step 1: Fetch cards from API
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

      // Step 2: Start background upsert
      Future.microtask(() async {
        try {
          // Step 3: Initialize list for cards to upsert
          final cardsToUpsert = <Map<String, dynamic>>[];
          // Step 4: Process each API card
          for (var card in apiCards) {
            // Step 5: Normalize image reference (No ?######)
            final normalizedImageRefSmall =
                card.imageRefSmall?.split('?').first ?? '';
            // Step 6: Check for existing cards by game code and image
            final existingCards = await _supabaseDataSource.getCardsByGameCode(
              gameCode: card.gameCode!.split('-').first,
              gameType: 'onepiece',
              imageRefSmall: normalizedImageRefSmall,
            );
            // Step 7: Determine if upsert is needed
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
                // Step 8: Generate new versioned game code
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
            // Step 9: Prepare card for upsert
            if (shouldUpsert) {
              final gameSpecificData = Map<String, dynamic>.from(
                card.gameSpecificData ?? {},
              );
              if (gameSpecificData['family'] != null &&
                  gameSpecificData['family'] is String) {
                gameSpecificData['family'] =
                    (gameSpecificData['family'] as String)
                        .split('/')
                        .map((f) => f.trim())
                        .toList();
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
          // Step 10: Upsert cards to Supabase
          if (cardsToUpsert.isNotEmpty) {
            await _supabaseDataSource.upsertCards(cardsToUpsert);
            developer.log('Upserted ${cardsToUpsert.length} cards to Supabase');
          }
        } catch (e) {
          developer.log('Background upsert error: $e');
        }
      });
      // Step 11: Return API cards
      return apiCards;
    } catch (e) {
      developer.log('Error in getCardsUploadCards: $e');
      throw Exception('Error syncing One Piece cards: $e');
    }
  }

  // FUNC 5: Fetch single card from API by ID or game code
  Future<TCGCard?> getCardFromAPI({required String idOrGameCode}) async {
    try {
      // Step 1: Load environment variables & API
      await _loadEnv();
      final apiKey = dotenv.env['API_TCG_KEY'];
      if (apiKey == null) {
        developer.log('API_TCG_KEY not found in assets/.env for One Piece');
        throw Exception('API_TCG_KEY not found in assets/.env');
      }
      // Step 2: Normalize ID
      final apiId = idOrGameCode.startsWith('onepiece-')
          ? idOrGameCode.replaceFirst('onepiece-', '')
          : idOrGameCode;
      // Step 3: Build API URI with ID
      final uri = Uri.parse(
        '$_baseUrl/$_gamePath/cards',
      ).replace(queryParameters: {'id': apiId, 'limit': '1'});
      // Step 4: Send GET request
      final response = await http.get(uri, headers: {'x-api-key': apiKey});
      developer.log('API Request for One Piece getCardFromAPI: $uri');
      // Step 5: Check response status
      if (response.statusCode == 200) {
        // Step 6a: Parse JSON response
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['data'] == null) return null;

        // Step 7a: Extract card JSON
        Map<String, dynamic> cardJson;
        if (json['data'] is List<dynamic>) {
          final list = json['data'] as List<dynamic>;
          if (list.isEmpty) return null;
          cardJson = list.first as Map<String, dynamic>;
        } else if (json['data'] is Map<String, dynamic>) {
          cardJson = json['data'] as Map<String, dynamic>;
        } else {
          throw Exception(
            'Unexpected data format: ${json['data'].runtimeType}',
          );
        }
        // Step 8a: Parse and return card
        return _parseCard(cardJson);
      } else {
        String errorMessage =
            'Failed to load One Piece card: ${response.statusCode} - ${response.body}';
        try {
          final errorJson = jsonDecode(response.body) as Map<String, dynamic>;
          errorMessage =
              'Failed to load One Piece card: ${response.statusCode} - ${errorJson['message'] ?? response.body}';
        } catch (_) {}
        // Step 6b: Throw error
        throw Exception(errorMessage);
      }
    } catch (e) {
      developer.log('Error fetching One Piece card with ID $idOrGameCode: $e');
      return null;
    }
  }

  // FUNC 6: Fetch single card from Supabase by ID or game code
  Future<TCGCard?> getCardFromSupabase({
    required String idOrGameCode,
    String? version,
  }) async {
    try {
      // Step 1: Check if input is UUID
      final isUuid = RegExp(
        r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
      ).hasMatch(idOrGameCode);
      // Step 2: Initialize row variable
      Map<String, dynamic>? row;

      // Step 3: Query by ID if UUID
      if (isUuid) {
        row = await _supabaseDataSource.supabase
            .from('cards')
            .select()
            .eq('id', idOrGameCode)
            .eq('game_type', 'onepiece')
            .maybeSingle();
      } else {
        // Step 4: Normalize game code and query by game code
        final base = _baseGameCode(idOrGameCode);
        var query = _supabaseDataSource.supabase
            .from('cards')
            .select()
            .eq('game_type', 'onepiece')
            .eq('game_code', base);
        // Step 5: Apply version filter if provided
        if (version != null && version.isNotEmpty) {
          query = query.eq('version', version);
        } else {
          // Fallback: sort by version and updated_at if no version specified
          // Chain .order() calls directly without reassigning to query
        }
        final list = await query
            .order('version', ascending: true, nullsFirst: false)
            .order('updated_at', ascending: false)
            .limit(1);
        if (list is List && list.isNotEmpty) {
          row = Map<String, dynamic>.from(list.first);
        }
      }
      // Step 6: Return null if no row found
      if (row == null) {
        developer.log(
          'No One Piece card found in Supabase for key: $idOrGameCode, version: ${version ?? 'not specified'}',
        );
        return null;
      }
      // Step 7: Normalize game-specific data
      final data = Map<String, dynamic>.from(row);
      final gsd = data['game_specific_data'];
      if (gsd is String) {
        try {
          data['game_specific_data'] = jsonDecode(gsd);
        } catch (_) {}
      }
      // Step 8: Parse and return card
      final card = TCGCard.fromJson(data);
      developer.log(
        'Fetched card from Supabase: ${card.name}, version: ${card.version}, image_ref_large: ${card.imageRefLarge}',
      );
      return card;
    } catch (e) {
      developer.log('Error fetching One Piece card from Supabase: $e');
      return null;
    }
  }

  // FUNC 7: Retrieve card from cached API cards
  TCGCard? getCardFromAPICards({
    String? idOrGameCode,
    String? gameCode,
    String? id,
  }) {
    try {
      // Step 1: Validate input key
      final key = idOrGameCode ?? gameCode ?? id;
      if (key == null || key.isEmpty) {
        throw ArgumentError('Provide idOrGameCode or gameCode or id');
      }
      // Step 2: Normalize key with prefix
      final normalizedKeyId = key.startsWith('onepiece-')
          ? key
          : 'onepiece-$key';

      // Step 3: Search cache by ID
      final direct = _cachedCards.where(
        (c) => c.id == key || c.id == normalizedKeyId,
      );
      if (direct.isNotEmpty) return direct.first;

      // Step 4: Search cache by base game code
      final base = _baseGameCode(key);
      for (final c in _cachedCards) {
        final cBase = _baseGameCode(c.gameCode ?? '');
        if (cBase == base) return c;
      }
      // Step 5: Return null if not found
      return null;
    } catch (e) {
      developer.log('Error retrieving One Piece card from cache: $e');
      return null;
    }
  }

  // COMP 1: Normalize game code by removing prefixes and version suffixes
  String _baseGameCode(String raw) {
    // Step 1: Remove 'onepiece-' prefix
    final stripped = raw.startsWith('onepiece-') ? raw.substring(9) : raw;
    // Step 2: Remove version suffix
    final underscore = stripped.indexOf('_');
    // Step 3: Return base code
    return underscore == -1 ? stripped : stripped.substring(0, underscore);
  }

  // COMP 2: Parse JSON into TCGCard object
  TCGCard _parseCard(Map<String, dynamic> json) {
    // Step 1: Generate card ID
    final cardId =
        'onepiece-${json['id'] ?? 'unknown-${DateTime.now().millisecondsSinceEpoch}'}';
    // Step 2: Create game-specific data map
    final gameSpecificData = Map<String, dynamic>.from(json)
      ..remove('id')
      ..remove('name')
      ..remove('rarity')
      ..remove('set')
      ..remove('images');
    // Step 3: Normalize type field
    if (json['cardType'] != null) {
      gameSpecificData['type'] = json['cardType'];
    } else if (json['types'] != null && json['types'] is List) {
      gameSpecificData['type'] = (json['types'] as List).join(', ');
    } else if (json['type'] != null) {
      gameSpecificData['type'] = json['type'];
    }

    // Step 4: Normalize family field
    if (json['family'] != null && json['family'] is String) {
      gameSpecificData['family'] = (json['family'] as String)
          .split('/')
          .map((f) => f.trim())
          .toList();
    }

    // Step 5: Create and return TCGCard
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

  // Fetch current user's cards
  Future<List<TCGCard>> getUserCards({GameType? gameType}) async {
    try {
      var query = _supabaseDataSource.supabase
          .from('user_cards')
          .select('*, cards(*)')
          .eq('user_id', _supabaseDataSource.supabase.auth.currentUser!.id);
      if (gameType != null) {
        query = query.eq(
          'cards.game_type',
          gameType.apiPath.replaceAll('-', ''),
        );
      }
      final response = await query;
      final cards = response.map((row) {
        final cardData = row['cards'] as Map<String, dynamic>;
        final gsd = cardData['game_specific_data'];
        if (gsd is String) {
          try {
            cardData['game_specific_data'] = jsonDecode(gsd);
          } catch (_) {}
        }
        return TCGCard(
          id: cardData['id'],
          gameCode: cardData['game_code'],
          name: cardData['name'],
          setName: cardData['set_name'],
          rarity: cardData['rarity'],
          imageRefSmall: cardData['image_ref_small'],
          imageRefLarge: cardData['image_ref_large'],
          gameType: cardData['game_type'],
          imageEmbedding: null,
          textEmbedding: null,
          gameSpecificData: {
            ...?cardData['game_specific_data'],
            'quantity': row['quantity'],
            'favorite': row['favorite'],
            'labels': List<String>.from(row['labels'] ?? []),
          },
        );
      }).toList();
      developer.log(
        'Fetched ${cards.length} user cards${gameType != null ? ' for gameType ${gameType.apiPath}' : ''}',
      );
      return cards;
    } catch (e) {
      developer.log('Error fetching user cards: $e');
      throw Exception('Error fetching user cards: $e');
    }
  }

  // Add card to current user's collection
  Future<void> addCardToUserCollection(String cardId, int quantity) async {
    try {
      await _repository.addUserCard(cardId, quantity);
    } catch (e) {
      developer.log('Error adding card to collection: $e');
      throw Exception('Error adding card to collection: $e');
    }
  }

  // Update a user card's quantity, favorite, or labels
  Future<void> updateUserCardQuantity(
    String cardId,
    int quantity,
    bool favorite,
    List<String> labels,
  ) async {
    await _repository.updateUserCard(cardId, quantity, favorite, labels);
  }

  // Remove a card from user's collection
  Future<void> removeUserCard(String cardId) async {
    try {
      await _repository.deleteUserCard(cardId);
    } catch (e) {
      developer.log('Error removing user card: $e');
      throw Exception('Error removing user card: $e');
    }
  }
}

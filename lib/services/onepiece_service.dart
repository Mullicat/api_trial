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

  // Single API call
  Future<List<dynamic>> _requestCardsOnce(
    Map<String, String> params, {
    required String apiKey,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl/$_gamePath/cards',
    ).replace(queryParameters: params);
    developer.log('API Request One Piece: $uri');
    final response = await http.get(uri, headers: {'x-api-key': apiKey});
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
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return (json['data'] as List<dynamic>?) ?? const [];
  }

  // Extract code from enum display: e.g., "[OP03]" or "[OP-11]" -> "OP03"/"OP11"
  String? _extractNormalizedSetPrefix(String raw) {
    final m = RegExp(r'\[([A-Za-z0-9\-]+)\]').firstMatch(raw);
    if (m == null) return null;
    var code = m.group(1)!.toUpperCase().replaceAll('-', '');
    final op = RegExp(r'^OP(\d+)$').firstMatch(code);
    if (op != null) {
      final digits = op.group(1)!;
      if (digits.length == 1) code = 'OP0$digits';
    }
    return code;
  }

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
      base['page'] = page.toString();
      base['limit'] = (pageSize > 100 ? 100 : pageSize).toString();

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

      if (trigger == Trigger.noTrigger) {
        for (final p in variants) {
          p['trigger'] = '';
        }
      } else if (trigger == Trigger.hasTrigger) {
        for (final p in variants) {
          p['trigger'] = '*';
        }
      }

      List<dynamic> cardsJson = const [];
      for (final params in variants) {
        cardsJson = await _requestCardsOnce(params, apiKey: apiKey);
        if (cardsJson.isNotEmpty) break;
      }

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
      final parsed = cardsJson
          .map((c) => _parseCard(c as Map<String, dynamic>))
          .toList();

      _cachedCards = parsed;

      List<TCGCard> result = parsed;
      if (appliedClientTrigger && trigger == Trigger.hasTrigger) {
        result = parsed.where((card) {
          final t = card.gameSpecificData?['trigger'];
          final s = (t == null) ? '' : t.toString().trim();
          return s.isNotEmpty;
        }).toList();
      }

      developer.log('Cards returned (post-filter): ${result.length}');
      return result;
    } catch (e) {
      developer.log('Error fetching One Piece cards from API: $e');
      throw Exception('Error fetching One Piece cards: $e');
    }
  }

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

      return normalized;
    } catch (e) {
      developer.log('Error fetching One Piece cards from Supabase: $e');
      throw Exception('Error fetching One Piece cards from Supabase: $e');
    }
  }

  /// NEW: Search by game_code in Supabase (One Piece), using the base code (ignores any local "_version" suffixes).
  Future<List<TCGCard>> getCardsByGameCodeFromDatabase({
    required String gameCode,
  }) async {
    try {
      final base = _baseGameCode(gameCode);
      final rows = await _supabaseDataSource.fetchOnePieceCardsByGameCode(base);
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
      return normalized;
    } catch (e) {
      developer.log('Error fetching by game code from Supabase: $e');
      throw Exception('Error fetching by game code: $e');
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

      // Background upsert
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

  Future<TCGCard?> getCardFromAPI({required String idOrGameCode}) async {
    try {
      await _loadEnv();
      final apiKey = dotenv.env['API_TCG_KEY'];
      if (apiKey == null) {
        developer.log('API_TCG_KEY not found in assets/.env for One Piece');
        throw Exception('API_TCG_KEY not found in assets/.env');
      }

      final apiId = idOrGameCode.startsWith('onepiece-')
          ? idOrGameCode.replaceFirst('onepiece-', '')
          : idOrGameCode;

      final uri = Uri.parse(
        '$_baseUrl/$_gamePath/cards',
      ).replace(queryParameters: {'id': apiId, 'limit': '1'});
      final response = await http.get(uri, headers: {'x-api-key': apiKey});
      developer.log('API Request for One Piece getCardFromAPI: $uri');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        if (json['data'] == null) return null;

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
      developer.log('Error fetching One Piece card with ID $idOrGameCode: $e');
      return null;
    }
  }

  Future<TCGCard?> getCardFromSupabase({required String idOrGameCode}) async {
    try {
      final isUuid = RegExp(
        r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
      ).hasMatch(idOrGameCode);

      Map<String, dynamic>? row;

      if (isUuid) {
        row = await _supabaseDataSource.supabase
            .from('cards')
            .select()
            .eq('id', idOrGameCode)
            .eq('game_type', 'onepiece')
            .maybeSingle();
      } else {
        final base = _baseGameCode(idOrGameCode);
        final list = await _supabaseDataSource.supabase
            .from('cards')
            .select()
            .eq('game_type', 'onepiece')
            .eq('game_code', base)
            .order('version', ascending: true, nullsFirst: false)
            .order('updated_at', ascending: false)
            .limit(1);

        if (list is List && list.isNotEmpty) {
          row = Map<String, dynamic>.from(list.first);
        }
      }

      if (row == null) {
        developer.log(
          'No One Piece card found in Supabase for key: $idOrGameCode',
        );
        return null;
      }

      final data = Map<String, dynamic>.from(row);
      final gsd = data['game_specific_data'];
      if (gsd is String) {
        try {
          data['game_specific_data'] = jsonDecode(gsd);
        } catch (_) {}
      }

      return TCGCard.fromJson(data);
    } catch (e) {
      developer.log('Error fetching One Piece card from Supabase: $e');
      return null;
    }
  }

  TCGCard? getCardFromAPICards({
    String? idOrGameCode,
    String? gameCode,
    String? id,
  }) {
    try {
      final key = idOrGameCode ?? gameCode ?? id;
      if (key == null || key.isEmpty) {
        throw ArgumentError('Provide idOrGameCode or gameCode or id');
      }

      final normalizedKeyId = key.startsWith('onepiece-')
          ? key
          : 'onepiece-$key';
      final direct = _cachedCards.where(
        (c) => c.id == key || c.id == normalizedKeyId,
      );
      if (direct.isNotEmpty) return direct.first;

      final base = _baseGameCode(key);
      for (final c in _cachedCards) {
        final cBase = _baseGameCode(c.gameCode ?? '');
        if (cBase == base) return c;
      }
      return null;
    } catch (e) {
      developer.log('Error retrieving One Piece card from cache: $e');
      return null;
    }
  }

  String _baseGameCode(String raw) {
    final stripped = raw.startsWith('onepiece-') ? raw.substring(9) : raw;
    final underscore = stripped.indexOf('_');
    return underscore == -1 ? stripped : stripped.substring(0, underscore);
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

    if (json['family'] != null && json['family'] is String) {
      gameSpecificData['family'] = (json['family'] as String)
          .split('/')
          .map((f) => f.trim())
          .toList();
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

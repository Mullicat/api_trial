// lib/services/catalog_yugioh_api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../models/card.dart'; // Use new TCGCard model

List<TCGCard> parseCards(String body) {
  final root = jsonDecode(body);
  if (root is Map<String, dynamic>) {
    if (root['error'] != null) {
      throw Exception(root['error']);
    }
    final data = root['data'];
    if (data is List) {
      return data.whereType<Map<String, dynamic>>().map((cardJson) {
        // Map Yu-Gi-Oh! API fields to TCGCard model
        final cardId =
            'yugioh-${cardJson['id'] ?? 'unknown-${DateTime.now().millisecondsSinceEpoch}'}';
        final gameSpecificData = <String, dynamic>{
          'type': cardJson['type'],
          'desc': cardJson['desc'],
          'atk': cardJson['atk'],
          'def': cardJson['def'],
          'level': cardJson['level'],
          'race': cardJson['race'],
          'attribute': cardJson['attribute'],
          'card_images': cardJson['card_images'],
          'card_sets': cardJson['card_sets'],
          'archetype': cardJson['archetype'],
          'banlist_info': cardJson['banlist_info'],
          'card_prices': cardJson['card_prices'],
        }..removeWhere((key, value) => value == null); // Remove null values
        return TCGCard(
          id: cardId,
          gameCode: cardJson['id']?.toString() ?? cardId,
          name: cardJson['name'] ?? 'Unknown Card',
          gameType: 'yugioh',
          setName: (cardJson['card_sets'] as List<dynamic>?)?.isNotEmpty == true
              ? cardJson['card_sets'][0]['set_name']
              : null,
          rarity: (cardJson['card_sets'] as List<dynamic>?)?.isNotEmpty == true
              ? cardJson['card_sets'][0]['set_rarity']
              : null,
          imageRefSmall:
              (cardJson['card_images'] as List<dynamic>?)?.isNotEmpty == true
              ? cardJson['card_images'][0]['image_url']
              : null,
          imageRefLarge:
              (cardJson['card_images'] as List<dynamic>?)?.isNotEmpty == true
              ? cardJson['card_images'][0]['image_url']
              : null,
          imageEmbedding: null, // Defer generation
          textEmbedding: null, // Defer generation
          gameSpecificData: cardJson.isEmpty ? null : gameSpecificData,
        );
      }).toList();
    }
  }
  return const [];
}

class CardApi {
  static const String host = 'db.ygoprodeck.com';
  static const String path = '/api/v7/cardinfo.php';

  Future<TCGCard?> getCard(String id) async {
    final params = <String, String>{'id': id};
    final uri = Uri.http(host, path, params);
    final response = await http.get(uri).timeout(const Duration(seconds: 20));
    if (response.statusCode == 200) {
      final cards = parseCards(response.body);
      return cards.isNotEmpty ? cards.first : null;
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  static Future<List<TCGCard>> getCards({
    String? name,
    List<int>? ids,
    int? konamiId,
    String? fname,
    List<String>? types,
    List<String>? races,
    List<String>? attributes,
    String? atk,
    String? def,
    String? level,
    String? link,
    List<String>? linkmarkers,
    String? scale,
    String? cardset,
    String? archetype,
    String? banlist,
    String? sort,
    String? format,
    bool? misc,
    bool? staple,
    bool? hasEffect,
    bool? useTcgplayerData,
    DateTime? startDate,
    DateTime? endDate,
    String? dateRegion,
    int? num,
    int? offset,
    Map<String, String>? extra,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    String fmt(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';

    final params = <String, String>{
      if (name?.isNotEmpty == true) 'name': name!,
      if (ids != null && ids.isNotEmpty) 'id': ids.join(','),
      if (konamiId != null) 'konami_id': '$konamiId',
      if (fname?.isNotEmpty == true) 'fname': fname!,
      if (types != null && types.isNotEmpty) 'type': types.join(','),
      if (races != null && races.isNotEmpty) 'race': races.join(','),
      if (attributes != null && attributes.isNotEmpty)
        'attribute': attributes.join(','),
      if (atk?.isNotEmpty == true) 'atk': atk!,
      if (def?.isNotEmpty == true) 'def': def!,
      if (level?.isNotEmpty == true) 'level': level!,
      if (link?.isNotEmpty == true) 'link': link!,
      if (linkmarkers != null && linkmarkers.isNotEmpty)
        'linkmarker': linkmarkers.join(','),
      if (scale?.isNotEmpty == true) 'scale': scale!,
      if (cardset?.isNotEmpty == true) 'cardset': cardset!,
      if (archetype?.isNotEmpty == true) 'archetype': archetype!,
      if (banlist?.isNotEmpty == true) 'banlist': banlist!,
      if (sort?.isNotEmpty == true) 'sort': sort!,
      if (format?.isNotEmpty == true) 'format': format!,
      if (misc == true) 'misc': 'yes',
      if (staple == true) 'staple': 'yes',
      if (hasEffect != null) 'has_effect': hasEffect.toString(),
      if (useTcgplayerData == true) 'tcgplayer_data': '1',
      if (startDate != null) 'startdate': fmt(startDate),
      if (endDate != null) 'enddate': fmt(endDate),
      if (dateRegion?.isNotEmpty == true) 'dateregion': dateRegion!,
      if (num != null) 'num': '$num',
      if (offset != null) 'offset': '$offset',
      if (extra != null) ...extra,
    };

    final uri = Uri.http(host, path, params);

    final response = await http.get(uri).timeout(timeout);
    if (response.statusCode == 200) {
      return parseCards(response.body);
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
    }
  }

  static Future<List<TCGCard>> getAll() => getCards();

  static Future<List<TCGCard>> cardByName(String name) => getCards(name: name);

  static Future<List<TCGCard>> cardByFuzzyName(
    String text, {
    int limit = 20,
    int offset = 0,
  }) => getCards(fname: text, num: limit, offset: offset);
}

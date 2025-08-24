import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../models/card_model_yugioh.dart';

List<Card> parseCards(String body) {
  final root = jsonDecode(body);
  if (root is Map<String, dynamic>) {
    if (root['error'] != null) {
      throw Exception(root['error']);
    }
    final data = root['data'];
    if (data is List) {
      return data.whereType<Map<String, dynamic>>().map(Card.fromJson).toList();
    }
  }
  return const [];
}

class CardApi {
  static const String host = 'db.ygoprodeck.com';
  static const String path = '/api/v7/cardinfo.php';

  static Future<List<Card>> getCards({
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

    // raw pass-through (advanced)
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

  //Funciones de filtrado rapido

  Future<List<Card>> getAll() => getCards();

  //Nombre exacto
  //Pareametros: Nombre -> Nombre completo de la carta
  Future<List<Card>> cardByName(String name) => getCards(name: name);

  //Nombre incompleto
  //Parametros: Nombre -> Nombre incompleto de la carta limit -> Limite de resultados offset -> Desplazamiento de resultados
  Future<List<Card>> cardByFuzzyName(
    String text, {
    int limit = 20,
    int offset = 0,
  }) => getCards(fname: text, num: limit, offset: offset);
}

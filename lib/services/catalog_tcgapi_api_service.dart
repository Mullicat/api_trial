import "package:http/http.dart" as http;
import "dart:convert";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "../models/card_model_tcgapi.dart";

//Non-functional
class CatalogApiService {
  static Future<void> _loadEnv() async {
    await dotenv.load(fileName: "assets/.env");
  }

  Future<List<Card>> fetchCards(
    int groupId, {
    String? search,
    int? page,
    String? sortBy,
    String? sortOrder,
    String? rarity,
  }) async {
    await _loadEnv();

    final apiKey = dotenv.env['TCG_API_KEY'];
    if (apiKey == null) {
      throw Exception('API key not found in TCG .env');
    }

    final queryParams = {
      if (search != null) 'search': search,
      if (page != null) 'page': page.toString(),
      if (sortBy != null) 'sortBy': sortBy,
      if (sortOrder != null) 'sortOrder': sortOrder,
      if (rarity != null) 'rarity': rarity,
    };
    final uri = Uri.parse(
      'https://api.tcgapis.com/api/v1/cards/$groupId',
    ).replace(queryParameters: queryParams);

    try {
      final response = await http.get(uri, headers: {'x-api-key': apiKey});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final cardsJson = data['data'] as List<dynamic>;

        return cardsJson.map((json) {
          return Card(
            name: json['name'] as String,
            rarity: json['rarity'] as String,
          );
        }).toList();
      } else {
        throw Exception(
          'Failed to load cards: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching cards: $e');
    }
  }
}

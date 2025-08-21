import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as developer;
import '../services/catalog_pokemontcg_api_service.dart';
import '../models/card_model_pokemon.dart' as model;

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<model.Card>? _cards;
  model.Card? _singleCard;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await dotenv.load(fileName: "assets/.env");
      final tcgService = PokemonTcgService();
      final cards = await tcgService.searchCards(
        page: 1,
        pageSize: 14,
        q: 'set.name:generations',
        orderBy: '-set.releaseDate',
      );
      final card = await tcgService.getCard('xy1-1');
      developer.log('getCard result for xy1-1: $card');

      if (!mounted) return;

      setState(() {
        _cards = cards;
        _singleCard = card;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching data: $e';
      });
      developer.log('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Text(_errorMessage!, style: const TextStyle(fontSize: 16)),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _cards?.length ?? 0,
                    itemBuilder: (context, index) {
                      final card = _cards![index];
                      return ListTile(
                        leading: card.images?.small != null
                            ? Image.network(
                                card.images!.small!,
                                width: 50,
                                height: 70,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image_not_supported, size: 50),
                        title: Text(card.name ?? 'No Name'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rarity: ${card.rarity ?? 'Unknown'}, HP: ${card.hp ?? 'N/A'}',
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _singleCard != null
                        ? 'Single Card: ${_singleCard!.name ?? 'No Name'}, Rarity: ${_singleCard!.rarity ?? 'Unknown'}'
                        : 'No single card found',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
    );
  }
}

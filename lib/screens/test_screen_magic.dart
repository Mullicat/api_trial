// lib/screens/test_screen_magic.dart
import 'package:api_trial/enums/game_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as developer;
import '../services/catalog_magic_api_service.dart';
import '../models/card_model_magic.dart' as model;
import './test_screen_single.dart';

class TestScreenMagic extends StatefulWidget {
  const TestScreenMagic({super.key});

  @override
  State<TestScreenMagic> createState() => _TestScreenMagicState();
}

class _TestScreenMagicState extends State<TestScreenMagic> {
  List<model.MagicCard>? _cards;
  bool _isLoading = false;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    await _fetchCards(name: null);
  }

  Future<void> _fetchCards({String? name}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await dotenv.load(fileName: 'assets/.env');
      final tcgService = MagicTcgService();
      final cards = await tcgService.getCards(pageSize: 20, name: name);
      developer.log('Cards fetched: ${cards.length}');

      if (!mounted) return;

      setState(() {
        _cards = cards;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching cards: $e';
      });
      developer.log('Error fetching cards: $e');
    }
  }

  Future<void> _fetchSingleCard(String multiverseid) async {
    if (multiverseid.isEmpty) {
      setState(() {
        _errorMessage = 'Invalid card ID';
      });
      developer.log('Error: multiverseid is empty');
      return;
    }

    try {
      developer.log(
        'Navigating to TestScreenMagicSingle with multiverseid: $multiverseid',
      );
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TestScreenSingle(id: multiverseid, gameType: GameType.magic),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error navigating to card details: $e';
      });
      developer.log('Error navigating to card details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Magic: The Gathering API Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading
                ? null
                : () => _fetchCards(
                    name: _searchController.text.isEmpty
                        ? null
                        : _searchController.text,
                  ),
            tooltip: 'Refresh Cards',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Card Name',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _isLoading
                      ? null
                      : () => _fetchCards(
                          name: _searchController.text.isEmpty
                              ? null
                              : _searchController.text,
                        ),
                ),
              ),
              onSubmitted: (value) =>
                  _fetchCards(name: value.isEmpty ? null : value),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => _fetchCards(
                            name: _searchController.text.isEmpty
                                ? null
                                : _searchController.text,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _cards == null || _cards!.isEmpty
                ? const Center(
                    child: Text(
                      'No cards found. Try adjusting your search.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: _cards!.length,
                    itemBuilder: (context, index) {
                      final card = _cards![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: card.imageUrl != null
                              ? Image.network(
                                  card.imageUrl!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                )
                              : const Icon(Icons.image_not_supported),
                          title: Text(card.name ?? 'No Name'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Type: ${card.type ?? 'Unknown'}'),
                              Text('Rarity: ${card.rarity ?? 'Unknown'}'),
                              Text('CMC: ${card.cmc?.toString() ?? 'N/A'}'),
                              Text('Mana Cost: ${card.manaCost ?? 'N/A'}'),
                            ],
                          ),
                          onTap: () => _fetchSingleCard(
                            card.multiverseid?.toString() ?? '',
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

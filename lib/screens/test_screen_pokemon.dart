// lib/screens/test_screen_pokemon.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as developer;
import '../services/catalog_pokemontcg_api_service.dart';
import '../models/card.dart'; // Updated to use TCGCard model
import './test_screen_single.dart';
import '../constants/enums/game_type.dart'; // Fixed import path

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<TCGCard>? _cards;
  bool _isLoading = false;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  final Map<String, String> _filters = {};

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
    await _fetchCards();
  }

  Future<void> _fetchCards() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await dotenv.load(fileName: 'assets/.env');
      final tcgService = PokemonTcgService();
      final filters = Map<String, String>.from(_filters);
      if (_searchController.text.isNotEmpty) {
        filters['name'] = _searchController.text;
      }
      final cards = await tcgService.searchCards(
        page: 1,
        pageSize: 14,
        filters: filters,
        orderBy: '-set.releaseDate',
      );
      developer.log('Cards fetched: ${cards.length} with filters: $filters');

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

  Future<void> _fetchSingleCard(String gameCode) async {
    if (gameCode.isEmpty) {
      setState(() {
        _errorMessage = 'Invalid card ID';
      });
      developer.log('Error: gameCode is empty');
      return;
    }

    try {
      developer.log('Navigating to TestScreenSingle with gameCode: $gameCode');
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TestScreenSingle(id: gameCode, gameType: GameType.pokemon),
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

  // Predefined options for dropdowns based on Pokémon TCG API
  final Map<String, List<String>> _parameterOptions = {
    'rarity': [
      'None',
      'Common',
      'Uncommon',
      'Rare',
      'Rare Holo',
      'Rare Ultra',
      'Rare Secret',
    ],
    'types': [
      'None',
      'Grass',
      'Fire',
      'Water',
      'Lightning',
      'Psychic',
      'Fighting',
      'Darkness',
      'Metal',
      'Fairy',
      'Dragon',
    ],
    'subtypes': [
      'None',
      'Basic',
      'Stage 1',
      'Stage 2',
      'V',
      'VMAX',
      'EX',
      'Mega',
      'GX',
      'Break',
      'Prism Star',
    ],
    'set.id': [
      'None',
      'base1',
      'base2',
      'sm1',
      'xy1',
      'swsh1',
      'sv1',
    ], // Example set IDs
    'hp': ['None', '[* TO 50]', '[50 TO 100]', '[100 TO 150]', '[150 TO *]'],
    'nationalPokedexNumbers': [
      'None',
      '[1 TO 151]',
      '[152 TO 251]',
      '[252 TO 386]',
      '[387 TO *]',
    ],
    'legalities.standard': ['None', 'Legal', 'Banned'],
  };

  // Free-text parameters that open a dialog directly
  final List<String> _freeTextParams = ['text', 'flavor', 'artist', 'number'];

  // Build filter bar with dropdown buttons and free-text buttons
  Widget _buildFilterBar() {
    return Row(
      children: [
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Dropdown buttons for non-free-text parameters
                ..._parameterOptions.keys.map((param) {
                  final isActive =
                      _filters.containsKey(param) && _filters[param] != 'None';
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: PopupMenuButton<String>(
                      onSelected: (value) async {
                        setState(() {
                          if (value == 'None') {
                            _filters.remove(param);
                          } else {
                            _filters[param] = value;
                          }
                        });
                        await _fetchCards();
                      },
                      itemBuilder: (context) => _parameterOptions[param]!
                          .map(
                            (option) => PopupMenuItem<String>(
                              value: option,
                              child: Text(option),
                            ),
                          )
                          .toList(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          param,
                          style: TextStyle(
                            color: isActive ? Colors.blue : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
                // Buttons for free-text parameters
                ..._freeTextParams.map((param) {
                  final isActive =
                      _filters.containsKey(param) &&
                      _filters[param]!.isNotEmpty;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: GestureDetector(
                      onTap: () => _showTextInputDialog(param),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          param,
                          style: TextStyle(
                            color: isActive ? Colors.blue : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextButton(
            onPressed: () {
              setState(() {
                _filters.clear();
                _searchController.clear();
              });
              _fetchCards();
            },
            child: const Text('Clear Filters'),
          ),
        ),
      ],
    );
  }

  // Show dialog for free-text parameters
  Future<void> _showTextInputDialog(String param) async {
    final controller = TextEditingController(text: _filters[param] ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter $param'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter $param value'),
          maxLines: 3, // Allow multi-line input for text and flavor
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _filters[param] = result;
      });
      await _fetchCards();
    } else if (result != null) {
      setState(() {
        _filters.remove(param);
      });
      await _fetchCards();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon TCG API Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : () => _fetchCards(),
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
                  onPressed: _isLoading ? null : () => _fetchCards(),
                ),
              ),
              onSubmitted: (value) => _fetchCards(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: _buildFilterBar(),
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
                          onPressed: () => _fetchCards(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _cards == null || _cards!.isEmpty
                ? const Center(
                    child: Text(
                      'No cards found. Try adjusting your search or filters.',
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
                          leading: card.imageRefSmall != null
                              ? Image.network(
                                  card.imageRefSmall!,
                                  width: 50,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image, size: 50),
                                )
                              : const Icon(Icons.image_not_supported, size: 50),
                          title: Text(card.name ?? 'No Name'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Rarity: ${card.rarity ?? 'Unknown'}'),
                              Text(
                                'HP: ${card.gameSpecificData?['hp']?.toString() ?? 'N/A'}',
                              ),
                            ],
                          ),
                          onTap: () {
                            if (card.gameCode != null) {
                              _fetchSingleCard(card.gameCode);
                            }
                          },
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

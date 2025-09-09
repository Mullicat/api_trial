// lib/screens/test_screen_magic.dart

import 'package:api_trial/constants/enums/game_type.dart';
import 'package:api_trial/models/card.dart'; // Updated to use new Card model
import 'package:api_trial/services/catalog_magic_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as developer;
import './test_screen_single.dart';

class TestScreenMagic extends StatefulWidget {
  const TestScreenMagic({super.key});

  @override
  State<TestScreenMagic> createState() => _TestScreenMagicState();
}

class _TestScreenMagicState extends State<TestScreenMagic> {
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
      final tcgService = MagicTcgService();
      final filters = Map<String, String>.from(_filters);
      if (_searchController.text.isNotEmpty) {
        filters['name'] = _searchController.text;
      }
      final cards = await tcgService.getCards(pageSize: 20, filters: filters);
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
              TestScreenSingle(id: gameCode, gameType: GameType.magic),
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

  final Map<String, List<String>> _parameterOptions = {
    'layout': [
      'None',
      'normal',
      'split',
      'flip',
      'double-faced',
      'token',
      'plane',
      'scheme',
      'phenomenon',
      'leveler',
      'vanguard',
      'aftermath',
    ],
    'cmc': ['None', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10'],
    'colors': ['None', 'White', 'Blue', 'Black', 'Red', 'Green'],
    'colorIdentity': ['None', 'W', 'U', 'B', 'R', 'G'],
    'type': [
      'None',
      'Instant',
      'Sorcery',
      'Artifact',
      'Creature',
      'Enchantment',
      'Land',
      'Planeswalker',
    ],
    'supertypes': ['None', 'Basic', 'Legendary', 'Snow', 'World', 'Ongoing'],
    'types': [
      'None',
      'Instant',
      'Sorcery',
      'Artifact',
      'Creature',
      'Enchantment',
      'Land',
      'Planeswalker',
    ],
    'subtypes': [
      'None',
      'Trap',
      'Arcane',
      'Equipment',
      'Aura',
      'Human',
      'Rat',
      'Squirrel',
    ],
    'rarity': [
      'None',
      'Common',
      'Uncommon',
      'Rare',
      'Mythic Rare',
      'Special',
      'Basic Land',
    ],
    'set': [
      'None',
      'LEA',
      '2ED',
      'ARN',
      'ATQ',
      'LEG',
      'DRK',
      'FEM',
      'ICE',
      'MIR',
    ],
    'setName': [
      'None',
      'Alpha',
      'Beta',
      'Arabian Nights',
      'Antiquities',
      'Legends',
    ],
    'power': ['None', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '1+*'],
    'toughness': [
      'None',
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '1+*',
    ],
    'loyalty': ['None', '1', '2', '3', '4', '5', '6', '7'],
    'language': ['None', 'English', 'Spanish', 'French', 'German', 'Italian'],
    'gameFormat': [
      'None',
      'Commander',
      'Standard',
      'Legacy',
      'Modern',
      'Vintage',
    ],
    'legality': ['None', 'Legal', 'Banned', 'Restricted'],
    'orderBy': [
      'None',
      'name',
      'set',
      'releaseDate',
      'cmc',
      'power',
      'toughness',
      'rarity',
    ],
    'contains': [
      'None',
      'imageUrl',
      'rulings',
      'foreignNames',
      'printings',
      'originalText',
      'originalType',
    ],
  };

  final List<String> _freeTextParams = ['text', 'flavor', 'artist', 'number'];

  Widget _buildFilterBar() {
    return Row(
      children: [
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
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

  Future<void> _showTextInputDialog(String param) async {
    final controller = TextEditingController(text: _filters[param] ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter $param'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter $param value'),
          maxLines: 3,
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
        title: const Text('Magic: The Gathering API Test'),
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
                          onPressed: _fetchCards,
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
                              Text(
                                'Type: ${card.gameSpecificData?['type']?.toString() ?? 'Unknown'}',
                              ),
                              Text('Rarity: ${card.rarity ?? 'Unknown'}'),
                              Text(
                                'CMC: ${card.gameSpecificData?['cmc']?.toString() ?? 'N/A'}',
                              ),
                              Text(
                                'Mana Cost: ${card.gameSpecificData?['manaCost']?.toString() ?? 'N/A'}',
                              ),
                            ],
                          ),
                          onTap: () => _fetchSingleCard(card.gameCode),
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

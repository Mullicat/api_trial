// lib/screens/test_screen_yugioh_like_pokemon.dart
/**
 * TestScreenYuGiOh - Yu-Gi-Oh! Card Search and Display Interface
 * 
 * This screen demonstrates advanced API integration with the YGOProDeck API,
 * featuring comprehensive filtering, searching, and sorting capabilities.
 * 
 * Key Features:
 * - Real-time card search by name (fuzzy search)
 * - Multiple filter types (attributes, types, races, archetypes)
 * - Sorting options (name, ATK, DEF, level, etc.)
 * - Responsive UI with loading states and error handling
 * - Horizontal filter bar with chip-based selection
 * - Navigation to TestScreenSingle for card details
 * 
 * Architecture Patterns:
 * - StatefulWidget for local state management
 * - Separation of concerns (UI logic vs API logic)
 * - Error handling with user-friendly messages
 * - Efficient API calls with conditional parameters
 * 
 * API Integration:
 * - Uses YGOProDeck public API (https://db.ygoprodeck.com/api/v7/cardinfo.php)
 * - Supports fuzzy name search, multi-parameter filtering
 * - Handles API errors and rate limiting gracefully
 */

import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import '../services/catalog_yugioh_api_service.dart';
import '../models/card.dart'; // Use new TCGCard model
import '../constants/enums/game_type.dart';
import './test_screen_single.dart';

class TestScreenYuGiOh extends StatefulWidget {
  const TestScreenYuGiOh({super.key});

  @override
  State<TestScreenYuGiOh> createState() => _TestScreenYuGiOhState();
}

class _TestScreenYuGiOhState extends State<TestScreenYuGiOh> {
  // =================================================================
  // CONSTANTS AND CONFIGURATION
  // =================================================================

  /// Number of cards to fetch per API call (pagination support)
  static const int _pageSize = 14;

  // =================================================================
  // STATE VARIABLES
  // =================================================================

  /// List of cards currently displayed (null = not loaded yet)
  List<TCGCard>? _cards;

  /// Whether an API call is currently in progress
  bool _isLoading = false;

  /// Current error message to display (null = no error)
  String? _errorMessage;

  // =================================================================
  // SEARCH AND FILTER STATE
  // =================================================================

  /// Text controller for the search input field
  final TextEditingController _searchController = TextEditingController();

  /// Map storing single-select filter values (type, race, etc.)
  /// Key: filter name, Value: selected value
  final Map<String, String> _filters = {};

  /// Set storing multi-select attribute filters (LIGHT, DARK, etc.)
  final Set<String> _selectedAttributes = {};

  /// Currently selected sort option (null = no sorting)
  String? _sortBy;

  // =================================================================
  // LIFECYCLE METHODS
  // =================================================================

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // =================================================================
  // FILTER CONFIGURATION
  // =================================================================

  /// Yu-Gi-Oh card attributes (monster card properties)
  /// Used for multi-select filtering
  static const List<String> _attributes = [
    'LIGHT', // Light attribute monsters
    'DARK', // Dark attribute monsters
    'EARTH', // Earth attribute monsters
    'WATER', // Water attribute monsters
    'FIRE', // Fire attribute monsters
    'WIND', // Wind attribute monsters
    'DIVINE', // Divine attribute monsters (rare)
  ];

  final Map<String, List<String>> _parameterOptions = {
    'type': [
      'None',
      'Normal Monster',
      'Effect Monster',
      'Fusion Monster',
      'Ritual Monster',
      'Synchro Monster',
      'XYZ Monster',
      'Link Monster',
      'Pendulum Normal Monster',
      'Pendulum Effect Monster',
      'Spell Card',
      'Trap Card',
    ],

    'race': [
      'None',
      'Warrior',
      'Spellcaster',
      'Dragon',
      'Zombie',
      'Fiend',
      'Fairy',
      'Machine',
      'Aqua',
      'Pyro',
      'Rock',
      'Winged Beast',
      'Plant',
      'Insect',
      'Thunder',
      'Fish',
      'Sea Serpent',
      'Reptile',
      'Psychic',
      'Divine-Beast',
      'Wyrm',
      'Cyberse',
      'Dinosaur',
      'Beast',
      'Beast-Warrior',
      'Illusion',
    ],
  };

  final List<String> _freeTextParams = ['archetype'];

  static const Map<String, String> _sortOptions = {
    'name': 'Name (A→Z)',
    'atk': 'ATK',
    'def': 'DEF',
    'level': 'Level',
    'id': 'ID',
    'new': 'Newest',
  };

  // =================================================================
  // UTILITY METHODS
  // =================================================================

  String? _thumbOf(TCGCard c) {
    return c.imageRefSmall;
  }

  // =================================================================
  // API INTEGRATION METHODS
  // =================================================================

  Future<void> _fetchCards() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final q = _searchController.text.trim();
      final hasAttrs = _selectedAttributes.isNotEmpty;
      final hasFilters = _filters.entries.any(
        (e) => e.value.isNotEmpty && e.value != 'None',
      );
      final hasSort = _sortBy?.isNotEmpty == true;
      final hasAny = hasAttrs || hasFilters || hasSort || q.isNotEmpty;

      List<TCGCard> cards;

      if (!hasAny) {
        cards = await CardApi.getCards();
      } else {
        final extra = <String, String>{};
        _filters.forEach((k, v) {
          if (v.isNotEmpty && v != 'None') extra[k] = v;
        });
        if (_sortBy?.isNotEmpty == true) extra['sort'] = _sortBy!;

        developer.log(
          'YuGiOh fetch extra=$extra attrs=$_selectedAttributes fname=${q.isNotEmpty ? q : '(none)'}',
        );

        cards = await CardApi.getCards(
          fname: q.isNotEmpty ? q : null,
          attributes: _selectedAttributes.toList(),
          extra: extra,
          num: _pageSize,
          offset: 0,
        );
      }

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
      developer.log('YGO fetch error: $e');
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
              TestScreenSingle(id: gameCode, gameType: GameType.yugioh),
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

  // =================================================================
  // UI COMPONENT METHODS
  // =================================================================

  Widget _buildFilterBar() {
    return Row(
      children: [
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: PopupMenuButton<String>(
                    tooltip: 'Attributes',
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        enabled: false,
                        child: Text(
                          'Attributes',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      const PopupMenuDivider(),
                      ..._attributes.map((attr) {
                        final selected = _selectedAttributes.contains(attr);
                        return PopupMenuItem<String>(
                          value: attr,
                          child: Row(
                            children: [
                              Icon(
                                selected
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(attr),
                            ],
                          ),
                        );
                      }),
                      const PopupMenuDivider(),
                      const PopupMenuItem<String>(
                        value: '__clear_attrs__',
                        child: Text('Clear attributes'),
                      ),
                    ],
                    child: _ChipBox(
                      label: 'attributes',
                      active: _selectedAttributes.isNotEmpty,
                    ),
                    onSelected: (value) async {
                      setState(() {
                        if (value == '__clear_attrs__') {
                          _selectedAttributes.clear();
                        } else {
                          if (_selectedAttributes.contains(value)) {
                            _selectedAttributes.remove(value);
                          } else {
                            _selectedAttributes.add(value);
                          }
                        }
                      });
                      await _fetchCards();
                    },
                  ),
                ),
                ..._parameterOptions.entries.map((entry) {
                  final param = entry.key;
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
                      itemBuilder: (context) => entry.value
                          .map(
                            (opt) => PopupMenuItem<String>(
                              value: opt,
                              child: Text(opt),
                            ),
                          )
                          .toList(),
                      child: _ChipBox(label: param, active: isActive),
                    ),
                  );
                }),
                ..._freeTextParams.map((param) {
                  final isActive =
                      _filters.containsKey(param) &&
                      _filters[param]!.isNotEmpty;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: GestureDetector(
                      onTap: () => _showTextInputDialog(param),
                      child: _ChipBox(label: param, active: isActive),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            setState(() {
              _filters.clear();
              _selectedAttributes.clear();
              _sortBy = null;
              _searchController.clear();
            });
            await _fetchCards();
          },
          child: const Text('Clear Filters'),
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

    if (!mounted) return;

    if (result != null && result.isNotEmpty) {
      setState(() => _filters[param] = result);
      await _fetchCards();
    } else if (result != null) {
      setState(() => _filters.remove(param));
      await _fetchCards();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yu-Gi-Oh! API Test'),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Sort',
            icon: const Icon(Icons.sort),
            onSelected: (v) async {
              setState(() => _sortBy = v == 'None' ? null : v);
              await _fetchCards();
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                enabled: false,
                child: Text('Sort by'),
              ),
              const PopupMenuDivider(),
              ..._sortOptions.entries.map(
                (e) =>
                    PopupMenuItem<String>(value: e.key, child: Text(e.value)),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(value: 'None', child: Text('None')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchCards,
            tooltip: 'Refresh',
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
                  onPressed: _isLoading ? null : _fetchCards,
                ),
              ),
              onSubmitted: (_) => _fetchCards(),
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
                            color: Colors.red,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
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
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: _cards!.length,
                    itemBuilder: (context, index) {
                      final c = _cards![index];
                      final img = _thumbOf(c);
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: img != null
                              ? Image.network(
                                  img,
                                  width: 50,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, _, __) =>
                                      const Icon(Icons.broken_image, size: 50),
                                )
                              : const Icon(Icons.image_not_supported, size: 50),
                          title: Text(c.name ?? 'No Name'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (c.gameSpecificData?['type'] != null)
                                Text('Type: ${c.gameSpecificData!['type']}'),
                              if (c.gameSpecificData?['attribute'] != null)
                                Text(
                                  'Attribute: ${c.gameSpecificData!['attribute']}',
                                ),
                              if (c.gameSpecificData?['atk'] != null ||
                                  c.gameSpecificData?['def'] != null)
                                Text(
                                  'ATK/DEF: ${c.gameSpecificData?['atk'] ?? '-'} / ${c.gameSpecificData?['def'] ?? '-'}',
                                ),
                            ],
                          ),
                          onTap: () {
                            if (c.gameCode != null) {
                              _fetchSingleCard(c.gameCode);
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

// Small chip-like box used in the filter bar
class _ChipBox extends StatelessWidget {
  final String label;
  final bool active;
  const _ChipBox({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: active ? Colors.blue : Colors.grey),
        borderRadius: BorderRadius.circular(4.0),
        color: active ? Colors.blue.withOpacity(0.08) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? Colors.blue : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

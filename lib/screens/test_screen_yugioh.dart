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

// lib/screens/test_screen_yugioh_like_pokemon.dart
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import '../services/catalog_yugioh_api_service.dart';
import '../models/card_model_yugioh.dart' as model;

/**
 * TestScreenYuGiOh - Main widget class for Yu-Gi-Oh card browser
 * 
 * Uses StatefulWidget because it needs to manage:
 * - Search query state
 * - Filter selections
 * - Loading states
 * - API response data
 * - Error messages
 */

class TestScreenYuGiOh extends StatefulWidget {
  const TestScreenYuGiOh({super.key});

  @override
  State<TestScreenYuGiOh> createState() => _TestScreenYuGiOhState();
}

/**
 * _TestScreenYuGiOhState - State class containing all the logic and UI
 */
class _TestScreenYuGiOhState extends State<TestScreenYuGiOh> {
  // =================================================================
  // CONSTANTS AND CONFIGURATION
  // =================================================================

  /// Number of cards to fetch per API call (pagination support)
  static const int _pageSize = 14;

  // =================================================================
  // STATE VARIABLES
  // These track the current state of the screen
  // =================================================================

  /// List of cards currently displayed (null = not loaded yet)
  List<model.Card>? _cards;

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
    // Load all cards when screen first opens (no filters applied)
    _fetchCards();
  }

  @override
  void dispose() {
    // Clean up text controller to prevent memory leaks
    _searchController.dispose();
    super.dispose();
  }

  // =================================================================
  // FILTER CONFIGURATION
  // These define the available filter options for the API
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

  /*
   * Dropdown filter options mapping
   * 
   * Key: API parameter name
   * Value: List of selectable options for that parameter
   * 
   * IMPORTANT: These values must match exactly what the YGOProDeck API expects
   * Using incorrect values will result in 400 Bad Request errors
   */
  final Map<String, List<String>> _parameterOptions = {
    // Card type filter - determines what kind of card it is
    'type': [
      'None', // No filter applied
      'Normal Monster', // Basic monsters with no effects
      'Effect Monster', // Monsters with special abilities
      'Fusion Monster', // Extra Deck fusion monsters
      'Ritual Monster', // Special summoned with ritual spells
      'Synchro Monster', // Extra Deck synchro monsters
      'XYZ Monster', // Extra Deck XYZ monsters
      'Link Monster', // Extra Deck link monsters
      'Pendulum Normal Monster', // Pendulum monsters without effects
      'Pendulum Effect Monster', // Pendulum monsters with effects
      'Spell Card', // All spell cards
      'Trap Card', // All trap cards
    ],

    // Race filter - monster types or spell/trap subtypes
    'race': [
      'None', // No filter applied
      'Warrior', // Warrior-type monsters
      'Spellcaster', // Spellcaster-type monsters
      'Dragon', // Dragon-type monsters
      'Zombie', // Zombie-type monsters
      'Fiend', // Fiend-type monsters
      'Fairy', // Fairy-type monsters
      'Machine', // Machine-type monsters
      'Aqua', // Aqua-type monsters
      'Pyro', // Fire-type monsters
      'Rock', // Rock-type monsters
      'Winged Beast', // Flying creatures
      'Plant', // Plant-type monsters
      'Insect', // Bug-type monsters
      'Thunder', // Electric-type monsters
      'Fish', // Fish-type monsters
      'Sea Serpent', // Sea creature monsters
      'Reptile', // Reptile-type monsters
      'Psychic', // Psychic-type monsters
      'Divine-Beast', // Divine beast monsters
      'Wyrm', // Dragon-like creatures
      'Cyberse', // Digital/cyber monsters
      'Dinosaur', // Prehistoric monsters
      'Beast', // Animal-type monsters
      'Beast-Warrior', // Humanoid beast monsters
      'Illusion', // Illusion-type monsters
    ],
    // Additional filters can be added here (level, ATK, DEF ranges)
  };

  /*
   * Free-text parameter filters
   * 
   * These filters open a text input dialog instead of dropdown menu.
   * Used for parameters that accept free-form text input like archetype names.
   */
  final List<String> _freeTextParams = [
    'archetype', // Card archetype (e.g., "Blue-Eyes", "Dark Magician")
    // Additional text filters like 'level', 'atk', 'def' ranges could be added
  ];

  /*
   * Available sorting options
   * 
   * Key: API parameter value
   * Value: User-friendly display name
   * 
   * These control how the API returns the card results
   */
  static const Map<String, String> _sortOptions = {
    'name': 'Name (A→Z)', // Alphabetical by card name
    'atk': 'ATK', // By attack points (highest first)
    'def': 'DEF', // By defense points (highest first)
    'level': 'Level', // By card level/rank
    'id': 'ID', // By card ID number
    'new': 'Newest', // By release date (newest first)
  };

  // =================================================================
  // UTILITY METHODS
  // =================================================================

  /*
   * Extract thumbnail image URL from card data
   * 
   * @param c - Card model object
   * @return URL string for small image, or null if no image available
   * 
   * Prioritizes small images for better performance in list views
   * Falls back to full-size image if small version not available
   */
  String? _thumbOf(model.Card c) {
    if (c.cardImages.isEmpty) return null;
    return c.cardImages.first.imageUrlSmall ?? c.cardImages.first.imageUrl;
  }

  // =================================================================
  // API INTEGRATION METHODS
  // =================================================================

  /*
   * Fetch cards from YGOProDeck API with current search/filter parameters
   * 
   * This method implements intelligent API calling logic:
   * 1. If no search/filters are active, fetches ALL cards
   * 2. If search/filters are active, applies them to the API call
   * 3. Handles loading states and error messages
   * 4. Updates UI state when complete
   * 
   * The API call strategy optimizes for user experience:
   * - Empty state shows all cards (browsing mode)  
   * - Filtered state shows targeted results (search mode)
   */
  Future<void> _fetchCards() async {
    // Set loading state and clear any previous errors
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get current search query (trimmed to remove whitespace)
      final q = _searchController.text.trim();

      // Check if any filters/sorting are currently active
      final hasAttrs = _selectedAttributes.isNotEmpty;
      final hasFilters = _filters.entries.any(
        (e) => e.value.isNotEmpty && e.value != 'None',
      );
      final hasSort = _sortBy?.isNotEmpty == true;
      final hasAny = hasAttrs || hasFilters || hasSort || q.isNotEmpty;

      List<model.Card> cards;

      if (!hasAny) {
        // No search query and no filters = fetch ALL cards (browsing mode)
        // This gives users a starting point to explore the card database
        cards = await CardApi.getCards();
      } else {
        // Active filters/search = build targeted API call

        // Build parameter map for non-attribute filters (type, race, etc.)
        final extra = <String, String>{};
        _filters.forEach((k, v) {
          if (v.isNotEmpty && v != 'None') extra[k] = v;
        });

        // Add sort parameter if selected
        if (_sortBy?.isNotEmpty == true) extra['sort'] = _sortBy!;

        // Log the API call parameters for debugging
        developer.log(
          'YuGiOh fetch extra=$extra attrs=$_selectedAttributes fname=${q.isNotEmpty ? q : '(none)'}',
        );

        // Execute API call with all active parameters
        cards = await CardApi.getCards(
          // Fuzzy name search - only send if user entered search query
          fname: q.isNotEmpty ? q : null,
          // Multi-select attributes (LIGHT, DARK, etc.)
          attributes: _selectedAttributes.toList(),
          // Other filters and sorting
          extra: extra,
          // Pagination support
          num: _pageSize,
          offset:
              0, // Start from beginning (could be enhanced for infinite scroll)
        );
      }

      // Check if widget is still mounted before updating state
      // Prevents setState calls on disposed widgets
      if (!mounted) return;

      // Update UI with fetched cards
      setState(() {
        _cards = cards;
        _isLoading = false;
      });
    } catch (e) {
      // Handle API errors gracefully
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        // Provide user-friendly error message
        _errorMessage = 'Error fetching cards: $e';
      });

      // Log detailed error for debugging
      developer.log('YGO fetch error: $e');
    }
  }

  // =================================================================
  // UI COMPONENT METHODS
  // These methods build different parts of the user interface
  // =================================================================

  // Horizontal filters like your Pokémon screen
  Widget _buildFilterBar() {
    return Row(
      children: [
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Attributes multi-select (ChoiceChip-like menu)
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

                // Dropdown-like popup menus for type/race/etc.
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

                // Free-text params -> open dialog
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
          // Sort menu
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
          // Search box
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

          // Filters row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: _buildFilterBar(),
          ),

          // Results
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
                              if (c.type != null) Text('Type: ${c.type!}'),
                              if (c.attribute != null)
                                Text('Attribute: ${c.attribute!}'),
                              if (c.atk != null || c.def != null)
                                Text(
                                  'ATK/DEF: ${c.atk ?? '-'} / ${c.def ?? '-'}',
                                ),
                            ],
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(c.name ?? 'Card')),
                            );
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

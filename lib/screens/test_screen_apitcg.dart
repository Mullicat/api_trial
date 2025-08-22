// lib/test_screen_api_tcg.dart
import 'package:api_trial/enums/game_type.dart';
import 'package:api_trial/models/card_model_api_apitcg.dart';
import 'package:api_trial/services/catalog_apitcg_api_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import './test_screen_single.dart';
import 'package:api_trial/models/card_model_magic.dart';

class TestScreenApiTcg extends StatefulWidget {
  final GameType gameType;

  const TestScreenApiTcg({super.key, this.gameType = GameType.onePiece});

  @override
  State<TestScreenApiTcg> createState() => _TestScreenApiTcgState();
}

class _TestScreenApiTcgState extends State<TestScreenApiTcg> {
  final TcgService _service = TcgService();
  GameType _selectedGameType = GameType.onePiece;
  dynamic _cards;
  bool _isLoading = false;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  final Map<String, String> _filters = {};

  @override
  void initState() {
    super.initState();
    developer.log(
      'TestScreenApiTcg initState: gameType=${widget.gameType.name}',
    );
    _selectedGameType = widget.gameType;
    _fetchInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    developer.log('Fetching initial data for ${_selectedGameType.name}');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _cards = null;
      _filters.clear();
      _searchController.clear();
    });
    await _fetchCards();
  }

  Future<void> _fetchCards() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _cards = null;
    });

    try {
      developer.log(
        'Fetching cards for ${_selectedGameType.name} with filters: $_filters',
      );
      final filters = Map<String, String>.from(_filters);
      if (_searchController.text.isNotEmpty) {
        filters['name'] = _searchController.text;
      }
      switch (_selectedGameType) {
        case GameType.onePiece:
          _cards = await _service.getCards<OnePieceCard>(
            gameType: _selectedGameType,
            filters: filters,
            pageSize: 5,
          );
          break;
        case GameType.pokemon:
          _cards = await _service.getCards<PokemonCard>(
            gameType: _selectedGameType,
            filters: filters,
            pageSize: 5,
          );
          break;
        case GameType.dragonBall:
          _cards = await _service.getCards<DragonBallCard>(
            gameType: _selectedGameType,
            filters: filters,
            pageSize: 5,
          );
          break;
        case GameType.digimon:
          _cards = await _service.getCards<DigimonCard>(
            gameType: _selectedGameType,
            filters: filters,
            pageSize: 5,
          );
          break;
        case GameType.unionArena:
          _cards = await _service.getCards<UnionArenaCard>(
            gameType: _selectedGameType,
            filters: filters,
            pageSize: 5,
          );
          break;
        case GameType.gundam:
          _cards = await _service.getCards<GundamCard>(
            gameType: _selectedGameType,
            filters: filters,
            pageSize: 5,
          );
          break;
        case GameType.magic:
          _cards = await _service.getCards<MagicCard>(
            gameType: _selectedGameType,
            filters: filters,
            pageSize: 5,
          );
          break;
      }
      developer.log(
        'Cards fetched for ${_selectedGameType.name}: ${_cards?.length ?? 0}',
      );
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching cards: $e';
        developer.log('Error fetching cards: $e');
      });
    }
  }

  Future<void> _fetchSingleCard(String id) async {
    if (id.isEmpty) {
      setState(() {
        _errorMessage = 'Invalid card ID';
      });
      developer.log('Error: cardId is empty');
      return;
    }

    try {
      developer.log(
        'Navigating to TestScreenSingle with cardId: $id, gameType: ${_selectedGameType.name}',
      );
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TestScreenSingle(id: id, gameType: _selectedGameType),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error navigating to card details: $e';
        developer.log('Error navigating to card details: $e');
      });
    }
  }

  void _onGameSelected(GameType gameType) {
    developer.log('Game selected: ${gameType.name}');
    setState(() {
      _selectedGameType = gameType;
      _cards = null;
      _filters.clear();
      _searchController.clear();
    });
    _fetchInitialData();
  }

  // Game-specific filter options
  final Map<GameType, Map<String, List<String>>> _parameterOptions = {
    GameType.onePiece: {
      'rarity': ['None', 'C', 'R', 'SR', 'SEC', 'L'],
      'type': ['None', 'CHARACTER', 'EVENT', 'STAGE', 'LEADER'],
      'color': ['None', 'Red', 'Green', 'Blue', 'Purple', 'Black'],
      'family': ['None', 'Straw Hat Crew', 'Water Seven', 'Donquixote Pirates'],
    },
    GameType.pokemon: {
      'rarity': [
        'None',
        'Common',
        'Uncommon',
        'Rare',
        'Rare Holo',
        'Rare Ultra',
      ],
      'types': [
        'None',
        'Grass',
        'Fire',
        'Water',
        'Lightning',
        'Psychic',
        'Fighting',
      ],
      'subtypes': ['None', 'Basic', 'Stage 1', 'Stage 2', 'V', 'VMAX', 'EX'],
      'hp': ['None', '[* TO 50]', '[50 TO 100]', '[100 TO 150]', '[150 TO *]'],
    },
    GameType.dragonBall: {
      'rarity': ['None', 'C', 'UC', 'R', 'SR', 'SCR', 'L'],
      'cardType': ['None', 'LEADER', 'BATTLE', 'EXTRA'],
      'color': ['None', 'Red', 'Blue', 'Green', 'Yellow', 'Black'],
      'features': ['None', 'Saiyan', 'Universe 7', 'Frieza Clan'],
    },
    GameType.digimon: {
      'rarity': ['None', 'C', 'U', 'R', 'SR', 'SEC'],
      'cardType': ['None', 'Digimon', 'Digi-Egg', 'Tamer', 'Option'],
      'colors': ['None', 'Red', 'Blue', 'Yellow', 'Green', 'Black', 'Purple'],
      'form': ['None', 'Rookie', 'Champion', 'Ultimate', 'Mega'],
    },
    GameType.unionArena: {
      'rarity': ['None', 'C', 'U', 'R', 'SR', 'PR'],
      'type': ['None', 'Character', 'Event', 'Field'],
      'needEnergy.value': ['None', 'Blue-', 'Red-', 'Green-', 'Yellow-'],
    },
    GameType.gundam: {
      'rarity': ['None', 'C', 'R', 'SR', 'LR'],
      'cardType': ['None', 'UNIT', 'PILOT', 'COMMAND'],
      'color': ['None', 'White', 'Red', 'Blue', 'Green'],
      'zone': ['None', 'Space', 'Earth', 'Space / Earth'],
    },
    GameType.magic: {}, // Empty since Magic uses MagicTcgService
  };

  // Game-specific free-text parameters
  final Map<GameType, List<String>> _freeTextParams = {
    GameType.onePiece: ['ability'],
    GameType.pokemon: ['text', 'flavor', 'artist', 'number'],
    GameType.dragonBall: ['effect'],
    GameType.digimon: ['effect'],
    GameType.unionArena: ['effect'],
    GameType.gundam: ['effect'],
    GameType.magic: [], // Empty since Magic uses MagicTcgService
  };

  // Build filter bar with dropdown buttons and free-text buttons
  Widget _buildFilterBar() {
    final params = _parameterOptions[_selectedGameType] ?? {};
    final freeTextParams = _freeTextParams[_selectedGameType] ?? [];
    return Row(
      children: [
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Dropdown buttons for non-free-text parameters
                ...params.keys.map((param) {
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
                      itemBuilder: (context) => params[param]!
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
                ...freeTextParams.map((param) {
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
    developer.log(
      'Building TestScreenApiTcg, selectedGameType: ${_selectedGameType.name}',
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_selectedGameType.name.toUpperCase()} TCG',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : () => _fetchCards(),
            tooltip: 'Refresh Cards',
          ),
          PopupMenuButton<GameType>(
            initialValue: _selectedGameType,
            onSelected: _onGameSelected,
            itemBuilder: (BuildContext context) => GameType.values.map((game) {
              return PopupMenuItem<GameType>(
                value: game,
                child: Text(game.name, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
            icon: const Icon(Icons.menu, color: Colors.blueGrey),
            tooltip: 'Select Game',
            color: Colors.white,
            elevation: 2,
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
          if (_selectedGameType != GameType.magic)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
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
                : _cards == null || _cards.isEmpty
                ? const Center(
                    child: Text(
                      'No cards found. Try adjusting your search or filters.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Cards (${_cards.length}):',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _cards.length,
                          itemBuilder: (context, index) {
                            final card = _cards[index];
                            developer.log('Rendering card: ${card.name}');
                            String typeText;
                            String rarityText;
                            switch (_selectedGameType) {
                              case GameType.onePiece:
                                final c = card as OnePieceCard;
                                typeText = c.type;
                                rarityText = c.rarity;
                                break;
                              case GameType.pokemon:
                                final c = card as PokemonCard;
                                typeText = c.types.join(', ') ?? 'Unknown';
                                rarityText = c.rarity;
                                break;
                              case GameType.dragonBall:
                                final c = card as DragonBallCard;
                                typeText = c.cardType;
                                rarityText = c.rarity;
                                break;
                              case GameType.digimon:
                                final c = card as DigimonCard;
                                typeText = c.cardType;
                                rarityText = c.rarity ?? 'Unknown';
                                break;
                              case GameType.unionArena:
                                final c = card as UnionArenaCard;
                                typeText = c.type;
                                rarityText = c.rarity;
                                break;
                              case GameType.gundam:
                                final c = card as GundamCard;
                                typeText = c.cardType;
                                rarityText = c.rarity;
                                break;
                              case GameType.magic:
                                final c = card as MagicCard;
                                typeText = c.type!;
                                rarityText = c.rarity!;
                                break;
                            }
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: ListTile(
                                leading: card.images['small'] != null
                                    ? Image.network(
                                        card.images['small']!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.broken_image,
                                                  size: 50,
                                                ),
                                      )
                                    : const Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                      ),
                                title: Text(card.name ?? 'No Name'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Type: $typeText'),
                                    Text('Rarity: $rarityText'),
                                  ],
                                ),
                                onTap: () => _fetchSingleCard(card.id),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

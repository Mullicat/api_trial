// lib/test_screen_api_tcg.dart
import 'package:api_trial/models/card_model_api_apitcg.dart';
import 'package:api_trial/services/catalog_apitcg_api_service.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

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
  dynamic _singleCard;
  bool _isLoading = false;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

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
      _singleCard = null;
    });

    try {
      await _fetchCards();
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching data: $e';
        developer.log('Error fetching data: $e');
      });
    }
  }

  Future<void> _fetchCards({String? name}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _cards = null;
      _singleCard = null;
    });

    try {
      developer.log(
        'Fetching cards for ${_selectedGameType.name} with name: $name',
      );
      switch (_selectedGameType) {
        case GameType.onePiece:
          _cards = await _service.getCards<OnePieceCard>(
            gameType: _selectedGameType,
            property: name != null ? 'name' : null,
            value: name,
            pageSize: 5,
          );
          break;
        case GameType.pokemon:
          _cards = await _service.getCards<PokemonCard>(
            gameType: _selectedGameType,
            property: name != null ? 'name' : null,
            value: name,
            pageSize: 5,
          );
          break;
        case GameType.dragonBall:
          _cards = await _service.getCards<DragonBallCard>(
            gameType: _selectedGameType,
            property: name != null ? 'name' : null,
            value: name,
            pageSize: 5,
          );
          break;
        case GameType.digimon:
          _cards = await _service.getCards<DigimonCard>(
            gameType: _selectedGameType,
            property: name != null ? 'name' : null,
            value: name,
            pageSize: 5,
          );
          break;
        case GameType.unionArena:
          _cards = await _service.getCards<UnionArenaCard>(
            gameType: _selectedGameType,
            property: name != null ? 'name' : null,
            value: name,
            pageSize: 5,
          );
          break;
        case GameType.gundam:
          _cards = await _service.getCards<GundamCard>(
            gameType: _selectedGameType,
            property: name != null ? 'name' : null,
            value: name,
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
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      developer.log(
        'Fetching single card for ${_selectedGameType.name}: id=$id',
      );
      switch (_selectedGameType) {
        case GameType.onePiece:
          _singleCard = await _service.getCard<OnePieceCard>(
            gameType: _selectedGameType,
            id: id,
          );
          break;
        case GameType.pokemon:
          _singleCard = await _service.getCard<PokemonCard>(
            gameType: _selectedGameType,
            id: id,
          );
          break;
        case GameType.dragonBall:
          _singleCard = await _service.getCard<DragonBallCard>(
            gameType: _selectedGameType,
            id: id,
          );
          break;
        case GameType.digimon:
          _singleCard = await _service.getCard<DigimonCard>(
            gameType: _selectedGameType,
            id: id,
          );
          break;
        case GameType.unionArena:
          _singleCard = await _service.getCard<UnionArenaCard>(
            gameType: _selectedGameType,
            id: id,
          );
          break;
        case GameType.gundam:
          _singleCard = await _service.getCard<GundamCard>(
            gameType: _selectedGameType,
            id: id,
          );
          break;
      }
      developer.log(
        'Single card fetched for ${_selectedGameType.name}: ${_singleCard?.name ?? 'None'}',
      );
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching single card: $e';
        developer.log('Error fetching single card: $e');
      });
    }
  }

  void _onGameSelected(GameType gameType) {
    developer.log('Game selected: ${gameType.name}');
    setState(() {
      _selectedGameType = gameType;
      _cards = null;
      _singleCard = null;
      _searchController.clear();
    });
    _fetchInitialData();
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
            onPressed: _isLoading
                ? null
                : () => _fetchCards(
                    name: _searchController.text.isEmpty
                        ? null
                        : _searchController.text,
                  ),
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
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Cards (${_cards!.length}):',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: _cards!.length,
                          itemBuilder: (context, index) {
                            final card = _cards![index];
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
                      if (_singleCard != null)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Single Card: ${_singleCard!.name}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  switch (_selectedGameType) {
                                    GameType.onePiece => Text(
                                      'Cost: ${(_singleCard as OnePieceCard).cost}',
                                    ),
                                    GameType.pokemon => Text(
                                      'HP: ${(_singleCard as PokemonCard).hp}',
                                    ),
                                    GameType.dragonBall => Text(
                                      'Power: ${(_singleCard as DragonBallCard).power}',
                                    ),
                                    GameType.digimon => Text(
                                      'DP: ${(_singleCard as DigimonCard).dp}',
                                    ),
                                    GameType.unionArena => Text(
                                      'AP: ${(_singleCard as UnionArenaCard).ap}',
                                    ),
                                    GameType.gundam => Text(
                                      'HP: ${(_singleCard as GundamCard).hp}',
                                    ),
                                  },
                                  Text(
                                    'Rarity: ${_singleCard!.rarity ?? 'Unknown'}',
                                  ),
                                  Text(
                                    'Types: ${_selectedGameType == GameType.pokemon ? (_singleCard as PokemonCard).types.join(', ') ?? 'Unknown' : 'N/A'}',
                                  ),
                                  if (_singleCard!.images['small'] != null)
                                    Image.network(
                                      _singleCard!.images['small']!,
                                      height: 100,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Text('Image unavailable'),
                                    ),
                                ],
                              ),
                            ),
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

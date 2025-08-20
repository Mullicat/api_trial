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
  List<dynamic>? _cards;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    developer.log(
      'TestScreenApiTcg initState: gameType=${widget.gameType.name}',
    );
    _selectedGameType = widget.gameType;
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    developer.log('Fetching initial data for ${_selectedGameType.name}');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _cards = null;
    });

    try {
      switch (_selectedGameType) {
        case GameType.onePiece:
          _cards = await _service.getCards<OnePieceCard>(
            gameType: _selectedGameType,
            pageSize: 5,
          );
          break;
        case GameType.pokemon:
          _cards = await _service.getCards<PokemonCard>(
            gameType: _selectedGameType,
            pageSize: 5,
          );
          break;
        case GameType.dragonBall:
          _cards = await _service.getCards<DragonBallCard>(
            gameType: _selectedGameType,
            pageSize: 5,
          );
          break;
        case GameType.digimon:
          _cards = await _service.getCards<DigimonCard>(
            gameType: _selectedGameType,
            pageSize: 5,
          );
          break;
        case GameType.unionArena:
          _cards = await _service.getCards<UnionArenaCard>(
            gameType: _selectedGameType,
            pageSize: 5,
          );
          break;
        case GameType.gundam:
          _cards = await _service.getCards<GundamCard>(
            gameType: _selectedGameType,
            pageSize: 5,
          );
          break;

        case GameType.magic:
          _cards = await _service.getCards<MagicCard>(
            gameType: _selectedGameType,
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
        if (_cards == null || _cards!.isEmpty) {
          _errorMessage = 'No cards found for ${_selectedGameType.name}.';
        }
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

  void _onGameSelected(GameType gameType) {
    developer.log('Game selected: ${gameType.name}');
    setState(() {
      _selectedGameType = gameType;
      _cards = null;
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Text(
                _errorMessage!,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            )
          : _cards == null || _cards!.isEmpty
          ? const Center(
              child: Text(
                'No cards available.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Cards:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _cards!.length,
                    itemBuilder: (context, index) {
                      final card = _cards![index];
                      developer.log('Rendering card: ${card.name}');
                      String typeText;
                      switch (_selectedGameType) {
                        case GameType.pokemon:
                          typeText =
                              (card.types as List<dynamic>?)?.join(', ') ??
                              'Unknown';
                          break;
                        case GameType.dragonBall:
                        case GameType.gundam:
                          typeText = card.cardType ?? 'Unknown';
                          break;
                        case GameType.digimon:
                          typeText = card.cardType ?? 'Unknown';
                          break;
                        case GameType.magic:
                          typeText =
                              card.type ??
                              (card.types as List<dynamic>?)?.join(', ') ??
                              'Unknown';
                          break;
                        default:
                          typeText = card.type ?? card.cardType ?? 'Unknown';
                      }
                      String rarityText = card.rarity ?? 'Unknown';
                      return ListTile(
                        title: Text(card.name ?? 'No Name'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Type: $typeText'),
                            Text('Rarity: $rarityText'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Single Card:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Single card endpoint not supported for ${_selectedGameType.name}.',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
    );
  }
}

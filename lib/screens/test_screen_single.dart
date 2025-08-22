import 'package:api_trial/services/catalog_apitcg_api_service.dart';
import 'package:api_trial/services/catalog_pokemontcg_api_service.dart';
import 'package:api_trial/services/catalog_magic_api_service.dart';
import '../models/card_model_magic.dart' as model;

import 'package:api_trial/enums/game_type.dart';

import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as developer;

class TestScreenSingle extends StatefulWidget {
  final String id;
  final GameType gameType;

  const TestScreenSingle({super.key, required this.id, required this.gameType});

  @override
  State<TestScreenSingle> createState() => _TestScreenSingleState();
}

class _TestScreenSingleState extends State<TestScreenSingle> {
  dynamic _card;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchSingleCard();
  }

  Future<void> _fetchSingleCard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      developer.log('Fetching single card with id: ${widget.id}');
      switch (widget.gameType) {
        case GameType.pokemon:
          _card = await PokemonTcgService().getCard(widget.id);
          break;
        case GameType.magic:
          _card = await MagicTcgService().getCard(widget.id);
          break;
        case GameType.onePiece:
          _card = await TcgService().getCard(
            gameType: widget.gameType,
            id: widget.id,
          );
          break;
        case GameType.dragonBall:
          _card = await TcgService().getCard(
            gameType: widget.gameType,
            id: widget.id,
          );
          break;
        case GameType.digimon:
          _card = await TcgService().getCard(
            gameType: widget.gameType,
            id: widget.id,
          );
          break;
        case GameType.unionArena:
          _card = await TcgService().getCard(
            gameType: widget.gameType,
            id: widget.id,
          );
          break;
        case GameType.gundam:
          _card = await TcgService().getCard(
            gameType: widget.gameType,
            id: widget.id,
          );
          break;
      }
      if (_card == null) {
        _errorMessage = 'Card not found for ID: ${widget.id}';
      }
    } catch (e) {
      _errorMessage = 'Error fetching card: $e';
      developer.log('Error fetching single card: $e');
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Card Detail - ${widget.gameType.name}')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _errorMessage != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchSingleCard,
                    child: const Text('Retry'),
                  ),
                ],
              )
            : _card == null
            ? const Text("No card data available.")
            : Text("Card Name: ${_card.name}"),
      ),
    );
  }
}

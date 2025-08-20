import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as developer;
import '../services/catalog_magic_api_service.dart';
import '../models/card_model_magic.dart' as model;
import 'dart:io';

class TestScreenMagic extends StatefulWidget {
  const TestScreenMagic({super.key});

  @override
  State<TestScreenMagic> createState() => _TestScreenMagicState();
}

class _TestScreenMagicState extends State<TestScreenMagic> {
  List<model.Card>? _cards; // List of cards from fixed search
  model.Card? _singleCard; // Single card fetched by ID
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await dotenv.load(fileName: "assets/.env"); // Load .env if needed
      final tcgService = MagicTcgService();
      // Fixed search for multiple cards (e.g., page 1, 10 cards, name "Dragon")
      final cards = await tcgService.getCards(
        pageSize: 20,
        language: null, // Optional, set to null for default
      );
      stderr.writeln('Cards fetched: ${cards.length}');
      // Fixed search for a single card (e.g., example ID)
      final card = await tcgService.getCard('386616');
      stderr.writeln('Card fetched: $card');

      if (!mounted) return;

      setState(() {
        _cards = cards;
        _singleCard = card;
        _isLoading = false;
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
      appBar: AppBar(title: const Text('Magic: The Gathering API Test')),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  )
                : _cards == null || _cards!.isEmpty
                ? const Center(
                    child: Text(
                      'No cards found with the specified filters.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: _cards!.length,
                    itemBuilder: (context, index) {
                      final card = _cards![index];
                      return ListTile(
                        title: Text(card.name ?? 'No Name'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Type: ${card.type ?? 'Unknown'}'),
                            Text('Rarity: ${card.rarity ?? 'Unknown'}'),
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

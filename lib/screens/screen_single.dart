// lib/screens/screen_single.dart
import 'package:api_trial/screens/screen_onepiece.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../constants/enums/game_type.dart';
import '../models/card.dart';
import '../services/onepiece_service.dart';
import '../constants/enums/onepiece_filters.dart';

class ScreenSingle extends StatefulWidget {
  final String id; // UUID for Supabase, game_code for API
  final String? version; // Optional version (e.g., "p7")
  final GameType gameType;
  final OnePieceTcgService service;
  final GetCardType getCardType;

  const ScreenSingle({
    super.key,
    required this.id,
    this.version,
    required this.gameType,
    required this.service,
    required this.getCardType,
  });

  @override
  State<ScreenSingle> createState() => _ScreenSingleState();
}

class _ScreenSingleState extends State<ScreenSingle> {
  TCGCard? _card;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    developer.log(
      'ScreenSingle initState: id=${widget.id}, version=${widget.version}, gameType=${widget.gameType.name}, getCardType=${widget.getCardType}',
    );
    _fetchCard();
  }

  Future<void> _fetchCard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _card = null;
    });

    try {
      TCGCard? card;
      switch (widget.getCardType) {
        case GetCardType.fromAPI:
          card = await widget.service.getCardFromAPI(idOrGameCode: widget.id);
          break;
        case GetCardType.fromSupabase:
          card = await widget.service.getCardFromSupabase(
            idOrGameCode: widget.id,
            version: widget.version,
          );
          break;
        case GetCardType.fromAPICards:
          card = widget.service.getCardFromAPICards(idOrGameCode: widget.id);
          break;
      }

      if (!mounted) return;

      if (card == null) {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Card not found for ID: ${widget.id}${widget.version != null ? ", version: ${widget.version}" : ""}';
        });
        developer.log(
          'Card not found for ID: ${widget.id}, version: ${widget.version}',
        );
        return;
      }

      setState(() {
        _card = card;
        _isLoading = false;
      });
      developer.log('Fetched card: ${_card!.name}, version: ${_card!.version}');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching card: $e';
      });
      developer.log('Error fetching card: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _card?.name ?? 'Card Details',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchCard,
            tooltip: 'Refresh Card',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchCard,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _card == null
          ? const Center(
              child: Text(
                'No card data available.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_card!.imageRefLarge != null)
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: _card!.imageRefLarge!,
                        width: 300,
                        fit: BoxFit.contain,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.broken_image, size: 100),
                      ),
                    )
                  else
                    const Center(
                      child: Icon(Icons.image_not_supported, size: 100),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    _card!.name ?? 'No Name',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version: ${_card!.version ?? 'Unknown'}', // Display version
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Type: ${_card!.gameSpecificData?['type'] ?? _card!.gameSpecificData?['cardType'] ?? (_card!.gameSpecificData?['types'] is List ? (_card!.gameSpecificData!['types'] as List).join(', ') : _card!.gameSpecificData?['types']?.toString() ?? 'Unknown')}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Rarity: ${_card!.rarity ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Set: ${_card!.setName ?? 'Unknown'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (_card!.gameSpecificData?['cost'] != null)
                    Text(
                      'Cost: ${_card!.gameSpecificData!['cost']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  if (_card!.gameSpecificData?['color'] != null)
                    Text(
                      'Color: ${_card!.gameSpecificData!['color']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  if (_card!.gameSpecificData?['power'] != null)
                    Text(
                      'Power: ${_card!.gameSpecificData!['power']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  if (_card!.gameSpecificData?['family'] != null)
                    Text(
                      'Family: ${_card!.gameSpecificData!['family'] is List<dynamic> ? (_card!.gameSpecificData!['family'] as List<dynamic>).join(', ') : _card!.gameSpecificData!['family'].toString()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  if (_card!.gameSpecificData?['counter'] != null)
                    Text(
                      'Counter: ${_card!.gameSpecificData!['counter']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  if (_card!.gameSpecificData?['trigger'] != null)
                    Text(
                      'Trigger: ${_card!.gameSpecificData!['trigger']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  if (_card!.gameSpecificData?['ability'] != null)
                    Text(
                      'Ability: ${_card!.gameSpecificData!['ability']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                ],
              ),
            ),
    );
  }
}

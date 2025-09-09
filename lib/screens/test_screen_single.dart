// lib/screens/test_screen_single.dart
import 'package:api_trial/services/catalog_digimon_api_service.dart';
import 'package:api_trial/services/catalog_gundam_api_service.dart';
import 'package:api_trial/services/catalog_onepiece_api_service.dart';
import 'package:api_trial/services/catalog_unionarena_api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:developer' as developer;
import '../constants/enums/game_type.dart';
import '../models/card.dart'; // Use unified TCGCard model
import '../services/catalog_pokemontcg_api_service.dart';
import '../services/catalog_yugioh_api_service.dart';
import '../services/catalog_magic_api_service.dart';

class TestScreenSingle extends StatefulWidget {
  final String id;
  final GameType gameType;

  const TestScreenSingle({super.key, required this.id, required this.gameType});

  @override
  State<TestScreenSingle> createState() => _TestScreenSingleState();
}

class _TestScreenSingleState extends State<TestScreenSingle> {
  TCGCard? _card;
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
      await dotenv.load(fileName: 'assets/.env');
      developer.log(
        'Fetching single card with id: ${widget.id} for ${widget.gameType.name}',
      );
      switch (widget.gameType) {
        case GameType.pokemon:
          _card = await PokemonTcgService().getCard(widget.id);
          break;
        case GameType.yugioh:
          _card = await CardApi().getCard(widget.id);
          break;
        case GameType.magic:
          _card = await MagicTcgService().getCard(widget.id);
          break;
        case GameType.onePiece:
          _card = await OnePieceTcgService().getCard(id: widget.id);
          break;
        case GameType.digimon:
          _card = await DigimonTcgService().getCard(id: widget.id);
          break;
        case GameType.unionArena:
          _card = await UnionArenaTcgService().getCard(id: widget.id);
          break;
        case GameType.gundam:
          _card = await GundamTcgService().getCard(id: widget.id);
          break;
        case GameType.dragonBall:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        if (_card == null) {
          _errorMessage = 'Card not found for ID: ${widget.id}';
        }
      });
      developer.log('Single card fetched: ${_card?.name ?? 'None'}');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching card: $e';
      });
      developer.log('Error fetching single card: $e');
    }
  }

  List<Widget> _buildCardDetails() {
    if (_card == null) return [const Text('No card data available.')];

    final details = <Widget>[];
    final Map<String, String> fields = {};

    // Helper to add non-null fields
    void addField(String key, dynamic value) {
      if (value != null &&
          value.toString().isNotEmpty &&
          value.toString() != '[]' &&
          value.toString() != '{}') {
        fields[key] = value.toString();
      }
    }

    // Helper to format lists
    String formatList(dynamic list) {
      if (list is List) return list.join(', ');
      return list?.toString() ?? '';
    }

    // Add image
    if (_card!.imageRefLarge != null) {
      details.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CachedNetworkImage(
            imageUrl: _card!.imageRefLarge!,
            height: 300,
            fit: BoxFit.contain,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                const Text('Image unavailable'),
          ),
        ),
      );
    }

    // Common fields across all games
    addField('Name', _card!.name);
    addField('Rarity', _card!.rarity);
    addField('Set Name', _card!.setName);

    // Game-specific fields
    switch (widget.gameType) {
      case GameType.pokemon:
        addField('HP', _card!.gameSpecificData?['hp']);
        addField('Types', formatList(_card!.gameSpecificData?['types']));
        addField('Subtypes', formatList(_card!.gameSpecificData?['subtypes']));
        addField(
          'Attacks',
          formatList(
            _card!.gameSpecificData?['attacks']?.map(
              (a) => '${a['name']}: ${a['damage']}',
            ),
          ),
        );
        addField(
          'Weaknesses',
          formatList(
            _card!.gameSpecificData?['weaknesses']?.map(
              (w) => '${w['type']}: ${w['value']}',
            ),
          ),
        );
        addField(
          'Retreat Cost',
          formatList(_card!.gameSpecificData?['retreatCost']),
        );
        addField(
          'Converted Retreat Cost',
          _card!.gameSpecificData?['convertedRetreatCost'],
        );
        addField('Number', _card!.gameSpecificData?['number']);
        addField('Artist', _card!.gameSpecificData?['artist']);
        addField('Flavor Text', _card!.gameSpecificData?['flavorText']);
        addField(
          'National Pokedex Numbers',
          formatList(_card!.gameSpecificData?['nationalPokedexNumbers']),
        );
        addField(
          'Legalities (Standard)',
          _card!.gameSpecificData?['legalities']?['standard'],
        );
        addField(
          'Legalities (Expanded)',
          _card!.gameSpecificData?['legalities']?['expanded'],
        );
        break;
      case GameType.yugioh:
        addField('Type', _card!.gameSpecificData?['type']);
        addField('Attribute', _card!.gameSpecificData?['attribute']);
        addField('ATK', _card!.gameSpecificData?['atk']);
        addField('DEF', _card!.gameSpecificData?['def']);
        addField('Level', _card!.gameSpecificData?['level']);
        addField('Race', _card!.gameSpecificData?['race']);
        addField('Description', _card!.gameSpecificData?['desc']);
        addField(
          'Card Sets',
          formatList(
            _card!.gameSpecificData?['card_sets']?.map(
              (s) => '${s['set_name']} (${s['set_rarity']})',
            ),
          ),
        );
        addField('Archetype', _card!.gameSpecificData?['archetype']);
        addField(
          'Banlist Info',
          formatList(_card!.gameSpecificData?['banlist_info']),
        );
        break;
      case GameType.magic:
        addField('Type', _card!.gameSpecificData?['type']);
        addField('Mana Cost', _card!.gameSpecificData?['manaCost']);
        addField('CMC', _card!.gameSpecificData?['cmc']);
        addField('Colors', formatList(_card!.gameSpecificData?['colors']));
        addField(
          'Color Identity',
          formatList(_card!.gameSpecificData?['colorIdentity']),
        );
        addField(
          'Supertypes',
          formatList(_card!.gameSpecificData?['supertypes']),
        );
        addField('Types', formatList(_card!.gameSpecificData?['types']));
        addField('Subtypes', formatList(_card!.gameSpecificData?['subtypes']));
        addField('Text', _card!.gameSpecificData?['text']);
        addField('Artist', _card!.gameSpecificData?['artist']);
        addField('Number', _card!.gameSpecificData?['number']);
        addField('Power', _card!.gameSpecificData?['power']);
        addField('Toughness', _card!.gameSpecificData?['toughness']);
        addField(
          'Rulings',
          formatList(
            _card!.gameSpecificData?['rulings']?.map(
              (r) => '${r['date']}: ${r['text']}',
            ),
          ),
        );
        addField(
          'Foreign Names',
          formatList(
            _card!.gameSpecificData?['foreignNames']?.map(
              (f) => '${f['name']} (${f['language']})',
            ),
          ),
        );
        addField(
          'Printings',
          formatList(_card!.gameSpecificData?['printings']),
        );
        break;
      case GameType.onePiece:
        addField('Code', _card!.gameSpecificData?['code']);
        addField('Type', _card!.gameSpecificData?['type']);
        addField('Cost', _card!.gameSpecificData?['cost']);
        addField('Attribute', _card!.gameSpecificData?['attribute']?['name']);
        addField('Power', _card!.gameSpecificData?['power']);
        addField('Counter', _card!.gameSpecificData?['counter']);
        addField('Color', _card!.gameSpecificData?['color']);
        addField('Family', _card!.gameSpecificData?['family']);
        addField('Ability', _card!.gameSpecificData?['ability']);
        addField('Trigger', _card!.gameSpecificData?['trigger']);
        addField('Set', _card!.gameSpecificData?['set']?['name']);
        addField('Notes', formatList(_card!.gameSpecificData?['notes']));
        break;
      case GameType.digimon:
        addField('Code', _card!.gameSpecificData?['code']);
        addField('Level', _card!.gameSpecificData?['level']);
        addField('Colors', formatList(_card!.gameSpecificData?['colors']));
        addField('Card Type', _card!.gameSpecificData?['cardType']);
        addField('Form', _card!.gameSpecificData?['form']);
        addField('Attribute', _card!.gameSpecificData?['attribute']);
        addField('Type', _card!.gameSpecificData?['type']);
        addField('DP', _card!.gameSpecificData?['dp']);
        addField('Play Cost', _card!.gameSpecificData?['playCost']);
        addField(
          'Digivolve Cost 1',
          _card!.gameSpecificData?['digivolveCost1'],
        );
        addField(
          'Digivolve Cost 2',
          _card!.gameSpecificData?['digivolveCost2'],
        );
        addField('Effect', _card!.gameSpecificData?['effect']);
        addField(
          'Inherited Effect',
          _card!.gameSpecificData?['inheritedEffect'],
        );
        addField('Security Effect', _card!.gameSpecificData?['securityEffect']);
        addField('Notes', _card!.gameSpecificData?['notes']);
        addField('Set', _card!.gameSpecificData?['set']?['name']);
        break;
      case GameType.unionArena:
        addField('Code', _card!.gameSpecificData?['code']);
        addField('URL', _card!.gameSpecificData?['url']);
        addField('AP', _card!.gameSpecificData?['ap']);
        addField('Type', _card!.gameSpecificData?['type']);
        addField('BP', _card!.gameSpecificData?['bp']);
        addField('Affinity', _card!.gameSpecificData?['affinity']);
        addField('Effect', _card!.gameSpecificData?['effect']);
        addField('Trigger', _card!.gameSpecificData?['trigger']);
        addField('Set', _card!.gameSpecificData?['set']?['name']);
        addField(
          'Need Energy',
          _card!.gameSpecificData?['needEnergy']?['value'],
        );
        break;
      case GameType.gundam:
        addField('Code', _card!.gameSpecificData?['code']);
        addField('Level', _card!.gameSpecificData?['level']);
        addField('Cost', _card!.gameSpecificData?['cost']);
        addField('Color', _card!.gameSpecificData?['color']);
        addField('Card Type', _card!.gameSpecificData?['cardType']);
        addField('Effect', _card!.gameSpecificData?['effect']);
        addField('Zone', _card!.gameSpecificData?['zone']);
        addField('Trait', _card!.gameSpecificData?['trait']);
        addField('Link', _card!.gameSpecificData?['link']);
        addField('AP', _card!.gameSpecificData?['ap']);
        addField('HP', _card!.gameSpecificData?['hp']);
        addField('Source Title', _card!.gameSpecificData?['sourceTitle']);
        addField('Get It', _card!.gameSpecificData?['getIt']);
        addField('Set', _card!.gameSpecificData?['set']?['name']);
        break;
      case GameType.dragonBall:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    // Add text widgets for fields
    fields.forEach((key, value) {
      details.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  key,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(flex: 3, child: Text(value)),
            ],
          ),
        ),
      );
    });

    return details;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _card?.name ?? 'Card Detail - ${widget.gameType.name}',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _errorMessage != null
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
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
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'No card data available.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchSingleCard,
                    child: const Text('Retry'),
                  ),
                ],
              )
            : Card(
                margin: const EdgeInsets.all(16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(children: _buildCardDetails()),
                ),
              ),
      ),
    );
  }
}

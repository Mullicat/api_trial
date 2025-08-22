// lib/screens/test_screen_single.dart
import 'package:api_trial/enums/game_type.dart';
import 'package:api_trial/models/card_model_api_apitcg.dart';
import 'package:api_trial/models/card_model_magic.dart' as magic_model;
import 'package:api_trial/models/card_model_pokemon.dart' as pokemon_model;
import 'package:api_trial/services/catalog_apitcg_api_service.dart';
import 'package:api_trial/services/catalog_magic_api_service.dart';
import 'package:api_trial/services/catalog_pokemontcg_api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
      await dotenv.load(fileName: 'assets/.env');
      developer.log(
        'Fetching single card with id: ${widget.id} for ${widget.gameType.name}',
      );
      switch (widget.gameType) {
        case GameType.pokemon:
          _card = await PokemonTcgService().getCard(widget.id);
          break;
        case GameType.magic:
          _card = await MagicTcgService().getCard(widget.id);
          break;
        case GameType.onePiece:
          _card = await TcgService().getCard<OnePieceCard>(
            gameType: widget.gameType,
            id: widget.id,
          );
          break;
        case GameType.dragonBall:
          _card = await TcgService().getCard<DragonBallCard>(
            gameType: widget.gameType,
            id: widget.id,
          );
          break;
        case GameType.digimon:
          _card = await TcgService().getCard<DigimonCard>(
            gameType: widget.gameType,
            id: widget.id,
          );
          break;
        case GameType.unionArena:
          _card = await TcgService().getCard<UnionArenaCard>(
            gameType: widget.gameType,
            id: widget.id,
          );
          break;
        case GameType.gundam:
          _card = await TcgService().getCard<GundamCard>(
            gameType: widget.gameType,
            id: widget.id,
          );
          break;
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

    // Helper to add nested object fields
    void addNestedField(String key, dynamic object, List<String> subKeys) {
      if (object != null) {
        subKeys.forEach((subKey) {
          if (object is Map &&
              object.containsKey(subKey) &&
              object[subKey] != null) {
            fields['$key.$subKey'] = object[subKey].toString();
          } else if (object.toString() != '{}') {
            fields[key] = object.toString();
          }
        });
      }
    }

    // Helper to format lists
    String formatList(List<dynamic>? list) => list?.join(', ') ?? '';

    // Add image (large preferred)
    String? imageUrl;
    if (_card is pokemon_model.Card) {
      imageUrl =
          (_card as pokemon_model.Card).images?.large ??
          (_card as pokemon_model.Card).images?.small;
    } else if (_card is magic_model.MagicCard) {
      imageUrl = (_card as magic_model.MagicCard).imageUrl;
    } else {
      imageUrl = _card.images != null
          ? (_card.images['large'] ?? _card.images['small'])
          : null;
    }
    if (imageUrl != null) {
      details.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            height: 300,
            fit: BoxFit.contain,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                const Text('Image unavailable'),
          ),
        ),
      );
    }

    // Add fields based on card type
    switch (widget.gameType) {
      case GameType.onePiece:
        final card = _card as OnePieceCard;
        addField('ID', card.id);
        addField('Code', card.code);
        addField('Rarity', card.rarity);
        addField('Type', card.type);
        addField('Name', card.name);
        addField('Cost', card.cost);
        addNestedField('Attribute', card.attribute, ['name', 'image']);
        addField('Power', card.power);
        addField('Counter', card.counter);
        addField('Color', card.color);
        addField('Family', card.family);
        addField('Ability', card.ability);
        addField('Trigger', card.trigger);
        addNestedField('Set', card.set, ['name', 'id']);
        addField('Notes', formatList(card.notes));
        break;

      case GameType.pokemon:
        final card = _card as pokemon_model.Card;
        addField('ID', card.id);
        addField('Name', card.name);
        addField('Supertype', card.supertype);
        addField('Subtypes', formatList(card.subtypes));
        addField('HP', card.hp);
        addField('Types', formatList(card.types));
        addField('Evolves From', card.evolvesFrom);
        addField(
          'Abilities',
          formatList(
            card.abilities?.map((a) => '${a.name}: ${a.text}').toList(),
          ),
        );
        addField(
          'Attacks',
          formatList(
            card.attacks?.map((a) => '${a.name}: ${a.damage}').toList(),
          ),
        );
        addField(
          'Weaknesses',
          formatList(
            card.weaknesses?.map((w) => '${w.type}: ${w.value}').toList(),
          ),
        );
        addField('Retreat Cost', formatList(card.retreatCost));
        addField('Converted Retreat Cost', card.convertedRetreatCost);
        addNestedField('Set', card.set, ['name', 'series', 'releaseDate']);
        addField('Number', card.number);
        addField('Artist', card.artist);
        addField('Rarity', card.rarity);
        addField('Flavor Text', card.flavorText);
        addField(
          'National Pokedex Numbers',
          formatList(card.nationalPokedexNumbers),
        );
        addNestedField('Legalities', card.legalities, [
          'unlimited',
          'standard',
          'expanded',
        ]);
        break;

      case GameType.dragonBall:
        final card = _card as DragonBallCard;
        addField('ID', card.id);
        addField('Code', card.code);
        addField('Rarity', card.rarity);
        addField('Name', card.name);
        addField('Color', card.color);
        addField('Card Type', card.cardType);
        addField('Cost', card.cost);
        addField('Specified Cost', card.specifiedCost);
        addField('Power', card.power);
        addField('Combo Power', card.comboPower);
        addField('Features', card.features);
        addField('Effect', card.effect);
        addField('Get It', card.getIt);
        addNestedField('Set', card.set, ['name', 'id']);
        break;

      case GameType.digimon:
        final card = _card as DigimonCard;
        addField('ID', card.id);
        addField('Code', card.code);
        addField('Rarity', card.rarity);
        addField('Name', card.name);
        addField('Level', card.level);
        addField('Colors', formatList(card.colors));
        addField('Card Type', card.cardType);
        addField('Form', card.form);
        addField('Attribute', card.attribute);
        addField('Type', card.type);
        addField('DP', card.dp);
        addField('Play Cost', card.playCost);
        addField('Digivolve Cost 1', card.digivolveCost1);
        addField('Digivolve Cost 2', card.digivolveCost2);
        addField('Effect', card.effect);
        addField('Inherited Effect', card.inheritedEffect);
        addField('Security Effect', card.securityEffect);
        addField('Notes', card.notes);
        addNestedField('Set', card.set, ['name', 'id']);
        break;

      case GameType.unionArena:
        final card = _card as UnionArenaCard;
        addField('ID', card.id);
        addField('Code', card.code);
        addField('URL', card.url);
        addField('Name', card.name);
        addField('Rarity', card.rarity);
        addField('AP', card.ap);
        addField('Type', card.type);
        addField('BP', card.bp);
        addField('Affinity', card.affinity);
        addField('Effect', card.effect);
        addField('Trigger', card.trigger);
        addNestedField('Set', card.set, ['name', 'id']);
        addNestedField('Need Energy', card.needEnergy, ['value', 'logo']);
        break;

      case GameType.gundam:
        final card = _card as GundamCard;
        addField('ID', card.id);
        addField('Code', card.code);
        addField('Rarity', card.rarity);
        addField('Name', card.name);
        addField('Level', card.level);
        addField('Cost', card.cost);
        addField('Color', card.color);
        addField('Card Type', card.cardType);
        addField('Effect', card.effect);
        addField('Zone', card.zone);
        addField('Trait', card.trait);
        addField('Link', card.link);
        addField('AP', card.ap);
        addField('HP', card.hp);
        addField('Source Title', card.sourceTitle);
        addField('Get It', card.getIt);
        addNestedField('Set', card.set, ['name', 'id']);
        break;

      case GameType.magic:
        final card = _card as magic_model.MagicCard;
        addField('Name', card.name);
        addField('Names', formatList(card.names));
        addField('Mana Cost', card.manaCost);
        addField('CMC', card.cmc);
        addField('Colors', formatList(card.colors));
        addField('Color Identity', formatList(card.colorIdentity));
        addField('Type', card.type);
        addField('Supertypes', formatList(card.supertypes));
        addField('Types', formatList(card.types));
        addField('Subtypes', formatList(card.subtypes));
        addField('Rarity', card.rarity);
        addField('Set', card.set);
        addField('Set Name', card.setName);
        addField('Text', card.text);
        addField('Artist', card.artist);
        addField('Number', card.number);
        addField('Power', card.power);
        addField('Toughness', card.toughness);
        addField('Layout', card.layout);
        addField('Multiverse ID', card.multiverseid);
        addField(
          'Rulings',
          formatList(card.rulings?.map((r) => '${r.date}: ${r.text}').toList()),
        );
        addField(
          'Foreign Names',
          formatList(
            card.foreignNames?.map((f) => '${f.name} (${f.language})').toList(),
          ),
        );
        addField('Printings', formatList(card.printings));
        addField('Original Text', card.originalText);
        addField('Original Type', card.originalType);
        addField('ID', card.id);
        break;
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

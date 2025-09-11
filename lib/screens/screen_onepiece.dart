import 'package:flutter/material.dart';
import 'package:api_trial/models/card.dart';
import 'package:api_trial/services/onepiece_service.dart';
import 'package:api_trial/constants/enums/game_type.dart';
import 'package:api_trial/constants/enums/onepiece_filters.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:api_trial/screens/screen_single.dart';
import 'dart:developer' as developer;

enum GetCardsType { fromAPI, fromDatabase, uploadCards }

class ScreenOnePiece extends StatefulWidget {
  final GameType gameType;

  const ScreenOnePiece({super.key, this.gameType = GameType.onePiece});

  @override
  State<ScreenOnePiece> createState() => _ScreenOnePieceState();
}

class _ScreenOnePieceState extends State<ScreenOnePiece> {
  OnePieceTcgService? _service; // Nullable to handle async initialization
  GetCardsType _selectedGetCardsType = GetCardsType.fromAPI;
  GetCardType _selectedGetCardType = GetCardType.fromAPI;
  List<TCGCard>? _cards;
  bool _isLoading = false;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  final Map<String, dynamic> _filters = {};
  int _page = 1;
  int _pageSize = 100;
  int _totalCards = 0; // To be updated from response if available

  // Game-specific filter options
  final Map<GameType, Map<String, List<String>>> _parameterOptions = {
    GameType.onePiece: {
      'set_name': ['None', ...SetName.values.map((e) => e.value)],
      'rarity': ['None', ...Rarity.values.map((e) => e.value)],
      'cost': ['None', ...Cost.values.map((e) => e.value)],
      'type': ['None', ...Type.values.map((e) => e.value)],
      'color': ['None', ...Color.values.map((e) => e.value)],
      'power': ['None', ...Power.values.map((e) => e.value)],
      'counter': ['None', ...Counter.values.map((e) => e.value)],
      'trigger': ['None', ...Trigger.values.map((e) => e.displayName)],
      'ability': ['None', ...Ability.values.map((e) => e.value)],
    },
  };

  // Game-specific free-text parameters (removed ability)
  final Map<GameType, List<String>> _freeTextParams = {GameType.onePiece: []};

  @override
  void initState() {
    super.initState();
    developer.log('ScreenOnePiece initState: gameType=${widget.gameType.name}');
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      _service = await OnePieceTcgService.create();
      await _fetchInitialData();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error initializing service: $e';
      });
      developer.log('Error initializing OnePieceTcgService: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    if (_service == null) return;
    developer.log('Fetching initial data');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _cards = null;
      _filters.clear();
      _searchController.clear();
      _page = 1;
    });
    await _fetchCards();
  }

  // Helper methods to safely convert filter strings to enums
  SetName? _getSetName(String? value) {
    if (value == null ||
        value == 'None' ||
        !SetName.values.any((e) => e.value == value)) {
      return null;
    }
    return SetName.values.firstWhere((e) => e.value == value);
  }

  Rarity? _getRarity(String? value) {
    if (value == null ||
        value == 'None' ||
        !Rarity.values.any((e) => e.value == value)) {
      return null;
    }
    return Rarity.values.firstWhere((e) => e.value == value);
  }

  Cost? _getCost(String? value) {
    if (value == null ||
        value == 'None' ||
        !Cost.values.any((e) => e.value == value)) {
      return null;
    }
    return Cost.values.firstWhere((e) => e.value == value);
  }

  Type? _getType(String? value) {
    if (value == null ||
        value == 'None' ||
        !Type.values.any((e) => e.value == value)) {
      return null;
    }
    return Type.values.firstWhere((e) => e.value == value);
  }

  Color? _getColor(String? value) {
    if (value == null ||
        value == 'None' ||
        !Color.values.any((e) => e.value == value)) {
      return null;
    }
    return Color.values.firstWhere((e) => e.value == value);
  }

  Power? _getPower(String? value) {
    if (value == null ||
        value == 'None' ||
        !Power.values.any((e) => e.value == value)) {
      return null;
    }
    return Power.values.firstWhere((e) => e.value == value);
  }

  Counter? _getCounter(String? value) {
    if (value == null ||
        value == 'None' ||
        !Counter.values.any((e) => e.value == value)) {
      return null;
    }
    return Counter.values.firstWhere((e) => e.value == value);
  }

  Trigger? _getTrigger(String? value) {
    if (value == null ||
        value == 'None' ||
        !Trigger.values.any((e) => e.displayName == value)) {
      return null;
    }
    return Trigger.values.firstWhere((e) => e.displayName == value);
  }

  Ability? _getAbility(String? value) {
    if (value == null ||
        value == 'None' ||
        !Ability.values.any((e) => e.value == value)) {
      return null;
    }
    return Ability.values.firstWhere((e) => e.value == value);
  }

  Future<void> _fetchCards() async {
    if (_service == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Service not initialized';
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _cards = null;
    });

    try {
      developer.log(
        'Fetching cards with filters: $_filters, page: $_page, pageSize: $_pageSize',
      );
      List<TCGCard> cards;
      switch (_selectedGetCardsType) {
        case GetCardsType.fromAPI:
          cards = await _service!.getCardsFromAPI(
            word: _searchController.text.isNotEmpty
                ? _searchController.text
                : null,
            setName: _getSetName(_filters['set_name'] as String?),
            rarity: _getRarity(_filters['rarity'] as String?),
            cost: _getCost(_filters['cost'] as String?),
            type: _getType(_filters['type'] as String?),
            color: _getColor(_filters['color'] as String?),
            power: _getPower(_filters['power'] as String?),
            families: _filters['family'] != null
                ? _filters['family'] as List<Family>
                : null,
            counter: _getCounter(_filters['counter'] as String?),
            trigger: _getTrigger(_filters['trigger'] as String?),
            ability: _getAbility(_filters['ability'] as String?),
            page: _page,
            pageSize: _pageSize,
          );
          break;
        case GetCardsType.fromDatabase:
          cards = await _service!.getCardsFromDatabase(
            word: _searchController.text.isNotEmpty
                ? _searchController.text
                : null,
            setName: _getSetName(_filters['set_name'] as String?),
            rarity: _getRarity(_filters['rarity'] as String?),
            cost: _getCost(_filters['cost'] as String?),
            type: _getType(_filters['type'] as String?),
            color: _getColor(_filters['color'] as String?),
            power: _getPower(_filters['power'] as String?),
            families: _filters['family'] != null
                ? _filters['family'] as List<Family>
                : null,
            counter: _getCounter(_filters['counter'] as String?),
            trigger: _getTrigger(_filters['trigger'] as String?),
            page: _page,
            pageSize: _pageSize,
          );
          break;
        case GetCardsType.uploadCards:
          cards = await _service!.getCardsUploadCards(
            word: _searchController.text.isNotEmpty
                ? _searchController.text
                : null,
            setName: _getSetName(_filters['set_name'] as String?),
            rarity: _getRarity(_filters['rarity'] as String?),
            cost: _getCost(_filters['cost'] as String?),
            type: _getType(_filters['type'] as String?),
            color: _getColor(_filters['color'] as String?),
            power: _getPower(_filters['power'] as String?),
            families: _filters['family'] != null
                ? _filters['family'] as List<Family>
                : null,
            counter: _getCounter(_filters['counter'] as String?),
            trigger: _getTrigger(_filters['trigger'] as String?),
            page: _page,
            pageSize: _pageSize,
          );
          break;
      }
      developer.log('Cards fetched: ${cards.length}');
      if (!mounted) return;
      setState(() {
        _cards = cards;
        _isLoading = false;
        _totalCards = 1000; // Replace with actual total if available
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

  Future<void> _fetchSingleCard(String? id) async {
    if (_service == null) {
      setState(() {
        _errorMessage = 'Service not initialized';
      });
      return;
    }
    if (id == null || id.isEmpty) {
      setState(() {
        _errorMessage = 'Invalid card ID';
      });
      developer.log('Error: cardId is null or empty');
      return;
    }

    try {
      developer.log(
        'Navigating to ScreenSingle with cardId: $id, gameType: ${widget.gameType.name}, getCardType: $_selectedGetCardType',
      );
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScreenSingle(
            id: id,
            gameType: widget.gameType,
            service: _service!,
            getCardType: _selectedGetCardType,
          ),
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

  void _onGetCardsTypeSelected(GetCardsType type) {
    setState(() {
      _selectedGetCardsType = type;
      _selectedGetCardType = type == GetCardsType.fromAPI
          ? GetCardType.fromAPI
          : type == GetCardsType.fromDatabase
          ? GetCardType.fromSupabase
          : GetCardType.fromAPICards;
      _page = 1;
      _filters.clear();
      _searchController.clear();
    });
    _fetchCards();
  }

  void _onGetCardTypeSelected(GetCardType type) {
    setState(() {
      _selectedGetCardType = type;
    });
  }

  Future<void> _showFamilyFilterDialog() async {
    final TextEditingController searchController = TextEditingController();
    List<Family> selectedFamilies = _filters['family'] != null
        ? List<Family>.from(_filters['family'])
        : [];
    List<Family> filteredFamilies = Family.values;

    final result = await showDialog<List<Family>>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Select Families'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search families...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          filteredFamilies = Family.values
                              .where(
                                (f) => f.value.toLowerCase().contains(
                                  value.toLowerCase(),
                                ),
                              )
                              .toList();
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: filteredFamilies.map((family) {
                          return CheckboxListTile(
                            title: Text(family.value),
                            value: selectedFamilies.contains(family),
                            onChanged: (bool? selected) {
                              setDialogState(() {
                                if (selected == true) {
                                  selectedFamilies.add(family);
                                } else {
                                  selectedFamilies.remove(family);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, selectedFamilies),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        if (result.isEmpty) {
          _filters.remove('family');
        } else {
          _filters['family'] = result;
        }
      });
      await _fetchCards();
    }
  }

  Widget _buildFilterBar() {
    final params = _parameterOptions[widget.gameType] ?? {};
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: DropdownButton<GetCardsType>(
                  value: _selectedGetCardsType,
                  items: GetCardsType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.toString().split('.').last),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _onGetCardsTypeSelected(value);
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: DropdownButton<GetCardType>(
                  value: _selectedGetCardType,
                  items: GetCardType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.toString().split('.').last),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _onGetCardTypeSelected(value);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...params.keys.where((param) => param != 'family').map((param) {
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
                        border: Border.all(
                          color: isActive ? Colors.blue : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                        color: isActive ? Colors.blue.withOpacity(0.08) : null,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: GestureDetector(
                  onTap: _showFamilyFilterDialog,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            _filters.containsKey('family') &&
                                (_filters['family'] as List).isNotEmpty
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                      color:
                          _filters.containsKey('family') &&
                              (_filters['family'] as List).isNotEmpty
                          ? Colors.blue.withOpacity(0.08)
                          : null,
                    ),
                    child: Text(
                      'family',
                      style: TextStyle(
                        color:
                            _filters.containsKey('family') &&
                                (_filters['family'] as List).isNotEmpty
                            ? Colors.blue
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                      _page = 1;
                    });
                    _fetchCards();
                  },
                  child: const Text('Clear Filters'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationBar() {
    final bool hasPrevious = _page > 1;
    final bool hasNext = _totalCards > _page * _pageSize;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: 8.0,
        bottom: MediaQuery.of(context).padding.bottom + 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: hasPrevious
                    ? () {
                        setState(() => _page--);
                        _fetchCards();
                      }
                    : null,
              ),
              Text('Page $_page'),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: hasNext
                    ? () {
                        setState(() => _page++);
                        _fetchCards();
                      }
                    : null,
              ),
            ],
          ),
          DropdownButton<int>(
            value: _pageSize,
            items: [25, 50, 100]
                .map(
                  (size) =>
                      DropdownMenuItem<int>(value: size, child: Text('$size')),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _pageSize = value;
                  _page = 1;
                });
                _fetchCards();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'One Piece TCG',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : () => _fetchCards(),
            tooltip: 'Refresh Cards',
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
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _filters.clear();
                              _searchController.clear();
                              _page = 1;
                            });
                            _fetchCards();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : _cards == null || _cards!.isEmpty
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
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: ListTile(
                                leading: card.imageRefSmall != null
                                    ? CachedNetworkImage(
                                        imageUrl: card.imageRefSmall!,
                                        width: 50,
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                              Icons.broken_image,
                                              size: 50,
                                            ),
                                      )
                                    : null,
                                title: Text(card.name ?? 'Unknown'),
                                subtitle: Text(
                                  'Type: ${card.gameSpecificData?['type'] ?? 'Unknown'}',
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
      bottomNavigationBar: _buildPaginationBar(),
    );
  }
}

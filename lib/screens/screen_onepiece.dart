import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import '../constants/enums/game_type.dart';
import '../models/card.dart';
import '../services/onepiece_service.dart';
import '../constants/enums/onepiece_filters.dart';
import './screen_single.dart';

enum GetCardsType { fromAPI, fromDatabase, uploadCards }

enum GetCardType { fromAPI, fromSupabase, fromAPICards }

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
    },
  };

  // Game-specific free-text parameters
  final Map<GameType, List<String>> _freeTextParams = {
    GameType.onePiece: ['ability'],
  };

  // Dynamic filter options based on GetCardsType
  Map<String, List<String>> _getDynamicFilterOptions() {
    final baseOptions = _parameterOptions[widget.gameType] ?? {};
    if (_selectedGetCardsType == GetCardsType.fromDatabase) {
      // Supabase might have different filter constraints
      // For simplicity, assume same filters as API for now
      return baseOptions;
    }
    return baseOptions;
  }

  @override
  void initState() {
    super.initState();
    developer.log('ScreenOnePiece initState: gameType=${widget.gameType.name}');
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      _service =
          await OnePieceTcgService.create(); // Use async factory constructor
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
    if (_service == null) return; // Guard against uninitialized service
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
        // Clear invalid filters to prevent persistent errors
        _filters.removeWhere((key, value) {
          if (key == 'family') return false; // Preserve family filter
          if (key == 'ability') return false; // Preserve ability filter
          return value != 'None' &&
              !_parameterOptions[widget.gameType]![key]!.contains(value);
        });
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
      _page = 1; // Reset page on type change
      _filters.clear(); // Clear filters to avoid invalid values
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

    if (!mounted) return;

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

  Widget _buildFilterBar() {
    final params = _getDynamicFilterOptions();
    final freeTextParams = _freeTextParams[widget.gameType] ?? [];
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
                  onChanged: (value) => _onGetCardsTypeSelected(value!),
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
                  onChanged: (value) => _onGetCardTypeSelected(value!),
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
              ...freeTextParams.map((param) {
                final isActive =
                    _filters.containsKey(param) && _filters[param]!.isNotEmpty;
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
        bottom:
            MediaQuery.of(context).padding.bottom +
            8.0, // Add system navigation bar height
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
              setState(() {
                _pageSize = value!;
                _page = 1; // Reset page when page size changes
              });
              _fetchCards();
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
                              _page = 1;
                              _searchController.clear();
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
                            developer.log(
                              'Rendering card: ${card.name ?? 'Unknown'}, imageRefSmall=${card.imageRefSmall}',
                            );
                            final typeText =
                                card.gameSpecificData?['type']?.toString() ??
                                'Unknown';
                            final rarityText = card.rarity ?? 'Unknown';
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: ListTile(
                                leading:
                                    card.imageRefSmall != null &&
                                        card.imageRefSmall!.isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl: card.imageRefSmall!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) {
                                          developer.log(
                                            'Image load error for ${card.name}: $error, URL: ${card.imageRefSmall}',
                                          );
                                          return const Icon(
                                            Icons.broken_image,
                                            size: 50,
                                          );
                                        },
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
                                onTap: () => _fetchSingleCard(card.gameCode),
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

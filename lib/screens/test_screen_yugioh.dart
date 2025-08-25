// lib/screens/top_logo_page.dart
import 'package:flutter/material.dart';
import '../services/catalog_yugioh_api_service.dart';
import '../models/card_model_yugioh.dart' as model;

class TestScreenYuGiOh extends StatefulWidget {
  const TestScreenYuGiOh({super.key});

  @override
  State<TestScreenYuGiOh> createState() => _TestScreenYuGiOhState();
}

class _TestScreenYuGiOhState extends State<TestScreenYuGiOh> {
  bool _loading = false;
  List<model.Card> _results = const [];

  // Hidden filters
  bool _showSection = false;
  final Set<String> _selectedAttributes = {}; // multi-select
  String? _sortBy;

  static const List<String> _attributes = [
    'LIGHT',
    'DARK',
    'EARTH',
    'WATER',
    'FIRE',
    'WIND',
    'DIVINE',
  ];
  static const Map<String, String> _sortOptions = {
    'name': 'Name',
    'atk': 'ATK',
    'def': 'DEF',
    'level': 'Level',
    'id': 'ID',
    'type': 'Type',
    'new': 'Newest',
  };

  String? _thumbOf(model.Card c) {
    if (c.cardImages.isEmpty) return null;
    return c.cardImages.first.imageUrlSmall ?? c.cardImages.first.imageUrl;
  }

  Future<void> _onSearch() async {
    setState(() => _loading = true);
    try {
      final hasFilters =
          _selectedAttributes.isNotEmpty ||
          (_sortBy != null && _sortBy!.isNotEmpty);

      List<model.Card> cards;

      if (!hasFilters) {
        cards = await CardApi.getCards();
      } else {
        final extra = <String, String>{
          if (_sortBy != null && _sortBy!.isNotEmpty) 'sort': _sortBy!,
        };

        cards = await CardApi.getCards(
          attributes: _selectedAttributes.toList(),
          extra: extra,
        );
      }

      setState(() => _results = cards);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Found ${cards.length} cards')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Search failed: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // Collapsible filters UI
  Widget _collapsibleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 230, 168, 255),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color.fromARGB(255, 226, 152, 255)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filters',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            const Text(
              'Attributes',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _attributes.map((attr) {
                final selected = _selectedAttributes.contains(attr);
                return ChoiceChip(
                  label: Text(attr),
                  selected: selected,
                  onSelected: (v) => setState(() {
                    if (v) {
                      _selectedAttributes.add(attr);
                    } else {
                      _selectedAttributes.remove(attr);
                    }
                  }),
                  selectedColor: const Color.fromARGB(255, 207, 252, 224),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),
            const Text(
              'Sort by',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _sortBy,
              isExpanded: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
              hint: const Text('None'),
              items: _sortOptions.entries
                  .map(
                    (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _sortBy = v),
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => setState(() {
                    _selectedAttributes.clear();
                    _sortBy = null;
                  }),
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear filters'),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Toggle hidden filters
            TextButton.icon(
              onPressed: () => setState(() => _showSection = !_showSection),
              icon: Icon(_showSection ? Icons.expand_less : Icons.expand_more),
              label: Text(_showSection ? 'Hide filters' : 'Show filters'),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              crossFadeState: _showSection
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: _collapsibleSection(),
            ),

            // Main Search button
            ElevatedButton.icon(
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: Text(_loading ? 'Searching...' : 'Search'),
              onPressed: _loading ? null : _onSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                foregroundColor: const Color.fromARGB(255, 153, 0, 255),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                elevation: 4,
                shadowColor: const Color.fromARGB(255, 0, 0, 0),
                shape: const StadiumBorder(),
              ),
            ),

            const SizedBox(height: 12),

            // Results grid
            Expanded(
              child: _results.isEmpty
                  ? const Center(
                      child: Text(
                        'Tap Search to load cards',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.7,
                          ),
                      itemCount: _results.length,
                      itemBuilder: (context, i) {
                        final c = _results[i];
                        final img = _thumbOf(c);
                        return Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: img != null
                                    ? Image.network(img, fit: BoxFit.cover)
                                    : const ColoredBox(
                                        color: Color(0x11000000),
                                        child: Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              c.name ?? 'Unknown',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// lib/screens/user_cards_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:api_trial/viewmodels/user_cards_viewmodel.dart';
import 'package:api_trial/models/card.dart';
import 'package:api_trial/constants/enums/game_type.dart';
import 'dart:developer' as developer;

// ============================================================================
// WIDGET: UserCardsScreen
// PURPOSE: Displays the user's card collection with options to add, update,
//          remove cards, toggle favorite status, manage labels, and filter by
//          game type or label in a compact, non-overflowing layout.
// ARCHITECTURE:
//   - StatefulWidget to trigger refresh on init.
//   - Uses Provider to access UserCardsViewModel for state.
//   - Shows a list of cards with image and text at the top, quantity controls,
//     label button, and favorite/delete column at the bottom.
//   - Includes GameType dropdown and label TextField for filtering.
//   - Uses dialog for label management to save space.
// ============================================================================
class UserCardsScreen extends StatefulWidget {
  const UserCardsScreen({super.key});

  @override
  State<UserCardsScreen> createState() => _UserCardsScreenState();
}

class _UserCardsScreenState extends State<UserCardsScreen> {
  final _labelFilterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Refresh collection when screen is entered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserCardsViewModel>().refresh();
    });
  }

  @override
  void dispose() {
    _labelFilterController.dispose();
    super.dispose();
  }

  // Dialog for managing labels
  void _showLabelDialog(
    BuildContext context,
    TCGCard card,
    UserCardsViewModel viewModel,
  ) {
    final labelController = TextEditingController();
    final labels = List<String>.from(card.gameSpecificData?['labels'] ?? []);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Manage Labels for ${card.name ?? 'Card'}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: labelController,
              decoration: const InputDecoration(
                labelText: 'Add Label',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (_validateLabel(value)) {
                  final newLabels = [...labels, value.trim()];
                  viewModel.updateCard(
                    card.id!,
                    card.gameSpecificData?['quantity'] ?? 1,
                    card.gameSpecificData?['favorite'] ?? false,
                    newLabels,
                  );
                  labelController.clear();
                  Navigator.pop(context);
                }
              },
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: labels
                  .map(
                    (label) => Chip(
                      label: Text(label),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        final newLabels = List<String>.from(labels)
                          ..remove(label);
                        viewModel.updateCard(
                          card.id!,
                          card.gameSpecificData?['quantity'] ?? 1,
                          card.gameSpecificData?['favorite'] ?? false,
                          newLabels,
                        );
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = labelController.text;
              if (_validateLabel(value)) {
                final newLabels = [...labels, value.trim()];
                viewModel.updateCard(
                  card.id!,
                  card.gameSpecificData?['quantity'] ?? 1,
                  card.gameSpecificData?['favorite'] ?? false,
                  newLabels,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // Validate label input
  bool _validateLabel(String value) {
    final trimmed = value.trim();
    return trimmed.isNotEmpty && trimmed.length <= 50;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserCardsViewModel>();
    final cards = viewModel.cards;
    final isLoading = viewModel.isLoading;
    final errorMessage = viewModel.errorMessage;

    return Scaffold(
      // --- AppBar --------------------------------------------------------------
      appBar: AppBar(
        title: const Text(
          'My Collection',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : () => viewModel.refresh(),
            tooltip: 'Refresh Collection',
          ),
        ],
      ),

      // --- Body ---------------------------------------------------------------
      body: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // GameType filter
                Expanded(
                  child: DropdownButton<GameType?>(
                    value: viewModel.selectedGameType,
                    hint: const Text('Filter by Game'),
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem<GameType?>(
                        value: null,
                        child: Text('All Games'),
                      ),
                      ...GameType.values.map(
                        (gameType) => DropdownMenuItem<GameType?>(
                          value: gameType,
                          child: Text(gameType.name),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      viewModel.setGameTypeFilter(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Label filter
                Expanded(
                  child: TextField(
                    controller: _labelFilterController,
                    decoration: InputDecoration(
                      labelText: 'Filter by Label',
                      border: const OutlineInputBorder(),
                      suffixIcon: _labelFilterController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _labelFilterController.clear();
                                viewModel.setLabelFilter(null);
                              },
                            )
                          : null,
                    ),
                    onSubmitted: (value) {
                      viewModel.setLabelFilter(
                        value.isEmpty ? null : value.trim(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Results (loading / error / empty / list)
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          errorMessage,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => viewModel.refresh(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : cards.isEmpty
                ? const Center(
                    child: Text(
                      'No cards in your collection. Add some!',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      final currentQuantity =
                          card.gameSpecificData?['quantity'] ?? 1;
                      final isFavorite =
                          card.gameSpecificData?['favorite'] ?? false;
                      final labels = List<String>.from(
                        card.gameSpecificData?['labels'] ?? [],
                      );

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Section: Image and Text
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image
                                  if (card.imageRefSmall != null)
                                    SizedBox(
                                      width: 40,
                                      child: CachedNetworkImage(
                                        imageUrl: card.imageRefSmall!,
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                              Icons.broken_image,
                                              size: 40,
                                            ),
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                  // Text (name, type, rarity, labels)
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          card.name ?? 'Unknown',
                                          style: const TextStyle(fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        Text(
                                          'Type: ${card.gameSpecificData?['type'] ?? 'Unknown'}\nRarity: ${card.rarity ?? 'Unknown'}',
                                          style: const TextStyle(fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        if (labels.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Wrap(
                                            spacing: 2,
                                            runSpacing: 2,
                                            children:
                                                labels
                                                    .take(1)
                                                    .map(
                                                      (label) => Chip(
                                                        label: Text(
                                                          label,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 8,
                                                              ),
                                                        ),
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 2,
                                                            ),
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                      ),
                                                    )
                                                    .toList()
                                                  ..addAll(
                                                    labels.length > 1
                                                        ? [
                                                            Chip(
                                                              label: Text(
                                                                '+${labels.length - 1} more',
                                                                style:
                                                                    const TextStyle(
                                                                      fontSize:
                                                                          8,
                                                                    ),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        2,
                                                                  ),
                                                              materialTapTargetSize:
                                                                  MaterialTapTargetSize
                                                                      .shrinkWrap,
                                                            ),
                                                          ]
                                                        : [],
                                                  ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Bottom Section: Quantity, Label, Favorite, Delete
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Quantity and Label controls
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Quantity controls
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.remove,
                                              size: 16,
                                            ),
                                            onPressed: () {
                                              if (currentQuantity > 1) {
                                                viewModel.updateCard(
                                                  card.id!,
                                                  currentQuantity - 1,
                                                  isFavorite,
                                                  labels,
                                                );
                                              } else {
                                                viewModel.removeCard(card.id!);
                                              }
                                            },
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                          SizedBox(
                                            width: 32,
                                            child: TextField(
                                              controller: TextEditingController(
                                                text: currentQuantity
                                                    .toString(),
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 4,
                                                    ),
                                              ),
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                              onSubmitted: (value) {
                                                final newQuantity =
                                                    int.tryParse(value) ??
                                                    currentQuantity;
                                                if (newQuantity >= 1) {
                                                  viewModel.updateCard(
                                                    card.id!,
                                                    newQuantity,
                                                    isFavorite,
                                                    labels,
                                                  );
                                                } else {
                                                  viewModel.removeCard(
                                                    card.id!,
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.add,
                                              size: 16,
                                            ),
                                            onPressed: () {
                                              viewModel.updateCard(
                                                card.id!,
                                                currentQuantity + 1,
                                                isFavorite,
                                                labels,
                                              );
                                            },
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 8),
                                      // Label management
                                      IconButton(
                                        icon: const Icon(Icons.label, size: 16),
                                        onPressed: () => _showLabelDialog(
                                          context,
                                          card,
                                          viewModel,
                                        ),
                                        tooltip: 'Manage Labels',
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                  // Favorite and Delete column
                                  IntrinsicWidth(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Favorite toggle
                                        IconButton(
                                          icon: Icon(
                                            isFavorite
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: isFavorite
                                                ? Colors.yellow
                                                : null,
                                            size: 16,
                                          ),
                                          onPressed: () {
                                            viewModel.updateCard(
                                              card.id!,
                                              currentQuantity,
                                              !isFavorite,
                                              labels,
                                            );
                                          },
                                          tooltip: isFavorite
                                              ? 'Remove from Favorites'
                                              : 'Add to Favorites',
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                        // Remove button
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                            size: 16,
                                          ),
                                          onPressed: () =>
                                              viewModel.removeCard(card.id!),
                                          tooltip: 'Remove Card',
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

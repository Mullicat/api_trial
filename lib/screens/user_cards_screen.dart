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
// PURPOSE: Displays the user's card collection with options to add, update, or
//          remove cards.
// ARCHITECTURE:
//   - Uses Provider to access UserCardsViewModel for state.
//   - Shows a list of cards with images, names, and quantity controls.
//   - Handles loading, error, and empty states.
//   - Includes GameType filter dropdown.
// ============================================================================
class UserCardsScreen extends StatefulWidget {
  const UserCardsScreen({super.key});

  @override
  State<UserCardsScreen> createState() => _UserCardsScreenState();
}

class _UserCardsScreenState extends State<UserCardsScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh collection when screen is entered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserCardsViewModel>().refresh();
    });
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
          // GameType filter
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                                      const Icon(Icons.broken_image, size: 50),
                                )
                              : null,
                          title: Text(card.name ?? 'Unknown'),
                          subtitle: Text(
                            'Type: ${card.gameSpecificData?['type'] ?? 'Unknown'}\nRarity: ${card.rarity ?? 'Unknown'}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Quantity controls
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: currentQuantity > 1
                                    ? () {
                                        viewModel.updateCard(
                                          card.id!,
                                          currentQuantity - 1,
                                          card.gameSpecificData?['favorite'] ??
                                              false,
                                          card.gameSpecificData?['labels'] ??
                                              [],
                                        );
                                      }
                                    : () {
                                        viewModel.removeCard(card.id!);
                                      },
                              ),
                              Text(
                                '$currentQuantity',
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  viewModel.updateCard(
                                    card.id!,
                                    currentQuantity + 1,
                                    card.gameSpecificData?['favorite'] ?? false,
                                    card.gameSpecificData?['labels'] ?? [],
                                  );
                                },
                              ),
                              // Remove button
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => viewModel.removeCard(card.id!),
                              ),
                            ],
                          ),
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

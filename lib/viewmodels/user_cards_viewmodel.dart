// lib/viewmodels/user_cards_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;
import 'package:api_trial/services/onepiece_service.dart';
import 'package:api_trial/models/card.dart';
import 'package:api_trial/constants/enums/game_type.dart';

// ============================================================================
// CLASS: UserCardsViewModel
// PURPOSE: Manages the state of the user's card collection, interfacing with
//          OnePieceTcgService for data operations.
// ARCHITECTURE:
//   - Uses ChangeNotifier for reactive UI updates.
//   - Handles fetching, adding, updating, and removing user cards.
//   - Supports gameType filtering with custom mapping for Supabase game_type.
//   - Tracks loading state, errors, and gameType filter for UI feedback.
// ============================================================================
class UserCardsViewModel with ChangeNotifier {
  final OnePieceTcgService _service;
  List<TCGCard> _allCards = [];
  bool _isLoading = false;
  String? _errorMessage;
  GameType? _selectedGameType; // Null means "All"

  // Map Supabase game_type to GameType
  GameType? _mapGameTypeToEnum(String gameType) {
    final gameTypeMap = {
      'onepiece': GameType.onePiece,
      'pokemon': GameType.pokemon,
      'dragonball': GameType.dragonBall, // Special case for dragon-ball-fusion
      'digimon': GameType.digimon,
      'unionarena': GameType.unionArena,
      'gundam': GameType.gundam,
      'magic': GameType.magic,
      'yugioh': GameType.yugioh,
    };
    return gameTypeMap[gameType];
  }

  // Map GameType to Supabase game_type
  String? _mapEnumToGameType(GameType? gameType) {
    if (gameType == null) return null;
    if (gameType == GameType.dragonBall) return 'dragonball';
    return gameType.apiPath.replaceAll('-', '');
  }

  // Getters for UI
  List<TCGCard> get cards => _selectedGameType == null
      ? _allCards
      : _allCards
            .where(
              (card) => _mapGameTypeToEnum(card.gameType!) == _selectedGameType,
            )
            .toList();
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  GameType? get selectedGameType => _selectedGameType;

  // Constructor: Takes OnePieceTcgService instance
  UserCardsViewModel(this._service) {
    _fetchUserCards();
  }

  // --------------------------------------------------------------------------
  // METHOD: Fetch user's cards
  // STEPS:
  //   1. Set loading state and clear error
  //   2. Call service to get user cards with optional gameType filter
  //   3. Update cards list and notify listeners
  //   4. Handle errors if they occur
  // --------------------------------------------------------------------------
  Future<void> _fetchUserCards() async {
    try {
      _setLoading(true);
      final cards = await _service.getUserCards(gameType: _selectedGameType);
      _allCards = cards;
      _setLoading(false);
      _errorMessage = null;
      notifyListeners();
      developer.log('Fetched ${cards.length} user cards');
    } catch (e) {
      _setLoading(false);
      _errorMessage = 'Failed to load collection: $e';
      notifyListeners();
      developer.log('Error fetching user cards: $e');
    }
  }

  // --------------------------------------------------------------------------
  // METHOD: Add card to collection
  // STEPS:
  //   1. Call service to add card with specified quantity
  //   2. Refresh card list on success
  //   3. Handle errors if they occur
  // --------------------------------------------------------------------------
  Future<void> addCard(String cardId, int quantity) async {
    try {
      _setLoading(true);
      await _service.addCardToUserCollection(cardId, quantity);
      await _fetchUserCards(); // Refresh collection
      _errorMessage = null;
      notifyListeners();
      developer.log('Added card $cardId with quantity $quantity');
    } catch (e) {
      _setLoading(false);
      _errorMessage = 'Failed to add card: $e';
      notifyListeners();
      developer.log('Error adding card $cardId: $e');
    }
  }

  // --------------------------------------------------------------------------
  // METHOD: Update card quantity, favorite, or labels
  // STEPS:
  //   1. Update local state optimistically
  //   2. Call service to update card with new values
  //   3. Refresh card list on success or revert on failure
  //   4. Handle errors if they occur
  // --------------------------------------------------------------------------
  Future<void> updateCard(
    String cardId,
    int quantity,
    bool favorite,
    List<String> labels,
  ) async {
    try {
      // Optimistic update
      final index = _allCards.indexWhere((card) => card.id == cardId);
      if (index != -1) {
        final updatedCard = TCGCard(
          id: _allCards[index].id,
          gameCode: _allCards[index].gameCode,
          name: _allCards[index].name,
          setName: _allCards[index].setName,
          rarity: _allCards[index].rarity,
          imageRefSmall: _allCards[index].imageRefSmall,
          imageRefLarge: _allCards[index].imageRefLarge,
          gameType: _allCards[index].gameType,
          imageEmbedding: _allCards[index].imageEmbedding,
          textEmbedding: _allCards[index].textEmbedding,
          gameSpecificData: {
            ...?_allCards[index].gameSpecificData,
            'quantity': quantity,
            'favorite': favorite,
            'labels': labels,
          },
        );
        _allCards[index] = updatedCard;
        notifyListeners(); // Update UI immediately
      }

      await _service.updateUserCardQuantity(cardId, quantity, favorite, labels);
      await _fetchUserCards(); // Refresh to ensure consistency
      _errorMessage = null;
      developer.log(
        'Updated card $cardId: quantity=$quantity, favorite=$favorite',
      );
    } catch (e) {
      _setLoading(false);
      _errorMessage = 'Failed to update card: $e';
      notifyListeners();
      developer.log('Error updating card $cardId: $e');
      await _fetchUserCards(); // Revert to server state on error
    }
  }

  // --------------------------------------------------------------------------
  // METHOD: Remove card from collection
  // STEPS:
  //   1. Remove card locally
  //   2. Call service to delete card
  //   3. Refresh card list on success or revert on failure
  //   4. Handle errors if they occur
  // --------------------------------------------------------------------------
  Future<void> removeCard(String cardId) async {
    try {
      // Optimistic update
      _allCards.removeWhere((card) => card.id == cardId);
      notifyListeners(); // Update UI immediately

      await _service.removeUserCard(cardId);
      await _fetchUserCards(); // Refresh collection
      _errorMessage = null;
      notifyListeners();
      developer.log('Removed card $cardId');
    } catch (e) {
      _setLoading(false);
      _errorMessage = 'Failed to remove card: $e';
      notifyListeners();
      developer.log('Error removing user card $cardId: $e');
      await _fetchUserCards(); // Revert to server state on error
    }
  }

  // --------------------------------------------------------------------------
  // METHOD: Set gameType filter
  // STEPS:
  //   1. Update selected gameType
  //   2. Fetch cards with new filter
  //   3. Notify listeners to refresh UI with filtered cards
  // --------------------------------------------------------------------------
  void setGameTypeFilter(GameType? gameType) {
    _selectedGameType = gameType;
    _fetchUserCards(); // Refresh with new filter
    developer.log(
      'Set gameType filter: ${_mapEnumToGameType(gameType) ?? "All"}',
    );
  }

  // --------------------------------------------------------------------------
  // HELPER: Set loading state and notify listeners
  // --------------------------------------------------------------------------
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // --------------------------------------------------------------------------
  // METHOD: Refresh collection
  // PURPOSE: Expose public method to manually trigger refresh
  // --------------------------------------------------------------------------
  Future<void> refresh() async {
    await _fetchUserCards();
  }
}

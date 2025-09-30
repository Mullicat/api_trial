// lib/viewmodels/user_cards_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;
import 'package:api_trial/services/onepiece_service.dart';
import 'package:api_trial/models/card.dart';

// ============================================================================
// CLASS: UserCardsViewModel
// PURPOSE: Manages the state of the user's card collection, interfacing with
//          OnePieceTcgService for data operations.
// ARCHITECTURE:
//   - Uses ChangeNotifier for reactive UI updates.
//   - Handles fetching, adding, updating, and removing user cards.
//   - Tracks loading state and errors for UI feedback.
// ============================================================================
class UserCardsViewModel with ChangeNotifier {
  final OnePieceTcgService _service;
  List<TCGCard> _cards = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters for UI
  List<TCGCard> get cards => _cards;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Constructor: Takes OnePieceTcgService instance
  UserCardsViewModel(this._service) {
    _fetchUserCards();
  }

  // --------------------------------------------------------------------------
  // METHOD: Fetch user's cards
  // STEPS:
  //   1. Set loading state and clear error
  //   2. Call service to get user cards
  //   3. Update cards list and notify listeners
  //   4. Handle errors if they occur
  // --------------------------------------------------------------------------
  Future<void> _fetchUserCards() async {
    try {
      _setLoading(true);
      final cards = await _service.getUserCards();
      _cards = cards;
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
  //   1. Call service to update card with new values
  //   2. Refresh card list on success
  //   3. Handle errors if they occur
  // --------------------------------------------------------------------------
  Future<void> updateCard(
    String cardId,
    int quantity,
    bool favorite,
    List<String> labels,
  ) async {
    try {
      _setLoading(true);
      await _service.updateUserCardQuantity(cardId, quantity, favorite, labels);
      await _fetchUserCards(); // Refresh collection
      _errorMessage = null;
      notifyListeners();
      developer.log(
        'Updated card $cardId: quantity=$quantity, favorite=$favorite',
      );
    } catch (e) {
      _setLoading(false);
      _errorMessage = 'Failed to update card: $e';
      notifyListeners();
      developer.log('Error updating card $cardId: $e');
    }
  }

  // --------------------------------------------------------------------------
  // METHOD: Remove card from collection
  // STEPS:
  //   1. Call service to delete card
  //   2. Refresh card list on success
  //   3. Handle errors if they occur
  // --------------------------------------------------------------------------
  Future<void> removeCard(String cardId) async {
    try {
      _setLoading(true);
      await _service.removeUserCard(cardId);
      await _fetchUserCards(); // Refresh collection
      _errorMessage = null;
      notifyListeners();
      developer.log('Removed card $cardId');
    } catch (e) {
      _setLoading(false);
      _errorMessage = 'Failed to remove card: $e';
      notifyListeners();
      developer.log('Error removing card $cardId: $e');
    }
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

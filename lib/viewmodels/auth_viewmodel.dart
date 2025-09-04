/**
 * AuthViewModel - MVVM Pattern Implementation for Authentication
 * 
 * This class implements the ViewModel layer in the MVVM (Model-View-ViewModel)
 * architectural pattern. It serves as the bridge between the UI (View) and
 * the business logic (Model/Repository).
 * 
 * Key Responsibilities:
 * - Manage authentication state (user, loading, errors)
 * - Provide methods for UI to trigger auth actions
 * - Listen to auth state changes and update UI accordingly
 * - Handle loading states and error messages
 * - Notify UI of state changes using ChangeNotifier
 * 
 * MVVM Benefits:
 * - Separation of concerns (UI logic vs business logic)
 * - Easier testing (can test ViewModel without UI)
 * - Reactive UI updates through ChangeNotifier
 * - Centralized state management for authentication
 */

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/repositories/auth_repository.dart';

class AuthViewModel with ChangeNotifier {
  // Repository for authentication operations
  final AuthRepository _authRepository = AuthRepository();

  // =================================================================
  // PRIVATE STATE VARIABLES
  // These hold the current state of authentication
  // =================================================================

  User? _currentUser; // Currently authenticated user
  bool _isLoading = false; // Loading state for UI feedback
  bool _isInitialized = false; // Whether ViewModel is ready to use
  String? _errorMessage; // Current error message to display
  bool _isAuthenticated = false; // Simplified auth status

  // =================================================================
  // PUBLIC GETTERS
  // These provide read-only access to state for the UI
  // =================================================================

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  /**
   * Constructor - Automatically initializes authentication
   * 
   * Called when ViewModel is created, starts the initialization process
   * which sets up auth state and starts listening for changes
   */

  AuthViewModel() {
    _initializeAuth();
  }

  /**
   * Initialize authentication system
   * 
   * This method:
   * 1. Gets current user (if any) from repository
   * 2. Sets up auth state listener for reactive updates
   * 3. Marks ViewModel as initialized
   * 
   * The auth state listener automatically updates the UI whenever
   * the user signs in or out, even from other parts of the app
   */
  Future<void> _initializeAuth() async {
    _setLoading(true);

    try {
      // Check if user is already signed in (persistent session)
      _currentUser = await _authRepository.getCurrentUser();
      _isAuthenticated = _currentUser != null;
      _isInitialized = true;

      // Set up listener for auth state changes
      // This enables reactive UI updates when auth state changes
      final authStream = await _authRepository.authStateChanges;
      authStream.listen((data) {
        _currentUser = data.session?.user;
        _isAuthenticated = _currentUser != null;
        print('Auth state changed: ${_currentUser?.email ?? 'No user'}');
        notifyListeners(); // Notify UI to rebuild with new state
      });
    } catch (e) {
      _setError('Failed to initialize authentication: ${e.toString()}');
      print('Auth initialization error: $e');
    } finally {
      _setLoading(false);
    }
  }

  /**
   * Register new user account
   * 
   * @param email - User's email address
   * @param password - User's chosen password
   * 
   * Process:
   * 1. Set loading state for UI feedback
   * 2. Clear any previous error messages
   * 3. Call repository to create account
   * 4. Update local state if successful
   * 5. Handle errors and update loading state
   */
  Future<void> signUpWithEmailPassword(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _authRepository.signUpWithEmailPassword(
        email,
        password,
      );
      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        print('Sign up successful: ${user.email}');
      }
    } catch (e) {
      _setError('Sign up failed: ${e.toString()}');
      print('Sign up error in viewmodel: $e');
    } finally {
      _setLoading(false);
    }
  }

  /**
   * Sign out current user
   * 
   * Clears user session and resets authentication state
   * UI will automatically update due to notifyListeners()
   */
  Future<void> signOut() async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.signOut();
      _currentUser = null;
      _isAuthenticated = false;
      print('Sign out successful');
    } catch (e) {
      _setError('Sign out failed: ${e.toString()}');
      print('Sign out error in viewmodel: $e');
    } finally {
      _setLoading(false);
    }
  }

  /**
   * Authenticate existing user
   * 
   * @param email - User's registered email
   * @param password - User's password
   * 
   * Similar to signUp but for existing users
   */
  Future<void> signInWithEmailPassword(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final user = await _authRepository.signInWithEmailPassword(
        email,
        password,
      );
      if (user != null) {
        _currentUser = user;
        _isAuthenticated = true;
        print('Sign in successful: ${user.email}');
      }
    } catch (e) {
      _setError('Sign in failed: ${e.toString()}');
      print('Sign in error in viewmodel: $e');
    } finally {
      _setLoading(false);
    }
  }

  // =================================================================
  // PRIVATE HELPER METHODS
  // These manage state updates and UI notifications
  // =================================================================

  /**
   * Update loading state and notify UI
   * 
   * @param loading - New loading state
   * 
   * notifyListeners() triggers UI rebuild in widgets that listen
   * to this ViewModel (typically through Consumer or Provider.of)
   */
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /**
   * Set error message and notify UI
   * 
   * @param error - Error message to display to user
   */
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  /**
   * Clear current error message and notify UI
   * 
   * Usually called at the start of new operations
   */
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /**
   * Public method to clear errors
   * 
   * Allows UI to manually clear error messages (e.g., when user
   * dismisses error dialog or starts typing in form)
   */
  void clearError() {
    _clearError();
  }
}

/**
 * AuthRepository - Repository Pattern Implementation for Authentication
 * 
 * This class acts as an abstraction layer between the UI (ViewModels) and
 * the data source (SupabaseDataSource). It follows the Repository pattern
 * which provides several benefits:
 * 
 * Benefits of Repository Pattern:
 * - Decouples business logic from data access logic
 * - Makes testing easier (can mock repository)
 * - Centralizes data access logic
 * - Provides consistent interface regardless of data source
 * 
 * Architecture Flow:
 * UI Layer (Widgets) -> ViewModel Layer -> Repository Layer -> DataSource Layer
 */

import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/supabase_datasource.dart';

class AuthRepository {
  // DataSource instance for actual Supabase operations
  late SupabaseDataSource _dataSource;

  // Initialization tracking to ensure dataSource is ready before use
  bool _initialized = false;

  /**
   * Lazy initialization pattern
   * 
   * Ensures SupabaseDataSource is initialized before any operations
   * This prevents errors when repository methods are called before
   * the underlying Supabase connection is established
   */
  Future<void> _ensureInitialized() async {
    if (_initialized) return; // Already initialized, skip
    _dataSource = await SupabaseDataSource.getInstance();
    _initialized = true;
  }

  /**
   * Register new user account
   * 
   * @param email - User's email address
   * @param password - User's chosen password
   * @return User object if registration successful, null otherwise
   * 
   * Process:
   * 1. Ensure dataSource is initialized
   * 2. Call dataSource signUp method
   * 3. Extract user from response
   * 4. Return user or handle errors
   * 
   * Note: Repository layer handles initialization and extracts
   * relevant data (User) from the full response
   */

  Future<User?> signUpWithEmailPassword(String email, String password) async {
    await _ensureInitialized();
    try {
      final response = await _dataSource.signUpWithEmailPassword(
        email,
        password,
      );
      // Extract User object from AuthResponse
      return response.user;
    } catch (e) {
      print('Repository signUp error: $e');
      rethrow; // Pass error up to ViewModel for handling
    }
  }

  /**
   * Authenticate existing user
   * 
   * @param email - User's registered email
   * @param password - User's password
   * @return User object if login successful, null otherwise
   * 
   * Similar to signUp but for existing users
   * Creates session that persists across app restarts
   */
  Future<User?> signInWithEmailPassword(String email, String password) async {
    await _ensureInitialized();
    try {
      final response = await _dataSource.signInWithEmailPassword(
        email,
        password,
      );
      return response.user;
    } catch (e) {
      print('Repository signIn error: $e');
      rethrow;
    }
  }

  /**
   * Sign out current user
   * 
   * Clears session and triggers auth state change
   * No return value needed - either succeeds or throws exception
   */
  Future<void> signOut() async {
    await _ensureInitialized();
    try {
      await _dataSource.signOut();
    } catch (e) {
      print('Repository signOut error: $e');
      rethrow;
    }
  }

  /**
   * Get current authenticated user
   * 
   * @return Current User or null if not authenticated
   * 
   * This is a synchronous check of the current session
   * No network call needed - checks local session
   */
  Future<User?> getCurrentUser() async {
    await _ensureInitialized();
    return _dataSource.getCurrentUser();
  }

  /**
   * Stream of authentication state changes
   * 
   * @return Stream<AuthState> for reactive UI updates
   * 
   * Use this to automatically update UI when user signs in/out
   * ViewModels can listen to this stream to update their state
   */
  Future<Stream<AuthState>> get authStateChanges async {
    await _ensureInitialized();
    return _dataSource.authStateChanges;
  }

  /**
   * Convenience method to check if user is authenticated
   * 
   * @return true if user is signed in, false otherwise
   * 
   * Simplifies checking auth state without dealing with User object
   */
  Future<bool> get isAuthenticated async {
    final user = await getCurrentUser();
    return user != null;
  }
}

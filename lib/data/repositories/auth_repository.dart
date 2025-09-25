//lib/data/repositories/auth_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../datasources/supabase_datasource.dart';

class AuthRepository {
  // DataSource instance for actual Supabase operations
  late SupabaseDataSource _dataSource;

  // Initialization tracking to ensure dataSource is ready before use
  bool _initialized = false;

  // Initialize SupabaseDataSource if not already done
  Future<void> _ensureInitialized() async {
    if (_initialized) return; // Already initialized, skip
    _dataSource = await SupabaseDataSource.getInstance();
    _initialized = true;
  }

  // Register user with email and password, returns User or null
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

  // Log in user with email and password, returns User or null
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

  // Log out current user, clears session
  Future<void> signOut() async {
    await _ensureInitialized();
    try {
      await _dataSource.signOut();
    } catch (e) {
      print('Repository signOut error: $e');
      rethrow;
    }
  }

  // Get current authenticated user or null
  Future<User?> getCurrentUser() async {
    await _ensureInitialized();
    return _dataSource.getCurrentUser();
  }

  // Stream of auth state changes for reactive UI updates
  Future<Stream<AuthState>> get authStateChanges async {
    await _ensureInitialized();
    return _dataSource.authStateChanges;
  }

  // Check if user is authenticated
  Future<bool> get isAuthenticated async {
    final user = await getCurrentUser();
    return user != null;
  }

  // Resend email confirmation to specified email
  Future<void> resendEmailConfirmation(String email) async {
    await _ensureInitialized();
    try {
      await _dataSource.resendEmailConfirmation(email);
      print('Email confirmation resent to: $email');
    } catch (e) {
      print('Repository resend email confirmation error: $e');
      rethrow;
    }
  }
}

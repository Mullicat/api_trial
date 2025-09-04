// lib/data/datasources/supabase_datasource.dart

/*
 * SupabaseDataSource - Data Access Layer for Supabase Backend
 * 
 * This class implements the Singleton pattern to ensure only one instance
 * of the Supabase client exists throughout the app lifecycle.
 * 
 * Responsibilities:
 * - Initialize Supabase connection with environment variables
 * - Provide authentication methods (sign up, sign in, sign out)
 * - Handle image upload/download to Supabase Storage
 * - Manage database operations for uploaded images
 * 
 * Design Pattern: Singleton + Repository Pattern
 * Why Singleton? Supabase client should be initialized once and reused
 */

import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseDataSource {
  // Singleton instance - only one SupabaseDataSource can exist
  static SupabaseDataSource? _instance;

  // Supabase client - the main connection to our backend
  static SupabaseClient? _client;

  // Private constructor prevents direct instantiation
  // Forces use of getInstance() method
  SupabaseDataSource._();

  /*
   * Singleton pattern implementation
   * Returns existing instance or creates new one if doesn't exist
   * 
   * Usage: final dataSource = await SupabaseDataSource.getInstance();
   */
  static Future<SupabaseDataSource> getInstance() async {
    if (_instance == null) {
      _instance = SupabaseDataSource._();
      await _instance!._initialize();
    }
    return _instance!;
  }

  /*
   * Initialize Supabase connection with environment variables
   * 
   * Process:
   * 1. Load .env file from assets folder
   * 2. Extract SUPABASE_URL and SUPABASE_KEY
   * 3. Initialize Supabase with these credentials
   * 4. Create client instance for future operations
   * 
   * Security: Environment variables keep sensitive data out of source code
   */

  Future<void> _initialize() async {
    // Prevent multiple initializations
    if (_client != null) return;

    try {
      // Load environment variables from assets/.env file
      await dotenv.load(fileName: "assets/.env");

      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final supabaseKey = dotenv.env['SUPABASE_KEY'];

      // Validate that required environment variables exist
      if (supabaseUrl == null || supabaseKey == null) {
        throw Exception('Supabase URL or Key not found in .env file');
      }

      // Initialize Supabase with URL and anonymous key
      // This creates the global Supabase instance
      await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

      // Get reference to the initialized client
      _client = Supabase.instance.client;
      print('Supabase initialized successfully');
    } catch (e) {
      print('Error initializing Supabase: $e');
      rethrow; // Re-throw to let caller handle the error
    }
  }

  /*
   * Getter for Supabase client with safety check
   * 
   * Returns the initialized Supabase client or throws exception
   * if not properly initialized. This prevents null pointer exceptions.
   */
  SupabaseClient get supabase {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call getInstance() first.');
    }
    return _client!;
  }

  // =================================================================
  // AUTHENTICATION METHODS
  // These methods handle user registration, login, and logout
  // =================================================================

  /*
   * Register new user with email and password
   * 
   * @param email - User's email address
   * @param password - User's chosen password
   * @return AuthResponse containing user info and session
   * 
   * Note: Supabase may send confirmation email depending on settings
   */

  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      print('Sign up error: $e');
      rethrow; // Let upper layers handle specific error types
    }
  }

  /*
   * Authenticate existing user with email and password
   * 
   * @param email - User's registered email
   * @param password - User's password
   * @return AuthResponse with user session if successful
   * 
   * Creates a session that persists across app restarts
   */
  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  /*
   * Sign out current user and clear session
   * 
   * This will:
   * - Clear local session data
   * - Invalidate JWT token
   * - Trigger auth state change listeners
   */
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  /*
   * Get currently authenticated user (if any)
   * 
   * @return User object or null if not authenticated
   * 
   * This checks the current session without making network calls
   */
  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  /*
   * Stream of authentication state changes
   * 
   * @return Stream<AuthState> that emits when user signs in/out
   * 
   * Useful for reactive UI updates when auth state changes
   * Listen to this stream to automatically update UI
   */
  Stream<AuthState> get authStateChanges {
    return supabase.auth.onAuthStateChange;
  }

  // =================================================================
  // IMAGE STORAGE METHODS
  // These methods handle image upload/download to Supabase Storage
  // =================================================================

  /*
   * Upload image file to Supabase Storage
   * 
   * @param file - Image file from device (File object)
   * @param path - Desired path/filename in storage
   * @return Public URL of uploaded image or null if failed
   * 
   * Process:
   * 1. Check user authentication (required for uploads)
   * 2. Create user-specific path to prevent conflicts
   * 3. Upload file to 'images' bucket
   * 4. Generate and return public URL for accessing image
   * 
   * Security: Files are organized by user_id to implement access control
   */

  Future<String?> uploadImage(File file, String path) async {
    try {
      // Verify user is authenticated before allowing upload
      final user = getCurrentUser();
      if (user == null) {
        throw Exception('User must be authenticated to upload images');
      }

      print('Uploading image as user: ${user.email}');

      // Create user-specific path to prevent filename conflicts
      // Format: user_[userid]/[original_path]
      final userPath = 'user_${user.id}/$path';

      // Upload file to 'images' bucket in Supabase Storage
      final response = await supabase.storage
          .from('images') // Bucket name - must exist in Supabase
          .upload(
            userPath, // Path within bucket
            file, // File to upload
            fileOptions: const FileOptions(
              contentType: 'image/jpeg', // MIME type for proper handling
              upsert: false, // Don't overwrite existing files
            ),
          );

      // Check if upload was successful
      if (response.isNotEmpty) {
        // Generate public URL for accessing the uploaded image
        final publicUrl = supabase.storage
            .from('images')
            .getPublicUrl(userPath);
        print('Image uploaded successfully: $publicUrl');
        return publicUrl;
      } else {
        throw Exception('Image upload failed: Empty response');
      }
    } catch (e) {
      print('Upload error: $e');
      // Provide helpful error messages for common issues
      if (e.toString().contains('row-level security policy')) {
        throw Exception(
          'Storage access denied. Please check Supabase RLS policies for the images bucket.',
        );
      }
      throw Exception('Image upload failed: $e');
    }
  }

  /*
   * Fetch all uploaded images from database
   * 
   * @return List of image metadata records
   * 
   * Retrieves image records from 'uploaded_images' table
   * Ordered by creation date (newest first)
   * 
   * Note: This returns metadata, not actual image files
   * Use the URLs in the records to display images
   */
  Future<List<Map<String, dynamic>>> fetchImages() async {
    try {
      final response = await supabase
          .from('uploaded_images') // Table name
          .select() // Select all columns
          .order('created_at', ascending: false); // Newest first

      return response;
    } catch (e) {
      print('Fetch images error: $e');
      throw Exception('Error fetching images: $e');
    }
  }

  /*
   * Fetch single image record by ID
   * 
   * @param id - Unique identifier of the image record
   * @return Image metadata record or null if not found
   * 
   * Uses .single() which expects exactly one match
   * Throws exception if 0 or multiple records found
   */
  Future<Map<String, dynamic>?> fetchImage(String id) async {
    try {
      final response = await supabase
          .from('uploaded_images')
          .select()
          .eq('id', id) // WHERE id = ?
          .single(); // Expect exactly one result

      return response;
    } catch (e) {
      print('Fetch image error: $e');
      throw Exception('Error fetching image: $e');
    }
  }
}

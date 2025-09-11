import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseDataSource {
  static SupabaseDataSource? _instance;
  static SupabaseClient? _client;

  SupabaseDataSource._();

  static Future<SupabaseDataSource> getInstance() async {
    if (_instance == null) {
      _instance = SupabaseDataSource._();
      await _instance!._initialize();
    }
    return _instance!;
  }

  Future<void> _initialize() async {
    if (_client != null) return;

    try {
      await dotenv.load(fileName: "assets/.env");
      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final supabaseKey = dotenv.env['SUPABASE_KEY'];

      if (supabaseUrl == null || supabaseKey == null) {
        throw Exception('Supabase URL or Key not found in .env file');
      }

      await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
      _client = Supabase.instance.client;
    } catch (e) {
      rethrow;
    }
  }

  SupabaseClient get supabase {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call getInstance() first.');
    }
    return _client!;
  }

  // Authentication methods (unchanged)
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
      rethrow;
    }
  }

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

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  Stream<AuthState> get authStateChanges {
    return supabase.auth.onAuthStateChange;
  }

  Future<void> resendEmailConfirmation(String email) async {
    try {
      await supabase.auth.resend(type: OtpType.signup, email: email);
      print('Email confirmation resent to: $email');
    } catch (e) {
      print('Resend email confirmation error: $e');
      throw Exception('Failed to resend email confirmation: $e');
    }
  }

  // Image storage methods
  Future<String?> uploadImage(File file, String path) async {
    try {
      final user = getCurrentUser();
      if (user == null) {
        throw Exception('User must be authenticated to upload images');
      }
      print('Uploading image as user: ${user.email}');
      final userPath = 'user_${user.id}/$path';
      final response = await supabase.storage
          .from('images')
          .upload(
            userPath,
            file,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: false,
            ),
          );
      if (response.isNotEmpty) {
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
      if (e.toString().contains('row-level security policy')) {
        throw Exception(
          'Storage access denied. Please check Supabase RLS policies for the images bucket.',
        );
      }
      throw Exception('Image upload failed: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchImages() async {
    try {
      final response = await supabase
          .from('uploaded_images')
          .select()
          .order('created_at', ascending: false);
      return response;
    } catch (e) {
      print('Fetch images error: $e');
      throw Exception('Error fetching images: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchImage(String id) async {
    try {
      final response = await supabase
          .from('uploaded_images')
          .select()
          .eq('id', id)
          .single();
      return response;
    } catch (e) {
      print('Fetch image error: $e');
      throw Exception('Error fetching image: $e');
    }
  }

  // Card-related methods
  Future<List<Map<String, dynamic>>> getCardsByGameCode({
    required String gameCode,
    required String gameType,
    required String imageRefSmall,
  }) async {
    try {
      final response = await supabase
          .from('cards')
          .select()
          .eq('game_code', gameCode)
          .eq('game_type', gameType)
          .eq('image_ref_small', imageRefSmall);
      return response;
    } catch (e) {
      print('Error fetching cards by game_code: $e');
      throw Exception('Error fetching cards: $e');
    }
  }

  Future<void> upsertCards(List<Map<String, dynamic>> cards) async {
    try {
      await supabase
          .from('cards')
          .upsert(
            cards,
            onConflict: 'game_code,game_type,set_name,image_ref_small',
          );
      print('Upserted ${cards.length} cards to Supabase');
    } catch (e) {
      print('Error upserting cards: $e');
      throw Exception('Error upserting cards: $e');
    }
  }
}

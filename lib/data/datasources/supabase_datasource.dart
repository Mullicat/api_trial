//lib/data/datasources/supabase_datasource.dart
import 'dart:developer' as developer;
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:api_trial/constants/enums/onepiece_filters.dart';

class SupabaseDataSource {
  static SupabaseDataSource? _instance;
  static SupabaseClient? _client;

  SupabaseDataSource._();

  // Initializes the singleton instance of SupabaseDataSource
  static Future<SupabaseDataSource> getInstance() async {
    if (_instance == null) {
      _instance = SupabaseDataSource._();
      await _instance!._initialize();
    }
    return _instance!;
  }

  // Loads Supabase credentials from .env and initializes the Supabase client
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

  // Provides access to the Supabase client
  SupabaseClient get supabase {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call getInstance() first.');
    }
    return _client!;
  }

  // Signs up a user with email and password
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

  // Signs in a user with email and password
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

  // Signs out the current user
  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  // Retrieves the current authenticated user
  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  // Streams authentication state changes
  Stream<AuthState> get authStateChanges {
    return supabase.auth.onAuthStateChange;
  }

  // Resends email confirmation for a user
  Future<void> resendEmailConfirmation(String email) async {
    try {
      await supabase.auth.resend(type: OtpType.signup, email: email);
      print('Email confirmation resent to: $email');
    } catch (e) {
      print('Resend email confirmation error: $e');
      throw Exception('Failed to resend email confirmation: $e');
    }
  }

  // Uploads an image to Supabase storage and returns its public URL
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

  // Fetches all images from the uploaded_images table
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

  // Fetches a single image by ID from the uploaded_images table
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

  // Fetches cards by game_code, game_type, and image_ref_small for duplicate/version checking
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

  // Upserts cards to the cards table, handling conflicts
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

  // Search cards by (fuzzy) name or game_code with filters
  Future<List<Map<String, dynamic>>> searchCardsByTerm({
    required String searchTerm,
    required String gameType,
    SetName? setName,
    Rarity? rarity,
    Cost? cost,
    Type? type,
    Color? color,
    Power? power,
    List<Family>? families,
    Counter? counter,
    Trigger? trigger,
    Ability? ability,
    int page = 1,
    int pageSize = 100,
  }) async {
    try {
      var query = supabase
          .from('cards')
          .select()
          .eq('game_type', gameType)
          .or(
            'name.ilike.%$searchTerm%,game_code.ilike.%$searchTerm%',
          ); // Fuzzy search on name AND game_code

      if (setName != null) query = query.eq('set_name', setName.value);
      if (rarity != null) query = query.eq('rarity', rarity.value);
      if (cost != null)
        query = query.eq('game_specific_data->>cost', cost.value);
      if (type != null)
        query = query.eq('game_specific_data->>type', type.value);
      if (color != null)
        query = query.eq('game_specific_data->>color', color.value);
      if (power != null)
        query = query.eq('game_specific_data->>power', power.value);

      if (families != null && families.isNotEmpty) {
        final familyValues = families.map((f) => f.value).toList();
        query = query.contains('game_specific_data->family', familyValues);
      }

      if (counter != null)
        query = query.eq('game_specific_data->>counter', counter.value);

      if (trigger != null) {
        if (trigger == Trigger.hasTrigger) {
          query = query
              .neq('game_specific_data->>trigger', '')
              .not('game_specific_data->>trigger', 'is', null);
        } else if (trigger == Trigger.noTrigger) {
          query = query.or(
            'game_specific_data->>trigger.eq.,game_specific_data->>trigger.is.null',
          );
        }
      }

      if (ability != null) {
        query = query.ilike(
          'game_specific_data->>ability',
          '%${ability.value}%',
        );
      }

      final offset = (page - 1) * pageSize;
      final response = await query.range(
        offset,
        offset + (pageSize > 100 ? 100 : pageSize) - 1,
      );
      return response as List<Map<String, dynamic>>;
    } catch (e) {
      throw Exception('Error searching cards: $e');
    }
  }

  /// NEW: fetch One Piece cards by exact game_code (base), returning all versions/prints
  Future<List<Map<String, dynamic>>> fetchOnePieceCardsByGameCode(
    String gameCodeBase,
  ) async {
    try {
      final response = await supabase
          .from('cards')
          .select()
          .eq('game_type', 'onepiece')
          .eq('game_code', gameCodeBase)
          .order('version', ascending: true, nullsFirst: false)
          .order('updated_at', ascending: false);
      return (response as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (e) {
      throw Exception('Error fetching One Piece cards by code: $e');
    }
  }

  // Fetch all cards owned by a user (joins with cards table)
  Future<List<Map<String, dynamic>>> getUserCards(String userId) async {
    try {
      return await supabase
          .from('user_cards')
          .select('*, card:card_id(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);
    } catch (e) {
      developer.log('Error fetching user cards: $e');
      throw e;
    }
  }

  // Add or upsert a card to a user's collection (increments quantity if exists)
  Future<void> addUserCard(String userId, String cardId, int quantity) async {
    try {
      await supabase.rpc(
        'add_user_card',
        params: {
          'p_user_id': userId,
          'p_card_id': cardId,
          'p_quantity': quantity,
        },
      );
    } catch (e) {
      developer.log('Error adding user card: $e');
      throw e;
    }
  }

  // Update a user card's quantity, favorite, or labels
  Future<void> updateUserCard(
    String userId,
    String cardId,
    int quantity,
    bool favorite,
    List<String> labels,
  ) async {
    try {
      await supabase
          .from('user_cards')
          .update({
            'quantity': quantity,
            'favorite': favorite,
            'labels': labels,
          })
          .eq('user_id', userId)
          .eq('card_id', cardId);
    } catch (e) {
      developer.log('Error updating user card: $e');
      throw e;
    }
  }

  // Delete a user card
  Future<void> deleteUserCard(String userId, String cardId) async {
    try {
      await supabase
          .from('user_cards')
          .delete()
          .eq('user_id', userId)
          .eq('card_id', cardId);
    } catch (e) {
      developer.log('Error deleting user card: $e');
      throw e;
    }
  }
}

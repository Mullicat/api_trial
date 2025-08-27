// lib/data/datasources/supabase_datasource.dart
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseDataSource {
  late final SupabaseClient supabase;

  SupabaseDataSource() {
    _initializeSupabase();
  }

  Future<void> _initializeSupabase() async {
    await dotenv.load(fileName: "assets/.env");
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseKey = dotenv.env['SUPABASE_KEY'];

    if (supabaseUrl == null || supabaseKey == null) {
      throw Exception('Supabase URL or Key not found');
    }

    supabase = SupabaseClient(supabaseUrl, supabaseKey);
  }

  Future<String?> uploadImage(File file, String path) async {
    try {
      final response = await supabase.storage
          .from('images')
          .upload(
            path,
            file,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );

      if (response.isNotEmpty) {
        return supabase.storage.from('images').getPublicUrl(path);
      } else {
        throw Exception('Image upload failed: Empty response');
      }
    } catch (e) {
      print('Upload error: $e');
      throw Exception('Image upload failed: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchImages() async {
    try {
      final response = await supabase
          .from('uploaded_images')
          .select()
          .order('created_at', ascending: false);

      return response as List<Map<String, dynamic>>;
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

      return response as Map<String, dynamic>;
    } catch (e) {
      print('Fetch image error: $e');
      throw Exception('Error fetching image: $e');
    }
  }
}

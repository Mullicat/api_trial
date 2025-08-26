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
    final supabaseUrl = 'https://xyzcompany.supabase.co';
    final supabaseKey = dotenv.env['SUPABASE_KEY'];
    if (supabaseKey == null) {
      throw Exception('Supabase key not found in .env');
    }
    supabase = SupabaseClient(supabaseUrl, supabaseKey);
  }

  Future<String?> uploadImage(File file, String fileName) async {
    try {
      final response = await supabase.storage
          .from('images')
          .uploadBinary(fileName, await file.readAsBytes());

      // If uploadBinary returns a non-empty string, it's the file path; otherwise, throw an error
      if (response.isNotEmpty) {
        return supabase.storage.from('images').getPublicUrl(fileName);
      } else {
        throw Exception('Image upload failed');
      }
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchImages() async {
    try {
      final response = await supabase
          .from('images')
          .select()
          .order('created_at', ascending: false);

      return response as List<Map<String, dynamic>>;
    } catch (e) {
      throw Exception('Error fetching images: $e');
    }
  }
}

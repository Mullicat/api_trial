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
    final supabaseUrl = "https://dexdpnudqzltludhtgub.supabase.co";
    final supabaseKey = dotenv.env['SUPABASE_KEY'];

    if (supabaseUrl == null || supabaseKey == null) {
      throw Exception('Supabase URL or Key not found in .env file');
    }

    supabase = SupabaseClient(supabaseUrl, supabaseKey);
  }

  Future<String?> uploadImage(File file, String fileName) async {
    try {
      final response = await supabase.storage
          .from('images') // Ensure this bucket exists
          .uploadBinary(
            fileName,
            await file.readAsBytes(),
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );

      if (response.isNotEmpty) {
        return supabase.storage.from('images').getPublicUrl(fileName);
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
          .from('uploaded_images') // Changed from 'images' to match table name
          .select()
          .order('created_at', ascending: false);

      return response as List<Map<String, dynamic>>;
    } catch (e) {
      print('Fetch images error: $e');
      throw Exception('Error fetching images: $e');
    }
  }
}

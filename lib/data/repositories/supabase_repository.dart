// lib/data/repositories/supabase_repository.dart
import 'dart:io';
import '../datasources/supabase_datasource.dart';
import '../../models/image_model.dart';
// import 'package:image_picker/image_picker.dart';

class SupabaseRepository {
  // DataSource instance for actual Supabase operations
  late SupabaseDataSource _dataSource;

  // Initialization tracking to ensure dataSource is ready before use
  bool _initialized = false;

  // Initialize SupabaseDataSource if not already done
  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      _dataSource = await SupabaseDataSource.getInstance();
      _initialized = true;
    }
  }

  // Upload image file to Supabase, returns UploadedImage or null
  Future<UploadedImage?> uploadImage(File file, String path) async {
    await _ensureInitialized();
    try {
      final url = await _dataSource.uploadImage(file, path);
      if (url != null) {
        return UploadedImage(
          url: url,
          name: path.split('/').last,
          createdAt: DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      print('Repository upload error: $e');
      return null;
    }
  }

  // Fetch list of uploaded images from Supabase
  Future<List<UploadedImage>> getUploadedImages() async {
    await _ensureInitialized();
    try {
      final imagesData = await _dataSource.fetchImages();
      print('Fetched images data: $imagesData');
      return imagesData.map((json) => UploadedImage.fromJson(json)).toList();
    } catch (e) {
      print('Repository fetch error: $e');
      return [];
    }
  }

  // Save image metadata to Supabase, returns saved UploadedImage or null
  Future<UploadedImage?> saveImageMetadata(UploadedImage image) async {
    await _ensureInitialized();
    try {
      final currentUser = _dataSource.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User must be authenticated to save image metadata');
      }

      final response = await _dataSource.supabase
          .from('uploaded_images')
          .insert({
            'url': image.url,
            'name': image.name,
            'user_id': currentUser.id,
            'created_at': image.createdAt?.toIso8601String(),
          })
          .select('id, url, name, user_id, created_at')
          .single();
      print('Metadata response: $response');
      return UploadedImage.fromJson(response);
    } catch (e) {
      print('Save metadata error: $e');
      return null;
    }
  }

  // Fetch single image by ID from Supabase, returns UploadedImage or null
  Future<UploadedImage?> getImage(String id) async {
    await _ensureInitialized();
    try {
      final imageData = await _dataSource.fetchImage(id);
      if (imageData != null) {
        return UploadedImage.fromJson(imageData);
      }
      return null;
    } catch (e) {
      print('Repository get image error: $e');
      return null;
    }
  }
}

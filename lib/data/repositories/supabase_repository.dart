// lib/data/repositories/supabase_repository.dart
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../datasources/supabase_datasource.dart';
import '../../models/image_model.dart';

class SupabaseRepository {
  final SupabaseDataSource _dataSource = SupabaseDataSource();

  Future<UploadedImage?> uploadImage(File file, String path) async {
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

  Future<List<UploadedImage>> getUploadedImages() async {
    try {
      final imagesData = await _dataSource.fetchImages();
      print('Fetched images data: $imagesData'); // Debug log
      return imagesData.map((json) => UploadedImage.fromJson(json)).toList();
    } catch (e) {
      print('Repository fetch error: $e');
      return [];
    }
  }

  Future<UploadedImage?> saveImageMetadata(UploadedImage image) async {
    try {
      final response = await _dataSource.supabase
          .from('uploaded_images')
          .insert({
            'url': image.url,
            'name': image.name,
            'created_at': image.createdAt?.toIso8601String(),
          })
          .select('id, url, name, created_at')
          .single();
      print('Metadata response: $response'); // Debug log
      return UploadedImage.fromJson(response);
    } catch (e) {
      print('Save metadata error: $e');
      return null;
    }
  }

  Future<UploadedImage?> getImage(String id) async {
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

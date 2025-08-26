// lib/data/repositories/supabase_repository.dart
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../datasources/supabase_datasource.dart';
import '../../models/image_model.dart'; // Assuming this contains UploadedImage

class SupabaseRepository {
  final SupabaseDataSource _dataSource = SupabaseDataSource();

  // Upload image from image_picker XFile
  Future<UploadedImage?> uploadImage(XFile imageFile, String fileName) async {
    try {
      final fileExtension = imageFile.path.split('.').last;
      final file = File(imageFile.path);

      final url = await _dataSource.uploadImage(file, fileName);
      if (url != null) {
        return UploadedImage(
          name: fileName,
          url: url,
          createdAt: DateTime.now(), // Temporary until saved to table
        );
      }
      return null;
    } catch (e) {
      print('Repository upload error: $e');
      return null;
    }
  }

  // Fetch all uploaded images
  Future<List<UploadedImage>> getUploadedImages() async {
    try {
      final imagesData = await _dataSource.fetchImages();
      return imagesData.map((json) => UploadedImage.fromJson(json)).toList();
    } catch (e) {
      print('Repository fetch error: $e');
      return [];
    }
  }

  // Optional: Save image metadata to Supabase table
  Future<UploadedImage?> saveImageMetadata(UploadedImage image) async {
    try {
      final response = await _dataSource.supabase
          .from('uploaded_images')
          .insert({
            'url': image.url,
            'created_at': image.createdAt?.toIso8601String(),
          })
          .select('id, url, created_at')
          .single();
      return UploadedImage.fromJson(response);
    } catch (e) {
      print('Save metadata error: $e');
      return null;
    }
  }
}

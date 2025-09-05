import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import '../data/repositories/supabase_repository.dart';
import '../models/image_model.dart';
import 'package:image/image.dart' as img;

// Service for handling image-related operations (picking, scanning, uploading, storage).
class ImageService {
  final ImagePicker _picker = ImagePicker();
  final SupabaseRepository _repository = SupabaseRepository();

  // Picks an image from the specified source (camera or gallery).
  Future<File?> pickImage(ImageSource source) async {
    final permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;
    final status = await permission.request();

    if (status.isPermanentlyDenied) {
      throw Exception(
        'Permission permanently denied. Please enable in settings.',
      );
    } else if (status.isDenied) {
      throw Exception('Permission denied');
    }

    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 800,
      maxHeight: 600,
    );

    if (pickedFile == null) {
      throw Exception('No image selected');
    }

    final file = File(pickedFile.path);
    if (!await file.exists()) {
      throw Exception('File does not exist: ${pickedFile.path}');
    }

    return file;
  }

  // Scans a single document using the device camera.
  Future<File?> scanSingle() async {
    final status = await Permission.camera.request();
    if (status.isPermanentlyDenied) {
      throw Exception(
        'Camera permission permanently denied. Please enable in settings.',
      );
    } else if (status.isDenied) {
      throw Exception('Camera permission denied');
    }

    final scannedDocuments = await CunningDocumentScanner.getPictures(
      noOfPages: 1,
    );
    if (scannedDocuments == null || scannedDocuments.isEmpty) {
      throw Exception('No document scanned or user cancelled');
    }

    final path = scannedDocuments[0];
    File imageFile = File(path);
    if (!await imageFile.exists()) {
      throw Exception('Scanned file does not exist at path: $path');
    }

    // Copy to app storage for reliability
    return await _copyToAppStorage(path) ?? imageFile;
  }

  // Uploads an image to Supabase and saves its metadata.
  Future<UploadedImage?> uploadImage(File imageFile, String fileName) async {
    if (!await imageFile.exists()) {
      throw Exception('File does not exist: ${imageFile.path}');
    }

    final image = await _repository.uploadImage(imageFile, fileName);
    if (image == null) {
      throw Exception('Image upload failed');
    }

    return await _repository.saveImageMetadata(image);
  }

  // Fetches all uploaded images from Supabase.
  Future<List<UploadedImage>> fetchUploadedImages() async {
    final images = await _repository.getUploadedImages();
    if (images.isEmpty) {
      throw Exception('No uploaded images found in the database.');
    }
    return images;
  }

  // Copies a file to app storage with a unique filename.
  Future<File?> _copyToAppStorage(String sourcePath) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final newFileName =
          DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
      final newFilePath = '${tempDir.path}/$newFileName';
      final newFile = await File(sourcePath).copy(newFilePath);
      return await newFile.exists() ? newFile : null;
    } catch (e) {
      return null;
    }
  }

  // Gets the dimensions of an image file.
  Future<Map<String, int>> getImageDimensions(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      return image != null
          ? {'width': image.width, 'height': image.height}
          : {'width': 800, 'height': 600}; // Fallback dimensions
    } catch (e) {
      return {'width': 800, 'height': 600}; // Fallback dimensions
    }
  }
}

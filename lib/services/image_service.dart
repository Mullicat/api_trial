// lib/services/image_service.dart
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

  // FUNC 1: Picks an image from the specified source (camera or gallery).
  Future<File?> pickImage(ImageSource source) async {
    // Step 1: Checks permission for photos & camera
    final permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;
    final status = await permission.request();
    // Step 2: If no permission, deny
    if (status.isPermanentlyDenied) {
      throw Exception(
        'Permission permanently denied. Please enable in settings.',
      );
    } else if (status.isDenied) {
      throw Exception('Permission denied');
    }
    // Step 3: Define XFile aspects
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 800,
      maxHeight: 600,
    );

    if (pickedFile == null) {
      throw Exception('No image selected');
    }
    // Step 4: Final File definition
    final file = File(pickedFile.path);
    if (!await file.exists()) {
      throw Exception('File does not exist: ${pickedFile.path}');
    }

    return file;
  }

  // FUNC 2: Scans a single document using the device camera.
  Future<File?> scanSingle() async {
    // Step 1: Check permissions
    final status = await Permission.camera.request();
    if (status.isPermanentlyDenied) {
      throw Exception(
        'Camera permission permanently denied. Please enable in settings.',
      );
    } else if (status.isDenied) {
      throw Exception('Camera permission denied');
    }

    // Step 2: Use Document library for scanning
    final scannedDocuments = await CunningDocumentScanner.getPictures(
      noOfPages: 1,
    );
    if (scannedDocuments == null || scannedDocuments.isEmpty) {
      throw Exception('No document scanned or user cancelled');
    }
    // Step 3: Extract path and check Image presence
    final path = scannedDocuments[0];
    File imageFile = File(path);
    if (!await imageFile.exists()) {
      throw Exception('Scanned file does not exist at path: $path');
    }

    // Step 4: Copy to app storage for reliability
    return await _copyToAppStorage(path) ?? imageFile;
  }

  // FUNC 3: Uploads an image to Supabase and saves its metadata.
  Future<UploadedImage?> uploadImage(File imageFile, String fileName) async {
    if (!await imageFile.exists()) {
      throw Exception('File does not exist: ${imageFile.path}');
    }
    // Step 1: Upload Image to Supabase
    final image = await _repository.uploadImage(imageFile, fileName);
    if (image == null) {
      throw Exception('Image upload failed');
    }
    // Step 2: Upload Metadata to Supabase
    return await _repository.saveImageMetadata(image);
  }

  // FUNC 4: Fetches all uploaded images from Supabase.
  Future<List<UploadedImage>> fetchUploadedImages() async {
    final images = await _repository.getUploadedImages();
    if (images.isEmpty) {
      throw Exception('No uploaded images found in the database.');
    }
    return images;
  }

  // COMP 1: Copies a file to app storage with a unique filename.
  Future<File?> _copyToAppStorage(String sourcePath) async {
    try {
      // Step 1: get temporary directory
      final tempDir = await getTemporaryDirectory();
      // Step 2: Define name through time taken
      final newFileName =
          DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
      // Step 3: Definition of new file's path and the file
      final newFilePath = '${tempDir.path}/$newFileName';
      final newFile = await File(sourcePath).copy(newFilePath);
      return await newFile.exists() ? newFile : null;
    } catch (e) {
      return null;
    }
  }

  // FUNC 5: Get image dimensions from a File
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

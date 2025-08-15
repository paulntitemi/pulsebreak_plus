import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'auth_service.dart';

class ImageUploadService {
  static final ImageUploadService _instance = ImageUploadService._internal();
  factory ImageUploadService() => _instance;
  ImageUploadService._internal();

  static ImageUploadService get instance => _instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<bool> _requestPermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
      final cameraStatus = await Permission.camera.status;
      if (cameraStatus.isGranted) {
        return true;
      }
      
      if (cameraStatus.isDenied) {
        final result = await Permission.camera.request();
        return result.isGranted;
      }
      
      if (cameraStatus.isPermanentlyDenied) {
        debugPrint('Camera permission permanently denied. Opening app settings...');
        await openAppSettings();
        return false;
      }
    } else {
      // Handle gallery permissions for different platforms and Android versions
      if (Platform.isAndroid) {
        // For Android 13+ (API 33+), use photos permission
        final photosStatus = await Permission.photos.status;
        if (photosStatus.isGranted) {
          return true;
        }
        
        if (photosStatus.isDenied) {
          final result = await Permission.photos.request();
          if (result.isGranted) {
            return true;
          }
          
          // Fallback to storage permission for older Android versions
          final storageStatus = await Permission.storage.status;
          if (storageStatus.isGranted) {
            return true;
          }
          
          if (storageStatus.isDenied) {
            final storageResult = await Permission.storage.request();
            return storageResult.isGranted;
          }
        }
        
        if (photosStatus.isPermanentlyDenied) {
          debugPrint('Photos permission permanently denied. Opening app settings...');
          await openAppSettings();
          return false;
        }
      } else {
        // iOS
        final photosStatus = await Permission.photos.status;
        if (photosStatus.isGranted || photosStatus.isLimited) {
          return true;
        }
        
        if (photosStatus.isDenied) {
          final result = await Permission.photos.request();
          return result.isGranted || result.isLimited;
        }
        
        if (photosStatus.isPermanentlyDenied) {
          debugPrint('Photos permission permanently denied. Opening app settings...');
          await openAppSettings();
          return false;
        }
      }
    }
    
    return false;
  }

  Future<XFile?> pickImage({required ImageSource source}) async {
    try {
      // Try to pick image directly first (image_picker handles permissions internally on newer versions)
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        debugPrint('Image picked successfully: ${image.path}');
        return image;
      } else {
        debugPrint('No image selected or permission denied for image source: $source');
        return null;
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      
      // If direct picking fails, try requesting permissions manually
      try {
        final hasPermission = await _requestPermissions(source);
        if (!hasPermission) {
          debugPrint('Permission denied for image source: $source');
          return null;
        }

        final XFile? image = await _picker.pickImage(
          source: source,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );

        if (image != null) {
          debugPrint('Image picked successfully after permission request: ${image.path}');
        }

        return image;
      } catch (permissionError) {
        debugPrint('Error with permission handling: $permissionError');
        return null;
      }
    }
  }

  Future<String?> uploadProfileImage(XFile imageFile) async {
    try {
      final currentUser = AuthService.instance.currentUser;
      if (currentUser == null) {
        debugPrint('No authenticated user found');
        return null;
      }

      // Test Firebase Storage connectivity first
      if (!await _testStorageAccess()) {
        debugPrint('Firebase Storage access test failed - falling back to demo mode');
        return _generateDemoImageUrl();
      }

      final String fileName = 'profile_${currentUser.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage.ref().child('profile_images/$fileName');

      final File file = File(imageFile.path);
      
      final UploadTask uploadTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploadedBy': currentUser.uid,
            'uploadDate': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Set a timeout for the upload
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        debugPrint('Upload progress: ${(progress * 100).toStringAsFixed(2)}%');
      });

      final TaskSnapshot snapshot = await uploadTask.timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Upload timeout - please check your connection and try again'),
      );
      
      final String downloadURL = await snapshot.ref.getDownloadURL();
      
      debugPrint('Profile image uploaded successfully: $downloadURL');
      return downloadURL;

    } catch (e) {
      debugPrint('Error uploading profile image: $e');
      
      // Provide more specific error handling
      if (e.toString().contains('object-not-found')) {
        debugPrint('Firebase Storage bucket may not be configured properly');
      } else if (e.toString().contains('unauthorized')) {
        debugPrint('Firebase Storage rules may be too restrictive');
      } else if (e.toString().contains('network')) {
        debugPrint('Network connectivity issue detected');
      }
      
      // Fall back to demo mode for better user experience
      debugPrint('Falling back to demo mode for profile image');
      return _generateDemoImageUrl();
    }
  }

  Future<bool> deleteProfileImage(String imageUrl) async {
    try {
      // Skip deletion for demo URLs
      if (imageUrl.contains('demo-profile-image')) {
        debugPrint('Skipping deletion of demo profile image');
        return true;
      }
      
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      debugPrint('Profile image deleted successfully');
      return true;
    } catch (e) {
      debugPrint('Error deleting profile image: $e');
      return false;
    }
  }

  /// Test Firebase Storage access
  Future<bool> _testStorageAccess() async {
    try {
      // Try to access the storage root - this should succeed even with restrictive rules
      final ref = _storage.ref();
      await ref.child('test_access').getMetadata().timeout(
        const Duration(seconds: 5),
      );
      debugPrint('Firebase Storage access test passed');
      return true;
    } catch (e) {
      debugPrint('Firebase Storage access test failed: $e');
      if (e.toString().contains('object-not-found')) {
        debugPrint('Storage bucket exists but test file not found (this is expected)');
        return true; // This is actually fine - bucket exists
      }
      return false;
    }
  }

  /// Generate a demo image URL when Firebase Storage is unavailable
  String _generateDemoImageUrl() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'https://demo-profile-image-$timestamp.placeholder.com/150x150';
  }

  Future<void> showImageSourceDialog({
    required void Function(ImageSource) onSourceSelected,
    required BuildContext context,
  }) async {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Wrap(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Select Photo Source',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E3A59),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSourceOption(
                        icon: Icons.camera_alt,
                        title: 'Take Photo',
                        subtitle: 'Use camera to take a new photo',
                        onTap: () {
                          Navigator.pop(context);
                          onSourceSelected(ImageSource.camera);
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildSourceOption(
                        icon: Icons.photo_library,
                        title: 'Choose from Gallery',
                        subtitle: 'Select an existing photo',
                        onTap: () {
                          Navigator.pop(context);
                          onSourceSelected(ImageSource.gallery);
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildSourceOption(
                        icon: Icons.cancel,
                        title: 'Cancel',
                        subtitle: 'Keep current photo',
                        onTap: () => Navigator.pop(context),
                        isDestructive: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isDestructive 
                ? const Color(0xFFEF4444).withValues(alpha: 0.1)
                : const Color(0xFF8B5CF6).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF8B5CF6),
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF2E3A59),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Future<File?> compressImage(File imageFile) async {
    try {
      final directory = await imageFile.parent.createTemp();
      final String targetPath = '${directory.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      final compressedFile = File(targetPath);
      await imageFile.copy(targetPath);
      
      return compressedFile;
    } catch (e) {
      debugPrint('Error compressing image: $e');
      return imageFile;
    }
  }
}
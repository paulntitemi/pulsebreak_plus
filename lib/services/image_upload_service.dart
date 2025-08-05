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
    Permission permission;
    
    if (source == ImageSource.camera) {
      permission = Permission.camera;
    } else {
      // Use storage permission for Android 13+ compatibility
      if (Platform.isAndroid) {
        permission = Permission.storage;
      } else {
        permission = Permission.photos;
      }
    }

    final status = await permission.status;
    
    if (status.isGranted) {
      return true;
    }
    
    if (status.isDenied || status.isLimited) {
      final result = await permission.request();
      if (result.isGranted || result.isLimited) {
        return true;
      }
    }
    
    if (status.isPermanentlyDenied) {
      debugPrint('Permission permanently denied. Opening app settings...');
      await openAppSettings();
      return false;
    }
    
    return false;
  }

  Future<XFile?> pickImage({required ImageSource source}) async {
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
        debugPrint('Image picked successfully: ${image.path}');
      }

      return image;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  Future<String?> uploadProfileImage(XFile imageFile) async {
    try {
      final currentUser = AuthService.instance.currentUser;
      if (currentUser == null) {
        debugPrint('No authenticated user found');
        return null;
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

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        debugPrint('Upload progress: ${(progress * 100).toStringAsFixed(2)}%');
      });

      final TaskSnapshot snapshot = await uploadTask;
      final String downloadURL = await snapshot.ref.getDownloadURL();
      
      debugPrint('Profile image uploaded successfully: $downloadURL');
      return downloadURL;

    } catch (e) {
      debugPrint('Error uploading profile image: $e');
      return null;
    }
  }

  Future<bool> deleteProfileImage(String imageUrl) async {
    try {
      final Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      debugPrint('Profile image deleted successfully');
      return true;
    } catch (e) {
      debugPrint('Error deleting profile image: $e');
      return false;
    }
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
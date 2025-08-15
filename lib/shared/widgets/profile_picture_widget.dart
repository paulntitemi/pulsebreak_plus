import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/image_upload_service.dart';
import '../../services/user_service.dart';
import '../../services/auth_service.dart';

class ProfilePictureWidget extends StatefulWidget {
  final String? imageUrl;
  final double size;
  final bool isEditable;
  final void Function(String?)? onImageUpdated;

  const ProfilePictureWidget({
    super.key,
    this.imageUrl,
    this.size = 100,
    this.isEditable = false,
    this.onImageUpdated,
  });

  @override
  State<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  final ImageUploadService _imageUploadService = ImageUploadService.instance;
  final UserService _userService = UserService.instance;
  final AuthService _authService = AuthService.instance;
  
  bool _isLoading = false;
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    _currentImageUrl = widget.imageUrl;
  }

  @override
  void didUpdateWidget(ProfilePictureWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      setState(() {
        _currentImageUrl = widget.imageUrl;
      });
    }
  }

  Future<void> _updateProfilePicture(ImageSource source) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final XFile? imageFile = await _imageUploadService.pickImage(source: source);
      
      if (imageFile == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final String? downloadUrl = await _imageUploadService.uploadProfileImage(imageFile);
      
      if (downloadUrl != null) {
        final currentUser = _authService.currentUser;
        if (currentUser != null) {
          await _userService.updateUserProfile(
            currentUser.uid,
            {'photoURL': downloadUrl},
          );
          
          setState(() {
            _currentImageUrl = downloadUrl;
          });
          
          widget.onImageUpdated?.call(downloadUrl);
          
          if (mounted) {
            final isDemo = downloadUrl.contains('demo-profile-image');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isDemo 
                      ? 'Profile picture updated successfully! (Demo mode - Firebase Storage not configured)'
                      : 'Profile picture updated successfully!'
                ),
                backgroundColor: const Color(0xFF10B981),
                duration: Duration(seconds: isDemo ? 4 : 3),
              ),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Upload failed. Using demo mode instead.'),
              backgroundColor: Color(0xFFFF9500),
              duration: Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Upload failed. Using demo mode for now. Check your internet connection.'),
            backgroundColor: Color(0xFFFF9500),
            duration: Duration(seconds: 4),
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showImageSourceDialog() {
    _imageUploadService.showImageSourceDialog(
      context: context,
      onSourceSelected: _updateProfilePicture,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isEditable ? _showImageSourceDialog : null,
      child: Stack(
        children: [
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _currentImageUrl == null
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF4F8A8B),
                        Color(0xFF188038),
                      ],
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F8A8B).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: _isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  )
                : _currentImageUrl != null
                    ? ClipOval(
                        child: _currentImageUrl!.contains('demo-profile-image')
                            ? _buildDemoAvatar()
                            : Image.network(
                                _currentImageUrl!,
                                width: widget.size,
                                height: widget.size,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildDefaultAvatar();
                                },
                              ),
                      )
                    : _buildDefaultAvatar(),
          ),
          
          if (widget.isEditable && !_isLoading)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: widget.size * 0.3,
                height: widget.size * 0.3,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: widget.size * 0.15,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Icon(
      Icons.person,
      color: Colors.white,
      size: widget.size * 0.5,
    );
  }

  Widget _buildDemoAvatar() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8B5CF6),
            Color(0xFF6366F1),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: widget.size * 0.3,
            ),
            if (widget.size > 80)
              Text(
                'Demo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.size * 0.1,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
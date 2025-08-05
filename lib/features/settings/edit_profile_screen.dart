import 'package:flutter/material.dart';
import 'package:pulsebreak_plus/services/settings_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    final settings = SettingsService.instance;
    _nameController = TextEditingController(text: settings.userName);
    _emailController = TextEditingController(text: settings.userEmail);
    _locationController = TextEditingController(text: settings.userLocation);
    _bioController = TextEditingController(
      text: 'Wellness enthusiast on a journey to better mental health. Love mindfulness, journaling, and staying active. Always looking for new ways to improve my daily habits! 🌱',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E3A59)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF2E3A59),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFF8B5CF6),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Picture Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF4F8A8B),
                            Color(0xFF188038),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4F8A8B).withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImagePicker,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Form Fields
              _buildFormCard([
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _locationController,
                  label: 'Location',
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _bioController,
                  label: 'Bio',
                  icon: Icons.info_outline,
                  maxLines: 4,
                  hintText: 'Tell us about yourself...',
                ),
              ]),

              const SizedBox(height: 32),

              // Additional Settings
              _buildFormCard([
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.cake_outlined,
                      color: Color(0xFF8B5CF6),
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Birthday',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  subtitle: const Text(
                    'March 15, 1990',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF9CA3AF),
                  ),
                  onTap: _showDatePicker,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Color(0xFF8B5CF6),
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3A59),
                    ),
                  ),
                  subtitle: const Text(
                    'Prefer not to say',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF9CA3AF),
                  ),
                  onTap: _showGenderPicker,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFF2E3A59),
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon, color: const Color(0xFF8B5CF6)),
        labelStyle: const TextStyle(
          color: Color(0xFF6B7280),
          fontSize: 14,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF8B5CF6), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      SettingsService.instance.updateUserProfile(
        name: _nameController.text,
        email: _emailController.text,
        location: _locationController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );

      Navigator.pop(context);
    }
  }

  void _showImagePicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Change Profile Picture',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E3A59),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF8B5CF6)),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Camera feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF8B5CF6)),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gallery feature coming soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Color(0xFFEF4444)),
              title: const Text('Remove Photo'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Photo removed!')),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 3, 15),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Birthday updated: ${picked.day}/${picked.month}/${picked.year}')),
      );
    }
  }

  void _showGenderPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Gender'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Male',
            'Female',
            'Non-binary',
            'Prefer not to say',
          ].map((gender) => ListTile(
            title: Text(gender),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Gender updated: $gender')),
              );
            },
          )).toList(),
        ),
      ),
    );
  }
}
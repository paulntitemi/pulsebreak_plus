// lib/features/auth/screens/login_screen.dart
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:pulsebreak_plus/features/auth/signup_screen.dart';
import 'package:pulsebreak_plus/features/dashboard/main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Firebase instances (lazy initialization) - commented out for now
  // FirebaseAuth? _auth;
  // GoogleSignIn? _googleSignIn;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  void _initializeFirebase() {
    // Firebase initialization commented out for now
    // try {
    //   _auth = FirebaseAuth.instance;
    //   _googleSignIn = GoogleSignIn();
    // } catch (e) {
    //   // Firebase not initialized - continuing in demo mode
    //   // Firebase instances will remain null
    // }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Demo mode - just delay and navigate
        await Future<void>.delayed(const Duration(seconds: 1));
        
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(builder: (context) => const MainNavigation()),
          );
        }
      } catch (e) {
        // Handle login errors
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed: ${e.toString()}'),
              backgroundColor: const Color(0xFFEF4444),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Demo mode - just delay and navigate
      await Future<void>.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(builder: (context) => const MainNavigation()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google Sign In failed: ${e.toString()}'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _facebookSignIn() async {
    // Implement Facebook Sign In when ready
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Facebook Sign In - Coming Soon!'),
        backgroundColor: Color(0xFF1877F2),
      ),
    );
  }

  Future<void> _appleSignIn() async {
    // Implement Apple Sign In when ready
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Apple Sign In - Coming Soon!'),
        backgroundColor: Color(0xFF000000),
      ),
    );
  }

  void _forgotPassword() {
    // Navigate to forgot password screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Forgot password clicked'),
        backgroundColor: Color(0xFF4F8A8B),
      ),
    );
  }

  void _signUp() {
    // Navigate to sign up screen
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => const SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // Logo and header
                Column(
                  children: [
                    // Your actual logo from assets
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF4F8A8B,
                            ).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/PulseBreak+.png', // Update with your actual logo path
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback if logo doesn't exist
                            return Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF4F8A8B), // Primary teal
                                    Color(0xFF188038), // Success green
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.favorite_rounded,
                                size: 40,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'PulseBreak+',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3A59),
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Welcome back to your wellness journey',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B7280),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Email field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: const TextStyle(
                          color: Color(0xFFB0B8C1),
                          fontSize: 16,
                        ),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFF4F8A8B),
                          size: 20,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5E7EB),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF4F8A8B),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFEF4444),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Password field
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E3A59),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      onFieldSubmitted: (_) => _login(),
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: const TextStyle(
                          color: Color(0xFFB0B8C1),
                          fontSize: 16,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFF4F8A8B),
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          onPressed: _togglePasswordVisibility,
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF6B7280),
                            size: 20,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5E7EB),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF4F8A8B),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFEF4444),
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Forgot password link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _forgotPassword,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 8,
                      ),
                    ),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF4F8A8B),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Login button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F8A8B),
                      disabledBackgroundColor: const Color(0xFFB0B8C1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      shadowColor: const Color(
                        0xFF4F8A8B,
                      ).withValues(alpha: 0.3),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                            : const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),

                const SizedBox(height: 32),

                // Divider with OR
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFE5E7EB),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: const Color(0xFFE5E7EB),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Social sign-in buttons
                Row(
                  children: [
                    // Google Sign In
                    Expanded(
                      child: _buildSocialButton(
                        onPressed: _handleGoogleSignIn,
                        icon: Icons.g_mobiledata,
                        color: const Color(0xFF4285F4),
                        label: 'Google',
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Facebook Sign In
                    Expanded(
                      child: _buildSocialButton(
                        onPressed: _facebookSignIn,
                        icon: Icons.facebook,
                        color: const Color(0xFF1877F2),
                        label: 'Facebook',
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Apple Sign In
                    Expanded(
                      child: _buildSocialButton(
                        onPressed: _appleSignIn,
                        icon: Icons.apple,
                        color: const Color(0xFF000000),
                        label: 'Apple',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                    ),
                    TextButton(
                      onPressed: _signUp,
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          color: Color(0xFF4F8A8B),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return SizedBox(
      height: 56,
      child: OutlinedButton(
        onPressed: _isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

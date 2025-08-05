import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart';
import 'user_service.dart';

enum AuthProvider { email, google, facebook, apple }

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static AuthService get instance => _instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final UserService _userService = UserService.instance;

  // Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  /// Sign up with email and password
  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await result.user?.updateDisplayName(displayName);
      await result.user?.reload();

      // Create user profile in Firestore
      if (result.user != null) {
        try {
          await _userService.createUserProfile(
            user: result.user!,
            displayName: displayName,
            authProvider: AuthProvider.email,
          );
          debugPrint('User profile created in Firestore');
        } catch (firestoreError) {
          debugPrint('Firestore error (continuing anyway): $firestoreError');
          // Don't throw here - user is created in Firebase Auth, just profile creation failed
        }
      }

      debugPrint('User signed up successfully: ${result.user?.email}');
      return result;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuth Sign up error: ${e.code} - ${e.message}');
      debugPrint('Error details: $e');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Unexpected sign up error: $e');
      debugPrint('Error type: ${e.runtimeType}');
      if (e.toString().contains('internal error')) {
        debugPrint('This might be a Firebase configuration issue');
      }
      throw Exception('Failed to create account. Please try again.');
    }
  }

  /// Sign in with email and password
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update last seen
      if (result.user != null) {
        await _userService.updateLastSeen(result.user!.uid);
      }

      debugPrint('User signed in successfully: ${result.user?.email}');
      return result;
    } on FirebaseAuthException catch (e) {
      debugPrint('Sign in error: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Unexpected sign in error: $e');
      throw Exception('Failed to sign in. Please try again.');
    }
  }

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential result = await _auth.signInWithCredential(credential);

      // Create or update user profile
      if (result.user != null) {
        await _userService.createOrUpdateUserProfile(
          user: result.user!,
          authProvider: AuthProvider.google,
        );
      }

      debugPrint('User signed in with Google: ${result.user?.email}');
      return result;
    } on FirebaseAuthException catch (e) {
      debugPrint('Google sign in error: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Unexpected Google sign in error: $e');
      throw Exception('Failed to sign in with Google. Please try again.');
    }
  }

  /// Sign in with Facebook
  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final OAuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken!.token,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(credential);

        // Create or update user profile
        if (userCredential.user != null) {
          await _userService.createOrUpdateUserProfile(
            user: userCredential.user!,
            authProvider: AuthProvider.facebook,
          );
        }

        debugPrint('User signed in with Facebook: ${userCredential.user?.email}');
        return userCredential;
      } else {
        debugPrint('Facebook sign in canceled or failed: ${result.status}');
        return null;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Facebook sign in error: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Unexpected Facebook sign in error: $e');
      throw Exception('Failed to sign in with Facebook. Please try again.');
    }
  }

  /// Sign in with Apple
  Future<UserCredential?> signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final UserCredential result = await _auth.signInWithCredential(oauthCredential);

      // Create or update user profile
      if (result.user != null) {
        String? displayName;
        if (appleCredential.givenName != null && appleCredential.familyName != null) {
          displayName = '${appleCredential.givenName} ${appleCredential.familyName}';
        }

        await _userService.createOrUpdateUserProfile(
          user: result.user!,
          authProvider: AuthProvider.apple,
          displayName: displayName,
        );
      }

      debugPrint('User signed in with Apple: ${result.user?.email}');
      return result;
    } on SignInWithAppleAuthorizationException catch (e) {
      debugPrint('Apple sign in authorization error: ${e.message}');
      if (e.code == AuthorizationErrorCode.canceled) {
        return null; // User canceled
      }
      throw Exception('Failed to sign in with Apple. Please try again.');
    } on FirebaseAuthException catch (e) {
      debugPrint('Apple sign in Firebase error: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Unexpected Apple sign in error: $e');
      throw Exception('Failed to sign in with Apple. Please try again.');
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint('Password reset email sent to: $email');
    } on FirebaseAuthException catch (e) {
      debugPrint('Password reset error: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Unexpected password reset error: $e');
      throw Exception('Failed to send password reset email. Please try again.');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      // Update user status to offline before signing out
      if (currentUser != null) {
        await _userService.updateUserStatus(currentUser!.uid, isOnline: false);
      }

      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
        FacebookAuth.instance.logOut(),
      ]);

      debugPrint('User signed out successfully');
    } catch (e) {
      debugPrint('Sign out error: $e');
      throw Exception('Failed to sign out. Please try again.');
    }
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Delete user data from Firestore
      await _userService.deleteUserData(user.uid);

      // Delete Firebase Auth account
      await user.delete();

      debugPrint('User account deleted successfully');
    } on FirebaseAuthException catch (e) {
      debugPrint('Delete account error: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Unexpected delete account error: $e');
      throw Exception('Failed to delete account. Please try again.');
    }
  }

  /// Re-authenticate user (required for sensitive operations)
  Future<void> reauthenticate(String password) async {
    try {
      final user = currentUser;
      if (user?.email == null) {
        throw Exception('No user logged in');
      }

      final credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      debugPrint('User reauthenticated successfully');
    } on FirebaseAuthException catch (e) {
      debugPrint('Reauthentication error: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Unexpected reauthentication error: $e');
      throw Exception('Failed to verify credentials. Please try again.');
    }
  }

  /// Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      final user = currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      await user.updatePassword(newPassword);
      debugPrint('Password updated successfully');
    } on FirebaseAuthException catch (e) {
      debugPrint('Update password error: ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      debugPrint('Unexpected update password error: $e');
      throw Exception('Failed to update password. Please try again.');
    }
  }

  /// Handle Firebase Auth exceptions
  Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No account found with this email address.');
      case 'wrong-password':
        return Exception('Incorrect password. Please try again.');
      case 'email-already-in-use':
        return Exception('An account already exists with this email address.');
      case 'weak-password':
        return Exception('Password is too weak. Please choose a stronger password.');
      case 'invalid-email':
        return Exception('Please enter a valid email address.');
      case 'user-disabled':
        return Exception('This account has been disabled. Please contact support.');
      case 'too-many-requests':
        return Exception('Too many failed attempts. Please try again later.');
      case 'network-request-failed':
        return Exception('Network error. Please check your connection and try again.');
      case 'requires-recent-login':
        return Exception('Please sign in again to complete this action.');
      default:
        return Exception(e.message ?? 'Authentication failed. Please try again.');
    }
  }
}
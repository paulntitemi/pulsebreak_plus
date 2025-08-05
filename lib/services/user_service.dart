import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'firebase_service.dart';
import 'auth_service.dart' as auth_svc;

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  static UserService get instance => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseService _firebaseService = FirebaseService.instance;

  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _friendRequestsCollection => _firestore.collection('friendRequests');
  CollectionReference get _friendshipsCollection => _firestore.collection('friendships');

  // Helper method to extract first name from display name
  String _extractFirstName(String displayName) {
    if (displayName.isEmpty) return '';
    return displayName.split(' ').first.trim();
  }

  /// Create a new user profile in Firestore
  Future<void> createUserProfile({
    required User user,
    required String displayName,
    required auth_svc.AuthProvider authProvider,
  }) async {
    try {
      debugPrint('Creating user profile for: ${user.email}');
      
      if (!_firebaseService.isInitialized) {
        debugPrint('Firebase service not initialized');
        throw Exception('Firebase not initialized');
      }

      final firstName = _extractFirstName(displayName);
      final userModel = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        displayName: displayName,
        firstName: firstName,
        photoURL: user.photoURL,
        createdAt: DateTime.now(),
        lastSeen: DateTime.now(),
        isOnline: true,
      );

      debugPrint('Attempting to save user to Firestore...');
      await _usersCollection.doc(user.uid).set(userModel.toMap());
      debugPrint('User profile created successfully for: ${user.email}');
    } catch (e) {
      debugPrint('Error creating user profile: $e');
      debugPrint('Error type: ${e.runtimeType}');
      throw Exception('Failed to create user profile: ${e.toString()}');
    }
  }

  /// Create or update user profile (for social login)
  Future<void> createOrUpdateUserProfile({
    required User user,
    required auth_svc.AuthProvider authProvider,
    String? displayName,
  }) async {
    try {
      if (!_firebaseService.isInitialized) {
        throw Exception('Firebase not initialized');
      }

      final docRef = _usersCollection.doc(user.uid);
      final doc = await docRef.get();

      if (doc.exists) {
        // Update existing user
        await docRef.update({
          'lastSeen': Timestamp.fromDate(DateTime.now()),
          'isOnline': true,
          'photoURL': user.photoURL,
          if (displayName != null) 'displayName': displayName,
        });
        debugPrint('User profile updated for: ${user.email}');
      } else {
        // Create new user
        final finalDisplayName = displayName ?? user.displayName ?? 'User';
        final firstName = _extractFirstName(finalDisplayName);
        final userModel = UserModel(
          uid: user.uid,
          email: user.email ?? '',
          displayName: finalDisplayName,
          firstName: firstName,
          photoURL: user.photoURL,
          createdAt: DateTime.now(),
          lastSeen: DateTime.now(),
          isOnline: true,
        );
        await docRef.set(userModel.toMap());
        debugPrint('User profile created for: ${user.email}');
      }
    } catch (e) {
      debugPrint('Error creating/updating user profile: $e');
      throw Exception('Failed to create or update user profile');
    }
  }

  /// Update user's last seen timestamp
  Future<void> updateLastSeen(String userId) async {
    try {
      await _usersCollection.doc(userId).update({
        'lastSeen': Timestamp.fromDate(DateTime.now()),
        'isOnline': true,
      });
      debugPrint('Last seen updated for user: $userId');
    } catch (e) {
      debugPrint('Error updating last seen: $e');
      throw Exception('Failed to update last seen');
    }
  }

  /// Update user's online status
  Future<void> updateUserStatus(String userId, {required bool isOnline}) async {
    try {
      final updates = <String, dynamic>{
        'isOnline': isOnline,
        'lastSeen': Timestamp.fromDate(DateTime.now()),
      };

      await _usersCollection.doc(userId).update(updates);
      debugPrint('User status updated: $userId - online: $isOnline');
    } catch (e) {
      debugPrint('Error updating user status: $e');
      throw Exception('Failed to update user status');
    }
  }

  /// Get user profile by ID with retry logic
  Future<UserModel?> getUserProfile(String userId) async {
    int retryCount = 0;
    const maxRetries = 3;
    const baseDelay = Duration(seconds: 1);
    
    while (retryCount < maxRetries) {
      try {
        final doc = await _usersCollection.doc(userId).get();
        if (doc.exists) {
          return UserModel.fromSnapshot(doc);
        }
        return null;
      } catch (e) {
        retryCount++;
        debugPrint('Error getting user profile (attempt $retryCount): $e');
        
        if (retryCount >= maxRetries) {
          debugPrint('Max retries reached for getUserProfile');
          return null;
        }
        
        // Exponential backoff
        final delay = Duration(seconds: baseDelay.inSeconds * retryCount);
        debugPrint('Retrying in ${delay.inSeconds} seconds...');
        await Future.delayed(delay);
      }
    }
    return null;
  }

  /// Update user profile
  Future<void> updateUserProfile(String userId, Map<String, dynamic> updates) async {
    try {
      await _usersCollection.doc(userId).update(updates);
      debugPrint('User profile updated for: $userId');
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      throw Exception('Failed to update user profile');
    }
  }

  /// Search users by display name or email
  Future<List<UserModel>> searchUsers(String query, {String? excludeUserId}) async {
    try {
      if (query.isEmpty) return [];

      final results = <UserModel>[];
      
      // Search by display name
      final nameQuery = await _usersCollection
          .where('displayName', isGreaterThanOrEqualTo: query)
          .where('displayName', isLessThan: '${query}z')
          .limit(10)
          .get();

      // Search by email
      final emailQuery = await _usersCollection
          .where('email', isGreaterThanOrEqualTo: query)
          .where('email', isLessThan: '${query}z')
          .limit(10)
          .get();

      // Combine results and remove duplicates
      final allDocs = [...nameQuery.docs, ...emailQuery.docs];
      final seenIds = <String>{};
      
      for (final doc in allDocs) {
        if (!seenIds.contains(doc.id) && doc.id != excludeUserId) {
          seenIds.add(doc.id);
          results.add(UserModel.fromSnapshot(doc));
        }
      }

      return results;
    } catch (e) {
      debugPrint('Error searching users: $e');
      return [];
    }
  }

  /// Delete all user data
  Future<void> deleteUserData(String userId) async {
    try {
      final batch = _firestore.batch();

      // Delete user profile
      batch.delete(_usersCollection.doc(userId));

      // Delete friend requests involving this user
      final friendRequestsQuery = await _friendRequestsCollection
          .where('fromUserId', isEqualTo: userId)
          .get();
      for (final doc in friendRequestsQuery.docs) {
        batch.delete(doc.reference);
      }

      final friendRequestsQuery2 = await _friendRequestsCollection
          .where('toUserId', isEqualTo: userId)
          .get();
      for (final doc in friendRequestsQuery2.docs) {
        batch.delete(doc.reference);
      }

      // Delete friendships involving this user
      final friendshipsQuery = await _friendshipsCollection
          .where('user1Id', isEqualTo: userId)
          .get();
      for (final doc in friendshipsQuery.docs) {
        batch.delete(doc.reference);
      }

      final friendshipsQuery2 = await _friendshipsCollection
          .where('user2Id', isEqualTo: userId)
          .get();
      for (final doc in friendshipsQuery2.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      debugPrint('All user data deleted for: $userId');
    } catch (e) {
      debugPrint('Error deleting user data: $e');
      throw Exception('Failed to delete user data');
    }
  }

  /// Send friend request
  Future<void> sendFriendRequest({
    required String fromUserId,
    required String toUserId,
    String? message,
  }) async {
    try {
      // Check if request already exists
      final existingRequest = await _friendRequestsCollection
          .where('fromUserId', isEqualTo: fromUserId)
          .where('toUserId', isEqualTo: toUserId)
          .where('status', whereIn: ['pending', 'accepted'])
          .get();

      if (existingRequest.docs.isNotEmpty) {
        throw Exception('Friend request already exists');
      }

      // Check if they're already friends
      final existingFriendship = await _friendshipsCollection
          .where('user1Id', whereIn: [fromUserId, toUserId])
          .where('user2Id', whereIn: [fromUserId, toUserId])
          .where('isActive', isEqualTo: true)
          .get();

      if (existingFriendship.docs.isNotEmpty) {
        throw Exception('Users are already friends');
      }

      final friendRequest = FriendRequest(
        id: _friendRequestsCollection.doc().id,
        fromUserId: fromUserId,
        toUserId: toUserId,
        status: FriendRequestStatus.pending,
        createdAt: DateTime.now(),
        message: message,
      );

      await _friendRequestsCollection.doc(friendRequest.id).set(friendRequest.toMap());
      debugPrint('Friend request sent from $fromUserId to $toUserId');
    } catch (e) {
      debugPrint('Error sending friend request: $e');
      throw Exception('Failed to send friend request');
    }
  }

  /// Respond to friend request
  Future<void> respondToFriendRequest({
    required String requestId,
    required FriendRequestStatus status,
  }) async {
    try {
      final requestDoc = await _friendRequestsCollection.doc(requestId).get();
      if (!requestDoc.exists) {
        throw Exception('Friend request not found');
      }

      final friendRequest = FriendRequest.fromSnapshot(requestDoc);
      
      // Update request status
      await _friendRequestsCollection.doc(requestId).update({
        'status': status.name,
        'respondedAt': Timestamp.fromDate(DateTime.now()),
      });

      // If accepted, create friendship
      if (status == FriendRequestStatus.accepted) {
        final friendship = Friendship(
          id: _friendshipsCollection.doc().id,
          user1Id: friendRequest.fromUserId,
          user2Id: friendRequest.toUserId,
          createdAt: DateTime.now(),
        );

        await _friendshipsCollection.doc(friendship.id).set(friendship.toMap());
        debugPrint('Friendship created between ${friendRequest.fromUserId} and ${friendRequest.toUserId}');
      }

      debugPrint('Friend request $requestId updated to ${status.name}');
    } catch (e) {
      debugPrint('Error responding to friend request: $e');
      throw Exception('Failed to respond to friend request');
    }
  }

  /// Get pending friend requests for a user
  Future<List<FriendRequest>> getPendingFriendRequests(String userId) async {
    try {
      final querySnapshot = await _friendRequestsCollection
          .where('toUserId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map(FriendRequest.fromSnapshot)
          .toList();
    } catch (e) {
      debugPrint('Error getting pending friend requests: $e');
      return [];
    }
  }

  /// Get user's friends
  Future<List<UserModel>> getUserFriends(String userId) async {
    try {
      final friendships = await _friendshipsCollection
          .where('user1Id', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .get();

      final friendships2 = await _friendshipsCollection
          .where('user2Id', isEqualTo: userId)
          .where('isActive', isEqualTo: true)
          .get();

      final friendIds = <String>{};
      
      for (final doc in friendships.docs) {
        final friendship = Friendship.fromSnapshot(doc);
        friendIds.add(friendship.user2Id);
      }
      
      for (final doc in friendships2.docs) {
        final friendship = Friendship.fromSnapshot(doc);
        friendIds.add(friendship.user1Id);
      }

      if (friendIds.isEmpty) return [];

      final friends = <UserModel>[];
      for (final friendId in friendIds) {
        final friend = await getUserProfile(friendId);
        if (friend != null) {
          friends.add(friend);
        }
      }

      return friends;
    } catch (e) {
      debugPrint('Error getting user friends: $e');
      return [];
    }
  }

  /// Remove friend
  Future<void> removeFriend(String userId, String friendId) async {
    try {
      final friendships = await _friendshipsCollection
          .where('user1Id', whereIn: [userId, friendId])
          .where('user2Id', whereIn: [userId, friendId])
          .where('isActive', isEqualTo: true)
          .get();

      for (final doc in friendships.docs) {
        await doc.reference.update({'isActive': false});
      }

      debugPrint('Friendship removed between $userId and $friendId');
    } catch (e) {
      debugPrint('Error removing friend: $e');
      throw Exception('Failed to remove friend');
    }
  }

  /// Stream user profile changes
  Stream<UserModel?> streamUserProfile(String userId) {
    return _usersCollection.doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromSnapshot(snapshot);
      }
      return null;
    });
  }

  /// Stream friend requests
  Stream<List<FriendRequest>> streamFriendRequests(String userId) {
    return _friendRequestsCollection
        .where('toUserId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(FriendRequest.fromSnapshot)
            .toList());
  }

  /// Stream user's friends
  Stream<List<UserModel>> streamUserFriends(String userId) {
    return _friendshipsCollection
        .where('user1Id', isEqualTo: userId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final friendIds = snapshot.docs
              .map((doc) => Friendship.fromSnapshot(doc).user2Id)
              .toList();

          final friendships2 = await _friendshipsCollection
              .where('user2Id', isEqualTo: userId)
              .where('isActive', isEqualTo: true)
              .get();

          friendIds.addAll(friendships2.docs
              .map((doc) => Friendship.fromSnapshot(doc).user1Id));

          if (friendIds.isEmpty) return <UserModel>[];

          final friends = <UserModel>[];
          for (final friendId in friendIds) {
            final friend = await getUserProfile(friendId);
            if (friend != null) {
              friends.add(friend);
            }
          }

          return friends;
        });
  }
}
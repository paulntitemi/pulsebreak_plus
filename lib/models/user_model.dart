import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String firstName;
  final String? photoURL;
  final String? location;
  final DateTime createdAt;
  final DateTime lastSeen;
  final bool isOnline;
  final int wellnessScore;
  final List<String> interests;
  final Map<String, dynamic> privacySettings;

  const UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.firstName,
    this.photoURL,
    this.location,
    required this.createdAt,
    required this.lastSeen,
    this.isOnline = false,
    this.wellnessScore = 0,
    this.interests = const [],
    this.privacySettings = const {},
  });

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'firstName': firstName,
      'photoURL': photoURL,
      'location': location,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastSeen': Timestamp.fromDate(lastSeen),
      'isOnline': isOnline,
      'wellnessScore': wellnessScore,
      'interests': interests,
      'privacySettings': privacySettings,
    };
  }

  // Create from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    final displayName = map['displayName'] as String? ?? '';
    final firstName = map['firstName'] as String? ?? _extractFirstName(displayName);
    
    return UserModel(
      uid: map['uid'] as String? ?? '',
      email: map['email'] as String? ?? '',
      displayName: displayName,
      firstName: firstName,
      photoURL: map['photoURL'] as String?,
      location: map['location'] as String?,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastSeen: (map['lastSeen'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isOnline: map['isOnline'] as bool? ?? false,
      wellnessScore: map['wellnessScore'] as int? ?? 0,
      interests: List<String>.from(map['interests'] as List<dynamic>? ?? []),
      privacySettings: Map<String, dynamic>.from(map['privacySettings'] as Map<dynamic, dynamic>? ?? {}),
    );
  }

  // Helper method to extract first name from display name
  static String _extractFirstName(String displayName) {
    if (displayName.isEmpty) return '';
    return displayName.split(' ').first;
  }

  // Create from Firestore DocumentSnapshot
  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Invalid user document');
    }
    return UserModel.fromMap(data);
  }

  // Copy with changes
  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? firstName,
    String? photoURL,
    String? location,
    DateTime? createdAt,
    DateTime? lastSeen,
    bool? isOnline,
    int? wellnessScore,
    List<String>? interests,
    Map<String, dynamic>? privacySettings,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      photoURL: photoURL ?? this.photoURL,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      isOnline: isOnline ?? this.isOnline,
      wellnessScore: wellnessScore ?? this.wellnessScore,
      interests: interests ?? this.interests,
      privacySettings: privacySettings ?? this.privacySettings,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, displayName: $displayName, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}

enum FriendRequestStatus { pending, accepted, declined, blocked }

class FriendRequest {
  final String id;
  final String fromUserId;
  final String toUserId;
  final FriendRequestStatus status;
  final DateTime createdAt;
  final DateTime? respondedAt;
  final String? message;

  const FriendRequest({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.status,
    required this.createdAt,
    this.respondedAt,
    this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'respondedAt': respondedAt != null ? Timestamp.fromDate(respondedAt!) : null,
      'message': message,
    };
  }

  factory FriendRequest.fromMap(Map<String, dynamic> map) {
    return FriendRequest(
      id: map['id'] as String? ?? '',
      fromUserId: map['fromUserId'] as String? ?? '',
      toUserId: map['toUserId'] as String? ?? '',
      status: FriendRequestStatus.values.firstWhere(
        (e) => e.name == (map['status'] as String? ?? 'pending'),
        orElse: () => FriendRequestStatus.pending,
      ),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      respondedAt: (map['respondedAt'] as Timestamp?)?.toDate(),
      message: map['message'] as String?,
    );
  }

  factory FriendRequest.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Invalid friend request document');
    }
    return FriendRequest.fromMap(data);
  }

  FriendRequest copyWith({
    String? id,
    String? fromUserId,
    String? toUserId,
    FriendRequestStatus? status,
    DateTime? createdAt,
    DateTime? respondedAt,
    String? message,
  }) {
    return FriendRequest(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      respondedAt: respondedAt ?? this.respondedAt,
      message: message ?? this.message,
    );
  }
}

class Friendship {
  final String id;
  final String user1Id;
  final String user2Id;
  final DateTime createdAt;
  final bool isActive;

  const Friendship({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.createdAt,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user1Id': user1Id,
      'user2Id': user2Id,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
    };
  }

  factory Friendship.fromMap(Map<String, dynamic> map) {
    return Friendship(
      id: map['id'] as String? ?? '',
      user1Id: map['user1Id'] as String? ?? '',
      user2Id: map['user2Id'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  factory Friendship.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Invalid friendship document');
    }
    return Friendship.fromMap(data);
  }

  // Check if a user is part of this friendship
  bool containsUser(String userId) {
    return user1Id == userId || user2Id == userId;
  }

  // Get the other user's ID in the friendship
  String getOtherUserId(String currentUserId) {
    if (user1Id == currentUserId) return user2Id;
    if (user2Id == currentUserId) return user1Id;
    throw Exception('User not part of this friendship');
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final String name;
  final List<String> participantIds;
  final Map<String, String> participantNames;
  final String? lastMessage;
  final String? lastMessageSenderId;
  final DateTime? lastMessageTime;
  final DateTime createdAt;
  final ChatType type;
  final String? avatarUrl;
  final Map<String, int> unreadCounts;
  final bool isActive;

  const Chat({
    required this.id,
    required this.name,
    required this.participantIds,
    required this.participantNames,
    this.lastMessage,
    this.lastMessageSenderId,
    this.lastMessageTime,
    required this.createdAt,
    required this.type,
    this.avatarUrl,
    this.unreadCounts = const {},
    this.isActive = true,
  });

  factory Chat.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Chat(
      id: doc.id,
      name: (data['name'] as String?) ?? '',
      participantIds: data['participantIds'] != null 
        ? List<String>.from(data['participantIds'] as List)
        : [],
      participantNames: data['participantNames'] != null
        ? Map<String, String>.from(data['participantNames'] as Map)
        : {},
      lastMessage: data['lastMessage'] as String?,
      lastMessageSenderId: data['lastMessageSenderId'] as String?,
      lastMessageTime: data['lastMessageTime'] != null
        ? (data['lastMessageTime'] as Timestamp).toDate()
        : null,
      createdAt: data['createdAt'] != null
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now(),
      type: ChatType.values.firstWhere(
        (type) => type.name == data['type'],
        orElse: () => ChatType.direct,
      ),
      avatarUrl: data['avatarUrl'] as String?,
      unreadCounts: data['unreadCounts'] != null
        ? Map<String, int>.from(data['unreadCounts'] as Map)
        : {},
      isActive: (data['isActive'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'participantIds': participantIds,
      'participantNames': participantNames,
      'lastMessage': lastMessage,
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessageTime': lastMessageTime != null 
        ? Timestamp.fromDate(lastMessageTime!)
        : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'type': type.name,
      'avatarUrl': avatarUrl,
      'unreadCounts': unreadCounts,
      'isActive': isActive,
    };
  }

  String getDisplayName(String currentUserId) {
    if (type == ChatType.group) {
      return name;
    }
    
    // For direct chats, return the other participant's name
    final otherParticipantId = participantIds.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );
    
    return participantNames[otherParticipantId] ?? 'Unknown User';
  }

  int getUnreadCount(String userId) {
    return unreadCounts[userId] ?? 0;
  }

  Chat copyWith({
    String? id,
    String? name,
    List<String>? participantIds,
    Map<String, String>? participantNames,
    String? lastMessage,
    String? lastMessageSenderId,
    DateTime? lastMessageTime,
    DateTime? createdAt,
    ChatType? type,
    String? avatarUrl,
    Map<String, int>? unreadCounts,
    bool? isActive,
  }) {
    return Chat(
      id: id ?? this.id,
      name: name ?? this.name,
      participantIds: participantIds ?? this.participantIds,
      participantNames: participantNames ?? this.participantNames,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      unreadCounts: unreadCounts ?? this.unreadCounts,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Chat && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum ChatType {
  direct,
  group,
}
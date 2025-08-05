import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/message_model.dart';
import '../models/chat_model.dart';
import 'auth_service.dart';

class MessagingService {
  static final MessagingService _instance = MessagingService._internal();
  factory MessagingService() => _instance;
  MessagingService._internal();

  static MessagingService get instance => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService.instance;

  Stream<List<Chat>> getUserChats() {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('chats')
        .where('participantIds', arrayContains: currentUser.uid)
        .where('isActive', isEqualTo: true)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(Chat.fromFirestore)
            .toList());
  }

  Stream<List<Message>> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(Message.fromFirestore)
            .toList());
  }

  Future<String?> createOrGetDirectChat(String otherUserId, String otherUserName) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) return null;

    try {
      final participantIds = [currentUser.uid, otherUserId]..sort();
      
      final existingChatQuery = await _firestore
          .collection('chats')
          .where('participantIds', isEqualTo: participantIds)
          .where('type', isEqualTo: ChatType.direct.name)
          .limit(1)
          .get();

      if (existingChatQuery.docs.isNotEmpty) {
        return existingChatQuery.docs.first.id;
      }

      final chatData = Chat(
        id: '',
        name: '',
        participantIds: participantIds,
        participantNames: {
          currentUser.uid: currentUser.displayName ?? 'You',
          otherUserId: otherUserName,
        },
        createdAt: DateTime.now(),
        type: ChatType.direct,
        unreadCounts: {
          currentUser.uid: 0,
          otherUserId: 0,
        },
      );

      final docRef = await _firestore.collection('chats').add(chatData.toFirestore());
      debugPrint('Created new direct chat: ${docRef.id}');
      return docRef.id;
      
    } catch (e) {
      debugPrint('Error creating direct chat: $e');
      return null;
    }
  }

  Future<bool> sendMessage({
    required String chatId,
    required String content,
    MessageType type = MessageType.text,
    String? replyToMessageId,
  }) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) return false;

    try {
      final messageData = Message(
        id: '',
        chatId: chatId,
        senderId: currentUser.uid,
        senderName: currentUser.displayName ?? 'Unknown',
        content: content,
        type: type,
        timestamp: DateTime.now(),
        replyToMessageId: replyToMessageId,
      );

      final batch = _firestore.batch();

      final messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc();

      batch.set(messageRef, messageData.toFirestore());

      final chatRef = _firestore.collection('chats').doc(chatId);
      
      final chatDoc = await chatRef.get();
      if (chatDoc.exists) {
        final chat = Chat.fromFirestore(chatDoc);
        final updatedUnreadCounts = Map<String, int>.from(chat.unreadCounts);
        
        for (final participantId in chat.participantIds) {
          if (participantId != currentUser.uid) {
            updatedUnreadCounts[participantId] = (updatedUnreadCounts[participantId] ?? 0) + 1;
          }
        }

        batch.update(chatRef, {
          'lastMessage': content,
          'lastMessageSenderId': currentUser.uid,
          'lastMessageTime': Timestamp.fromDate(DateTime.now()),
          'unreadCounts': updatedUnreadCounts,
        });
      }

      await batch.commit();
      debugPrint('Message sent successfully to chat: $chatId');
      return true;
      
    } catch (e) {
      debugPrint('Error sending message: $e');
      return false;
    }
  }

  Future<void> markMessagesAsRead(String chatId) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) return;

    try {
      final chatRef = _firestore.collection('chats').doc(chatId);
      await chatRef.update({
        'unreadCounts.${currentUser.uid}': 0,
      });
      
      debugPrint('Marked messages as read for chat: $chatId');
    } catch (e) {
      debugPrint('Error marking messages as read: $e');
    }
  }

  Future<Chat?> getChatById(String chatId) async {
    try {
      final doc = await _firestore.collection('chats').doc(chatId).get();
      if (doc.exists) {
        return Chat.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting chat by ID: $e');
      return null;
    }
  }

  Future<List<Message>> getMoreMessages(String chatId, DateTime lastMessageTime) async {
    try {
      final query = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('timestamp', isLessThan: Timestamp.fromDate(lastMessageTime))
          .orderBy('timestamp', descending: true)
          .limit(20)
          .get();

      return query.docs.map(Message.fromFirestore).toList();
    } catch (e) {
      debugPrint('Error loading more messages: $e');
      return [];
    }
  }

  Future<bool> deleteMessage(String chatId, String messageId) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) return false;

    try {
      final messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId);

      final messageDoc = await messageRef.get();
      if (!messageDoc.exists) return false;

      final message = Message.fromFirestore(messageDoc);
      if (message.senderId != currentUser.uid) {
        debugPrint('User cannot delete message they did not send');
        return false;
      }

      await messageRef.delete();
      debugPrint('Message deleted successfully');
      return true;
      
    } catch (e) {
      debugPrint('Error deleting message: $e');
      return false;
    }
  }

  Future<bool> editMessage(String chatId, String messageId, String newContent) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) return false;

    try {
      final messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId);

      final messageDoc = await messageRef.get();
      if (!messageDoc.exists) return false;

      final message = Message.fromFirestore(messageDoc);
      if (message.senderId != currentUser.uid) {
        debugPrint('User cannot edit message they did not send');
        return false;
      }

      await messageRef.update({
        'content': newContent,
        'editedAt': Timestamp.fromDate(DateTime.now()),
      });
      
      debugPrint('Message edited successfully');
      return true;
      
    } catch (e) {
      debugPrint('Error editing message: $e');
      return false;
    }
  }

  Future<void> updateChatLastSeen(String chatId) async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) return;

    try {
      await _firestore.collection('chats').doc(chatId).update({
        'lastSeen.${currentUser.uid}': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      debugPrint('Error updating last seen: $e');
    }
  }

  Stream<int> getTotalUnreadCount() {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      return Stream.value(0);
    }

    return _firestore
        .collection('chats')
        .where('participantIds', arrayContains: currentUser.uid)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      int totalUnread = 0;
      for (final doc in snapshot.docs) {
        final chat = Chat.fromFirestore(doc);
        totalUnread += chat.getUnreadCount(currentUser.uid);
      }
      return totalUnread;
    });
  }
}
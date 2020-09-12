import 'package:chatverse_chat_app/utilities/exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirebaseStorageService {
  FirebaseStorageService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<DocumentSnapshot> getMessagesStream(String chatRoomId) {
    print("getting chat room stream : $chatRoomId");
    return _firestore.collection("chatrooms").doc(chatRoomId).snapshots();
  }

  static Future<DocumentSnapshot> getUserDocumentSnapshot(String userId) async {
    try {
      final DocumentSnapshot snapshot =
          await _firestore.collection("users").doc(userId).get();
      return snapshot;
    } catch (e) {
      print("ERROR WHILE GETTING DOCUMENT SNAPSHOT : $e");
    }
    return null;
  }

  static Future<void> setUserData(
      String userId, Map<String, dynamic> data) async {
    await _firestore.collection("users").doc(userId).set(data);
  }

  static Future<void> sendMessage({
    String contactId,
    String chatRoomId,
    Map<String, dynamic> message,
  }) async {
    await _firestore.collection("chatrooms").doc(chatRoomId).set({
      'messages': FieldValue.arrayUnion([message]),
      contactId: {'unreadMessageCount': FieldValue.increment(1)}
    }, SetOptions(merge: true));
  }

  static Future<void> resetUnreadMessages({
    @required String userId,
    @required DocumentReference reference,
  }) async {
    print("setting unread for $userId");
    if (reference != null) {
      await _firestore.runTransaction((Transaction myTransaction) {
        myTransaction.update(reference, {
          userId: {
            'unreadMessageCount': 0,
          }
        });
        return;
      });
    }
  }

  static Future<String> addContact(String userId, String contactId) async {
    try {
      final DocumentReference ref = _firestore.collection("chatrooms").doc();
      final DocumentReference userRef =
          _firestore.collection("users").doc(userId);
      final DocumentReference contactRef =
          _firestore.collection("users").doc(contactId);
      final String chatRoomId = ref.id;
      WriteBatch batch = _firestore.batch();
      batch.update(userRef, {
        'contacts': FieldValue.arrayUnion([contactId]),
        'chatrooms': FieldValue.arrayUnion([chatRoomId])
      });
      batch.update(contactRef, {
        'contacts': FieldValue.arrayUnion([userId]),
        'chatrooms': FieldValue.arrayUnion([chatRoomId])
      });
      await batch.commit();
      return chatRoomId;
    } catch (e) {
      print("ERROR ADDING CONTACT $e");
      throw CannotAddContactException("Error adding contact");
    }
  }
}

import 'dart:io';

import 'package:chatverse_chat_app/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FirebaseStorageService {
  FirebaseStorageService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://chatverse-4c90c.appspot.com/');

  static Stream<DocumentSnapshot> getMessagesStream(String chatRoomId) {
    print("getting chat room stream : $chatRoomId");
    return _firestore.collection("chatrooms").doc(chatRoomId).snapshots();
  }

  static Stream<QuerySnapshot> getAllUsersStream() {
    return _firestore.collection("users").snapshots();
  }

  static Future<QuerySnapshot> getUsers() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection("users").get();
      return snapshot;
    } catch (e) {
      print("ERROR WHILE GETTING ALL USERS : $e");
    }
    return null;
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

  static Future<void> updateUserDetails({String userId, String name}) async {
    try {
      await _firestore.collection("users").doc(userId).update({
        'name': name,
      });
    } catch (e) {
      print("ERROR WHILE UPDATING USER DETAILS");
    }
  }

  static Future<void> addContactToFavorites(
      {String userId, String contactId}) async {
    await _firestore.collection("users").doc(userId).update({
      'favoriteContactIds': FieldValue.arrayUnion([contactId])
    });
  }

  static Future<void> removeContactFromFavorites(
      {String userId, String contactId}) async {
    await _firestore.collection("users").doc(userId).update({
      'favoriteContactIds': FieldValue.arrayRemove([contactId])
    });
  }

  static Future<void> setUserData(
      String userId, Map<String, dynamic> data) async {
    await _firestore.collection("users").doc(userId).set(data);
  }

  static Future<void> sendMessage({
    String contactId,
    String chatRoomId,
    String encodedMessage,
  }) async {
    await _firestore.collection("chatrooms").doc(chatRoomId).set({
      'messages': FieldValue.arrayUnion([encodedMessage]),
      contactId: {
        'unreadMessageCount': FieldValue.increment(1),
      }
    }, SetOptions(merge: true));
  }

  static Future<void> setMessages({
    String chatRoomId,
    List messagesList,
  }) async {
    await _firestore.collection("chatrooms").doc(chatRoomId).update(
      {
        'messages': messagesList,
      },
    );
  }

  static void resetUnreadMessages({
    @required String userId,
    @required DocumentReference reference,
  }) async {
    if (reference != null) {
      _firestore.runTransaction((Transaction myTransaction) {
        myTransaction.update(reference, {
          userId: {
            'unreadMessageCount': 0,
          }
        });
        return;
      });
    }
  }

//  static Future<String> addContact(String userId, String contactId) async {
//    try {
//      final DocumentReference ref = _firestore.collection("chatrooms").doc();
//      final DocumentReference userRef =
//          _firestore.collection("users").doc(userId);
//      final DocumentReference contactRef =
//          _firestore.collection("users").doc(contactId);
//      final String chatRoomId = ref.id;
//      WriteBatch batch = _firestore.batch();
//      batch.update(userRef, {
//        'contacts': FieldValue.arrayUnion([contactId]),
//        'chatrooms': FieldValue.arrayUnion([chatRoomId])
//      });
//      batch.update(contactRef, {
//        'contacts': FieldValue.arrayUnion([userId]),
//        'chatrooms': FieldValue.arrayUnion([chatRoomId])
//      });
//      await batch.commit();
//      return chatRoomId;
//    } catch (e) {
//      print("ERROR ADDING CONTACT $e");
//      throw CannotAddContactException("Error adding contact");
//    }
//  }

  static Future<String> uploadFile(String userId, File image) async {
    try {
      StorageUploadTask uploadTask =
          _storage.ref().child('Profile Pictures/$userId.png').putFile(image);
      await uploadTask.onComplete;
      String fileURL = await _storage
          .ref()
          .child('Profile Pictures/$userId.png')
          .getDownloadURL();
      return fileURL;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<String> updateProfilePicture(
      {String userId, String oldImageURL, File newImage}) async {
    try {
      if (oldImageURL != kDefaultPhotoUrl) {
        StorageReference photoRef =
        await _storage.getReferenceFromUrl(oldImageURL);
        await photoRef.delete();
      }

      String newFileURL = await uploadFile(userId, newImage);
      await _firestore.collection("users").doc(userId).update({
        'photoUrl': newFileURL,
      });

      return newFileURL;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<String> removeProfilePicture(
      {String userId, String oldImageURL}) async {
    try {
      if (oldImageURL != kDefaultPhotoUrl) {
        StorageReference photoRef =
        await _storage.getReferenceFromUrl(oldImageURL);
        await photoRef.delete();

        await _firestore.collection("users").doc(userId).update({
          'photoUrl': kDefaultPhotoUrl,
        });
      }
      return kDefaultPhotoUrl;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

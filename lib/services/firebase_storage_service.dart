import 'dart:io';

import 'package:chatverse_chat_app/models/message.dart';
import 'package:chatverse_chat_app/utilities/constants.dart';
import 'package:chatverse_chat_app/utilities/exceptions.dart';
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

  static Future<QuerySnapshot> getAllUsers() async {
    return await _firestore.collection("users").get();
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

  static Future<void> removeContactsFromFavorites(
      {String userId, List<String> contactIds}) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .update({'favoriteContactIds': FieldValue.arrayRemove(contactIds)});
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

  //FIXME : delete message bug fix for media messages
  static Future<void> deleteMessage({
    @required String chatRoomId,
    String userId,
    String contactId,
    bool deleteForEveryone = false,
    @required int messageIndex,
  }) async {
    await _firestore.collection("chatrooms").doc(chatRoomId).set(
      {
        userId: {
          'deletedMessagesIndex': FieldValue.arrayUnion([messageIndex]),
        },
        contactId: {
          'deletedMessagesIndex':
              FieldValue.arrayUnion(deleteForEveryone ? [messageIndex] : []),
        },
      },
      SetOptions(merge: true),
    );
  }

  static void resetUnreadMessages({
    @required String userId,
    @required DocumentReference reference,
  }) async {
    if (reference != null) {
      _firestore.runTransaction((Transaction myTransaction) {
        myTransaction.set(
            reference,
            {
              userId: {
                'unreadMessageCount': 0,
              }
            },
            SetOptions(merge: true));
        return;
      });
    }
  }

  static Future<Map<String, String>> addContact(
      String userId, String contactId) async {
    try {
      final DocumentReference chatRoomRef =
          _firestore.collection("chatrooms").doc();
      final DocumentReference userRef =
          _firestore.collection("users").doc(userId);
      final DocumentReference contactRef =
          _firestore.collection("users").doc(contactId);
      final String chatRoomId = chatRoomRef.id;
      WriteBatch batch = _firestore.batch();
      batch.update(userRef, {
        'contacts.$contactId': chatRoomId,
      });
      batch.update(contactRef, {
        'contacts.$userId': chatRoomId,
      });
      batch.set(chatRoomRef, {
        'messages': [],
        userId: {
          'unreadMessageCount': 0,
          'deletedMessagesIndex': [],
        },
        contactId: {
          'unreadMessageCount': 0,
          'deletedMessagesIndex': [],
        },
      });
      await batch.commit();
      return {contactId: chatRoomId};
    } catch (e) {
      print("ERROR ADDING CONTACT $e");
      throw CannotAddContactException("Error adding contact");
    }
  }

  static Future<String> uploadFile(
      {@required String path,
      @required File file,
      @required MessageType messageType}) async {
    StorageUploadTask uploadTask;
    if (messageType == MessageType.photo)
      uploadTask = _storage.ref().child(path).putFile(file);
    else
      uploadTask = _storage.ref().child(path).putFile(
            file,
            StorageMetadata(contentType: 'video/mp4'),
          );

    await uploadTask.onComplete;
    String fileURL = await _storage.ref().child(path).getDownloadURL();
    return fileURL;
  }

  static Future<String> uploadProfilePicture(String userId, File image) async {
    try {
      final String fileUrl = await uploadFile(
        path: 'Profile Pictures/$userId.png',
        file: image,
        messageType: MessageType.photo,
      );
      return fileUrl;
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

      final String newFileURL = await uploadFile(
        path: 'Profile Pictures/$userId.png',
        file: newImage,
        messageType: MessageType.photo,
      );
      await _firestore.collection("users").doc(userId).update({
        'photoUrl': newFileURL,
      });

      return newFileURL;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  static Future<String> uploadMediaMessage({
    String userId,
    File image,
    String timestamp,
    MessageType messageType,
  }) async {
    try {
      String path = "Media/$userId/";
      if (messageType == MessageType.photo)
        path += "$timestamp.png";
      else
        path += "$timestamp.mp4";
      final String fileUrl = await uploadFile(
        path: path,
        file: image,
        messageType: messageType,
      );

      return fileUrl;
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

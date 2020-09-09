import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseStorageService {
  FirebaseStorageService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot> getMessagesStream(String chatRoomId) {
    print("getting chat room stream : $chatRoomId");
    return _firestore
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy('timestamp', descending: true)
        .snapshots();
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

  static Future<void> sendMessage(
      {String chatRoomId, Map<String, dynamic> message}) async {
    await _firestore
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(message);
  }

  static void setMessagesReadToTrue(DocumentReference reference) {
    if (reference != null) {
      _firestore.runTransaction((Transaction myTransaction) {
        myTransaction.update(reference, {'isRead': true});
        return;
      });
    }
  }

  static Future<int> getUnreadMessageCount({String chatRoomId}) async {
    int unreadMessageCount = 0;
    final QuerySnapshot chatsSnapshot = await _firestore
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .get();

    unreadMessageCount = chatsSnapshot.docs.length;
    return unreadMessageCount;
  }
}

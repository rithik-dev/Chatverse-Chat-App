import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseStorageService {
  FirebaseStorageService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot> getFriendsStream(String userId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("contacts")
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
}

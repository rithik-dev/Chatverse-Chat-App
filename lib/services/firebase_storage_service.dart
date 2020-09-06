import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseStorageService {
  static String _loggedInUserId;

  static final Firestore _firestore = Firestore.instance;

  static Future<DocumentSnapshot> getUserDocumentSnapshot(String userId) async {
    _loggedInUserId = userId;
    try {
      final DocumentSnapshot snapshot =
          await _firestore.collection("users").document(_loggedInUserId).get();
      return snapshot;
    } catch (e) {
      print("ERROR WHILE GETTING DOCUMENT SNAPSHOT : $e");
    }
    return null;
  }

  static Future<void> setInitialUserData(
      String userId, Map<String, String> data) async {
    _loggedInUserId = userId;
    await _firestore
        .collection("users")
        .document(_loggedInUserId)
        .setData(data);
  }
}

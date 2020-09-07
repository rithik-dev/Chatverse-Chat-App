import 'package:firebase_core/firebase_core.dart';

class FirebaseCoreService {
  FirebaseCoreService._();

  static Future<void> initApp() async {
    await Firebase.initializeApp();
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs._();

  static Future<Map<String, dynamic>> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool _seenIntro = (prefs.getBool('seenIntro') ?? false);
    final String _userId = (prefs.getString('userId') ?? null);

    return {
      'seenIntro': _seenIntro,
      'userId': _userId,
    };
  }

  static Future<void> setLoggedInUserID(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  static Future<void> setSeenIntro(bool seenIntro) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenIntro', seenIntro);
  }
}

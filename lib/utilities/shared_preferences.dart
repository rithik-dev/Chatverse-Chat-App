import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs._();

  static SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<Map<String, dynamic>> getData() async {
    final bool _seenIntro = (_prefs.getBool('seenIntro') ?? false);
    final String _userId = (_prefs.getString('userId') ?? null);

    return {
      'seenIntro': _seenIntro,
      'userId': _userId,
    };
  }

  static Future<void> setLoggedInUserID(String userId) async {
    await _prefs.setString('userId', userId);
  }

  static Future<void> setSeenIntro(bool seenIntro) async {
    await _prefs.setBool('seenIntro', seenIntro);
  }
}

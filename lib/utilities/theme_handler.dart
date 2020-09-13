import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class ThemeHandler {
  ThemeHandler._();

//  scaffoldBackgroundColor: Color(0xFF385C6A),

  static final Brightness defaultBrightness = Brightness.light;
  static Brightness currentBrightness;

  static final baseTheme = ThemeData();

  static final ThemeData lightTheme = baseTheme.copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.grey[300],
    primaryColor: Colors.red,
    accentColor: Color(0xFFFEF9EB),
  );

  static final ThemeData darkTheme = baseTheme.copyWith(
    brightness: Brightness.dark,
  );

  static Future<void> setDarkTheme(BuildContext context) async {
    await DynamicTheme.of(context).setBrightness(Brightness.dark);
  }

  static Future<void> setLightTheme(BuildContext context) async {
    await DynamicTheme.of(context).setBrightness(Brightness.light);
  }

  static ThemeData getThemeData(Brightness brightness) {
    currentBrightness = brightness;
    print("currentBrightness : $currentBrightness");
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }
}

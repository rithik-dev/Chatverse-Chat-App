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
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    textTheme: TextTheme(
      // drawer name style
      headline1: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: Colors.black,
      ),

      // drawer text style
      headline2: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: Colors.black,
      ),

      // fav contacts style
      headline3: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
        color: Colors.grey[700],
      ),

      // message text style
      headline4: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),

      // message time style ,last msg style
      headline5: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: Colors.black.withOpacity(0.5),
      ),

      // input text fields
      headline6: TextStyle(
        fontSize: 16.0,
        color: Colors.black87,
      ),
    ),
    colorScheme: ColorScheme.light().copyWith(
      primary: Colors.white,
      secondary: Colors.black,
      // user message bg color
      onPrimary: Color(0xFFFEF9EB),
      // contacts message bg color
      onSecondary: Color(0xFFFFEFEE),
      // message read icon color
      secondaryVariant: Colors.green,
    ),
    scaffoldBackgroundColor: Colors.grey[200],
    backgroundColor: Colors.grey[300],
    // app bar color
    primaryColor: Colors.red,
    iconTheme: IconThemeData(color: Colors.red),
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

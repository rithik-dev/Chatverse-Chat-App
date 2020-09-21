import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class ThemeHandler {
  ThemeHandler._();

  static final Brightness defaultBrightness = Brightness.dark;

//  static final baseTheme = ThemeData();
//
//  static final ThemeData lightTheme = baseTheme.copyWith(
//    brightness: Brightness.light,
//    splashColor: Colors.transparent,
//    highlightColor: Colors.transparent,
//    textTheme: TextTheme(
//      // drawer name style
//      headline1: TextStyle(
//        fontSize: 25,
//        fontWeight: FontWeight.bold,
//        letterSpacing: 0.5,
//        color: Colors.black,
//      ),
//
//      // drawer text style
//      headline2: TextStyle(
//        fontSize: 20,
//        fontWeight: FontWeight.w700,
//        letterSpacing: 0.5,
//        color: Colors.black,
//      ),
//
//      // fav contacts style
//      headline3: TextStyle(
//        fontSize: 20.0,
//        fontWeight: FontWeight.bold,
//        letterSpacing: 1.0,
//        color: Colors.grey[700],
//      ),
//
//      // message text style
//      headline4: TextStyle(
//        fontSize: 16.0,
//        fontWeight: FontWeight.w600,
//        color: Colors.black,
//      ),
//
//      // message time style ,last msg style
//      headline5: TextStyle(
//        fontSize: 16.0,
//        fontWeight: FontWeight.w600,
//        color: Colors.black.withOpacity(0.5),
//      ),
//
//      // input text fields
//      headline6: TextStyle(
//        fontSize: 16.0,
//        color: Colors.black87,
//      ),
//    ),
//    colorScheme: ColorScheme.light().copyWith(
//      primary: Colors.white,
//      secondary: Colors.black,
//      // user message bg color
//      onPrimary: Color(0xFFFEF9EB),
//      // contacts message bg color
//      onSecondary: Color(0xFFFFEFEE),
//      // message read icon color
//      secondaryVariant: Colors.green,
//    ),
//    scaffoldBackgroundColor: Colors.grey[200],
//    backgroundColor: Colors.grey[300],
//    // app bar color
//    primaryColor: Colors.red,
//    iconTheme: IconThemeData(color: Colors.red),
//  );
//
//  static final ThemeData darkTheme = baseTheme.copyWith(
//    brightness: Brightness.dark,
//    scaffoldBackgroundColor: Color(0xFF385C6A),
//    colorScheme: ColorScheme.dark().copyWith(
//      primary: Colors.black,
//      secondary: Colors.white,
//      // user message bg color
//      onPrimary: Color(0xFFFEF9EB),
//      // contacts message bg color
//      onSecondary: Color(0xFFFFEFEE),
//      // message read icon color
//      secondaryVariant: Colors.yellow,
//    ),
//    textTheme: TextTheme(
//      // drawer name style
//      headline1: TextStyle(
//        fontSize: 25,
//        fontWeight: FontWeight.bold,
//        letterSpacing: 0.5,
//        color: Colors.black,
//      ),
//
//      // drawer text style
//      headline2: TextStyle(
//        fontSize: 20,
//        fontWeight: FontWeight.w700,
//        letterSpacing: 0.5,
//        color: Colors.black,
//      ),
//
//      // fav contacts style
//      headline3: TextStyle(
//        fontSize: 20.0,
//        fontWeight: FontWeight.bold,
//        letterSpacing: 1.0,
//        color: Colors.grey[700],
//      ),
//
//      // message text style
//      headline4: TextStyle(
//        fontSize: 16.0,
//        fontWeight: FontWeight.w600,
//        color: Colors.black,
//      ),
//
//      // message time style ,last msg style
//      headline5: TextStyle(
//        fontSize: 16.0,
//        fontWeight: FontWeight.w600,
//        color: Colors.black.withOpacity(0.5),
//      ),
//
//      // input text fields
//      headline6: TextStyle(
//        fontSize: 16.0,
//        color: Colors.black87,
//      ),
//    ),
//  );

  static Color favoriteContactsBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.deepOrangeAccent
        : Color(0xFF162447);
  }

  static Color selectedContactBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.red
        : Color(0xFF162447);
  }

  static Color unreadMessageBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.red
        : Color(0xFF1f4068);
  }

  static Color myMessageCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.grey[400]
        : Color(0xFF353A47);
  }

  static Color contactMessageCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.deepPurpleAccent
        : Color(0xFF2646FF);
  }

  static Color sendTextFieldBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.grey[600]
        : Colors.grey[850];
  }

  static Color primaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Colors.white;
  }

  static Color secondaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Colors.black87;
  }

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(
        centerTitle: true,
        color: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 30),
        actionsIconTheme: IconThemeData(color: Colors.black, size: 30)),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.black),
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Color(0xFF1b1b2f),
    appBarTheme: AppBarTheme(
        centerTitle: true,
        color: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.tealAccent, size: 30),
        actionsIconTheme: IconThemeData(color: Colors.tealAccent, size: 30)),
    accentColor: Colors.tealAccent,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    canvasColor: Color(0xFF1b1b2f),
    iconTheme: IconThemeData(color: Colors.tealAccent),
  );

  static Future<void> setDarkTheme(BuildContext context) async {
    await DynamicTheme.of(context).setBrightness(Brightness.dark);
  }

  static Future<void> setLightTheme(BuildContext context) async {
    await DynamicTheme.of(context).setBrightness(Brightness.light);
  }

  static ThemeData getThemeData(Brightness brightness) {
    print("currentBrightness : $brightness");
    return darkTheme;
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }

  static Future<void> toggleTheme(BuildContext context) async {
    if (Theme
        .of(context)
        .brightness == Brightness.light)
      await setDarkTheme(context);
    else
      await setLightTheme(context);
  }
}

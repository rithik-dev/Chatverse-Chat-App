import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class ThemeHandler {
  ThemeHandler._();

//  scaffoldBackgroundColor: Color(0xFF385C6A),

  static final Brightness defaultBrightness = Brightness.light;
  static Brightness currentBrightness;

  static final baseTheme = ThemeData(
    textTheme: TextTheme().copyWith(),
  );

  static final ThemeData lightTheme = baseTheme.copyWith(
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = baseTheme.copyWith(
    brightness: Brightness.dark,
  );

  static void setDarkTheme(BuildContext context) {
    DynamicTheme.of(context).setBrightness(Brightness.dark);
  }

  static void setLightTheme(BuildContext context) {
    DynamicTheme.of(context).setBrightness(Brightness.light);
  }

  static ThemeData getThemeData(Brightness brightness) {
    currentBrightness = brightness;
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }
}

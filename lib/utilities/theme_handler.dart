import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class ThemeHandler {
  ThemeHandler._();

  static final Brightness defaultBrightness = Brightness.light;

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
  );
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
  );

  static void setDarkTheme(BuildContext context) {
    DynamicTheme.of(context).setBrightness(Brightness.dark);
  }

  static void setLightTheme(BuildContext context) {
    DynamicTheme.of(context).setBrightness(Brightness.light);
  }

  static ThemeData getThemeData(Brightness brightness) {
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }
}

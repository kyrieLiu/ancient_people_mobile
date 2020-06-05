import 'package:flutter/material.dart';

class ThemeUtils {
  static const Color defaultColor = Colors.blue;
  static Color currentThemeColor = defaultColor;
  static bool dark = false;

  static ThemeData getThemeData() {
    if (dark) {
      return new ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF35464E),
        primaryColorDark: Color(0xFF212A2F),
        accentColor: Color(0xFF35464E),
        dividerColor: Color(0x1FFFFFFF),
      );
    } else {
      return new ThemeData(
        brightness: Brightness.light,
        primaryColor: defaultColor,
        primaryColorDark: currentThemeColor,
        accentColor: currentThemeColor,
        dividerColor: Color(0x1F000000),
      );
    }
  }
}
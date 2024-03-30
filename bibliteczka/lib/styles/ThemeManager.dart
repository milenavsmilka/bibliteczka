import 'package:biblioteczka/styles/DarkTheme.dart';
import 'package:biblioteczka/styles/LightTheme.dart';
import 'package:flutter/material.dart';

class ThemeManager {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return isDarkTheme ? darkTheme : lightTheme;
  }
}
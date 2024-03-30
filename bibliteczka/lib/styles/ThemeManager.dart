import 'package:biblioteczka/styles/DarkTheme.dart';
import 'package:biblioteczka/styles/LightTheme.dart';
import 'package:flutter/material.dart';

class ThemeManager {
  static ThemeData themeData(String howIsTheme, BuildContext context) {
    switch(howIsTheme){
      case 'light': return lightTheme;
      case 'dark': return darkTheme;
      default: return lightTheme;
    }
  }
}
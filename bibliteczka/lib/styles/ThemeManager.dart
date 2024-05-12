import 'package:biblioteczka/styles/DaltonismTheme.dart';
import 'package:biblioteczka/styles/DarkTheme.dart';
import 'package:biblioteczka/styles/LightTheme.dart';
import 'package:biblioteczka/styles/SpecialTheme.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';

class ThemeManager {
  static ThemeData themeData(String howIsTheme, BuildContext context) {
    switch(howIsTheme){
      case light: return lightTheme;
      case dark: return darkTheme;
      case special: return specialTheme;
      case daltonism: return daltonismTheme;
      default: return lightTheme;
    }
  }
}
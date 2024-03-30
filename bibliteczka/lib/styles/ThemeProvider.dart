import 'package:biblioteczka/styles/ThemePreferences.dart';
import 'package:flutter/cupertino.dart';

class ThemeProvider with ChangeNotifier {
  ThemePreferences themePreferences = ThemePreferences();
  bool _darkTheme = false;

  bool get getDarkTheme => _darkTheme;

  set setDarkTheme(bool value) {
    _darkTheme = value;
    themePreferences.setDarkTheme(value);
    notifyListeners();
  }
}

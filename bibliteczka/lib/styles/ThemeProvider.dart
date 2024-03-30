import 'package:biblioteczka/styles/ThemePreferences.dart';
import 'package:flutter/cupertino.dart';

class ThemeProvider with ChangeNotifier {
  ThemePreferences themePreferences = ThemePreferences();
  String _howTheme = 'light';

  String get getDarkTheme => _howTheme;

  set setDarkTheme(String value) {
    _howTheme = value;
    themePreferences.setDarkTheme(value);
    notifyListeners();
  }
}

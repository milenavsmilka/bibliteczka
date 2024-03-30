import 'package:biblioteczka/styles/ThemePreferences.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/cupertino.dart';

class ThemeProvider with ChangeNotifier {
  ThemePreferences themePreferences = ThemePreferences();
  String _whichTheme = light;

  String get getCurrentTheme => _whichTheme;

  set setAnotherTheme(String value) {
    _whichTheme = value;
    themePreferences.setAnotherTheme(value);
    notifyListeners();
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const THEME_TYPE = 'THEMETYPE';

  setDarkTheme(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(THEME_TYPE, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(THEME_TYPE) ?? false;
  }
}

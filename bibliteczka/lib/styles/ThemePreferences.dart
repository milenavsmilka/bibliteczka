import 'package:biblioteczka/styles/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  static const THEME_TYPE = 'THEMETYPE';

  setAnotherTheme(String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(THEME_TYPE, value);
  }

  Future<String> getTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(THEME_TYPE) ?? light;
  }
}

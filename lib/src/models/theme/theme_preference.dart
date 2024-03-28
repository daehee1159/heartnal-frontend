import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference {
  static const THEME_STATUS = 'THEME_STATUS';

  void setTheme(String value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(THEME_STATUS, value);
  }

  Future<String> getTheme() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(THEME_STATUS).toString();
  }
}

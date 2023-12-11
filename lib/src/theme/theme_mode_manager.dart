import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_mode_handler/theme_mode_manager_interface.dart';

class MyThemeModeManager implements IThemeModeManager {
  static const _key = 'my_theme_mode';

  @override
  Future<String?> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    // Intended delay for demonstration purposes
    await Future.delayed(const Duration(milliseconds: 500));

    return prefs.getString(_key);
  }

  @override
  Future<bool> saveThemeMode(String value) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.setString(_key, value);
  }
}

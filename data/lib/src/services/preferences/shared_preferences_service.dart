import 'package:shared_preferences/shared_preferences.dart';

import 'shared_pref_keys.dart';

class SharedPreferencesService {
  static SharedPreferencesService _instance;
  static SharedPreferences _preferences;

  SharedPreferencesService._internal();

  static Future<SharedPreferencesService> get instance async {
    if (_instance == null) {
      _instance = SharedPreferencesService._internal();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  /// saving the current user preferred theme mode.
  /// use [PrefsConstants.SYSTEM_THEME_MODE] => system settings mode.
  /// use [PrefsConstants.LIGHT_THEME_MODE] => light theme mode.
  /// use [PrefsConstants.DARK_THEME_MODE] => dark theme mode.
  Future<bool> setCurrentUserId(String userId) async =>
      await _preferences.setString(SharedPrefKeys.currentUserId, userId);

  String get currentUserId =>
      _preferences.getString(SharedPrefKeys.currentUserId);
}

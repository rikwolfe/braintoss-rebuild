import 'package:shared_preferences/shared_preferences.dart';

import 'package:braintoss/services/impl/base_service_impl.dart';
import 'package:braintoss/services/interfaces/shared_preferences_service.dart';

class SharedPreferencesServiceImpl extends BaseServiceImpl
    implements SharedPreferencesService {
  static SharedPreferences localStorage =
      SharedPreferences.getInstance() as SharedPreferences;
  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }

  @override
  String? getString(String key) {
    return localStorage.getString(key);
  }

  @override
  void saveString(String key, String value) {
    localStorage.setString(key, value);
  }

  @override
  void saveStringList(String key, List<String> value) {
    localStorage.setStringList(key, value);
  }

  @override
  bool getBool(String key) {
    return localStorage.getBool(key) ?? false;
  }

  @override
  void saveBool(String key, bool value) {
    localStorage.setBool(key, value);
  }

  @override
  List<String>? getStringList(String key) {
    return localStorage.getStringList(key);
  }
}

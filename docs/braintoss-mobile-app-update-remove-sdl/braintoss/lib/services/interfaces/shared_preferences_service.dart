import 'package:braintoss/services/interfaces/base_service.dart';

abstract class SharedPreferencesService extends BaseService {
  void saveString(String key, String value);
  String? getString(String key);

  void saveBool(String key, bool value);
  bool getBool(String key);

  void saveStringList(String key, List<String> value);
  List<String>? getStringList(String key);
}

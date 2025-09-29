import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/services/impl/shared_preferences_service_impl.dart';

String getFullFilePath(String fileName) {
  SharedPreferencesServiceImpl sharedPreferences =
      SharedPreferencesServiceImpl();

  String fullFilePath =
      "${sharedPreferences.getString(SharedPreferencesConstants.fileDirectoryPath)!}/$fileName";

  return fullFilePath;
}

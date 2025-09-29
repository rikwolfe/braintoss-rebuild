import 'package:braintoss/services/interfaces/base_service.dart';

abstract class QuickstartService extends BaseService {
  void setQuickstartOption(String optionName);
  String getQuickstartOption();
  void triggerQuickstart();
  void setLastUsedRoute(String route);
  String? getLastUsedRoute();
  void disableQuickstart();
  void handleBackNavigation(String value, String route);
  bool isPhotoQuickstartEnable();
}

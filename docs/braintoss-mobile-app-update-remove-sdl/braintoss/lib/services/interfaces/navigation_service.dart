import 'package:braintoss/services/interfaces/base_service.dart';

import '../../routes.dart';

abstract class NavigationService extends BaseService {
  Future<void> navigateTo<T extends BaseStoreArguments>(String path,
      {T? arguments});
  void goBack();
  void goHome();
  void replaceWith<T extends BaseStoreArguments>(String path, {T? arguments});
  Future<void> navigateWithCallback(String path, Function() callbackFunction);
  void navigateWithoutAnimation(String path);
}

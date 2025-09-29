import 'package:braintoss/routes.dart';
import 'package:braintoss/services/impl/base_service_impl.dart';
import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:seafarer/seafarer.dart';

class NavigationServiceImpl extends BaseServiceImpl
    implements NavigationService {
  @override
  Future<void> navigateTo<T extends BaseStoreArguments>(String path,
      {T? arguments}) async {
    await Routes.seafarer.navigate(path, args: arguments);
  }

  @override
  void goBack() {
    Routes.seafarer.pop();
  }

  @override
  void replaceWith<T extends BaseStoreArguments>(String path, {T? arguments}) {
    Routes.seafarer.navigate(
      path,
      args: arguments,
      navigationType: NavigationType.pushReplace,
    );
  }

  @override
  Future<void> navigateWithCallback(
      String path, Function() callbackFunction) async {
    await Routes.seafarer.navigate(Routes.defaultLanguage);
    callbackFunction();
  }

  @override
  void navigateWithoutAnimation(String path) {
    Routes.seafarer.navigate(path, transitionDuration: const Duration());
  }

  @override
  void goHome() {
    Routes.seafarer.navigate(
      Routes.home,
      navigationType: NavigationType.pushAndRemoveUntil,
      removeUntilPredicate: (_) => false,
    );
  }
}

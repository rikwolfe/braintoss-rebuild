import 'package:braintoss/services/interfaces/navigation_service.dart';

abstract class BaseStore {
  final NavigationService? navigationService;
  const BaseStore({
    this.navigationService,
  });
}

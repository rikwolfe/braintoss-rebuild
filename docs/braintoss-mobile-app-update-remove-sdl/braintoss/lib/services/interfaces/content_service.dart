import 'package:braintoss/services/interfaces/base_service.dart';

abstract class ContentService extends BaseService {
  Future<String> getAboutPage();
}

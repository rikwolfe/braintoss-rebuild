import 'package:braintoss/services/interfaces/base_service.dart';

abstract class LoggerService extends BaseService {
  void recordError(String message);
}

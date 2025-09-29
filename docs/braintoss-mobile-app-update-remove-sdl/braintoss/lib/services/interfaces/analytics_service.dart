import 'package:braintoss/services/interfaces/base_service.dart';

abstract class AnalyticsService extends BaseService {
  void sendLog(String log);
}

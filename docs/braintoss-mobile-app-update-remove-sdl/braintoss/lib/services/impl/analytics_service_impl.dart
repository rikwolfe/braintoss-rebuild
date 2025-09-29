import 'package:braintoss/services/impl/base_service_impl.dart';
import 'package:braintoss/services/interfaces/analytics_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AnalyticsServiceImpl extends BaseServiceImpl implements AnalyticsService {
  @override
  void sendLog(String log) {
    FirebaseCrashlytics.instance.log(log);
  }
}

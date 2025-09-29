import 'dart:developer';
import 'package:braintoss/services/impl/base_service_impl.dart';
import 'package:braintoss/services/interfaces/logger_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class LoggerServiceImpl extends BaseServiceImpl implements LoggerService {
  @override
  void recordError(String message) {
    FirebaseCrashlytics.instance.recordError(message, StackTrace.current);
    FirebaseCrashlytics.instance.log(message);
    log(message);
  }
}

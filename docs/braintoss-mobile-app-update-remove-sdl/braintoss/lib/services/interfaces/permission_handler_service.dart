import 'package:braintoss/services/interfaces/base_service.dart';

abstract class PermissionHandlerService extends BaseService {
  Future<bool> requestMicrophonePermission();
}

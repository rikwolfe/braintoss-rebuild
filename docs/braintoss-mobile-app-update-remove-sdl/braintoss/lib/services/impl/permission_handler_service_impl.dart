import 'package:permission_handler/permission_handler.dart';

import 'package:braintoss/services/interfaces/permission_handler_service.dart';
import 'package:braintoss/services/impl/base_service_impl.dart';

class PermissionHandlerServiceImpl extends BaseServiceImpl
    implements PermissionHandlerService {
  @override
  Future<bool> requestMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      return false;
    }

    if (status.isDenied || status.isRestricted) {
      final newStatus = await Permission.microphone.request();

      if (newStatus.isDenied || newStatus.isPermanentlyDenied) {
        return false;
      }
    }

    return status.isGranted;
  }
}
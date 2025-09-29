import 'package:braintoss/models/capture_entity.dart';
import 'package:braintoss/services/interfaces/base_service.dart';

import '../../models/request_response.dart';

abstract class StatusUpdaterService extends BaseService {
  Future<RequestResponse?> updateStatus(CaptureEntity capture);
}

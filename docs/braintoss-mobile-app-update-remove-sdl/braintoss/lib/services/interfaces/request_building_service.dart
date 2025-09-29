import 'package:braintoss/models/request_details.dart';

import 'base_service.dart';

enum RequestType {
  note,
  voice,
  photo,
  photoOcr,
  photoVcf,
  about,
  language,
  status,
  notifications,
  history,
}

abstract class RequestBuildingService extends BaseService {
  Future<RequestDetails> buildRequest(RequestType requestType, String? email,
      String? bitrate, String? messageId,
      {String? existingLocation});
}

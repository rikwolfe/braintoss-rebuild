import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/models/capture_entity.dart';
import 'package:braintoss/models/request_details.dart';
import 'package:braintoss/models/status_request_response.dart';
import 'package:braintoss/services/interfaces/logger_service.dart';

import '../../connectors/http_connector.dart';
import '../../models/request_response.dart';
import '../interfaces/capture_data_manager.dart';
import '../interfaces/request_building_service.dart';
import '../interfaces/status_updater_service.dart';

class StatusUpdaterServiceImpl implements StatusUpdaterService {
  StatusUpdaterServiceImpl(
    this._captureDataManager,
    this._httpConnector,
    this._requestBuildingService,
    this._loggerService,
  );
  final CaptureDataManager _captureDataManager;
  final RequestBuildingService _requestBuildingService;
  final HttpConnector _httpConnector;
  final LoggerService _loggerService;

  @override
  Future<RequestResponse?> updateStatus(CaptureEntity capture) async {
    RequestDetails requestDetails = await _requestBuildingService.buildRequest(
        RequestType.status, capture.email, null, capture.messageID);

    try {
      var httpResponse = await _httpConnector.get(requestDetails.builtString);
      if (httpResponse == null || httpResponse.data == null) {
        throw Exception("Null response.");
      }
      StatusRequestResponse statusResponse =
          StatusRequestResponse.fromJson(httpResponse.data);
      if (statusResponse.response.error == null ||
          statusResponse.response.error == 0) {
        int? statusCode = statusResponse.response.history![0].code;
        try {
          capture.statusCode = statusCode;
        } catch (e) {
          capture.statusCode = 0;
        }
        capture.description = statusResponse.response.history![0].description;
        capture.alive = statusResponse.response.history![0].alive == "yes" ||
            statusResponse.response.history![0].alive == "resend";

        _captureDataManager.saveCapture(capture);
        return responseStatusCodes[statusCode];
      } else {
        return responseStatusCodes[statusResponse.response.error];
      }
    } catch (e) {
      _loggerService.recordError(e.toString());
    }
    return null;
  }
}

import 'package:braintoss/connectors/http_connector.dart';
import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/models/html_response.dart';
import 'package:braintoss/services/impl/base_service_impl.dart';
import 'package:braintoss/services/interfaces/logger_service.dart';
import 'package:braintoss/services/interfaces/request_building_service.dart';

import '../interfaces/content_service.dart';

class ContentServiceImpl extends BaseServiceImpl implements ContentService {
  final HttpConnector _httpConnector;
  final RequestBuildingService _requestBuildingService;
  final LoggerService _loggerService;

  ContentServiceImpl(
      this._httpConnector, this._requestBuildingService, this._loggerService);

  @override
  Future<String> getAboutPage() async {
    try {
      final response = await _httpConnector.get((await _requestBuildingService
              .buildRequest(RequestType.about, null, null, null))
          .builtString);
      if (response == null || response.data == null) {
        throw Exception("No response received");
      }
      final ContentModel content = ContentModel.fromJson(response.data);

      if (content.response.status != okResponseStatus ||
          content.response.error != 0) {
        throw Exception("Returned error ${content.response.status}");
      }
      if (content.response.html == null) {
        throw Exception("No content in response.");
      }

      return content.response.html!;
    } catch (e) {
      _loggerService.recordError(e.toString());
      return Future.error(e);
    }
  }
}

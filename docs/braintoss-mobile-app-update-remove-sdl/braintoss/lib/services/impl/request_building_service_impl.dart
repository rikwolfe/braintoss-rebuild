import 'dart:io';

import 'package:braintoss/models/request_details.dart';
import 'package:braintoss/services/impl/base_service_impl.dart';
import 'package:braintoss/services/interfaces/language_service.dart';
import 'package:braintoss/services/interfaces/location_service.dart';
import 'package:braintoss/services/interfaces/request_building_service.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../constants/app_constants.dart';
import '../../utils/functions/generators.dart';
import '../interfaces/user_information_service.dart';

class DeviceInfo {
  DeviceInfo(this.deviceName, this.osName, this.osVersion);
  final String deviceName;
  final String osName;
  final String osVersion;
}

const List<RequestType> _extendedRequests = [
  RequestType.note,
  RequestType.photo,
  RequestType.photoOcr,
  RequestType.photoVcf,
  RequestType.voice
];

Future<DeviceInfo> _getDeviceInfo() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final String deviceName;
  final String osName;
  final String osVersion;
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    deviceName = androidInfo.model;
    osName = "Android";
    osVersion = androidInfo.version.release;
  } else if (Platform.isIOS) {
    IosDeviceInfo iOsInfo = await deviceInfoPlugin.iosInfo;
    deviceName = iOsInfo.model;
    osName = "iOS";
    osVersion = iOsInfo.systemVersion;
  } else {
    deviceName = "Unknown";
    osName = "Unknown";
    osVersion = "Unknown";
  }
  return Future.value(DeviceInfo(deviceName, osName, osVersion));
}

String _getRequestTypeQueryParameter(RequestType requestType, String? bitrate) {
  switch (requestType) {
    case RequestType.about:
      return '&q=about';
    case RequestType.language:
      return '&q=lang';
    case RequestType.notifications:
      return '&q=notifications';
    case RequestType.photoOcr:
      return '&q=ocr';
    case RequestType.photoVcf:
      return '&q=vcard';
    case RequestType.status:
      return '&q=status&t=json';
    case RequestType.voice:
      return '&rate=$bitrate';
    case RequestType.history:
      return '&q=xml';
    default:
      return "";
  }
}

class RequestBuildingServiceImpl extends BaseServiceImpl
    implements RequestBuildingService {
  RequestBuildingServiceImpl(
    this._userInformationService,
    this._locationService,
    this._languageService,
  );
  final UserInformationService _userInformationService;
  final LocationService _locationService;
  final LanguageService _languageService;

  @override
  Future<RequestDetails> buildRequest(
    RequestType requestType,
    String? email,
    String? bitrate,
    String? messageId, {
    String? existingLocation,
    String? watchOsVersion,
  }) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final DeviceInfo deviceInfo = await _getDeviceInfo();

    final String emailAddress =
        email ?? _userInformationService.getDefaultUserEmail().emailAddress;
    final String userID = _userInformationService.getUserId();
    final String osName = deviceInfo.osName;
    final String osVersion = deviceInfo.osVersion;
    final String messageID = messageId ?? generateUUIDv1();
    final String appVersion = packageInfo.version;
    final String isoLanguageCode =
        _languageService.getSpeechToTextLanguage().localCode;

    StringBuffer requestBuffer = StringBuffer();
    requestBuffer.write('?email=$emailAddress');
    requestBuffer.write('&key=$apiKey');
    requestBuffer.write('&uid=$userID');
    requestBuffer.write('&os=$osName-$osVersion');
    requestBuffer.write('&mid=$messageID');
    requestBuffer.write('&v=$appVersion');
    requestBuffer.write('&lang=$isoLanguageCode');

    final String deviceName = deviceInfo.deviceName;
    String latitude = "";
    String longitude = "";
    String locationString = "";
    if (_extendedRequests.contains(requestType)) {
      requestBuffer.write(
        '&d=$deviceName${watchOsVersion != null ? "[/watchOS]" : ""}',
      );
      List<String> location = await _locationService.getCurrentLocation();
      if (existingLocation != null && existingLocation.isNotEmpty) {
        locationString = existingLocation;
        requestBuffer.write(locationString);
      } else if (location.length == 2) {
        latitude = location[0];
        longitude = location[1];
        locationString = '&lat=$latitude&long=$longitude';
        requestBuffer.write(locationString);
      }
    }

    requestBuffer
        .write(_getRequestTypeQueryParameter(requestType, bitrate ?? "128"));

    final String requestString = requestBuffer.toString();
    final RequestDetails requestDetails = RequestDetails(
        builtString: requestString,
        appVersion: appVersion,
        deviceName: deviceName,
        emailAddress: emailAddress,
        isoLanguageCode: isoLanguageCode,
        messageID: messageID,
        osName: osName,
        osVersion: osVersion,
        userID: userID,
        location: locationString,
        bitrate: bitrate);

    return Future.value(requestDetails);
  }
}

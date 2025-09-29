import 'dart:async';
import 'dart:io';
import 'package:braintoss/connectors/http_connector.dart';
import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/models/capture_entity.dart';
import 'package:braintoss/models/capture_upload_model.dart';
import 'package:braintoss/models/request_details.dart';
import 'package:braintoss/models/status_request_response.dart';
import 'package:braintoss/services/impl/base_service_impl.dart';
import 'package:braintoss/services/interfaces/capture_service.dart';
import 'package:braintoss/services/interfaces/capture_data_manager.dart';
import 'package:braintoss/services/interfaces/shared_preferences_service.dart';
import 'package:braintoss/services/interfaces/sound_service.dart';
import 'package:braintoss/utils/functions/file_path_helper.dart';
import 'package:dio/dio.dart';
import '../../models/capture_type.dart';
import '../interfaces/request_building_service.dart';
import 'package:vibration/vibration.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CaptureServiceImpl extends BaseServiceImpl implements CaptureService {
  CaptureServiceImpl(
    this._httpConnector,
    this._requestBuildingService,
    this._soundService,
    this._sharedPreferencesService,
    this._captureDataManager,
  );

  final HttpConnector _httpConnector;
  final RequestBuildingService _requestBuildingService;
  final SoundService _soundService;
  final SharedPreferencesService _sharedPreferencesService;
  final CaptureDataManager _captureDataManager;

  @override
  void playSoundAndVibrate() {
    final bool isSoundOn =
        _sharedPreferencesService.getBool(SharedPreferencesConstants.sound);
    final bool isVibrationOn =
        _sharedPreferencesService.getBool(SharedPreferencesConstants.vibration);
    if (isSoundOn) {
      _soundService.playSound('audio/boomerang_sound.mp3');
    }
    if (isVibrationOn) {
      Vibration.vibrate(duration: 1000);
    }
  }

  @override
  Future<StatusRequestResponse?> sendCapture(CaptureUploadModel capture) async {
    RequestType requestType;
    switch (capture.captureType) {
      case CaptureType.photo:
        if (capture.ocr) {
          requestType = RequestType.photoOcr;
        } else if (capture.vcard) {
          requestType = RequestType.photoVcf;
        } else {
          requestType = RequestType.photo;
        }
        break;
      case CaptureType.voiceWatch:
      case CaptureType.voice:
        requestType = RequestType.voice;
        break;
      case CaptureType.note:
        requestType = RequestType.note;
        break;
    }

    final RequestDetails request = await _requestBuildingService.buildRequest(
      requestType,
      capture.email,
      capture.bitrate,
      capture.messageID,
      existingLocation: capture.location,
    );

    capture.location ??= request.location;

    CaptureEntity captureEntity = capture.toCaptureEntity();
    _captureDataManager.saveCapture(captureEntity);

    FormData formData = FormData.fromMap(
      {
        "file": MultipartFile.fromBytes(
            File(getFullFilePath(capture.filename)).readAsBytesSync(),
            filename: capture.filename)
      },
    );

    Response? rawResponse;
    StatusRequestResponse? parsedResponse;

    try {
      bool hasConnection = await InternetConnectionChecker().hasConnection;
      if (hasConnection) {
        rawResponse = await _httpConnector.post(request.builtString, formData);
      } else {
        throw Exception('No internet Connection');
      }

      if (rawResponse == null) {
        throw Exception("No response.");
      }
      parsedResponse = StatusRequestResponse.fromJson(rawResponse.data);
      captureEntity.status = parsedResponse.response.status ?? "";
      captureEntity.statusCode = parsedResponse.response.error;
      _captureDataManager.saveCapture(captureEntity);
    } catch (e) {
      captureEntity.statusCode = 300;
      _captureDataManager.saveCapture(captureEntity);
    }

    return parsedResponse;
  }

  @override
  Future<StatusRequestResponse?> resendCapture(CaptureEntity capture) {
    return sendCapture(capture.toCaptureUploadModel());
  }
}

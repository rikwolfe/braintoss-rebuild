import 'dart:io';

import 'package:braintoss/inject/injectservices_extension.dart';
import 'package:braintoss/models/capture_entity.dart';
import 'package:braintoss/models/capture_type.dart';
import 'package:braintoss/services/interfaces/capture_data_manager.dart';
import 'package:braintoss/services/interfaces/capture_service.dart';
import 'package:braintoss/services/interfaces/logger_service.dart';
import 'package:braintoss/services/interfaces/user_information_service.dart';
import 'package:braintoss/utils/functions/generators.dart';
import 'package:flutter/services.dart';

import '../../constants/app_constants.dart';
import '../../models/capture_upload_model.dart';
import '../../models/email_model.dart';
import 'package:braintoss/routes.dart';
import 'package:braintoss/services/impl/navigation_service_impl.dart';
import 'package:braintoss/services/interfaces/navigation_service.dart';

class MethodCalls {
  static const String receiveAudioFromWatch = "UploadAudio";
  static const String receiveCaptureFromCar = "uploadFromCar";
  static const String navigateWithSiri = "NavigateWithSiri";
}

const methodChannel = MethodChannel(methodChannelName);

void sendUserInfoToWatch() async {
  if (Platform.isAndroid) return;
  UserInformationService userInformationService =
      ModuleContainer.shared.getService<UserInformationService>();

  List<Email> emails = userInformationService.getUserEmails().isNotEmpty
      ? userInformationService.getUserEmails()
      : [userInformationService.getDefaultUserEmail()];

  List<String> emailAddressList = [
    ...(emails.map((emailEntry) => emailEntry.emailAddress).toList())
  ];

  List<String> aliasList = [
    ...(emails.map((emailEntry) => emailEntry.alias).toList())
  ];

  String userId = userInformationService.getUserId();

  methodChannel.invokeMapMethod(
    "UserInfo",
    {
      "UserId": userId,
      "EmailList": emailAddressList,
      "AliasList": aliasList,
    },
  );
}

Future<void> methodCallHandler(MethodCall call) async {
  CaptureService captureService =
      ModuleContainer.shared.getService<CaptureService>();
  CaptureDataManager captureDataManager =
      ModuleContainer.shared.getService<CaptureDataManager>();
  LoggerService loggerService =
      ModuleContainer.shared.getService<LoggerService>();
  NavigationService navigationService = NavigationServiceImpl();

  switch (call.method) {
    case MethodCalls.receiveAudioFromWatch:
      try {
        final Map<dynamic, dynamic> info =
            call.arguments as Map<dynamic, dynamic>;
        final String email = info["Email"];
        final String fileURL = info["FileURL"];
        final bool fileUploadedByWatch = info["FileUploadedByWatch"];
        final String watchOSVersion = info["WatchOSVersion"];
        final String watchHttpRequestStatus = info["WatchHttpRequestStatus"];

        final String messageID = generateUUIDv1();
        final String timestamp = generateTimestamp();
        final String filename = fileURL.split("/").last;

        if (fileUploadedByWatch) {
          final CaptureEntity captureEntity = CaptureEntity(
              messageID: messageID,
              captureSource: CaptureType.voiceWatch,
              timestamp: timestamp,
              filename: filename,
              fullFilePath: fileURL,
              status: watchHttpRequestStatus,
              email: email);
          captureDataManager.saveCapture(captureEntity);
        } else {
          final CaptureUploadModel captureUploadModel = CaptureUploadModel(
              messageID: messageID,
              captureType: CaptureType.voiceWatch,
              timestamp: timestamp,
              filename: filename,
              fullFilePath: fileURL,
              email: email,
              watchOsVersion: watchOSVersion);
          captureService.sendCapture(captureUploadModel);
        }
      } catch (error) {
        loggerService.recordError(error.toString());
      }
      break;
    case MethodCalls.receiveCaptureFromCar:
      try {
        final Map<dynamic, dynamic> info =
            call.arguments as Map<dynamic, dynamic>;
        final String messageID = info["messageId"];
        final String email = info["emailParam"];
        final String fileURL = info["fileURL"];

        final String timestamp = generateTimestamp();
        final String filename = fileURL.split("/").last;

        final CaptureEntity captureEntity = CaptureEntity(
            messageID: messageID,
            captureSource: CaptureType.voice,
            timestamp: timestamp,
            filename: filename,
            fullFilePath: fileURL,
            status: "110",
            email: email);
        captureDataManager.saveCapture(captureEntity);
      } catch (error) {
        loggerService.recordError(error.toString());
      }
      break;
    case MethodCalls.navigateWithSiri:
      try {
        final String route = call.arguments as String;
        switch (route) {
          case "Note":
            navigationService.navigateTo(Routes.note);
            break;
          case "Voice":
            navigationService.navigateTo(Routes.voice);
            break;
          case "Photo":
            navigationService.navigateTo(Routes.photo);
            break;
        }
      } catch (error) {
        loggerService.recordError(error.toString());
      }
      break;
    default:
      break;
  }
}

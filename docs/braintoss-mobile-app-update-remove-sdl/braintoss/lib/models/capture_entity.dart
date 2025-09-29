import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';
import 'capture_model.dart';
import 'capture_type.dart';
import 'capture_upload_model.dart';

part 'capture_entity.g.dart';

@HiveType(typeId: 1)
class CaptureEntity extends HiveObject {
  CaptureEntity(
      {required this.messageID,
      required this.captureSource,
      required this.timestamp,
      required this.filename,
      required this.fullFilePath,
      required this.status,
      required this.email,
      this.statusCode,
      this.description,
      this.bitrate,
      this.vcard = false,
      this.ocr = false,
      this.location,
      this.shared = false,
      this.alive = false}) {
    dateAndTime = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
  }
  @HiveField(0)
  final String messageID;
  @HiveField(1)
  final CaptureType captureSource;
  @HiveField(2)
  final String timestamp;
  late DateTime dateAndTime;
  @HiveField(3)
  final String filename;
  @HiveField(4)
  final String fullFilePath;
  @HiveField(5)
  String status;
  @HiveField(6)
  final String? email;
  @HiveField(7)
  int? statusCode;
  @HiveField(8)
  String? description;
  @HiveField(9)
  final String? bitrate;
  @HiveField(10)
  bool vcard;
  @HiveField(11)
  bool ocr;
  @HiveField(12)
  final String? location;
  @HiveField(13)
  final bool shared;
  @HiveField(14)
  bool alive;

  bool isAlive() {
    return (alive == true ||
        status == "" ||
        responseStatusCodes.containsKey(statusCode) == false ||
        responseStatusCodes[statusCode]?.resolved == false);
  }

  bool isOld() {
    final twoWeeksAgo = DateTime.now().subtract(const Duration(days: 14));
    if (dateAndTime.isBefore(twoWeeksAgo)) {
      return true;
    }
    return false;
  }

  CaptureStatus getCaptureStatus() {
    CaptureStatus captureStatus = CaptureStatus.queue;

    if (responseStatusCodes[statusCode]?.sent == true) {
      captureStatus = CaptureStatus.sent;
    }
    if (responseStatusCodes[statusCode]?.error == true) {
      captureStatus = CaptureStatus.fail;
    }

    return captureStatus;
  }

  Capture toCapture() {
    return Capture(
        messageID: messageID,
        email: email ?? "",
        filename: filename,
        fullFilePath: fullFilePath,
        captureDate: dateAndTime,
        captureType: captureSource,
        captureStatus: getCaptureStatus(),
        status: status,
        shared: shared,
        statusCode: statusCode,
        description: description);
  }

  CaptureUploadModel toCaptureUploadModel() {
    return CaptureUploadModel(
        messageID: messageID,
        captureType: captureSource,
        timestamp: timestamp,
        filename: filename,
        fullFilePath: fullFilePath,
        email: email ?? "",
        bitrate: bitrate,
        vcard: vcard,
        ocr: ocr,
        location: location,
        shared: shared);
  }
}

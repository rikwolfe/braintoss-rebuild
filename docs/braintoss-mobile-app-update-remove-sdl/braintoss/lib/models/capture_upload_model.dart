import 'capture_entity.dart';
import 'capture_type.dart';

class CaptureUploadModel {
  CaptureUploadModel({
    required this.messageID,
    required this.captureType,
    required this.timestamp,
    required this.filename,
    required this.fullFilePath,
    required this.email,
    this.bitrate,
    this.vcard = false,
    this.ocr = false,
    this.shared = false,
    this.location,
    this.watchOsVersion,
  });
  String messageID;
  CaptureType captureType;
  String timestamp;
  String filename;
  String fullFilePath;
  String email;
  String? bitrate;
  bool vcard;
  bool ocr;
  bool shared;
  String? location;
  String? watchOsVersion;

  CaptureEntity toCaptureEntity() {
    return CaptureEntity(
        messageID: messageID,
        captureSource: captureType,
        timestamp: timestamp,
        filename: filename,
        fullFilePath: fullFilePath,
        status: "",
        email: email,
        bitrate: bitrate,
        vcard: vcard,
        ocr: ocr,
        location: location,
        shared: shared);
  }
}

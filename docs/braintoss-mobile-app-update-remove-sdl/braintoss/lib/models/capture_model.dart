import 'capture_type.dart';

enum CaptureStatus { sent, queue, fail }

//this will be changed
class Capture {
  final String messageID;
  final String email;
  final String filename;
  final String fullFilePath;
  final DateTime captureDate;
  final CaptureType captureType;
  final CaptureStatus captureStatus;
  final bool shared;
  final int? statusCode;
  final String? description;
  final String status;

  Capture(
      {required this.messageID,
      required this.email,
      required this.filename,
      required this.fullFilePath,
      required this.captureDate,
      required this.captureType,
      required this.captureStatus,
      required this.shared,
      required this.status,
      this.statusCode,
      this.description});
}

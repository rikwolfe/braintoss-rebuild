class RequestDetails {
  RequestDetails(
      {required this.builtString,
      required this.appVersion,
      this.deviceName,
      required this.emailAddress,
      required this.isoLanguageCode,
      required this.messageID,
      required this.osName,
      required this.osVersion,
      required this.userID,
      this.location,
      this.bitrate});

  final String builtString;
  final String emailAddress;
  final String userID;
  final String isoLanguageCode;
  final String appVersion;
  final String? deviceName;
  final String messageID;
  final String osName;
  final String osVersion;
  final String? location;
  final String? bitrate;
}

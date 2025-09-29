enum ResponseStatusType {
  messageQueued,
  deliveryFailed,
  mailboxFull,
  userNotFound,
  messageTooBig,
  couldNotProcess,
  messageMarkedAsSpam,
  messageSentToDebug,
  blacklisted,
  couldNotTranscribe,
  messageDelivered,
  duplicateMessage,
  messageNotFound,
  unsupported,
  endProcess,
  noConnection,
  postReceived,
  missingOrInvalidKey,
  emailNotSet,
  uploadFailed,
  bitRateNotSet,
  invalidEmailAddress,
  mailFailed,
  userIdNotFound,
  userIdNotParsed,
  acceptedFormatNotParsed,
}

extension ResponseStatusTypeExtension on ResponseStatusType {
  int get statusCode {
    switch (this) {
      case ResponseStatusType.messageQueued:
        return 110;
      case ResponseStatusType.deliveryFailed:
        return 111;
      case ResponseStatusType.mailboxFull:
        return 112;
      case ResponseStatusType.userNotFound:
        return 113;
      case ResponseStatusType.messageTooBig:
        return 114;
      case ResponseStatusType.couldNotProcess:
        return 115;
      case ResponseStatusType.messageMarkedAsSpam:
        return 116;
      case ResponseStatusType.messageSentToDebug:
        return 117;
      case ResponseStatusType.blacklisted:
        return 118;
      case ResponseStatusType.couldNotTranscribe:
        return 119;
      case ResponseStatusType.messageDelivered:
        return 120;
      case ResponseStatusType.duplicateMessage:
        return 121;
      case ResponseStatusType.messageNotFound:
        return 122;
      case ResponseStatusType.unsupported:
        return 130;
      case ResponseStatusType.endProcess:
        return 200;
      case ResponseStatusType.noConnection:
        return 300;
      case ResponseStatusType.postReceived:
        return 100;
      case ResponseStatusType.missingOrInvalidKey:
        return 101;
      case ResponseStatusType.emailNotSet:
        return 102;
      case ResponseStatusType.uploadFailed:
        return 104;
      case ResponseStatusType.bitRateNotSet:
        return 105;
      case ResponseStatusType.invalidEmailAddress:
        return 106;
      case ResponseStatusType.mailFailed:
        return 103;
      case ResponseStatusType.userIdNotFound:
        return 107;
      case ResponseStatusType.userIdNotParsed:
        return 108;
      case ResponseStatusType.acceptedFormatNotParsed:
        return 109;
    }
  }
}

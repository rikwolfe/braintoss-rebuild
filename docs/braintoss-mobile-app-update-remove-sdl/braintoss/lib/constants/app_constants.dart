import 'package:braintoss/models/request_response_type.dart';
import 'package:braintoss/models/shared_preferences_quickstart.dart';
import '../models/request_response.dart';

const apiKey = "PFGBNakkoyJ7Ry9N3E3xgnCYbLPxFK8K";

const Map<int, RequestResponse> responseStatusCodes = {
  100: RequestResponse(type: ResponseStatusType.postReceived, resolved: false),
  101: RequestResponse(
      type: ResponseStatusType.missingOrInvalidKey, error: true),
  102: RequestResponse(type: ResponseStatusType.emailNotSet, error: true),
  103: RequestResponse(type: ResponseStatusType.mailFailed, error: true),
  104: RequestResponse(type: ResponseStatusType.uploadFailed, error: true),
  105: RequestResponse(type: ResponseStatusType.bitRateNotSet, error: true),
  106: RequestResponse(
      type: ResponseStatusType.invalidEmailAddress, error: true),
  107: RequestResponse(type: ResponseStatusType.userIdNotFound, error: true),
  108: RequestResponse(type: ResponseStatusType.userIdNotParsed, error: true),
  109: RequestResponse(
      type: ResponseStatusType.acceptedFormatNotParsed, error: true),
  110: RequestResponse(type: ResponseStatusType.messageQueued, resolved: false),
  111: RequestResponse(type: ResponseStatusType.deliveryFailed, error: true),
  112: RequestResponse(type: ResponseStatusType.mailboxFull, error: true),
  113: RequestResponse(type: ResponseStatusType.userNotFound, error: true),
  114: RequestResponse(type: ResponseStatusType.messageTooBig, error: true),
  115: RequestResponse(type: ResponseStatusType.couldNotProcess, error: true),
  116: RequestResponse(
      type: ResponseStatusType.messageMarkedAsSpam, error: true),
  117: RequestResponse(
      type: ResponseStatusType.messageSentToDebug, resolved: false, sent: true),
  118: RequestResponse(type: ResponseStatusType.blacklisted, error: true),
  119:
      RequestResponse(type: ResponseStatusType.couldNotTranscribe, error: true),
  120: RequestResponse(
      type: ResponseStatusType.messageDelivered, resolved: false, sent: true),
  121: RequestResponse(
      type: ResponseStatusType.duplicateMessage, error: true, resolved: false),
  122: RequestResponse(
      type: ResponseStatusType.messageNotFound, resolved: false),
  130: RequestResponse(type: ResponseStatusType.unsupported, error: true),
  200: RequestResponse(type: ResponseStatusType.endProcess, sent: true),
  300: RequestResponse(type: ResponseStatusType.noConnection, resolved: false),
};

const String okResponseStatus = "OK";

const String welcomeMailContent =
    "Hello from Braintoss! \n \nIf this e-mail ended up in your Junk or Spam folder, please choose 'Remove from' or 'Mark as NOT' from the options (often found through right clicking on the e-mail) to stop Braintoss mails going to your junk folder from now. \n \nHappy Braintossing :)";

class SharedPreferencesConstants {
  static const String isOnboardingDone = 'isOnboardingDone';
  static const String email = 'email';
  static const String emailList = 'emailList';
  static const String sound = 'Sound';
  static const String vibration = 'Vibration';
  static const String proximity = 'Proximity';
  static const String speechToTextLanguage = 'speechToTextLanguage';
  static const String languageCode = 'languageCode';
  static const String userId = 'userId';
  static SharedPreferencesQuickstart quickstart =
      const SharedPreferencesQuickstart();
  static const String theme = 'theme';
  static const String fileDirectoryPath = 'fileDirectoryPath';
}

class ButtonImages {
  static const send = "assets/images/Photo_Note_Send_Button.png";
  static const plus = "assets/images/General_Plus_Icon.png";
  static const closePopup = "assets/images/General_Plus_Cancel_Icon.png";
  static const microphone = 'assets/images/Menu_microhone.png';
  static const photo = 'assets/images/Menu_Photo_Icon.png';
  static const note = 'assets/images/Menu_Note_Icon.png';
  static const clear = 'assets/images/General_Clear_Icon.png';
  static const paste = 'assets/images/General_Paste_Icon.png';
  static const back = 'assets/images/Settings_Back_Icon.png';
  static const closeScreen = 'assets/images/General_Cancel_Icon.png';
  static const album = 'assets/images/Photo_Album_Icon.png';
  static const flipCamera = 'assets/images/Photo_Camera_Flip_Icon.png';
  static const flashAuto = 'assets/images/Photo_Flash_Icon_Auto.png';
  static const flashOff = 'assets/images/Photo_Flash_Icon_Off.png';
  static const flashOn = 'assets/images/Photo_Flash_Icon_On.png';
  static const scan = 'assets/images/Photo_Scan_Icon.png';
  static const vCard = 'assets/images/Photo_Vcard_Icon.png';
  static const voiceSend = 'assets/images/Voice_Send_Button.png';
  static const checkIcon = 'assets/images/History_Check_Icon.png';
  static const failedIcon = 'assets/images/History_Failed_Icon.png';
  static const trashCan = 'assets/images/History_Trash_Can.png';
}

class ThemeNames {
  static const system = "system";
  static const light = "light";
  static const dark = "dark";
}

class MiscImages {
  static const success = "assets/images/Photo_Note_Check_Icon.png";
  static const microphone = "assets/images/Voice_Microphone_Icon.png";
}

class HistoryIcons {
  static const check = 'assets/images/History_Check_Icon.png';
  static const failed = 'assets/images/History_Failed_Icon.png';
  static const queued = 'assets/images/History_Queued_Icon.png';
  static const shared = 'assets/images/History_Shared_Icon.png';
  static const sharedOverlay = 'assets/images/History_Share_Overlay.png';
  static const sharedDarkOverlay =
      'assets/images/History_Share_Dark_Overlay.png';
  static const camera = 'assets/images/History_Camera_Icon.png';
  static const note = 'assets/images/History_Note_Icon.png';
  static const microphone = 'assets/images/History_Microphone_Icon.png';
  static const watch = 'assets/images/History_Apple_Watch.png';
  static const play = 'assets/images/History_Play_Icon.png';
  static const trashCan = 'assets/images/History_Trash_Can_Icon.png';
  static const pause = 'assets/images/History_Pause_Icon.png';
}

const methodChannelName = "AppChannel";

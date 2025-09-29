import 'package:braintoss/inject/injectservices_extension.dart';
import 'package:braintoss/services/interfaces/logger_service.dart';
import 'package:braintoss/services/interfaces/status_updater_service.dart';
import 'package:braintoss/stores/history_note_store.dart';
import 'package:braintoss/stores/image_store.dart';
import 'package:braintoss/stores/theme_page_store.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:braintoss/services/interfaces/language_service.dart';
import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:braintoss/services/interfaces/capture_service.dart';
import 'package:braintoss/services/interfaces/user_information_service.dart';
import 'package:braintoss/services/interfaces/content_service.dart';
import 'package:braintoss/services/interfaces/location_service.dart';
import 'package:braintoss/services/interfaces/shared_preferences_service.dart';
import 'package:braintoss/services/interfaces/share_service.dart';
import 'package:braintoss/services/interfaces/quickstart_service.dart';
import 'package:braintoss/services/interfaces/permission_handler_service.dart';
import 'package:braintoss/services/interfaces/capture_data_manager.dart';
import 'package:braintoss/services/interfaces/theme_service.dart';
import 'package:braintoss/stores/about_store.dart';
import 'package:braintoss/stores/capture_store.dart';
import 'package:braintoss/stores/base_store.dart';
import 'package:braintoss/stores/default_language_store.dart';
import 'package:braintoss/stores/history_store.dart';
import 'package:braintoss/stores/home_store.dart';
import 'package:braintoss/stores/quickstart_store.dart';
import 'package:braintoss/stores/settings_store.dart';
import 'package:braintoss/stores/tutorial_store.dart';
import 'package:braintoss/stores/note_store.dart';
import 'package:braintoss/stores/photo_store.dart';
import 'package:braintoss/stores/voice_store.dart';
import 'package:braintoss/stores/history_voice_preview_store.dart';

import '../stores/history_photo_store.dart';

export 'modulecontainer.dart';

extension InjectStoresExtension on ModuleContainer {
  Injector registerStores(Injector injector) {
    injector.map<AboutStore>((_) => AboutStore(
          navigationService: getService<NavigationService>(),
          contentService: getService<ContentService>(),
        ));
    injector.map<HomeStore>((_) => HomeStore(
          navigationService: getService<NavigationService>(),
          quickstartService: getService<QuickstartService>(),
          captureDataManager: getService<CaptureDataManager>(),
        ));
    injector.map<HistoryStore>((_) => HistoryStore(
          getService<NavigationService>(),
          getService<CaptureDataManager>(),
          getService<StatusUpdaterService>(),
          getService<CaptureService>(),
          getService<QuickstartService>(),
        ));
    injector.map<QuickstartStore>((_) => QuickstartStore(
          navigationService: getService<NavigationService>(),
          quickstartService: getService<QuickstartService>(),
          sharedPreferencesService: getService<SharedPreferencesService>(),
        ));
    injector.map<SettingsStore>((_) => SettingsStore(
          navigationService: getService<NavigationService>(),
          sharedPreferencesService: getService<SharedPreferencesService>(),
          shareService: getService<ShareService>(),
          userInformationService: getService<UserInformationService>(),
          quickstartService: getService<QuickstartService>(),
        ));
    injector.map<TutorialStore>((_) => TutorialStore(
          navigationService: getService<NavigationService>(),
          sharedPreferencesService: getService<SharedPreferencesService>(),
          locationService: getService<LocationService>(),
          languageService: getService<LanguageService>(),
          captureService: getService<CaptureService>(),
          userInformationService: getService<UserInformationService>(),
        ));
    injector.map<DefaultLanguageStore>((_) => DefaultLanguageStore(
          sharedPreferencesService: getService<SharedPreferencesService>(),
          navigationService: getService<NavigationService>(),
          languageService: getService<LanguageService>(),
        ));
    injector.map<VoiceStore>((_) => VoiceStore(
          navigationService: getService<NavigationService>(),
          userInformationService: getService<UserInformationService>(),
          quickstartService: getService<QuickstartService>(),
          captureService: getService<CaptureService>(),
          permissionHandlerService: getService<PermissionHandlerService>(),
          sharedPreferencesService: getService<SharedPreferencesService>(),
        ));
    injector.map<PhotoStore>((_) => PhotoStore(
          navigationService: getService<NavigationService>(),
          userInformationService: getService<UserInformationService>(),
          captureService: getService<CaptureService>(),
          quickstartService: getService<QuickstartService>(),
        ));
    injector.map<NoteStore>((_) => NoteStore(
          navigationService: getService<NavigationService>(),
          userInformationService: getService<UserInformationService>(),
          captureService: getService<CaptureService>(),
          quickstartService: getService<QuickstartService>(),
          loggerService: getService<LoggerService>(),
        ));
    injector.map<CaptureStore>((_) => CaptureStore(
          navigationService: getService<NavigationService>(),
        ));
    injector.map<ImageStore>((_) => ImageStore(
          getService<UserInformationService>(),
          getService<CaptureService>(),
          quickstartService: getService<QuickstartService>(),
          navigationService: getService<NavigationService>(),
          loggerService: getService<LoggerService>(),
        ));
    injector.map<HistoryNoteStore>((_) => HistoryNoteStore(
          captureDataManager: getService<CaptureDataManager>(),
          navigationService: getService<NavigationService>(),
          captureService: getService<CaptureService>(),
          userInformationService: getService<UserInformationService>(),
          loggerService: getService<LoggerService>(),
        ));
    injector.map<ThemePageStore>((_) => ThemePageStore(
          navigationService: getService<NavigationService>(),
          themeService: getService<ThemeService>(),
        ));
    injector.map<HistoryVoicePreviewStore>((_) => HistoryVoicePreviewStore(
          navigationService: getService<NavigationService>(),
          userInformationService: getService<UserInformationService>(),
          captureService: getService<CaptureService>(),
          captureDataManager: getService<CaptureDataManager>(),
          loggerService: getService<LoggerService>(),
        ));
    injector.map<HistoryPhotoStore>((_) => HistoryPhotoStore(
          captureDataManager: getService<CaptureDataManager>(),
          navigationService: getService<NavigationService>(),
          captureService: getService<CaptureService>(),
          userInformationService: getService<UserInformationService>(),
          loggerService: getService<LoggerService>(),
        ));
    return injector;
  }

  S getStore<S extends BaseStore>() => Injector().get<S>();
}

import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/pages/history_note_page.dart';
import 'package:braintoss/pages/history_photo_page.dart';
import 'package:braintoss/pages/history_voice_preview.dart';
import 'package:braintoss/pages/image_page.dart';
import 'package:braintoss/pages/navigator_page.dart';
import 'package:braintoss/pages/theme_page.dart';
import 'package:braintoss/pages/tutorial_done_page.dart';
import 'package:seafarer/seafarer.dart';
import 'package:braintoss/services/impl/shared_preferences_service_impl.dart';
import 'package:braintoss/pages/tutorial_page.dart';
import 'package:braintoss/pages/about_page.dart';
import 'package:braintoss/pages/capture_page.dart';
import 'package:braintoss/pages/default_language_page.dart';
import 'package:braintoss/pages/history_page.dart';
import 'package:braintoss/pages/home_page.dart';
import 'package:braintoss/pages/quickstart_page.dart';
import 'package:braintoss/pages/settings_page.dart';

abstract class BaseStoreArguments extends BaseArguments {
  Map<String, dynamic>? asMap() {
    return null;
  }
}

class Routes {
  static final seafarer = Seafarer();

  static const String home = 'home';
  static final SeafarerRoute _homeRoute = SeafarerRoute(
      defaultTransitionDuration: Duration.zero,
      name: home,
      builder: (context, args, params) {
        return const HomePage();
      });

  static const String tutorial = 'tutorial';
  static final SeafarerRoute _tutorialRoute = SeafarerRoute(
      name: tutorial,
      builder: (context, args, params) {
        return const TutorialPage();
      });

  static const String settings = 'settings';
  static final SeafarerRoute _settingsRoute = SeafarerRoute(
      name: settings,
      builder: (context, args, params) {
        return SettingsPage();
      });

  static const String history = 'history';
  static final SeafarerRoute _historyRoute = SeafarerRoute(
    name: history,
    builder: (context, args, params) {
      return const HistoryPage();
    },
  );

  static const String historyNote = 'historyNote';
  static final SeafarerRoute _historyNoteRoute = SeafarerRoute(
    name: historyNote,
    builder: (context, args, params) {
      return const HistoryNotePage();
    },
  );

  static const String historyVoicePreview = 'historyVoicePreview';
  static final SeafarerRoute _historyVoiceRoute = SeafarerRoute(
    name: historyVoicePreview,
    builder: (context, args, params) {
      return const HistoryVoicePreviewPage();
    },
  );

  static const String historyPhotoPreview = 'historyPhotoPreview';
  static final SeafarerRoute _historyPhotoRoute = SeafarerRoute(
    name: historyPhotoPreview,
    builder: (context, args, params) {
      return const HistoryPhotoPage();
    },
  );

  static const String about = 'about';
  static final SeafarerRoute _aboutRoute = SeafarerRoute(
      name: about,
      builder: (context, args, params) {
        return AboutPage();
      });

  static const String quickstart = 'quickstart';
  static final SeafarerRoute _quickstartRoute = SeafarerRoute(
      name: quickstart,
      builder: (context, args, params) {
        return const QuickstartPage();
      });

  static const String defaultLanguage = 'defaultLanguage';
  static final SeafarerRoute _defaultLanguageRoute = SeafarerRoute(
      name: defaultLanguage,
      builder: (context, args, params) {
        return const DefaultLanguagePage();
      });

  static const String voice = 'voice';
  static final SeafarerRoute _voiceRoute = SeafarerRoute(
      name: voice,
      builder: (context, args, params) {
        return CapturePage();
      },
      defaultArgs: CapturePageArgs(CaptureMode.voice));

  static const String note = 'note';
  static final SeafarerRoute _noteRoute = SeafarerRoute(
      name: note,
      builder: (context, args, params) {
        return CapturePage();
      },
      defaultArgs: CapturePageArgs(CaptureMode.note));

  static const String photo = 'photo';
  static final SeafarerRoute _photoRoute = SeafarerRoute(
      name: photo,
      builder: (context, args, params) {
        return CapturePage();
      },
      defaultArgs: CapturePageArgs(CaptureMode.photo));

  static const String image = 'image';
  static final SeafarerRoute _imageRoute = SeafarerRoute(
    name: image,
    builder: (context, args, params) {
      return ImagePage();
    },
  );

  static const String theme = 'theme';
  static final SeafarerRoute _themeRoute = SeafarerRoute(
      name: theme,
      builder: (context, args, params) {
        return const ThemePage();
      });

  static const String tutorialDone = 'tutorialDone';
  static final SeafarerRoute _tutorialDoneRoute = SeafarerRoute(
    name: tutorialDone,
    builder: (context, args, params) {
      return const TutorialDonePage();
    },
  );

  static const String navigator = 'navigator';
  static final SeafarerRoute _navigatorRoute = SeafarerRoute(
    name: navigator,
    builder: (context, args, params) {
      return const NavigatorPage();
    },
  );

  static void createRoutes() {
    seafarer.addRoutes(
      [
        _homeRoute,
        _tutorialRoute,
        _settingsRoute,
        _historyRoute,
        _historyNoteRoute,
        _historyPhotoRoute,
        _historyVoiceRoute,
        _aboutRoute,
        _quickstartRoute,
        _defaultLanguageRoute,
        _voiceRoute,
        _photoRoute,
        _noteRoute,
        _imageRoute,
        _themeRoute,
        _tutorialDoneRoute,
        _navigatorRoute
      ],
    );
  }

  static Future<String> getInitialRoute() async {
    SharedPreferencesServiceImpl sharedPreferences =
        SharedPreferencesServiceImpl();
    bool isOnboardingDone =
        sharedPreferences.getBool(SharedPreferencesConstants.isOnboardingDone);
    String initialRoute = isOnboardingDone ? Routes.navigator : Routes.tutorial;

    return initialRoute;
  }
}

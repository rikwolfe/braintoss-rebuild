import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/models/capture_entity.dart';
import 'package:braintoss/config/theme.dart';
import 'package:braintoss/services/interfaces/capture_data_manager.dart';
import 'package:braintoss/services/interfaces/quickstart_service.dart';
import 'package:braintoss/services/interfaces/theme_service.dart';
import 'package:braintoss/stores/theme_store.dart';
import 'package:braintoss/utils/functions/method_call_handlers.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'package:braintoss/localization/l10n.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:braintoss/inject/injectservices_extension.dart';
import 'package:braintoss/inject/injectstores_extensions.dart';

import 'package:braintoss/routes.dart';

import 'package:braintoss/services/impl/shared_preferences_service_impl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'models/capture_type.dart';

String? initialRoute;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CaptureEntityAdapter());
  Hive.registerAdapter(CaptureTypeAdapter());
  await Hive.openBox<CaptureEntity>('captures');
  await startApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
}

Future<void> startApp() async {
  final injector = ModuleContainer.shared.registerServices(Injector());
  ModuleContainer.shared.registerStores(injector);
  Routes.createRoutes();
  await SharedPreferencesServiceImpl.init();
  initialRoute = await Routes.getInitialRoute();
  SharedPreferencesServiceImpl.localStorage.setString(
      SharedPreferencesConstants.fileDirectoryPath,
      (await getApplicationDocumentsDirectory()).path);

  methodChannel.setMethodCallHandler(methodCallHandler);
  sendUserInfoToWatch();

  final CaptureDataManager captureDataManager =
      ModuleContainer.shared.getService<CaptureDataManager>();
  captureDataManager.deleteLeftoverCaptures();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ThemeStore>(
          create: (_) => ThemeStore(
            ModuleContainer.shared.getService<ThemeService>(),
            ModuleContainer.shared.getService<QuickstartService>(),
          ),
        )
      ],
      child: Consumer<ThemeStore>(
        builder: (_, ThemeStore store, __) => Observer(
          builder: (ctx) => AnnotatedRegion(
            value: SystemUiOverlayStyle.dark,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Braintoss",
              theme: light,
              darkTheme: dark,
              themeMode: store.currentTheme,
              supportedLocales: L10n.all,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              initialRoute: initialRoute,
              onGenerateRoute: Routes.seafarer.generator(),
              navigatorKey: Routes.seafarer.navigatorKey,
            ),
          ),
        ),
      ),
    );
  }
}

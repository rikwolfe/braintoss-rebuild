import 'package:braintoss/connectors/http_connector.dart';
import 'package:braintoss/repositories/impl/hive_repository.dart';
import 'package:braintoss/repositories/interfaces/local_db_repository.dart';
import 'package:braintoss/services/impl/logger_service_impl.dart';
import 'package:braintoss/services/impl/content_service_impl.dart';
import 'package:braintoss/services/impl/capture_data_manager_impl.dart';
import 'package:braintoss/services/impl/language_service_impl.dart';
import 'package:braintoss/services/impl/location_service_impl.dart';
import 'package:braintoss/services/impl/navigation_service_impl.dart';
import 'package:braintoss/services/impl/permission_handler_service_impl.dart';
import 'package:braintoss/services/impl/quickstart_service_impl.dart';
import 'package:braintoss/services/impl/shared_preferences_service_impl.dart';
import 'package:braintoss/services/impl/request_building_service_impl.dart';
import 'package:braintoss/services/impl/share_service_impl.dart';
import 'package:braintoss/services/impl/sound_service_impl.dart';
import 'package:braintoss/services/impl/status_updater_service_impl.dart';
import 'package:braintoss/services/impl/theme_service_impl.dart';
import 'package:braintoss/services/impl/user_information_service_impl.dart';
import 'package:braintoss/services/impl/capture_service_impl.dart';
import 'package:braintoss/services/interfaces/logger_service.dart';
import 'package:braintoss/services/interfaces/content_service.dart';
import 'package:braintoss/services/interfaces/capture_data_manager.dart';
import 'package:braintoss/services/interfaces/language_service.dart';
import 'package:braintoss/services/interfaces/location_service.dart';
import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:braintoss/services/interfaces/capture_service.dart';
import 'package:braintoss/services/interfaces/permission_handler_service.dart';
import 'package:braintoss/services/interfaces/quickstart_service.dart';
import 'package:braintoss/services/interfaces/shared_preferences_service.dart';
import 'package:braintoss/services/interfaces/share_service.dart';
import 'package:braintoss/services/interfaces/status_updater_service.dart';
import 'package:braintoss/services/interfaces/theme_service.dart';
import 'package:braintoss/services/interfaces/user_information_service.dart';
import 'package:braintoss/services/interfaces/sound_service.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import '../services/interfaces/base_service.dart';
import '../services/interfaces/request_building_service.dart';
import 'modulecontainer.dart';
export 'modulecontainer.dart';

extension InjectServicesExtension on ModuleContainer {
  Injector registerServices(Injector injector) {
    injector.map<LocalDBRepository>(
      (_) => HiveRepository(),
      isSingleton: true,
    );
    injector.map<NavigationService>(
      (_) => NavigationServiceImpl(),
      isSingleton: true,
    );
    injector.map<HttpConnector>(
      (_) => HttpConnector(),
      isSingleton: true,
    );
    injector.map<SharedPreferencesService>(
        (i) => SharedPreferencesServiceImpl(),
        isSingleton: true);
    injector.map<UserInformationService>(
      (i) => UserInformationServiceImpl(
        i.get<SharedPreferencesService>(),
      ),
      isSingleton: true,
    );
    injector.map<RequestBuildingService>(
      (i) => RequestBuildingServiceImpl(
        i.get<UserInformationService>(),
        i.get<LocationService>(),
        i.get<LanguageService>(),
      ),
      isSingleton: true,
    );
    injector.map<CaptureDataManager>(
      (i) => CaptureDataManagerImpl(
        i.get<LocalDBRepository>(),
        i.get<LoggerService>(),
      ),
      isSingleton: true,
    );
    injector.map<CaptureService>(
      (i) => CaptureServiceImpl(
        i.get<HttpConnector>(),
        i.get<RequestBuildingService>(),
        i.get<SoundService>(),
        i.get<SharedPreferencesService>(),
        i.get<CaptureDataManager>(),
      ),
      isSingleton: true,
    );
    injector.map<ContentService>(
      (i) => ContentServiceImpl(
        i.get<HttpConnector>(),
        i.get<RequestBuildingService>(),
        i.get<LoggerService>(),
      ),
      isSingleton: true,
    );
    injector.map<LanguageService>(
      (i) => LanguageServiceImpl(
        i.get<HttpConnector>(),
        i.get<UserInformationService>(),
        i.get<SharedPreferencesService>(),
        i.get<LoggerService>(),
      ),
      isSingleton: true,
    );
    injector.map<LocationService>(
      (i) => LocationServiceImpl(i.get<LoggerService>()),
      isSingleton: true,
    );
    injector.map<ShareService>(
      (_) => ShareServiceImpl(),
      isSingleton: true,
    );
    injector.map<SoundService>((_) => SoundServiceImpl(), isSingleton: true);
    injector.map<LoggerService>((_) => LoggerServiceImpl(), isSingleton: true);
    injector.map<QuickstartService>(
        (i) => QuickstartServiceImpl(
              i.get<SharedPreferencesService>(),
              i.get<NavigationService>(),
            ),
        isSingleton: true);
    injector.map<ThemeService>(
      (i) => ThemeServiceImpl(
        i.get<SharedPreferencesService>(),
      ),
      isSingleton: true,
    );
    injector.map<PermissionHandlerService>(
      (i) => PermissionHandlerServiceImpl(),
      isSingleton: true,
    );
    injector.map<StatusUpdaterService>(
      (i) => StatusUpdaterServiceImpl(
        i.get<CaptureDataManager>(),
        i.get<HttpConnector>(),
        i.get<RequestBuildingService>(),
        i.get<LoggerService>(),
      ),
      isSingleton: true,
    );

    return injector;
  }

  T getService<T extends BaseService>() => Injector().get<T>();
}

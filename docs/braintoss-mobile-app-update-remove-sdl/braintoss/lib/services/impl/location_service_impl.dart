import 'package:braintoss/services/interfaces/logger_service.dart';
import 'package:geolocator/geolocator.dart';

import 'package:braintoss/services/impl/base_service_impl.dart';
import 'package:braintoss/services/interfaces/location_service.dart';

class LocationServiceImpl extends BaseServiceImpl implements LocationService {
  LocationServiceImpl(this._loggerService);
  final LoggerService _loggerService;

  @override
  Future<List<String>> getCurrentLocation() async {
    List<String> location = [];
    try {
      if (await isLocationPermissionAllowed() != true) return [];
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          forceAndroidLocationManager: true,
          timeLimit: const Duration(seconds: 2));
      location.add(position.latitude.toString());
      location.add(position.longitude.toString());
    } catch (e) {
      _loggerService.recordError(e.toString());
    }
    return location;
  }

  @override
  Future<bool> isLocationPermissionAllowed() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return true;
  }
}

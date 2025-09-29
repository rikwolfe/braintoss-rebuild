import 'package:braintoss/services/interfaces/base_service.dart';

abstract class LocationService extends BaseService {
  Future<bool> isLocationPermissionAllowed();
  Future<List<String>> getCurrentLocation();
}

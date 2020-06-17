import 'package:location/location.dart';

class LocationUtils {
  Location _location = Location();

  LocationUtils() {
    checkPerm();
    checkService();

    _location.changeSettings(accuracy: LocationAccuracy.high);
  }

  Future<LocationData> getPresentPos() async {
    return await _location.getLocation();
  }

  checkService() async {
    if (!await _location.serviceEnabled()) {
      _location.requestService();
    }
  }

  checkPerm() async {
    PermissionStatus hasPerm = await _location.hasPermission();
    if (hasPerm == null) {
      _location.requestPermission();
    }
  }
}

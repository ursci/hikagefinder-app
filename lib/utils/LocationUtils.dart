import 'dart:async';

import 'package:location/location.dart';

class LocationUtils {
  Location _location = Location();

  LocationUtils() {
    checkPermService();
    changeSettings(LocationAccuracy.high);
  }

  Future<bool> changeSettings(LocationAccuracy accuracy,
      {int timeInterval = 0, double distanceInterval = 0.0}) async {
    return await _location.changeSettings(
        accuracy: accuracy,
        interval: timeInterval,
        distanceFilter: distanceInterval);
  }

  Stream<LocationData> getLocationStream() {
    return _location.onLocationChanged;
  }

  Future<LocationData> getPresentPos() async {
    return await _location.getLocation();
  }

  checkPermService() async {
    PermissionStatus hasPerm = await _location.hasPermission();
    if (hasPerm == null) {
      _location.requestPermission();
    }

    if (!await _location.serviceEnabled()) {
      _location.requestService();
    }
  }
}

import 'dart:convert';

import 'package:geojson/geojson.dart';
import 'package:hikageapp/network/NetworkResult.dart';
import 'package:hikageapp/network/RestUtil.dart';
import 'package:hikageapp/res/RestParams.dart';
import 'package:latlong/latlong.dart';

class RouteUtils {
  GeoJson _recommendedGeoJson = GeoJson();
  GeoJson _shortestGeoJson = GeoJson();

  GeoJson get recommendedGeoJson => _recommendedGeoJson;
  GeoJson get shortestGeoJson => _shortestGeoJson;

  Future<bool> findRoute(LatLng startPos, LatLng stopPos,
      {DateTime dateParam}) async {
    String dateNow = DateTime.now().toIso8601String();

    if (dateParam != null) {
      dateNow = dateParam.toIso8601String();
    }

    Map<String, dynamic> mapDep = {
      "lat": startPos.latitude,
      "lon": startPos.longitude,
    };
    Map<String, dynamic> mapDest = {
      "lat": stopPos.latitude,
      "lon": stopPos.longitude,
    };

    Map<String, dynamic> dataReq = {
      "departure_time": dateNow,
      "arrival_time": dateNow,
      "departure_point": mapDep,
      "destination_point": mapDest,
    };

    JsonEncoder jsonEncoder = JsonEncoder();

    RestUtil restUtil = RestUtil();
    NetworkResult retVal = await restUtil.registerData(
        jsonEncoder.convert(dataReq), null, RestParams.baseUrl);

    if (retVal != null && retVal.response == "OK") {
      Map<String, dynamic> result = retVal.responseBody;
      GeoJson sGeoJson = GeoJson();
      GeoJson rGeoJson = GeoJson();

      await sGeoJson.parse(jsonEncoder.convert(result["shortest"]));
      await rGeoJson.parse(jsonEncoder.convert(result["recommended"]));

      if (sGeoJson.features.length == 0 && rGeoJson.features.length == 0) {
        /// No Features
        return false;
      }

      _shortestGeoJson = sGeoJson;
      _recommendedGeoJson = rGeoJson;

      return true;
    }

    return false;
  }
}

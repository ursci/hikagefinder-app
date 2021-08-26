import 'dart:convert';

import 'package:geojson_vi/geojson_vi.dart';
import 'package:hikageapp/network/NetworkResult.dart';
import 'package:hikageapp/network/RestUtil.dart';
import 'package:hikageapp/res/RestParams.dart';
import 'package:latlong/latlong.dart';

class RouteUtils {
  GeoJSONFeature _recommendedGeoJson;
  GeoJSONFeature _shortestGeoJson;
  int _errorCode = 1; // 1=Normal Error, 2=Service Time, 3=Service Area

  GeoJSONFeature get recommendedGeoJson => _recommendedGeoJson;
  GeoJSONFeature get shortestGeoJson => _shortestGeoJson;
  int get errorCode => _errorCode;

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

    Map<String, dynamic> result = retVal.responseBody;

    if (retVal != null && retVal.response == "OK") {
      GeoJSON sGeoJson = GeoJSON.fromMap(result["shortest"]);
      GeoJSON rGeoJson = GeoJSON.fromMap(result["recommended"]);

      if (sGeoJson == null && rGeoJson == null) {
        /// No Features
        return false;
      }

      if (rGeoJson is GeoJSONFeatureCollection) {
        List<GeoJSONFeature> features = rGeoJson.features;
        _recommendedGeoJson = features.first;
      }

      if (sGeoJson is GeoJSONFeatureCollection) {
        List<GeoJSONFeature> features = sGeoJson.features;
        _shortestGeoJson = features.first;
      }

      return true;
    }

    String errorStr = result["detail"].toString().toUpperCase();
    //result["detail"][0]["msg"].toString().toUpperCase();

    if (errorStr.contains("SERVICE TIME")) {
      _errorCode = 2;
    } else if (errorStr.contains("SERVICE AREA")) {
      _errorCode = 3;
    }

    return false;
  }
}

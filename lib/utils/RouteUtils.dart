import 'dart:convert';

import 'package:hikageapp/network/NetworkResult.dart';
import 'package:hikageapp/network/RestUtil.dart';
import 'package:hikageapp/res/RestParams.dart';
import 'package:latlong/latlong.dart';

class RouteUtils {
  static Future<Map<String, dynamic>> findRoute(LatLng startPos, LatLng stopPos,
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

    if (retVal != null && retVal.response != "200") {
      return retVal.responseBody;
    }

    return null;
  }
}

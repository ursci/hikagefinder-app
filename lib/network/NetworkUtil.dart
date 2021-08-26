import "dart:async";
import "dart:convert";

import 'package:flutter/cupertino.dart';
import "package:http/http.dart" as http;

class NetworkUtil {
  /// Making this Class a Singleton
  ///
  static NetworkUtil _instance = NetworkUtil.internal();
  NetworkUtil.internal();

  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url, {Map<String, dynamic> headers}) {
    debugPrint("Get URL: $url, Header: ${headers.toString()}");

    Uri uri = Uri.parse(url);

    return http.get(uri, headers: headers).then(
      (http.Response response) {
        final String res = response.body;
        final int statusCode = response.statusCode;

        Map<String, dynamic> retVal;

        //debugPrint("GET Status Code: $statusCode, GET Message: $res");

        if (statusCode < 200 || statusCode > 450 || json == null) {
          //throw Exception("Error: fetching data");
          retVal = {"status": statusCode, "message": null};
          return (retVal);
        }

        try {
          dynamic json = _decoder.convert(res);
          retVal = {"status": statusCode, "message": json};
        } catch (Exception) {
          print(Exception.toString());
          retVal = {"status": statusCode, "message": null};
        }

        return retVal;
      },
    );
  }

  Future<dynamic> delete(String url, {Map<String, dynamic> headers}) {
    Uri uri = Uri.parse(url);

    return http.delete(uri, headers: headers).then((http.Response response) {
      debugPrint("Delete URL: $url, Response: ${response.body}");

      final String res = response.body;
      final int statusCode = response.statusCode;

      Map<String, dynamic> retVal;

      if (statusCode < 200 || statusCode > 450 || json == null) {
        retVal = {"status": statusCode, "message": null};
        return (retVal);
        //throw Exception("Error: fetching data");
      }

      try {
        dynamic json = _decoder.convert(res);
        retVal = {"status": statusCode, "message": json};
      } catch (Exception) {
        print(Exception.toString());
        retVal = {"status": statusCode, "message": null};
      }

      return retVal;
    });
  }

  Future<dynamic> patch(String url,
      {Map<String, dynamic> headers, body, encoding}) {
    debugPrint("Patch URL: $url, Header: ${headers.toString()}, "
        "body : ${body.toString()}");

    Uri uri = Uri.parse(url);

    return http
        .patch(uri, body: body.toString(), headers: headers, encoding: encoding)
        .then((http.Response response) {
      debugPrint("Patch URL: $url, Response: ${response.body}");

      final String res = response.body;
      final int statusCode = response.statusCode;

      Map<String, dynamic> retVal;

      if (statusCode < 200 || statusCode > 450 || json == null) {
        retVal = {"status": statusCode, "message": null};
        return (retVal);
        //throw Exception("Error: fetching data");
      }

      try {
        dynamic json = _decoder.convert(res);
        retVal = {"status": statusCode, "message": json};
      } catch (Exception) {
        print(Exception.toString());
        retVal = {"status": statusCode, "message": null};
      }

      return retVal;
    });
  }

  Future<dynamic> post(String url,
      {Map<String, dynamic> headers, body, encoding}) {
    Uri uri = Uri.parse(url);

    return http
        .post(uri, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      Map<String, dynamic> retVal;

      if (statusCode < 200 || statusCode > 450 || json == null) {
        retVal = {"status": statusCode, "message": null};
        return (retVal);
        //throw Exception("Error: fetching data");
      }

      try {
        dynamic json = _decoder.convert(res);
        retVal = {"status": statusCode, "message": json};
      } catch (Exception) {
        print(Exception.toString());
        retVal = {"status": statusCode, "message": null};
      }

      return retVal;
    });
  }

  Future<bool> isInternetConnected() async {
    /*
    bool retVal = false;

    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        retVal = true;
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }

    return retVal;
     */
    return true;
  }
}

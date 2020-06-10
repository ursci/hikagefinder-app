import "dart:async";
import "dart:convert";
import 'dart:io';

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

    return http.get(url, headers: headers).then(
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
    return http.delete(url, headers: headers).then((http.Response response) {
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

    return http
        .patch(url, body: body.toString(), headers: headers, encoding: encoding)
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
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
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
  }
}

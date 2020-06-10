import 'package:flutter/cupertino.dart';

import "NetworkResult.dart";
import "NetworkUtil.dart";

class RestUtil {
  final NetworkUtil _netUtil = NetworkUtil();

  Future<NetworkResult> obtainData(String regServer,
      {Map<String, dynamic> headers = const {}}) async {
    NetworkResult nr = NetworkResult();

    if (!await _netUtil.isInternetConnected()) {
      nr.setInternetConnected(false);
      nr.setResponse("NG");
      return nr;
    }

    try {
      Map<String, dynamic> response;

      debugPrint("Header Passed: ${headers.toString()}");

      if (headers.isEmpty) {
        response = await _netUtil.get(regServer);
      } else {
        response = await _netUtil.get(regServer, headers: headers);
      }

      debugPrint("Status: ${response["status"]},"
          "Message:${response["message"]}");

      nr.setInternetConnected(true);

      if (response["status"] == 200 || response["status"] == 204) {
        nr.setResponse("OK");
      } else {
        nr.setResponse("NG");
      }

      nr.setResponseBody(response["message"]);
    } catch (exception) {
      debugPrint("GET Exception: ${exception.toString()}");
      nr.setInternetConnected(false);
      nr.setResponseText("Network Error");
      nr.setResponse("NG");
    }
    return nr;
  }

  Future<NetworkResult> removeData(String regServer,
      {Map<String, dynamic> headers = const {}}) async {
    NetworkResult nr = NetworkResult();

    if (!await _netUtil.isInternetConnected()) {
      nr.setInternetConnected(false);
      nr.setResponse("NG");
      return nr;
    }

    try {
      Map<String, dynamic> response;

      debugPrint("Header Passed: ${headers.toString()}");

      if (headers.isEmpty) {
        response = await _netUtil.delete(regServer);
      } else {
        response = await _netUtil.delete(regServer, headers: headers);
      }

      debugPrint("Status: ${response["status"]},"
          "Message:${response["message"]}");

      nr.setInternetConnected(true);

      if (response["status"] == 200 || response["status"] == 204) {
        nr.setResponse("OK");
      } else {
        nr.setResponse("NG");
      }

      nr.setResponseBody(response["message"]);
    } catch (exception) {
      debugPrint("GET Exception: ${exception.toString()}");
      nr.setInternetConnected(false);
      nr.setResponseText("Network Error");
      nr.setResponse("NG");
    }
    return nr;
  }

  Future<NetworkResult> modifyData(
      dynamic request, Map<String, dynamic> headers, String regServer) async {
    NetworkResult nr = NetworkResult();

    if (!await _netUtil.isInternetConnected()) {
      nr.setInternetConnected(false);
      nr.setResponse("NG");
      return nr;
    }

    try {
      debugPrint("Request Params: ${request.toString()}");

      dynamic response = await _netUtil.patch(
        regServer,
        body: request,
        headers: headers,
      );

      debugPrint("Server Response: ${response.toString()}");

      nr.setInternetConnected(true);

      if (/*response["status"] != 422 &&*/ response["status"] != 200) {
        nr.setResponse("NG");
        nr.setResponseText("${response["status"]}");
        nr.setResponseBody(response["message"]);
      } else {
        nr.setResponse("OK");
        nr.setResponseText("${response["status"]}");
        //nr.setResponseExtra(response["messages"].toString());
        nr.setResponseBody(response["message"]);
      }
    } catch (exception) {
      debugPrint("Exception: ${exception.toString()}");
      nr.setInternetConnected(false);
      nr.setResponseText("Network Error");
      nr.setResponse("NG");
    }

    return nr;
  }

  Future<NetworkResult> registerData(
      dynamic request, Map<String, dynamic> headers, String regServer) async {
    NetworkResult nr = NetworkResult();

    if (!await _netUtil.isInternetConnected()) {
      nr.setInternetConnected(false);
      nr.setResponse("NG");
      return nr;
    }

    try {
      //dynamic response = await _netUtil.post(regServer,
      //    body: request, headers: {'content-type': 'application/JSON'});

      debugPrint("Request Params: ${request.toString()}");

      dynamic response = await _netUtil.post(
        regServer,
        body: request,
        headers: headers,
      );

      debugPrint("Server Response: ${response.toString()}");

      nr.setInternetConnected(true);

      if (response["status"] != 200 && response["status"] != 202) {
        nr.setResponse("NG");
        nr.setResponseText("${response["status"]}");
        nr.setResponseBody(response["message"]);
      } else {
        nr.setResponse("OK");
        nr.setResponseText("${response["status"]}");
        //nr.setResponseExtra(response["messages"].toString());
        nr.setResponseBody(response["message"]);
      }
    } catch (exception) {
      debugPrint("Exception: ${exception.toString()}");
      nr.setInternetConnected(false);
      nr.setResponseText("Network Error");
      nr.setResponse("NG");
    }
    return nr;
  }
}

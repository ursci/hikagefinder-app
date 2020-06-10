class NetworkResult {
  bool _internetConnected = false;
  String _response;
  String _responseText;
  String _responseExtra;
  //List<Map<String, dynamic>> _responseBody;
  dynamic _responseBody;

  //NetworkResult(this._internetConnected, this._response, this._responseText,
  //    this._responseExtra);

  bool get internetConnected => _internetConnected;
  String get response => _response;
  String get responseText => _responseText;
  String get responseExtra => _responseExtra;
  //List<Map<String, dynamic>> get responseBody => _responseBody;
  dynamic get responseBody => _responseBody;

  void setInternetConnected(bool input) => _internetConnected = input;
  void setResponse(String input) => _response = input;
  void setResponseText(String input) => _responseText = input;
  void setResponseExtra(String input) => _responseExtra = input;
  //void setResponseBody(List<Map<String, dynamic>> input) =>
  //    _responseBody = input;
  void setResponseBody(dynamic input) => _responseBody = input;
}

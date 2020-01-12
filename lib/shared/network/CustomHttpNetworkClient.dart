import 'package:apogee_main/shared/UIMessageListener.dart';
import 'package:apogee_main/shared/network/NetworkClient.dart';
import 'package:apogee_main/shared/network/NetworkResponseHandler.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class CustomHttpNetworkClient implements NetworkClient {
  String baseUrl;
  Map<String, String> headers;
  UIMessageListener uiMessageListener;
  Client _networkClient;

  CustomHttpNetworkClient({
    Client client,
    @required this.baseUrl,
    this.headers,
    @required this.uiMessageListener
  }) : this._networkClient = client ?? Client();

  @override
  Future<Null> get(String url, Function(String) onSucess) async {
    url = url ?? "";
    Response response = await _networkClient.get("$baseUrl$url", headers: headers);
    NetworkResponseHandler.handleResponse(
      response: response,
      messageListener: uiMessageListener,
      onSuccess: onSucess
    );
  }

  @override
  Future<Null> post(String url, String body, Function(String) onSucess) async {
    url = url ?? "";
    Response response = await _networkClient.post("$baseUrl$url");
    print("Code = ${response.statusCode}");
    print("Response = ${response.body}");
    NetworkResponseHandler.handleResponse(
      response: response,
      messageListener: uiMessageListener,
      onSuccess: onSucess
    );
  }
}
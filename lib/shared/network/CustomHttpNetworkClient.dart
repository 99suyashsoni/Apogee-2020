import 'package:apogee_main/shared/network/NetworkClient.dart';
import 'package:apogee_main/shared/network/NetworkResponseHandler.dart';
import 'package:apogee_main/shared/network/errorState.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class CustomHttpNetworkClient implements NetworkClient {
  String baseUrl;
  Map<String, String> headers;
  Client _networkClient;

  CustomHttpNetworkClient({
    Client client,
    @required this.baseUrl,
    this.headers,
  }) : this._networkClient = client ?? Client();

  @override
  Future<ErrorState> get(String url, Function(String) onSucess) async {
    url = url ?? "";
    Response response = await _networkClient.get("$baseUrl$url", headers: headers);
    return NetworkResponseHandler.handleResponse(
      response: response,
      onSuccess: onSucess
    );
  }

  @override
  Future<ErrorState> post(String url, String body, Function(String) onSucess) async {
    url = url ?? "";
    Response response = await _networkClient.post("$baseUrl$url");
    print("Code = ${response.statusCode}");
    print("Response = ${response.body}");
    return NetworkResponseHandler.handleResponse(
      response: response,
      onSuccess: onSucess
    );
  }
}
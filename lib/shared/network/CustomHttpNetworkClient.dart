import 'dart:io';

import 'package:apogee_main/shared/network/NetworkClient.dart';
import 'package:apogee_main/shared/network/NetworkResponseHandler.dart';
import 'package:apogee_main/shared/network/errorState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class CustomHttpNetworkClient implements NetworkClient {
  String baseUrl;
  Client _networkClient;
  FlutterSecureStorage _secureStorage;

  CustomHttpNetworkClient({
    Client client,
    @required this.baseUrl,
    @required FlutterSecureStorage secureStorage
  }) : this._networkClient = client ?? Client(),
       this._secureStorage = secureStorage;

  @override
  Future<ErrorState> get(String url, Function(String) onSucess) async {
    url = url ?? "";
    print("try: inside get networkcliner url $url ");

    Response response = await _networkClient.get("$baseUrl$url", headers: {'Content-Type': 'application/json', HttpHeaders.authorizationHeader: await _secureStorage.read(key: 'JWT') ?? ""});
    print("try: get url $url Code = ${response.statusCode} Response = ${response.body}");

    return await NetworkResponseHandler.handleResponse(
      response: response,
      onSuccess: onSucess
    );
  }

  @override
  Future<ErrorState> post(String url, String body, Function(String) onSucess/*, [bool wantAuth = true]*/) async {
    url = url ?? "";
    print("try: inside post networkcliner url $url ");
    final headers = {'Content-Type': 'application/json'};
    //if(wantAuth){
      headers.addAll({HttpHeaders.authorizationHeader: await _secureStorage.read(key: 'JWT') ?? ""});
    //}
    Response response = await _networkClient.post("$baseUrl$url", headers: headers, body: body);
    print("try: post  url $url Code = ${response.statusCode} Response = ${response.body}");

    return await NetworkResponseHandler.handleResponse(
      response: response,
      onSuccess: onSucess
    );
  }
}
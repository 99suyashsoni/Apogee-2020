import 'dart:convert';

import 'package:apogee_main/shared/network/errorState.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class NetworkResponseHandler {
  static Future<ErrorState> handleResponse({@required Function(String) onSuccess, @required http.Response response}) async {
   print("try: inside handleresponse${response.statusCode}");
    if(response != null) {
      if(response.statusCode == 200 || response.statusCode == 201) {
        await onSuccess(response.body);
        return ErrorState(
          state: 0,
          message: "200: Success"
        );
      } else if(response.statusCode==500) {
        return ErrorState(
            state: 2,
            message: "${response.statusCode}: Error Ocurred!!! Contact DVM official"
        );
          // TODO discuss with backend and sort error handling
      }
      else{
        return ErrorState(
          state: 2,
          message: "${response.statusCode}: "+ getDisplayMessage(response.body.toString()) ,
          );
      }
    } else {
      return ErrorState(
        state: 1,
        message: "Unable to contact our servers. Please try later",
        actions: [FlatButton(
          child: Text("Ok"),
          onPressed: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
        )]
      );
    }
  }

}
String getDisplayMessage(String errorBody){
 var jsonResponse =jsonDecode(errorBody);
 if(jsonResponse.containsKey('display_message')){
    return jsonResponse['display'];
 }
 else if(jsonResponse.containsKey('detail')){
    return jsonResponse['detail'];
 }
 else
    return 'Something went wrong!!!';

}
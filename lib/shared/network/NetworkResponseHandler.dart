import 'package:apogee_main/shared/UIMessageListener.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class NetworkResponseHandler {
  static void handleResponse({@required Function(String) onSuccess, @required http.Response response, @required UIMessageListener messageListener}) {
    if(response != null) {
      if(response.statusCode == 200 || response.statusCode == 201) {
        onSuccess(response.body);
      } else {
        if(messageListener != null) {
          // TODO discuss with backend and sort error handling
        } else {
          // Do Nothing as nothing appropriate can be done
        }
      }
    } else {
      messageListener.onAlertMessageRecived(
        message: "Unknown Error occoured. Please Restart your app",
        actions: [
          FlatButton(
            child: Text("Ok"),
            onPressed: () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
          )
        ]
      );
    }
  }
}
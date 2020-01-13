import 'package:flutter/cupertino.dart';

abstract class UIMessageListener {
  void onToastMessageRecived({@required String message});

  void onAuthenticationExpiered();

  void onSnackbarMessageRecived({@required String message});

  void onAlertMessageRecived({@required String message, String title = "Alert", List<Widget> actions});
}
import 'package:flutter/cupertino.dart';

class ErrorState {
  int state;
  String message;
  List<Widget> actions;

  ErrorState({

    @required
    this.state,

    @required
    this.message,

    this.actions
});
}
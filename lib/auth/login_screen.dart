import 'package:apogee_main/auth/data/auth_repository.dart';
import 'package:apogee_main/shared/UIMessageListener.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:apogee_main/wallet/view/CartScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Screen(
      title: "Login",
      child: _Login(),
      selectedTabIndex: -1,
    );
  }
}

class _Login extends StatefulWidget{

  const _Login({
    Key key,
}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<_Login> implements UIMessageListener{

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if(_isLoading) {
      return Center(child: CircularProgressIndicator(),);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Spacer(),
        RaisedButton(
          child: Text("Login"),
          onPressed: () async {
            final repo = Provider.of<AuthRepository>(context);
            setState(() {
              _isLoading = true;
            });
            await repo.loginOutstee("outguy", "outoutout", "");
            await repo.isLoggedIn.then((loginCheck) {
              _isLoading = false;
              if(loginCheck){
                Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ));
              }
              else{
                //to be decided
              }
            }).catchError((error) {
              //to be decided
            });
          },
        )
      ],
    );
  }

  @override
  void onAlertMessageRecived({String message, String title = "Alert", List<Widget> actions}) {
    // TODO: implement onAlertMessageRecived
  }

  @override
  void onAuthenticationExpiered() {
    // TODO: implement onAuthenticationExpiered
  }

  @override
  void onSnackbarMessageRecived({String message}) {
    // TODO: implement onSnackbarMessageRecived
  }

  @override
  void onToastMessageRecived({String message}) {
    // TODO: implement onToastMessageRecived
  }

}
import 'package:apogee_main/auth/data/auth_repository.dart';
import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Screen(
      title: "Login",
      child: _Login(),
      selectedTabIndex: -1,
      endColor: topLevelScreensGradientEndColor,
      screenBackground: orderScreenBackground,
      startColor: topLevelScreensGradientStartColor,
    );
  }
}

class _Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<_Login> {

  bool _isLoading = false;
  String _username;
  String _password;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Spacer(),
        TextField(
          onChanged: (user) {
            setState(() {
              _username = user;
            });
          },
        ),
        SizedBox(
          height: 20.0,
        ),
        TextField(
          onChanged: (pass) {
            setState(() {
              _password = pass;
            });
          },
        ),
        SizedBox(
          height: 20.0,
        ),
        RaisedButton(
          child: Text("Login"),
          onPressed: () async {
            final repo = Provider.of<AuthRepository>(context);
            setState(() {
              _isLoading = true;
            });
            await repo.loginOutstee(_username, _password, "");
            repo.isLoggedIn.then((loginCheck) {
              setState(() {
                _isLoading = false;
              });
              if (loginCheck) {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Login Success')));
                Navigator.of(context).pop();
              } else {
                //to be decided
              }
            }).catchError((error) {
              //to be decided
            });
          },
        ),
        SizedBox(height: 20.0),
        RaisedButton(
          child: Text('Bits Login'),
          onPressed: () async {
            final repo = Provider.of<AuthRepository>(context);
            String idToken = await repo.signInWithGoogle();
            setState(() {
              _isLoading = true;
            });
            await repo.loginBitsian(idToken, '');
            repo.isLoggedIn.then((loginCheck) {
              setState(() {
                _isLoading = false;
              });
              if (loginCheck) {
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Login Success')));
                Navigator.of(context).pop();
              } else {
                //to be decided
              }
            }).catchError((error) {
              //to be decided
            });
          },
        ),
        Spacer()
      ],
    );
  }
}

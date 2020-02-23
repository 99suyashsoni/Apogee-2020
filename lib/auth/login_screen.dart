import 'package:apogee_main/auth/data/auth_repository.dart';
import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:apogee_main/shared/utils/HexColor.dart';
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

    return Container(
      margin: EdgeInsets.only(left: 32.0, right: 32.0),
      decoration: BoxDecoration(
        color: orderCardBackground,
        borderRadius: BorderRadius.circular(25.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 46.0),
            child: Center(
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/apogee_logo.png"),
                    fit: BoxFit.fitHeight
                  )
                ),
              )
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Username",
                hintStyle: TextStyle(color: offWhite44, fontFamily: 'Google-Sans'),
                
              ),
              onChanged: (user) {
                setState(() {
                  _username = user;
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(
                  color: offWhite44,
                  fontFamily: 'Google-Sans'
                )
              ),
              onChanged: (pass) {
                setState(() {
                  _password = pass;
                });
              },
            ),
          ),
          /* SizedBox(
            height: 20.0,
          ), */
          Container(
            margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 64.0, bottom: 8.0),
            child: RaisedButton(
              color: HexColor("#61D3D3"),
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
              ),
              child: Text("Login", style: TextStyle(color: Colors.white)),
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
          ),
          // SizedBox(height: 20.0),
          Container(
            margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 8.0, bottom: 16.0),
            child: RaisedButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
              ),
              /* child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: "Login using BITS mail",
                  hintStyle: TextStyle(color: HexColor("#31365E")),
                ),
                readOnly: true,
              ), */
              child: Text('Login using BITS Mail', style: TextStyle(color: HexColor("#31365E")),),
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
          ),
          Expanded(
            flex: 1,
            child: Container(),
          )
        ],
      ),
    );
  }
}

import 'package:apogee_main/auth/data/auth_repository.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget{

  LoginScreen({
    this.authRepository
  });

  final AuthRepository authRepository;

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: "Login",
      child: _Login(authRepository: authRepository),
      selectedTabIndex: -1,
    );
  }
}

class _Login extends StatefulWidget{

  const _Login({
    this.authRepository,
    Key key,
}) : super(key: key);

  final AuthRepository authRepository;
  @override
  _LoginState createState() => _LoginState(authRepository: authRepository);
}

class _LoginState extends State<_Login>{

  _LoginState({
    @required
    AuthRepository authRepository
    }): this._authRepository = authRepository;

  AuthRepository _authRepository;
  bool _isLoading = false;
  String _username;
  String _password;

  @override
  Widget build(BuildContext context) {
    if(_isLoading) {
      return Center(child: CircularProgressIndicator(),);
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
            final repo = _authRepository;
            setState(() {
              _isLoading = true;
            });
            await repo.loginOutstee(_username, _password, "");
            repo.isLoggedIn.then((loginCheck) {
              setState(() {
                _isLoading = false;
              });
              if(loginCheck){
                Scaffold.of(context).showSnackBar(SnackBar(content: Text('Login Success')));
                Navigator.popAndPushNamed(context, '/events');
              }
              else{
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
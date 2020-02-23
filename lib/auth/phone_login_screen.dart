import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Screen(
      title: 'Verify Number',
      child: _PhoneLogin(),
      selectedTabIndex: -1,
      endColor: topLevelScreensGradientEndColor,
      screenBackground: orderScreenBackground,
      startColor: topLevelScreensGradientStartColor,
    );
  }
}

class _PhoneLogin extends StatefulWidget {
  @override
  State<_PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<_PhoneLogin> {
  bool _isLoading = false;
  String phoneNumber;
  String opt;
  String verificationId;
  FirebaseAuth _auth;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
//        decoration: BoxDecoration(),
        child: CircularProgressIndicator(),
      );
    }

    return Container(
//      decoration: ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter phone number',
            ),
            onChanged: (number) {
              setState(() {
                phoneNumber = number;
              });
            },
          ),
          SizedBox(height: 20.0),
          RaisedButton(
            child: Text('Verify number'),
            onPressed: () async {
              _auth = Provider.of<FirebaseAuth>(context);
              _auth.verifyPhoneNumber(
                phoneNumber: phoneNumber,
                timeout: const Duration(seconds: 30),
                verificationCompleted: (AuthCredential phoneAuthCred) {
                  print(phoneAuthCred.toString());
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                verificationFailed: (AuthException e) {
                  print(e.message);
                },
                codeSent: (String verId, [int forceCodeResend]) {
                  setState(() {
                    verificationId = verId;
                  });
//                  smsOtpDialog(context).then((value) {});
//                  print('signIn');
                },
                codeAutoRetrievalTimeout: (String verId) {
                  setState(() {
                    verificationId = verId;
                  });
//                  smsOtpDialog(context).then((value) {});
                },
              );
            },
          ),
          Spacer(),
        ],
      ),
    );
  }

  Future<bool> smsOtpDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return new AlertDialog(
            title: Text('Enter OTP'),
            content: Container(
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        opt = value;
                      });
                    },
                  )
                ],
              ),
            ),
            contentPadding: EdgeInsets.all(8.0),
            actions: [
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  _auth.currentUser().then((user) {
                    if (user != null) {
                      print(user.toString());
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed('/login');
                    }
                    else {
                    }
                  });
                },
              )
            ],
          );
        }
    );
  }
}



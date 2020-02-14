import 'package:flutter/material.dart';

final appThemeData = ThemeData(
    primarySwatch: Colors.blue,
    appBarTheme: AppBarTheme(
      color: Colors.white,
      brightness: Brightness.light,
    ),
    backgroundColor: Colors.grey,
    buttonColor: Colors.lightBlue,
    disabledColor: Colors.blueGrey,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    primaryColor: Colors.white,
    accentColor: Colors.black,
    splashColor: Colors.blue,
    textTheme: TextTheme(
        button: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold,),
        title: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.w900,fontFamily: 'Google-Sans',fontStyle: FontStyle.normal),
        subtitle: TextStyle(fontSize: 22, color: Colors.grey),
        body1: TextStyle(fontSize: 20)
    )
);
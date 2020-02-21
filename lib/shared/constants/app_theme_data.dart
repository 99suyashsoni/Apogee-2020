import 'package:apogee_main/shared/constants/appColors.dart';
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
        title: TextStyle(fontSize: 34, color: Colors.white, fontWeight: FontWeight.w900, fontFamily: 'Google-Sans', fontStyle: FontStyle.normal),
        subtitle: TextStyle(fontSize: 22, color: Colors.grey),
        body1: TextStyle(fontSize: 20)
    )
);

final cardThemeData = ThemeData(
  textTheme: TextTheme(
    headline: TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: 'Google-Sans',
      fontStyle: FontStyle.normal
    ),
    title: TextStyle(
      fontSize: 14,
      color: offWhite44,
      fontFamily: 'Google-Sans',
      fontStyle: FontStyle.normal
    ),
    subtitle: TextStyle(
      fontSize: 11,
      color: offWhite44,
      fontFamily: 'Google-Sans',
      fontStyle: FontStyle.normal
    ),
    body1: TextStyle(
      fontSize: 16,
      color: orderCardAmount,
      fontFamily: 'Google-Sans',
      fontStyle: FontStyle.normal
    ),
    body2: TextStyle(
      fontSize: 14,
      color: Colors.white,
      fontFamily: 'Google-Sans',
      fontStyle: FontStyle.normal
    )
  )
);
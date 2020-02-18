import 'package:apogee_main/shared/utils/HexColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color borderColor = Colors.black;

Color strikeThroughLine = Colors.lightGreen;

Color cartQuantityButtonBackground = Colors.lightBlue;

// NOTE: Syntax fileName-function or as described below
Color orderCardBackground = HexColor("#3D4253");
Color orderCardPending = HexColor("#FF003B");
Color orderCardReady = HexColor("#ECFC03");
Color orderCardFinished = HexColor("#21CD7D");
// TODO Discuss this shadow with Devansh
Color orderCardPendingShadow = HexColor("#DAF81929");
Color orderCardReadyShadow = HexColor("#DAF81929");
Color orderCardFinishedShadow = HexColor("#19F8A629");
Color orderCardAmount = HexColor("#00B2FF");

// NOTE: If we need a color that has an opacity defferent from 100, we use the prefix
// off before the color, followed by the name of color or its function, followed by it's
// opacity in percentage
Color offWhite44 = Color.fromRGBO(255, 255, 255, 0.44);
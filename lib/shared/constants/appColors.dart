import 'package:apogee_main/shared/utils/HexColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color borderColor = Colors.black;

Color strikeThroughLine = Colors.lightGreen;

//TODO: make Standard margins and common colors to use throughout the app

Color topLevelScreensGradientStartColor = HexColor("#61D3D3");
Color topLevelScreensGradientEndColor = HexColor("#6E92FA");

// NOTE: Syntax fileName-function or as described below
Color orderScreenBackground = HexColor("#30305B");
Color orderCardBackground = HexColor("#70474f7a");
Color orderCardPending = HexColor("#FF003B");
Color orderCardReady = HexColor("#ECFC03");
Color orderCardFinished = HexColor("#21CD7D");
// TODO Discuss this shadow with Devansh
Color orderCardPendingShadow = HexColor("#DAF81929");
Color orderCardReadyShadow = HexColor("#DAF81929");
Color orderCardFinishedShadow = HexColor("#19F8A629");
Color orderCardAmount = HexColor("#00B2FF");

//Cart Screen Colors
Color cartAddQuantity = HexColor('#4D4D63');
Color cartItemBorder = HexColor('#FDFDFD');

Color menuScreenItemColor=HexColor('#FEFEFE');
//Common Screen Colors
Color screenBackground = HexColor("#30305B");
//Common Card Colours 
Color cardBackground=HexColor("#70474f7a");

//Stall Screen Colors
Color offStallNameDivider16 = Color.fromRGBO(255, 255, 255,0.16);
Color stallDescription=HexColor('#6BC0FF');
Color stallPlaceHolderBg = HexColor('#CECECE');

// NOTE: If we need a color that has an opacity defferent from 100, we use the prefix
// off before the color, followed by the name of color or its function, followed by it's
// opacity in percentage
Color offWhite44 = Color.fromRGBO(255, 255, 255, 0.44);
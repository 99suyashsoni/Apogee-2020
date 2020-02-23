import 'package:apogee_main/shared/utils/HexColor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/HexColor.dart';
import '../utils/HexColor.dart';

Color borderColor = Colors.black;

Color strikeThroughLine = Colors.lightGreen;

Color cartQuantityButtonBackground = Colors.lightBlue;
Color eventsGradientStartColor=HexColor("#FF4EC0");
Color eventsGradientEndColor=HexColor("#FF8D91");
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

Color eventCardBackground =HexColor("#043A68");
Color eventBookmark=HexColor("#5DB1FF");
//Cart Screen Colors
Color cartAddQuantity = HexColor('#4D4D63');
Color cartItemBorder = HexColor('#FDFDFD');
//Menu Screen Colors
Color menuScreenItemColor=HexColor('#FEFEFE');
Color menuScreenItemPrice=Color.fromRGBO(254, 254, 254, 0.66);
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
Color offwhite74 = Color.fromRGBO(255, 255, 255, 0.74);
Color offwhite80 = Color.fromRGBO(255, 255, 255, 0.80);
Color offWhite44 = Color.fromRGBO(255, 255, 255, 0.44);
import 'dart:math';
import 'dart:ui';
import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:apogee_main/shared/utils/HexColor.dart';
import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  const Screen({
    @required this.title,
    @required this.child,
    @required this.selectedTabIndex,
    @required this.endColor,
    @required this.startColor,
    @required this.screenBackground,
    Key key,
  }) : super(key: key);

  final Widget child;
  final int selectedTabIndex;
  final String title;
  final Color startColor;
  final Color endColor;
  final Color screenBackground;

  @override
  Widget build(BuildContext context) {
    //TODO: add statusbar color
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Container(
            child: Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                Positioned.fill(
                  child: Container(
                    color: screenBackground,
                  ),
                ),
                Transform.translate(
                  // The numbers 0.15, 0.3 and 0.35 for height are selected by trial and error on 1 device. But since MediaQuery is used,
                  // I am hoping it should scale well on all kinds of screens
                  offset: Offset(-MediaQuery.of(context).size.height * 0.15,
                      -MediaQuery.of(context).size.width * 0.3),
                  child: Transform.rotate(
                    angle: 1.2 * pi,
                    child: Container(
                      height: (MediaQuery.of(context).size.height * 0.35),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          gradient: LinearGradient(
                            colors: <Color>[startColor, endColor],
                          )),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.120,
                  // This should be the same as that of the horizontal margin given
                  left: 32,
                  child: ClipPath(
                    child: BackdropFilter(
                      // The blur values were selected by a trial and error process
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Transform.translate(
                        // PROBLEM: These offsets are absolute, and won't work well on devices of different sizes. Have to think of a solution
                        offset: Offset(20, -5),
                        child: Transform.rotate(
                          angle: 1.1 * pi,
                          child: Container(
                            height: 0.35 * MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                // Try to keep this value close to half of the radius of the backgroung rectangle
                                borderRadius: BorderRadius.circular(25.0),
                                color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        // This padding value has to be same as that of the horizontal margin given to every order Card for proper alignment
                        padding: EdgeInsets.only(left: 32.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.title,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 13,
                      child: child,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: selectedTabIndex,endcolor: endColor,
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    this.currentIndex,
    this.endcolor,
    Key key,
  }) : super(key: key);

  final int currentIndex;
  final Color endcolor;

  @override
  Widget build(BuildContext context) {
    if (currentIndex != -1) {
      return BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: bottomNavBackground,
        selectedItemColor: endcolor,
        //Theme.of(context).primaryColorLight
        unselectedItemColor: HexColor('#767676'),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 9.0,
        unselectedFontSize: 9.0,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        items: [
          _bottomNavItem(
            title: 'Stalls',
            selectedIconData:Icons.fastfood,
            unselectedIconData:Icons.fastfood,
            isSelected: currentIndex == 0,
          ),
          _bottomNavItem(
            title: 'Orders',
            selectedIconData: Icons.list,
            unselectedIconData: Icons.list,
            isSelected: currentIndex == 1,
          ),
          _bottomNavItem(
            title: 'Events',
            selectedIconData: Icons.event,
            unselectedIconData: Icons.event,
            isSelected: currentIndex == 2,
          ),
          _bottomNavItem(
            title: 'Profile',
            selectedIconData: Icons.person,
            unselectedIconData: Icons.person,
            isSelected: currentIndex == 3,
          ),
          // _bottomNavItem(
          //   title: 'More',
          //   selectedIconData: Icons.star,
          //   unselectedIconData: Icons.more,
          //   isSelected: currentIndex == 4,
          // ),
        ],
        onTap: (i) {
          if (i == currentIndex) {
            return;
          }

          if (i == 0) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/stalls', ModalRoute.withName('/'));
          } else if (i == 1) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/orders', ModalRoute.withName('/'));
          } else if (i == 2) {
            Navigator.of(context).popUntil(ModalRoute.withName('/'));
          } else if (i == 3) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/profile', ModalRoute.withName('/'));
          }
          //  else if (i == 4) {
          //   Navigator.of(context)
          //       .pushNamedAndRemoveUntil('/more', ModalRoute.withName('/'));
          // }
        },
      );
    } else {
      return Container(
        // color: Colors.greenAccent,
        height: 0,
      );
    }
  }
}

BottomNavigationBarItem _bottomNavItem({
  String title,
  IconData selectedIconData,
  IconData unselectedIconData,
  bool isSelected,
}) {
  return BottomNavigationBarItem(
    title: Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(title),
    ),
    icon: Icon(isSelected ? selectedIconData : unselectedIconData),
  );
}

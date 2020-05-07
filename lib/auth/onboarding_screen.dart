import 'dart:math';
import 'package:flutter/material.dart';

class OnBoardingScreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF464F7A),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Transform.translate(
                offset: Offset(
                  (-MediaQuery.of(context).size.height) * 0.40,
                  (-MediaQuery.of(context).size.width) * -0.25,
                ),
                child: Transform.rotate(
                  angle: 1.3 * pi,
                  child: Container(
                    width: (MediaQuery.of(context).size.width) * 0.60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF61D3D3),
                          Color(0xFF6E92FA),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(
                  (-MediaQuery.of(context).size.height) * -0.55,
                  (-MediaQuery.of(context).size.width) * 0.85,
                ),
                child: Transform.rotate(
                  angle: 1.3 * pi,
                  child: Container(
                    width: (MediaQuery.of(context).size.width) * 0.60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF61D3D3),
                          Color(0xFF6E92FA),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _Content(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: 5,
      itemBuilder: (_, i) {
        if (i == 0) {
          return _OnBoardingScreen(
            text: 'Refer the app to your friends and exciting gift vouchers!',
            heading: 'Referral',
            imageAsset: 'assets/images/onBoarding/referral.png',
            onButtonPressed: _nextPage,
            dotPosition: 1,
          );
        } else if (i == 1) {
          return _OnBoardingScreen(
            text: 'Order food through app and get discounts on food items!',
            heading: 'Discounts',
            imageAsset: 'assets/images/onBoarding/discounts.png',
            onButtonPressed: _nextPage,
            dotPosition: 2,
          );
        } else if (i == 2) {
          return _OnBoardingScreen(
            text:
                'No more waiting in long queues for your food! Simply order your favorite items from the app, track order status and collect it when it\'s ready. Indulge yourself in the seamless APOGEE experience.',
            heading: 'Order Food',
            imageAsset: 'assets/images/onBoarding/orderFood.png',
            onButtonPressed: _nextPage,
            dotPosition: 3,
          );
        } else if (i == 3) {
          return _OnBoardingScreen(
            text:
                'Earn Kind Store Tokens by taking part in various competitions organized during Oasis. Spend them by visiting Kind Store and get free Goodies. Know your Kind Store token points through your Profile Screen.',
            heading: 'Kind Store',
            imageAsset: 'assets/images/onBoarding/kindStore.png',
            onButtonPressed: _nextPage,
            dotPosition: 4,
          );
        } else if (i == 4) {
          return _OnBoardingScreen(
            text:
                'Get notifications and updates for different events and competitions going on in the campus!',
            heading: 'Track Events',
            imageAsset: 'assets/images/onBoarding/trackEvents.png',
            onButtonPressed: () {
              Navigator.of(context).pop();
            },
            dotPosition: 5,
          );
        } else {
          return null;
        }
      },
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
    );
  }
}

class _OnBoardingScreen extends StatelessWidget {
  const _OnBoardingScreen({
    @required this.text,
    @required this.heading,
    @required this.imageAsset,
    @required this.onButtonPressed,
    @required this.dotPosition,
    Key key,
  }) : super(key: key);

  final String text;
  final String heading;
  final String imageAsset;
  final VoidCallback onButtonPressed;
  final int dotPosition;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.0),
        Row(
          children: [
            Spacer(),
            FlatButton(
              child: Text(
                'Skip',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            SizedBox(width: 10.0),
          ],
        ),
        SizedBox(height: 20.0),
        Expanded(
          child: Image.asset(imageAsset),
        ),
        SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(
            heading,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'Google-Sans',
              fontSize: 32.0,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(0.0),
          height: 2.0,
          width: 40.0,
          color: Colors.white,
        ),
        SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            text,
            style: TextStyle(
              color: Color(0xFF86C3F1),
              fontWeight: FontWeight.w400,
              fontFamily: 'Google-Sans',
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 40.0),
        Row(
          children: [
            Spacer(),
            Container(
              child: FlatButton(
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 8.0),
                    Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.arrow_right,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ],
                ),
                onPressed: onButtonPressed,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                gradient: LinearGradient(colors: [
                  Color(0xFF61D3D3),
                  Color(0xFF6E92FA),
                ]),
              ),
            ),
            SizedBox(width: 30.0)
          ],
        ),
        SizedBox(height: 20.0)
      ],
    );
  }
}

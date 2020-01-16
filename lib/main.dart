import 'package:apogee_main/events/EventsScreen.dart';
import 'package:apogee_main/wallet/view/CartScreen.dart';
import 'package:apogee_main/wallet/view/MenuScreen.dart';
import 'package:apogee_main/wallet/view/OrderScreen.dart';
import 'package:apogee_main/wallet/view/ProfileScreen.dart';
import 'package:apogee_main/wallet/view/StallScreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
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
          title: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.w900),
          subtitle: TextStyle(fontSize: 22, color: Colors.grey),
          body1: TextStyle(fontSize: 20)
        )
      ),
      home: OrderScreen(),
      routes: <String, WidgetBuilder> {
        '/cart': (BuildContext context) => CartScreen(),
      },
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics)
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

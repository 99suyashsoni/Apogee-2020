import 'dart:async';
import 'package:apogee_main/auth/data/auth_repository.dart';
import 'package:apogee_main/auth/login_screen.dart';
import 'package:apogee_main/auth/phone_login_screen.dart';
import 'package:apogee_main/events/data/EventsModel.dart';
import 'package:apogee_main/events/data/database/EventsDao.dart';
import 'package:apogee_main/events/eventsScreen.dart';
import 'package:apogee_main/shared/constants/app_theme_data.dart';
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/wallet/controller/CartController.dart';
import 'package:apogee_main/wallet/controller/ProfileController_PreApogee.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:apogee_main/wallet/view/CartScreen.dart';
import 'package:apogee_main/wallet/view/OrderScreen.dart';
import 'package:apogee_main/wallet/view/ProfileScreen.dart';
import 'package:apogee_main/wallet/view/ProfileScreenPreApogee.dart';
import 'package:apogee_main/wallet/view/StallScreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runZoned(() async {
    final secureStorage = new FlutterSecureStorage();
    final customHttpNetworkClient = CustomHttpNetworkClient(
        baseUrl: "https://www.bits-oasis.org/",
        secureStorage: secureStorage,
        client: Client());

    final analytics = FirebaseAnalytics();
    final auth = FirebaseAuth.instance;
    final messaging = FirebaseMessaging();

    await messaging.requestNotificationPermissions(IosNotificationSettings());
    //All repo and dao to be made singleton here
    final authRepository = AuthRepository(
      client: customHttpNetworkClient,
      secureStorage: secureStorage,
      messaging: messaging,
    );
    final eventsDao = EventsDao();
    final walletDao = WalletDao();

//    Future<dynamic> myBackgroundMessageHandler(
//        Map<String, dynamic> message) async {
//      return Future<void>.value();
//    }

    messaging.configure(
      /*onBackgroundMessage: myBackgroundMessageHandler,*/
      onLaunch: (Map<String, dynamic> message) async {
        print(message.toString());
      },
      onMessage: (Map<String, dynamic> message) async {
        print(message.toString());
      },
      onResume: (Map<String, dynamic> message) async {
        print(message.toString());
      },
    );

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF5A534A),
    ));

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if ((await secureStorage.read(key: 'JWT')) == null) {
      runApp(ApogeeApp(
        initialRoute: '/login',
        analytics: analytics,
        authRepository: authRepository,
        eventsDao: eventsDao,
        customHttpNetworkClient: customHttpNetworkClient,
        walletDao: walletDao,
        secureStorage: secureStorage,
        auth: auth,
      ));
    } else {
      runApp(ApogeeApp(
        initialRoute: '/',
        analytics: analytics,
        authRepository: authRepository,
        eventsDao: eventsDao,
        customHttpNetworkClient: customHttpNetworkClient,
        walletDao: walletDao,
        secureStorage: secureStorage,
        auth: auth,
      ));
    }
  });
}

class ApogeeApp extends StatelessWidget {
  const ApogeeApp({
    @required this.initialRoute,
    @required this.analytics,
    @required this.authRepository,
    @required this.eventsDao,
    @required this.customHttpNetworkClient,
    @required this.walletDao,
    @required this.secureStorage,
    @required this.auth,
    Key key,
  }) : super(key: key);

  final String initialRoute;
  final FirebaseAnalytics analytics;
  final AuthRepository authRepository;
  final EventsDao eventsDao;
  final CustomHttpNetworkClient customHttpNetworkClient;
  final WalletDao walletDao;
  final FlutterSecureStorage secureStorage;
  final FirebaseAuth auth;

  //Make controller instance while passing so that functions of constructor are called every time the screen opens
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Apogee App',
      theme: appThemeData,
      initialRoute: initialRoute,
      routes: {
        '/login': (context) {
          return Provider.value(
            value: authRepository,
            child: LoginScreen(),
          );
        },
        '/phone-ver': (context) {
          return Provider.value(
            value: auth,
            child: PhoneLoginScreen(),
          );
        },
        '/events': (context) {
          return ChangeNotifierProvider.value(
            value: EventsModel(
                eventsDao: eventsDao, networkClient: customHttpNetworkClient),
            child: EventsScreen(),
          );
        },
        '/orders': (context) {
          return ChangeNotifierProvider.value(
            value: CartController(
                walletDao: walletDao, networkClient: customHttpNetworkClient),
            child: CartScreen(),
          );
        },
        '/stalls': (context) {
          return ChangeNotifierProvider.value(
            value: MyStallModel(
                walletDao: walletDao, networkClient: customHttpNetworkClient),
            child: StallScreen(),
          );
        },
        '/profile': (context) {
          //ProfileScreenPreApogeeController controller =
          return ChangeNotifierProvider.value(
            value: MyProfileModel(
                walletDao: walletDao, networkClient: customHttpNetworkClient),
            child: ProfileScreen(),
          );
        },
        '/more': (context) {
          return ChangeNotifierProvider.value(
            value: CartController(
                walletDao: walletDao, networkClient: customHttpNetworkClient),
            child: CartScreen(),
          );
        },
        '/cart': (context) {
          return ChangeNotifierProvider.value(
            value: CartController(
                walletDao: walletDao, networkClient: customHttpNetworkClient),
            child: CartScreen(),
          );
        },
        '/': (context) {
          return ChangeNotifierProvider.value(
            value:
                ProfileScreenPreApogeeController(secureStorage: secureStorage),
            child: ProfileScreenPreApogee(secureStorage),
          );
        },
      },
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}

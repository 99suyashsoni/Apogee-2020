import 'dart:async';
import 'package:apogee_main/auth/data/auth_repository.dart';
import 'package:apogee_main/auth/login_screen.dart';
import 'package:apogee_main/events/data/EventsModel.dart';
import 'package:apogee_main/events/data/database/EventsDao.dart';
import 'package:apogee_main/events/eventsScreen.dart';
import 'package:apogee_main/shared/constants/app_theme_data.dart';
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/wallet/controller/CartController.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:apogee_main/wallet/view/CartScreen.dart';
import 'package:apogee_main/wallet/view/MenuScreen.dart';
import 'package:apogee_main/wallet/view/OrderScreen.dart';
import 'package:apogee_main/wallet/view/ProfileScreen.dart';
import 'package:apogee_main/wallet/view/StallScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
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

    //All repo and dao to be made singleton here
    final authRepository = AuthRepository(
        client: customHttpNetworkClient, secureStorage: secureStorage);
    final eventsDao = EventsDao();
    final walletDao = WalletDao();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFF5A534A),
    ));

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    if (secureStorage.read(key: 'JWT') != null) {
      runApp(ApogeeApp(
        initialRoute: '/',
        authRepository: authRepository,
        eventsDao: eventsDao,
        customHttpNetworkClient: customHttpNetworkClient,
        walletDao: walletDao,
        secureStorage: secureStorage,
      ));
    } else {
      runApp(ApogeeApp(
        initialRoute: '/events',
        authRepository: authRepository,
        eventsDao: eventsDao,
        customHttpNetworkClient: customHttpNetworkClient,
        walletDao: walletDao,
        secureStorage: secureStorage,
      ));
    }
  });
}

class ApogeeApp extends StatelessWidget {
  const ApogeeApp({
    @required this.initialRoute,
    @required this.authRepository,
    @required this.eventsDao,
    @required this.customHttpNetworkClient,
    @required this.walletDao,
    @required this.secureStorage,
    Key key,
  }) : super(key: key);

  final String initialRoute;
  final AuthRepository authRepository;
  final EventsDao eventsDao;
  final CustomHttpNetworkClient customHttpNetworkClient;
  final WalletDao walletDao;
  final FlutterSecureStorage secureStorage;

  //final Firestore

  //Make controller instance while passing so that functions of constructor are called every time the screen opens
  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Apogee App',
      theme: appThemeData,
      initialRoute: '/',
      routes: {
        '/': (context) {
          return Provider.value(
            value: authRepository,
            child: LoginScreen(),
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
      },
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
    );
  }
}

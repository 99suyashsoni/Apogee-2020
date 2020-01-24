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

  // WidgetsFlutterBinding.ensureInitialized();

   print("Print 1");

  final secureStorage = new FlutterSecureStorage();

  print("Print 2");

  final customHttpNetworkClient = CustomHttpNetworkClient(
    baseUrl: "https://www.bits-oasis.org/",
    secureStorage: secureStorage,
    client: Client()
  );


  //All repo and dao to be made singleton here
  final authRepository = AuthRepository(client: customHttpNetworkClient, secureStorage: secureStorage);
  final eventsDao = EventsDao();
  final walletDao = WalletDao();
  //final firestoreDB= Firestore.instance;


  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xFF5A534A),
    )
  );

  runApp(ApogeeApp(
    authRepository: authRepository,
    eventsDao: eventsDao,
    customHttpNetworkClient: customHttpNetworkClient,
    walletDao: walletDao,

   // firestoreDB: firestoreDB

  ));
}

class ApogeeApp extends StatelessWidget {

  const ApogeeApp({
    @required this.authRepository,
    @required this.eventsDao,
    @required this.customHttpNetworkClient,
    @required this.walletDao,
    @required this.secureStorage,
   // @required this.firestoreDB,

    Key key
  }) : super(key: key);

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
           return LoginScreen(authRepository: authRepository);
        },
        '/events': (context) {
          return ChangeNotifierProvider.value(
            value: EventsModel(eventsDao: eventsDao, networkClient: customHttpNetworkClient),
            child: EventsScreen(),
          );
        },
        '/orders': (context) {
          return
             //MyOrderModel(walletDao: walletDao, networkClient: customHttpNetworkClient),
             OrderScreen( walletDao, customHttpNetworkClient,secureStorage);
        },
        '/stalls': (context) {
          return ChangeNotifierProvider.value(
            value: MyStallModel(walletDao: walletDao, networkClient: customHttpNetworkClient),
            child: StallScreen(),
          );
        },
        '/profile': (context) {
          return ChangeNotifierProvider.value(
            value: CartController(walletDao: walletDao, networkClient: customHttpNetworkClient),
            child: CartScreen(),
          );
        },
        '/more': (context) {
          return ChangeNotifierProvider.value(
            value: CartController(walletDao: walletDao, networkClient: customHttpNetworkClient),
            child: CartScreen(),
          );
        },
        '/cart': (context) {
          return ChangeNotifierProvider.value(
            value: CartController(walletDao: walletDao, networkClient: customHttpNetworkClient),
            child: CartScreen(),
          );
        },
        /*'/menu': (context) {
          return ChangeNotifierProvider.value(
            value: menumo,
            child: CartScreen(),
          );
        },*/
      },

      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics)
      ],
    );
  }
}

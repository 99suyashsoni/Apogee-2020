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
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final secureStorage = new FlutterSecureStorage();

  final customHttpNetworkClient = CustomHttpNetworkClient(
    baseUrl: "https://www.bits-oasis.org/",
    secureStorage: secureStorage,
    client: Client()
  );

  final authRepository = AuthRepository(client: customHttpNetworkClient, secureStorage: secureStorage);
  final eventsDao = EventsDao();
  final eventsModel = EventsModel(eventsDao: eventsDao, networkClient: customHttpNetworkClient);
  final walletDao = WalletDao();
  final cartController = CartController(walletDao: walletDao, networkClient: customHttpNetworkClient);
  final stallModel = MyStallModel(walletDao: walletDao, networkClient: customHttpNetworkClient);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Color(0xFF5A534A),
    )
  );

  runApp(ApogeeApp(
    authRepository: authRepository,
    eventsModel: eventsModel,
    cartController: cartController,
    stallModell: stallModel,
  ));
}

class ApogeeApp extends StatelessWidget {

  const ApogeeApp({
    @required this.authRepository,
    @required this.eventsModel,
    @required this.cartController,
    @required this.stallModell,
    Key key
  }) : super(key: key);

  final AuthRepository authRepository;
  final EventsModel eventsModel;
  final CartController cartController;
  final MyStallModel stallModell;

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
            value: eventsModel,
            child: EventsScreen(),
          );
        },
        '/orders': (context) {
          return ChangeNotifierProvider.value(
            value: cartController,
            child: CartScreen(),
          );
        },
        '/stalls': (context) {
          return ChangeNotifierProvider.value(
            value: stallModell,
            child: StallScreen(),
          );
        },
        '/profile': (context) {
          return ChangeNotifierProvider.value(
            value: cartController,
            child: CartScreen(),
          );
        },
        '/more': (context) {
          return ChangeNotifierProvider.value(
            value: cartController,
            child: CartScreen(),
          );
        }
      },
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics)
      ],
    );
  }
}

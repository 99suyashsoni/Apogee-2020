import 'dart:convert';
import 'package:apogee_main/Constants.dart';
import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:apogee_main/shared/constants/app_theme_data.dart';
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/shared/network/errorState.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:apogee_main/shared/utils/HexColor.dart';
import 'package:apogee_main/wallet/controller/ProfileController_PreApogee.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/UserShow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:paytm_payments/paytm_payments.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> /*implements  CartQuantityListener*/ {
  // MyProfileModel _myProfileModel;
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('users').document(Constants.userId).snapshots(),
      builder: (context, snapshot) {
        return Screen(
          selectedTabIndex: 3,
          title: "Profile",
          endColor: topLevelScreensGradientEndColor,
          screenBackground: orderScreenBackground,
          startColor: topLevelScreensGradientStartColor,
          child: Consumer<MyProfileModel> (
            builder: (context, profileController, child) {
              /* StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance.collection('tickets').document(Constants.userId).snapshots(),
                builder: (context, snapshot) {
                  profileController.fetchTicketsDataFromBackend();
                  return Container();
                },
              ); */
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 32.0),
                child: profileController.isLoading ? Center(child: CircularProgressIndicator()) : ListView (
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: orderCardBackground,
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            margin: EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          profileController.name,
                                          style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
                                        ),
                                        Text(
                                          "User Id: ${profileController.id}",
                                          style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    maxHeight: 120,
                                    maxWidth: 120,
                                    minHeight: 80,
                                    minWidth: 80
                                  ),
                                  color: Colors.white,
                                  child: profileController.qrCode.isEmpty ? Center( child: CircularProgressIndicator()) : 
                                    QrImage(
                                      data: profileController.qrCode,
                                      version: QrVersions.auto,
                                      constrainErrorBounds: true,
                                      errorStateBuilder: (cxt, err) {
                                        return Container(
                                          child: Center( 
                                            child: Text(
                                              "OOPs!!! Try again after sometime.",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        );
                                      }
                                    ),
                                )
                              ],
                            ),
                          ),
                          Divider(color: offwhite74,),
                          Container(
                            padding: EdgeInsets.only(top: 24.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      "Balance",
                                      style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      "Tokens",
                                      style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
                                    ),
                                  )
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      "\u20B9${snapshot.data["total_balance"]}",
                                        style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      "\u20B9${snapshot.data["tokens"]}",
                                      style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: RotatedBox(
                                      quarterTurns: 2,
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25.0),
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomRight,
                                            end: Alignment.topLeft,
                                            colors: [
                                              HexColor("#8467e8"),
                                              HexColor("#8467e8").withOpacity(0.8),
                                              HexColor("#61DCD0"),
                                            ]
                                          )
                                        ),
                                        child: Icon(
                                          Icons.money_off,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25.0),
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                            colors: [
                                              HexColor("#8467e8"),
                                              HexColor("#8467e8").withOpacity(0.8),
                                              HexColor("#61DCD0"),
                                            ]
                                          )
                                        ),
                                      child: Icon(
                                        Icons.money_off,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      "Send Money",
                                      style: Theme.of(context).textTheme.body2.copyWith(color: offWhite44),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      "Add Money",
                                      style: Theme.of(context).textTheme.body2.copyWith(color: offWhite44),
                                    ),
                                  )
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                      margin: EdgeInsets.symmetric(vertical: 32.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: orderCardBackground,
                      ),
                      constraints: BoxConstraints(
                        maxHeight: (150.0 + (30 * (profileController.userShows.length + 1))),
                      ),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "TICKETS",
                              style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Event",
                                    style: Theme.of(context).textTheme.body2.copyWith(color: offwhite74),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Used",
                                    style: Theme.of(context).textTheme.body2.copyWith(color: offwhite74),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Unused",
                                    style: Theme.of(context).textTheme.body2.copyWith(color: offwhite74),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: profileController.userShows.map((ticket) => Container(
                                margin: EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        ticket.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.body2.copyWith(color: offwhite74),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        ticket.used.toString(),
                                        style: Theme.of(context).textTheme.body2.copyWith(color: offwhite74),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        ticket.unused.toString(),
                                        style: Theme.of(context).textTheme.body2.copyWith(color: offwhite74),
                                      ),
                                    )
                                  ],
                                ),
                              )).toList(),
                            ),
                          ),
                          Center(
                            child: GestureDetector(
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                margin: EdgeInsets.only(top: 8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      HexColor("#8467e8"),
                                      HexColor("#8467e8").withOpacity(0.8),
                                      // HexColor("#61DCD0"),
                                    ]
                                  )
                                ),
                                child: Text(
                                  "Buy Tickets",
                                  style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )
        );
      }
    );
  }
}

class MyProfileModel with ChangeNotifier {
  bool isLoading = true;
  bool validInput = true;
  String qrCode = "";
  String name = "";
  String id = "";
  FlutterSecureStorage _secureStorage;
  List<UserShow> userShows = [
    UserShow(id: 0, name: "Show 1")
  ];

  //List<StallDataItem> stallItems;
  int state = 0;
  String message = "";
  WalletDao _walletDao;

  CustomHttpNetworkClient _networkClient;

  // Map<String, String> headerMap = {HttpHeaders.authorizationHeader: "JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyOTg2LCJ1c2VybmFtZSI6Im91dGd1eSIsImV4cCI6MTU3OTQ0Mjk3OSwiZW1haWwiOiIifQ.jkUfUC72EpPGeD4tvKn0wRYfsMK27oudMuZW4W6-MbY"};
  int balance = -1;

  MyProfileModel({WalletDao walletDao, CustomHttpNetworkClient networkClient, @required FlutterSecureStorage secureStorage})
      : this._walletDao = walletDao,
        this._networkClient = networkClient,
        this._secureStorage = secureStorage {
          initializeProfileController();
    }

  Future<Null> initializeProfileController() async {
      qrCode = await _secureStorage.read(key: 'QR');
      name = await _secureStorage.read(key: 'NAME');
      id = await _secureStorage.read(key: 'ID');
      isLoading=false;
      notifyListeners();
      fetchTicketsDataFromBackend();
    }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'NAME');
    await _secureStorage.delete(key: 'JWT');
    await _secureStorage.delete(key: 'EMAIL');
    await _secureStorage.delete(key: 'CONTACT');
    await _secureStorage.delete(key: 'ID');
    await _secureStorage.delete(key: 'QR');
    await _secureStorage.delete(key: 'IS_BITSIAN');
    await _secureStorage.delete(key: 'REFERRAL_CODE');
  }

  // TODO: Handle Error state
  Future<Null> fetchTicketsDataFromBackend() async {
    ErrorState errorState = await _networkClient.get(
      "tickets-manager/tickets",
      (response) async {
        var jsonResponse = json.decode(response);
        for(var show in jsonResponse["shows"]) {
          userShows.add(UserShow.fromResponse(show));
        }
        notifyListeners();
      }
    );
  }

  Future<Null> addMoney(String money) async {
    isLoading = true;
    notifyListeners();
    int amount = int.tryParse(money);
    if (amount == null) {
      validInput = false;
      notifyListeners();
      return;
    }
    Map<String, int> body = {"amount": amount};
    ErrorState errorState = await _networkClient.post(
      "wallet/monetary/add/swd",
      json.encode(body),
      (response) async {
        // TODO: money firebase se dikhana h
        //amount
        print(response);
        isLoading = false;
        notifyListeners();
      },
    );

    if (errorState.state == 2) {
      state = 2;
      message = errorState.message;
      isLoading = false;
      notifyListeners();
    }
  }
}

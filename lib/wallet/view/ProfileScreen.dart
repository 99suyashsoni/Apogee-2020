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
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 32.0),
                child: profileController.isLoading ? Center(child: CircularProgressIndicator()) : Column (
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
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          profileController.name
                                        ),
                                        Text(
                                          "User Id: ${profileController.id}"
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
                          Divider(color: Colors.white,),
                          Container(
                            padding: EdgeInsets.only(top: 32.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      "Balance"
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      "Tokens"
                                    ),
                                  )
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    "\u20B9${snapshot.data["total_balance"]}"
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: Text(
                                    "\u20B9${snapshot.data["tokens"]}"
                                  ),
                                ),
                              )
                            ],
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
                                            colors: [
                                              HexColor("#4920D6"),
                                              HexColor("#61DCD0")
                                            ]
                                          )
                                        ),
                                        child: Icon(
                                          Icons.money_off
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
                                        borderRadius: BorderRadius.circular(25.0)
                                      ),
                                      child: Icon(
                                        Icons.money_off
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
                                      "Send Money"
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text(
                                      "Add Money"
                                    ),
                                  )
                                )
                              ],
                            ),
                          ),
                          Container(
                             child: FlatButton(onPressed:()=>profileController.logout(), child: Text('Logout',style: cardThemeData.textTheme.headline,),color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
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

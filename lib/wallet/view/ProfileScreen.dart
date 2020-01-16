import 'dart:convert';
import 'dart:io';

import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:flutter/material.dart';
import 'package:apogee_main/shared/constants/strings.dart' as prefix0;
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> /*implements  CartQuantityListener*/ {
 // MyProfileModel _myProfileModel;
  final textController= TextEditingController();
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Screen(
      selectedTabIndex: 3,
      title: "Profile",
      child: ChangeNotifierProvider<MyProfileModel>(
        create: (BuildContext context) => MyProfileModel(this),
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Consumer<MyProfileModel>(
                  builder: (context, myProfileModel, child) {
                  //  _myProfileModel = myProfileModel;
                    return myProfileModel.isLoading ? Center(child: CircularProgressIndicator(),) : 
                     // myProfileModel.cartItems.isEmpty ? Center(child: Text("There are no items in your cart"),) :
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    'Wallet Balance',
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    myProfileModel.balance.toString(),
                                    textAlign: TextAlign.center)
                                ],
                              ),
                              TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Enter amount',
                                  errorText: myProfileModel.validInput? null: 'Enter valid amount'
                                ),
                                controller:textController ,
                              ),
                              RaisedButton(
                                child: Text('Add Money '),
                                onPressed:(){ 
                                  myProfileModel.addMoney(textController.text) ;
                                }
                                )
                              
                            ],
                          ),
                        );
                  },
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  

  
}

class MyProfileModel with ChangeNotifier{

  bool isLoading=false;
  bool validInput=true;
  //List<StallDataItem> stallItems;

  WalletDao _walletDao;

  CustomHttpNetworkClient _networkClient;
  Map<String, String> headerMap = {HttpHeaders.authorizationHeader: "JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyOTg2LCJ1c2VybmFtZSI6Im91dGd1eSIsImV4cCI6MTU3OTQ0Mjk3OSwiZW1haWwiOiIifQ.jkUfUC72EpPGeD4tvKn0wRYfsMK27oudMuZW4W6-MbY"};
  int balance =-1;
  
   
  MyProfileModel(uiMessageListener) {
    this._walletDao = WalletDao();
    this._networkClient = CustomHttpNetworkClient(
        baseUrl: prefix0.baseUrl,
        //uiMessageListener: uiMessageListener,
        headers: headerMap
    );
   
  }
  
  Future<Null> addMoney(String money) async {
    isLoading = true;
    notifyListeners();
    int amount = int.tryParse(money);
    if(amount==null)
    {
       validInput=false;
       notifyListeners();
       return;
    }
    Map<String,int> body={
      "amount": amount
    };
    _networkClient.post("monetary/add/swd", json.encode(body), (response) async {
      // TODO: money firebase se dikhana h 
      //amount
      print(response);
      isLoading = false;
      notifyListeners();
    },);
  }

  
  }







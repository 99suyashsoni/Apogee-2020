import 'dart:convert';
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/shared/network/errorState.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection('users').document("5889").snapshots(),
          builder: (context,snapshot){
         return Screen(
        selectedTabIndex: 3,
        title: "Profile",
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Consumer<MyProfileModel>(
                  builder: (context, myProfileModel, child) {
                  //  _myProfileModel = myProfileModel;
                  if(myProfileModel.state ==2) {
                    Fluttertoast.showToast(msg: myProfileModel.message);
                    myProfileModel.state=0;
                  }
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
                                  snapshot==null? "???": snapshot.hasData? (snapshot.data["total_balance"] ?? "???").toString(): "???",
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
        )
      );
      }
    );
  }

  

  
}

class MyProfileModel with ChangeNotifier{

  bool isLoading=false;
  bool validInput=true;
  //List<StallDataItem> stallItems;
  int state=0;
  String message ="";
  WalletDao _walletDao;

  CustomHttpNetworkClient _networkClient;
 // Map<String, String> headerMap = {HttpHeaders.authorizationHeader: "JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyOTg2LCJ1c2VybmFtZSI6Im91dGd1eSIsImV4cCI6MTU3OTQ0Mjk3OSwiZW1haWwiOiIifQ.jkUfUC72EpPGeD4tvKn0wRYfsMK27oudMuZW4W6-MbY"};
  int balance =-1;
  
   
  MyProfileModel({
     WalletDao walletDao,
    CustomHttpNetworkClient networkClient
  }): this._walletDao = walletDao,
      this._networkClient = networkClient{
       
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
   ErrorState errorState= await _networkClient.post("wallet/monetary/add/swd", json.encode(body), (response) async {
      // TODO: money firebase se dikhana h 
      //amount
      print(response);
      isLoading = false;
      notifyListeners();
    },);

     if(errorState.state==2){
      state=2;
      message=errorState.message;
      isLoading=false;
      notifyListeners();
    }
    
  }

  
  }







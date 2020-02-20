import 'dart:convert';
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/shared/network/errorState.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:apogee_main/wallet/controller/ProfileController_PreApogee.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paytm_payments/paytm_payments.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          decoration: new BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/background.png'),
            fit: BoxFit.cover),
             
          ),
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
                                 // myProfileModel.addMoney(textController.text) ;
                                 myProfileModel.initPayment();
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
       
       setResponseListener();
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
 // method to initiate payment
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPayment() async {

    // try/catch any Exceptions.
    try {

      await PaytmPayments.makePaytmPayment(
        "rxazcv89315285244163", // [YOUR_MERCHANT_ID] (required field)
        "https://ajax8732.000webhostapp.com/generateChecksum.php", // [YOUR_CHECKSUM_URL] (required field)
        customerId: "12345", // [UNIQUE_ID_FOR_YOUR_CUSTOMER] (auto generated if not specified)
        orderId: DateTime.now().millisecondsSinceEpoch.toString(), // [UNIQUE_ID_FOR_YOUR_ORDER] (auto generated if not specified)
        txnAmount: "10.0", // default: 10.0
        channelId: "WAP", // default: WAP (STAGING value)
        industryTypeId: "Retail", // default: Retail (STAGING value)
        website: "APPSTAGING", // default: APPSTAGING (STAGING value)
        staging: true, // default: true (by default paytm staging environment is used)
        showToast: true, // default: true (by default shows callback messages from paytm in Android Toasts)
      );

    } on Exception {

      print("Some error occurred");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    //if (!mounted) return;
  }

   void setResponseListener(){

    // setting a listener on payment response
    PaytmPayments.responseStream.listen((Map<dynamic, dynamic> responseData){

      print(responseData);

      /*
      * {RESPMSG : [MSG]} // this is the type of map object received, except for one case.
      *
      * In this unique case, Transaction Response is received of the format:
      * {CURRENCY: INR, ORDERID: 1557210948833, STATUS: TXN_FAILURE, BANKTXNID: , RESPMSG: Invalid checksum, MID: rxazcv89315285244163, RESPCODE: 330, TXNAMOUNT: 10.00}
      *
      * Call any method here to handle payment process on receiving response. According to the response received.
      * handleResponse();
      *
      * */
    });
  }
  
  }

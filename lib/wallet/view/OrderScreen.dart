import 'dart:convert';
import 'dart:io';

import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/shared/network/errorState.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/Orders.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/OrderItems.dart';
import 'package:apogee_main/wallet/view/OrderDataWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();

  WalletDao walletDao;
  CustomHttpNetworkClient networkClient;
  FlutterSecureStorage secureStorage;
  MyOrderModel myOrderModel;
  OrderScreen(this.myOrderModel, this.walletDao, this.networkClient,
      this.secureStorage);
}

class _OrderScreenState extends State<OrderScreen> implements OtpSeenListener {
  //MyOrderModel _myOrderModel;
  // This variable is used to manually cache the stream builder widget, as it was causing an infinite loop if not cached
  // Widget stream = null;

  @override
  Widget build(BuildContext context) {
    //

    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('orders')
          .where('userid', isEqualTo: 5889)
          .snapshots(),
      builder: (context, snapshot) {
        print("Entered stream query builder");
        if (snapshot.hasData) {
          widget.myOrderModel.fetchOrderData();
        }
        return Widget1(widget.networkClient, widget.walletDao, this);
      },
    );
  }

  @override
  void onOtpSeenClicked({int orderId}) {
    widget.myOrderModel.makeOtpSeen(orderId);
    // TODO: implement onOtpSeenClicked
  }

  // }
}

class Widget1 extends StatelessWidget {
  MyOrderModel myordermodel;
  OtpSeenListener otpSeenListener;
  WalletDao walletDao;
  CustomHttpNetworkClient networkClient;
  Widget1(this.networkClient, this.walletDao, this.otpSeenListener);

  @override
  Widget build(BuildContext context) {
   
    return Consumer<MyOrderModel>(
      builder: (context, myordermodel, child) {
         if(myordermodel.state ==2) {
           Fluttertoast.showToast(msg: myordermodel.message);
      myordermodel.state=0;
    }
        return Screen(
            selectedTabIndex: 1,
            title: "Orders",
//              child: ChangeNotifierProvider<MyOrderModel>(
//                create: (BuildContext context) => MyOrderModel(),
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      // child: Consumer<MyOrderModel>(
                      // builder: (context, myOrderModel, child) {
                      child: myordermodel.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : myordermodel.orderData.isEmpty
                              ? Center(child: Text("No orders are available"))
                              : Container(
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: ListView.builder(
                                          itemCount:
                                              myordermodel.orderData.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              child: OrderDataWidget(
                                                orders: myordermodel
                                                    .orderData[index],
                                                otpSeenListener:
                                                    otpSeenListener,
                                              ),
                                              onTap: () {
                                               
                                                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MenuScreen(myOrderModel.orderData[index].orderId), settings: RouteSettings(name: "/menuItems$index")));
                                                //TODO: open menu Screen
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      
                                    ],
                                  ),
                                )
                      // },
                      // ),
                      ),
                ],
              ),
              //),
            ));
      },
    );
  }
}

class MyOrderModel with ChangeNotifier {
  bool isLoading = false;
  //List<StallDataItem> stallItems;
  int state=0;
  String message=" ";
  WalletDao _walletDao;
  CustomHttpNetworkClient _networkClient;
  //Map<String, String> headerMap = {HttpHeaders.authorizationHeader: "JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyOTg2LCJ1c2VybmFtZSI6Im91dGd1eSIsImV4cCI6MTU4MDQyMzA3MCwiZW1haWwiOiIifQ.r3FGPr7Z1aZvfZuCkb14jIt6hXeQ1SJfsfojZYW_vUA"};
  List<Orders> orderData = [];
  List<OrderItems> orderDetails = [];

  MyOrderModel(WalletDao walletDao, CustomHttpNetworkClient networkClient)
      : this._walletDao = walletDao,
        this._networkClient = networkClient {
    isLoading = true;
    print("try: calling from order screen");
    displayOrderData();
    fetchOrderData();
  }

  Future<Null> displayOrderData() async {
    print("try: inside diplay orders data ");
    orderData = await _walletDao.getOrderData();
    isLoading = false;
    notifyListeners();
    print("try: Updated orders = $orderData");
  }

  Future<Null> displayOrderDetails(int orderId) async {
    orderDetails = await _walletDao.getOrderDetails(orderId);
    isLoading = false;
    notifyListeners();
    print("Updated order details = $orderDetails");
  }
//TODO: insert and fetch order items and orders data

  Future<Null> fetchOrderData() async {
    print("try: fetch order data called");
    // isLoading = true;
    // notifyListeners();
    _networkClient.get(
      "wallet/orders/",
      (response) async {
        print("try: order responseee$response");
        await _walletDao.insertAllOrders((json.decode(response)));
        isLoading = false;
        //TODO: harbar nahi update karna h
        displayOrderData();
        // notifyListeners();
      },
    );
  }

  Future<Null> makeOtpSeen(int orderid) async {
    print("try: make otp seen  called");
    isLoading = true;
    notifyListeners();
    Map<String, int> body = {"order_id": orderid};

    ErrorState errorState= await _networkClient.post(
      "wallet/orders/make_otp_seen",
      json.encode(body),
      (response) async {
        print("try: make otp seen responseee$response");
//      isLoading = false;
//       notifyListeners();
      },
    );
    if(errorState.state==2){
      state=2;
      message=errorState.message;
      isLoading=false;
      notifyListeners();
    }

    
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:apogee_main/shared/constants/app_theme_data.dart';
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/shared/network/errorState.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:apogee_main/wallet/controller/OrderController.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/Orders.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/OrderItems.dart';
import 'package:apogee_main/wallet/view/OrderCard.dart';
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
  OrderController myOrderModel;
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
  OrderController myordermodel;
  OtpSeenListener otpSeenListener;
  WalletDao walletDao;
  CustomHttpNetworkClient networkClient;
  Widget1(this.networkClient, this.walletDao, this.otpSeenListener);

  @override
  Widget build(BuildContext context) {
   
    return Consumer<OrderController>(
      builder: (context, myordermodel, child) {
         if(myordermodel.state ==2) {
           Fluttertoast.showToast(msg: myordermodel.message);
      myordermodel.state=0;
    }
    print("Order Details = ${myordermodel.orderDetails}");
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
                                          itemCount:myordermodel.orderData.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              child: Theme(
                                                data: orderCardThemeData,
                                                child: OrderCard(
                                                  orders: myordermodel.orderData[index],
                                                  orderItems: myordermodel.orderDetails.where((item) => item.orderId == myordermodel.orderData[index].orderId).toList(),
                                                ),
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
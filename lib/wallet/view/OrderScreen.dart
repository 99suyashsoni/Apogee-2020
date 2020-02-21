import 'dart:ui';

import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:apogee_main/wallet/controller/OrderController.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:apogee_main/wallet/view/OrderDataWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import 'package:provider/provider.dart';

import 'OrdersList.dart';

class OrderScreen extends StatefulWidget {
  WalletDao walletDao;
  CustomHttpNetworkClient networkClient;
  FlutterSecureStorage secureStorage;
  OrderController orderController;

  OrderScreen(
    this.orderController,
    this.walletDao,
    this.networkClient,
    this.secureStorage
  );

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> implements OtpSeenListener {
  @override
  Widget build(BuildContext context) {
    print("size = ${MediaQuery.of(context).size.height}\n${MediaQuery.of(context).size.width}");
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
        .collection('orders')
        .where('userid', isEqualTo: 5889)
        .snapshots(),
      builder: (context, snapshot) {
        print("Entered stream query builder");
        if (snapshot.hasData) {
          widget.orderController.fetchOrderData();
        }
        return Consumer<OrderController>(
          builder: (context, orderController, child) {
            if(orderController.state == 2) {
              Fluttertoast.showToast(msg: orderController.message);
              orderController.state=0;
            }
            return Screen(
              title: "Orders",
              selectedTabIndex: 1,
              child: Container(
                child: Stack(
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        color: orderScreenBackground,
                      ),
                    ),
                    Transform.translate(
                      // The numbers 0.15, 0.3 and 0.35 for height are selected by trial and error on 1 device. But since MediaQuery is used,
                      // I am hoping it should scale well on all kinds of screens
                      offset: Offset(-MediaQuery.of(context).size.height * 0.15, -MediaQuery.of(context).size.width * 0.3),
                      child: Transform.rotate(
                        angle: 1.2 * pi,
                        child: Container(
                          height: (MediaQuery.of(context).size.height * 0.35),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            gradient: LinearGradient(
                              colors: <Color>[
                                topLevelScreensGradientStartColor,
                                topLevelScreensGradientEndColor
                              ],
                            )
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.120,
                      // This should be the same as that of the horizontal margin given
                      left: 32,
                      child: ClipPath(
                        child: BackdropFilter(
                          // The blur values were selected by a trial and error process
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Transform.translate(
                            // PROBLEM: These offsets are absolute, and won't work well on devices of different sizes. Have to think of a solution
                            offset: Offset(20, -5),
                            child: Transform.rotate(
                              angle: 1.1 * pi,
                              child: Container(
                                height: 0.35 * MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  // Try to keep this value close to half of the radius of the backgroung rectangle
                                  borderRadius: BorderRadius.circular(25.0),
                                  color: Colors.transparent
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            // This padding value has to be same as that of the horizontal margin given to every order Card for proper alignment
                            padding: EdgeInsets.only(left: 32.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Orders",
                              style: Theme.of(context).textTheme.title,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 13,
                          child: getChildForOrderScreen(orderController),
                        )
                      ],
                    ),
                  ],
                ),
              )
            );
          },
        );
      },
    );
  }

  Widget getChildForOrderScreen(OrderController orderController) {
    if(widget.orderController.isLoading != null && widget.orderController.isLoading)
     return Center(
       child: CircularProgressIndicator(
         valueColor: new AlwaysStoppedAnimation<Color>(
           Colors.white
          )
        )
      );
    if(widget.orderController.orderData != null && widget.orderController.orderData.isEmpty)
     return Center(
       child: Text(
         "No Orders Available",
         style: Theme.of(context).textTheme.title.copyWith(fontSize: 28)
        ),
      );
    return OrdersList(
      widget.networkClient, 
      widget.walletDao, 
      this, 
      orderController.orderData, 
      orderController.orderDetails
    );
  }

  @override
  void onOtpSeenClicked({int orderId}) {
    widget.orderController.makeOtpSeen(orderId);
    // TODO: implement onOtpSeenClicked
  }
}
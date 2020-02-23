import 'dart:ui';

import 'package:apogee_main/Constants.dart';
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

  OrderScreen(this.walletDao, this.networkClient, this.secureStorage);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> implements OtpSeenListener {
  @override
  Widget build(BuildContext context) {
    widget.orderController = Provider.of<OrderController>(context);
    print(
        "size = ${MediaQuery.of(context).size.height}\n${MediaQuery.of(context).size.width}");
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('orders')
          .where('userid', isEqualTo: Constants.userId)
          .snapshots(),
      builder: (context, snapshot) {
        print("Entered stream query builder");
        if (snapshot.hasData) {
          widget.orderController.fetchOrderData();
        }
        return Consumer<OrderController>(
          builder: (context, orderController, child) {
            if (orderController.state == 2) {
              Fluttertoast.showToast(msg: orderController.message);
              orderController.state = 0;
            }
            return Screen(
                title: "Orders",
                selectedTabIndex: 1,
                endColor: topLevelScreensGradientEndColor,
                screenBackground: orderScreenBackground,
                startColor: topLevelScreensGradientStartColor,
                child: getChildForOrderScreen(orderController));
          },
        );
      },
    );
  }

  Widget getChildForOrderScreen(OrderController orderController) {
    if (widget.orderController.isLoading != null &&
        widget.orderController.isLoading)
      return Center(
          child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)));
    if (widget.orderController.orderData != null &&
        widget.orderController.orderData.isEmpty)
      return Center(
        child: Text("No Orders Available",
            style: Theme.of(context).textTheme.title.copyWith(fontSize: 28)),
      );
    return OrdersList(widget.networkClient, widget.walletDao, this,
        orderController.orderData, orderController.orderDetails);
  }

  @override
  void onOtpSeenClicked({int orderId}) {
    widget.orderController.makeOtpSeen(orderId);
    // TODO: implement onOtpSeenClicked
  }
}

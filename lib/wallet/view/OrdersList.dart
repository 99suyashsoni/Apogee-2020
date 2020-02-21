
import 'package:apogee_main/shared/constants/app_theme_data.dart';
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/OrderItems.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/Orders.dart';
import 'package:flutter/material.dart';
import 'OrderCard.dart';
import 'OrderDataWidget.dart';

class OrdersList extends StatelessWidget {
  OtpSeenListener otpSeenListener;
  WalletDao walletDao;
  CustomHttpNetworkClient networkClient;
  List<Orders> orders;
  List<OrderItems> orderItems;

  OrdersList(
    this.networkClient,
    this.walletDao,
    this.otpSeenListener,
    this.orders,
    this.orderItems
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount:orders.length,
                      itemBuilder: (context, index) {
                        return Theme(
                          data: cardThemeData,
                          child: OrderCard(
                            orders: orders[index],
                            orderItems: orderItems.where((item) => item.orderId == orders[index].orderId).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}
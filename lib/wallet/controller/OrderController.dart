import 'dart:convert';

import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/shared/network/errorState.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/OrderItems.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/Orders.dart';
import 'package:flutter/material.dart';

class OrderController with ChangeNotifier {
  bool isLoading = false;
  int state=0;
  String message=" ";
  WalletDao _walletDao;
  CustomHttpNetworkClient _networkClient;
  List<Orders> orderData = [];
  List<OrderItems> orderDetails = [];

  OrderController(WalletDao walletDao, CustomHttpNetworkClient networkClient)
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
    orderDetails = await _walletDao.getAllOrderDetails();
    isLoading = false;
    notifyListeners();
    print("try: Updated orders = $orderData");
  }

  Future<Null> fetchOrderData() async {
    print("try: fetch order data called");
    _networkClient.get(
      "wallet/orders/",
      (response) async {
        print("try: order responseee$response");
        await _walletDao.insertAllOrders((json.decode(response)));
        isLoading = false;
        displayOrderData();
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
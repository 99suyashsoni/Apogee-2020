import 'dart:convert';
import 'dart:io';

import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/Orders.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/OrderItems.dart';
import 'package:apogee_main/shared/constants/strings.dart' as prefix0;
import 'package:apogee_main/wallet/view/OrderDataWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget{
  @override
  _OrderScreenState createState() => _OrderScreenState();

}

class _OrderScreenState extends State<OrderScreen>  {
  MyOrderModel _myOrderModel;

  @override
  Widget build(BuildContext context) {
    return Screen(
        selectedTabIndex: 1,
        title: "Orders",
        child: ChangeNotifierProvider<MyOrderModel>(
          create: (BuildContext context) => MyOrderModel(this),
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Consumer<MyOrderModel>(
                    builder: (context, myOrderModel, child) {
                      _myOrderModel = myOrderModel;
                      return myOrderModel.isLoading ? Center(child: CircularProgressIndicator()) :
                      myOrderModel.orderData.isEmpty ? Center(child: Text("No Stalls are available")) :
                      Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: ListView.builder(
                                itemCount: myOrderModel.orderData.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    child: OrderDataWidget(orders:myOrderModel.orderData[index]),
                                    onTap: (){
                                      Scaffold
                                          .of(context)
                                          .showSnackBar(SnackBar(content: Text(index.toString())));
                                     // Navigator.of(context).push(MaterialPageRoute(builder: (context) => MenuScreen(myOrderModel.orderData[index].orderId), settings: RouteSettings(name: "/menuItems$index")));
                                      //TODO: open menu Screen
                                    },
                                  );
                                },
                              ),
                            ),
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

 



 
/*
  @override
  void onQuantityChanged({int id, int quantity}) {
    _controller.cartItemQuantityChanged(id, quantity);
  }
*/


}

class MyOrderModel with ChangeNotifier{

  bool isLoading=false;
  //List<StallDataItem> stallItems;

  WalletDao _walletDao;
  CustomHttpNetworkClient _networkClient;
  Map<String, String> headerMap = {HttpHeaders.authorizationHeader: "JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyOTg2LCJ1c2VybmFtZSI6Im91dGd1eSIsImV4cCI6MTU3OTQ0Mjk3OSwiZW1haWwiOiIifQ.jkUfUC72EpPGeD4tvKn0wRYfsMK27oudMuZW4W6-MbY"};
  List<Orders> orderData = [];
  List<OrderItems> orderDetails = [];

  MyOrderModel(uiMessageListener) {
    this._walletDao = WalletDao();
    this._networkClient = CustomHttpNetworkClient(
        baseUrl: prefix0.baseUrl,
       // uiMessageListener: uiMessageListener,
        headers: headerMap
    );
    //
    displayOrderData();
    fetchOrderData();
     isLoading = true;
    // loadCartItems();
  }

  Future<Null> displayOrderData() async {
    orderData = await _walletDao.getOrderData();
    isLoading = false;
    notifyListeners();
    print("Updated orders = $orderData");
  }

   Future<Null> displayOrderDetails(int orderId) async {
    orderDetails = await _walletDao.getOrderDetails(orderId);
    isLoading = false;
    notifyListeners();
    print("Updated order details = $orderDetails");
  }
//TODO: insert and fetch order items and orders data 


  Future<Null> fetchOrderData() async {
    isLoading = true;
    notifyListeners();
    _networkClient.get("wallet/orders/",  (response) async {
      await _walletDao.insertAllOrders((json.decode(response)));
      isLoading = false;
      //TODO: harbar nahi update karna h 
      displayOrderData();
      notifyListeners();

    },);
  }




}
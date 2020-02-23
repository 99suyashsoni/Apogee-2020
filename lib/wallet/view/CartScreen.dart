import 'dart:io';

import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:apogee_main/wallet/controller/CartController.dart';
import 'package:apogee_main/wallet/view/CartItemWidget.dart';
import 'package:apogee_main/wallet/view/CartQuantityWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> implements CartQuantityListener {
  CartController _controller;

  @override
  Widget build(BuildContext context) {
    return Screen(
      selectedTabIndex: -1,
      title: "Cart",
      endColor: topLevelScreensGradientEndColor,
      screenBackground: orderScreenBackground,
      startColor: topLevelScreensGradientStartColor,
//      child: ChangeNotifierProvider<CartController>(
//        create: (BuildContext context) => CartController(),
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Consumer<CartController>(
                  builder: (context, controller, child) {
                    _controller = controller;
                    if(controller.state ==2) {
                    Fluttertoast.showToast(msg: controller.message);
                    controller.state=0;
                  }
                    return controller.isLoading ? Center(child: CircularProgressIndicator(),) :
                      controller.cartItems.isEmpty ? Center(child: Text("There are no items in your cart"),) :
                        Container(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: ListView.builder(
                                  itemCount: controller.cartItems.length,
                                  itemBuilder: (context, index) {
                                    return CartItemWidget(item: controller.cartItems[index], cartQuantityListener: this,);
                                  },
                                ),
                              ),
                             /*  Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  child: Text("Total: \u20B9 ${11000}"),
                                ),
                              ), */
                              Container(
                                margin: EdgeInsets.only(top: 4.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text(controller.cartItems.length.toString()+" items", style: Theme.of(context).textTheme.body1,),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text("\u20B9 "+controller.getTotalPrice().toString(), style: Theme.of(context).textTheme.body1,),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          child: Text("Place Order",
                                          ),
                                          onTap: () {
                                            controller.placeOrder();
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
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
      //)
    );
  }

  @override
  void onQuantityChanged({int id, int quantity}) {
    _controller.cartItemQuantityChanged(id, quantity);
  }

  
  

  
}
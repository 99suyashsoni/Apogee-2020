import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/shared/utils/HexColor.dart';
import 'package:apogee_main/wallet/controller/CartController.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:apogee_main/wallet/view/CartQuantityWidget.dart';
import 'package:apogee_main/wallet/view/MenuCategoryWidget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CartScreenBottomSheet extends StatefulWidget {
  @override
  _CartScreenBottomSheetState createState() => _CartScreenBottomSheetState();
  WalletDao walletDao;
  CustomHttpNetworkClient networkClient;
  CartScreenBottomSheet(this.networkClient,this.walletDao);
}
//TODO:  agar cart me item pehle se and badme vendor ne band kiya to cart se autoremove/not order

class _CartScreenBottomSheetState extends State<CartScreenBottomSheet> implements CartQuantityListener {
  CartController _controller;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartController>(
      create: (BuildContext context) => new CartController(walletDao: widget.walletDao,networkClient: widget.networkClient),
      child: Container(
        
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Cart',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline.copyWith(fontSize: 28,color: Colors.white),
              ),
            ),
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
                                itemCount: controller.getStallIds().length,
                                itemBuilder: (context, index) {
                                  //return CartItemWidget(item: controller.cartItems[index], cartQuantityListener: this,);
                                  // return MenuItemWidget(item: controller.cartItems[index], cartQuantityListener: this);
                                  return MenuCategoryWidget(menuItems:controller.mapItems[controller.stallIds[index]],
                                  cartQuantityListener: this,isCart: true, );                                                      },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Divider(color: offStallNameDivider16,height: 2,thickness: 2,endIndent: 8.0,indent: 8.0,),
                            ),

                            Container(
                            
                              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text('GRAND TOTAL',
                                      style: TextStyle(color: menuScreenItemColor,fontSize: 14),),
                                      Text(
                                        "\u20B9 "+controller.getTotalPrice().toString(),
                                        style: Theme.of(context).textTheme.body1.copyWith(
                                          color: HexColor('#F4E87A'),fontSize: 20)),
                                    ],
                                  ),
                                  // Container(
                                  //   padding: EdgeInsets.only(left: 8.0),
                                  //   child: Text(controller.cartItems.length.toString()+" items", style: Theme.of(context).textTheme.body1,),
                                  // ),
                                  // Expanded(
                                  //   flex: 1,
                                  //   child: Container(),
                                  // ),
                                   
                                  Container(
                                    padding: EdgeInsets.only(right: 8.0),
                                    decoration: BoxDecoration(
                                      gradient:LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors:[HexColor('#FCF379'),HexColor('#FA5C76')]),
                                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                    ),
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
    );
  }

  @override
  void onQuantityChanged({int id, int quantity}) {
    _controller.cartItemQuantityChanged(id, quantity);
  }

  
}
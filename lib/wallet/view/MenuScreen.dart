import 'dart:io';
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:apogee_main/wallet/controller/CartController.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/CartItem.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/StallMenuItem.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/StallModifiedMenuItem.dart';
import 'package:apogee_main/wallet/view/CartItemWidget.dart';
import 'package:apogee_main/shared/constants/strings.dart' as prefix0;
import 'package:apogee_main/wallet/view/CartQuantityWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MenuItemWidget.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();

  int id;

  MenuScreen(this.id);
}

class _MenuScreenState extends State<MenuScreen> implements CartQuantityListener {
  MyMenuModel _myMenuModel;
  @override
  Widget build(BuildContext context) {
    return Screen(
        selectedTabIndex: -1,
        title: "Menu",
        child: ChangeNotifierProvider<MyMenuModel>(
          create: (BuildContext context) => MyMenuModel(this,widget.id),
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Consumer<MyMenuModel>(
                    builder: (context, mymenumodel, child) {
                      _myMenuModel = mymenumodel;
                      return mymenumodel.isLoading ? Center(child: CircularProgressIndicator(),) :
                      mymenumodel.menuItems.isEmpty ? Center(child: Text("No menu available for this stall"),) :
                      Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: ListView.builder(
                                itemCount: mymenumodel.menuItems.length,
                                itemBuilder: (context, index) {
                                  return MenuItemWidget(item: mymenumodel.menuItems[index], cartQuantityListener: this,);
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                child: Text("Total: \u20B9 ${1000}"),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 4.0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text(mymenumodel.menuItems.length.toString()+" items", style: Theme.of(context).textTheme.body1,),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text("\u20B9 1000", style: Theme.of(context).textTheme.body1,),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: GestureDetector(
                                      child: Text("View cart"),
                                      onTap: () {
                                        Navigator.of(context).pushNamed('/cart');

                                       /* controller.placeOrder();*/
                                        Scaffold
                                            .of(context)
                                            .showSnackBar(SnackBar(content: Text("to open cart")));
                                      },
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
        )
    );
  }

  @override
  void onQuantityChanged({int id, int quantity}) {
    //_controller.cartItemQuantityChanged(id, quantity);
  }


}

class MyMenuModel with ChangeNotifier{

  bool isLoading=false;
  //List<StallDataItem> stallItems;

  WalletDao _walletDao;
  Map<String, String> headerMap = {HttpHeaders.authorizationHeader: "JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyOTg2LCJ1c2VybmFtZSI6Im91dGd1eSIsImV4cCI6MTU3OTQ0Mjk3OSwiZW1haWwiOiIifQ.jkUfUC72EpPGeD4tvKn0wRYfsMK27oudMuZW4W6-MbY"};
  List<StallModifiedMenuItem> menuItems= [];

  MyMenuModel(uiMessageListener,int stallId) {
    this._walletDao = WalletDao();

    displayStallMenuItems(stallId);
    // isLoading = true;
    // loadCartItems();
  }

  Future<Null> displayStallMenuItems(int stallId) async {
    menuItems = await _walletDao.getModifiedMenuItems(stallId, 1);
    isLoading = false;
    notifyListeners();
    print("Updated CartItems = $menuItems");
  }







}
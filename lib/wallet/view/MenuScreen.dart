import 'dart:io';
import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/CartItem.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/StallModifiedMenuItem.dart';
import 'package:apogee_main/wallet/view/CartQuantityWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MenuItemWidget.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();

  int id;
  WalletDao walletDao;

  MenuScreen(this.id, this.walletDao);
}

class _MenuScreenState extends State<MenuScreen>
    with WidgetsBindingObserver
    implements CartQuantityListener {
  MyMenuModel _myMenuModel;

  @override
  Widget build(BuildContext context) {
    return Screen(
      selectedTabIndex: -1,
      title: "Menu",
      endColor: topLevelScreensGradientEndColor,
      screenBackground: orderScreenBackground,
      startColor: topLevelScreensGradientStartColor,
      child: ChangeNotifierProvider<MyMenuModel>(
        create: (BuildContext context) =>
            MyMenuModel(widget.id, widget.walletDao),
        child: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Consumer<MyMenuModel>(
                  builder: (context, mymenumodel, child) {
                    _myMenuModel = mymenumodel;
                    mymenumodel.stallId = widget.id;
                    return mymenumodel.isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : mymenumodel.menuItems.isEmpty
                            ? Center(
                                child: Text("No menu available for this stall"),
                              )
                            : Container(
                                child: Column(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: ListView.builder(
                                        itemCount: mymenumodel.menuItems.length,
                                        itemBuilder: (context, index) {
                                          return MenuItemWidget(
                                            item: mymenumodel.menuItems[index],
                                            cartQuantityListener: this,
                                          );
                                        },
                                      ),
                                    ),
                                    /*   Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                child: Text("Total: \u20B9 ${1000}"),
                              ),
                            ), */
                                    Container(
                                      margin: EdgeInsets.only(top: 4.0),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              mymenumodel.cartItems.length
                                                      .toString() +
                                                  " items",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body1,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              "\u20B9 " +
                                                  mymenumodel
                                                      .getTotalPrice()
                                                      .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body1,
                                            ),
                                          ),
                                          /*  Expanded(
                                    flex: 1,
                                    child: Container(),
                                  ), */
                                          Container(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                child: Text("View cart"),
                                                onTap: () async {
                                                  await Navigator.of(context)
                                                      .pushNamed('/cart');
                                                  mymenumodel
                                                      .displayStallMenuItems(
                                                          widget.id);
                                                  mymenumodel.getCartItems();
                                                  /* controller.placeOrder();*/
                                                  Scaffold.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "to open cart")));
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
      ),
    );
  }

  @override
  void onQuantityChanged({int id, int quantity}) {
    _myMenuModel.cartItemQuantityChanged(id, quantity);
  }
}

class MyMenuModel with ChangeNotifier {
  bool isLoading = false;

  //List<StallDataItem> stallItems;

  WalletDao _walletDao;
  int stallId;

  List<StallModifiedMenuItem> menuItems = [];
  List<CartItem> cartItems = [];

  MyMenuModel(int stallId, WalletDao walletDao) {
    this._walletDao = walletDao;
    this.stallId = stallId;

    isLoading = true;
    displayStallMenuItems(stallId);
    getCartItems();

    // loadCartItems();
  }

  Future<Null> displayStallMenuItems(int stallId) async {
    print("try: display called");
    menuItems = await _walletDao.getModifiedMenuItems(stallId, 1);
    isLoading = false;
    notifyListeners();
    print("Updated CartItems = $menuItems");
  }

  Future<Null> cartItemQuantityChanged(int id, int quantity) async {
    if (quantity >= 0) {
      if (quantity == 0) {
        //cartItems.removeWhere((item) => item.itemId == id);
        menuItems.firstWhere((item) => item.itemId == id).quantity = quantity;
        notifyListeners();
        var result = await _walletDao.deleteCartItem(id);
        print("Result for delting item from cart = $result");
      } else if (quantity == 1) {
        //cartItems.removeWhere((item) => item.itemId == id);
        menuItems.firstWhere((item) => item.itemId == id).quantity = quantity;
        notifyListeners();
        var result = await _walletDao.insertCartItemfromMenuScreen(
            id, quantity, stallId);
        print("insert new intem to cart");
      } else {
        print("enter update with new quantity$quantity id$id");
        menuItems.firstWhere((item) => item.itemId == id).quantity = quantity;
        notifyListeners();
        _walletDao.updateCartItemQuantity(id, quantity);
      }
    }
    getCartItems();
  }

  Future<Null> getCartItems() async {
    print("try: dget cart items called in Menu Screen");
    cartItems = await _walletDao.getAllCartItems();
    // isLoading = false;
    notifyListeners();
    print("Updated CartItems = $cartItems");
  }

  int getTotalPrice() {
    int price = 0;
    for (var item in cartItems) {
      price += item.quantity * item.currentPrice;
    }
    return price;
  }
}

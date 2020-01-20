import 'dart:io';
import 'package:apogee_main/shared/screen.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/StallModifiedMenuItem.dart';
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

class _MenuScreenState extends State<MenuScreen>  with WidgetsBindingObserver implements CartQuantityListener {
AppLifecycleState _lastLifecycleState;
    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lastLifecycleState = state;
    });
  }



  MyMenuModel _myMenuModel;
  @override
  Widget build(BuildContext context) {
     if (_lastLifecycleState == null)
     print("No lifecylce chage");

     else if(_lastLifecycleState==AppLifecycleState.resumed)
                  _myMenuModel.
          
    
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
    _myMenuModel.cartItemQuantityChanged(id, quantity);
  }


}

class MyMenuModel with ChangeNotifier{

  bool isLoading=false;
  //List<StallDataItem> stallItems;

  WalletDao _walletDao;
  int stallId;

  Map<String, String> headerMap = {HttpHeaders.authorizationHeader: "JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyOTg2LCJ1c2VybmFtZSI6Im91dGd1eSIsImV4cCI6MTU3OTQ0Mjk3OSwiZW1haWwiOiIifQ.jkUfUC72EpPGeD4tvKn0wRYfsMK27oudMuZW4W6-MbY"};
  List<StallModifiedMenuItem> menuItems= [];

  MyMenuModel(uiMessageListener,int stallId) {
    this._walletDao = WalletDao();
     this.stallId=stallId;
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

  Future<Null> cartItemQuantityChanged(int id, int quantity) async {
    if(quantity >= 0) {
      if(quantity == 0) {
        //cartItems.removeWhere((item) => item.itemId == id);
        menuItems.firstWhere((item) => item.itemId == id).quantity=quantity;
        notifyListeners();
        var result = await _walletDao.deleteCartItem(id);
        print("Result for delting item from cart = $result");
      }
      else if(quantity == 1) {
        //cartItems.removeWhere((item) => item.itemId == id);
        menuItems.firstWhere((item) => item.itemId == id).quantity=quantity;
        notifyListeners();
        var result = await _walletDao.insertCartItemfromMenuScreen(id, quantity, stallId);
        print("insert new intem to cart");
      }
      else {
        print("enter update with new quantity$quantity id$id");
        menuItems.firstWhere((item) => item.itemId == id).quantity = quantity;
        notifyListeners();
        _walletDao.updateCartItemQuantity(id, quantity);
      }
    }
  }







}
import 'dart:io';
import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:apogee_main/shared/utils/HexColor.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/CartItem.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/StallModifiedMenuItem.dart';
import 'package:apogee_main/wallet/view/CartQuantityWidget.dart';
import 'package:apogee_main/wallet/view/CartScreen.dart';
import 'package:apogee_main/wallet/view/CartScreen_BottomSheet.dart';
import 'package:apogee_main/wallet/view/MenuCategoryWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MenuItemWidget.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();

  int id;
  String stallName;
  CustomHttpNetworkClient networkClient;  
  WalletDao walletDao;
  MenuScreen(this.id,this.stallName,this.networkClient,this.walletDao);
}

class _MenuScreenState extends State<MenuScreen>  with WidgetsBindingObserver implements CartQuantityListener {


  MyMenuModel _myMenuModel;
  @override
  Widget build(BuildContext context) {
    
    return Screen(
        selectedTabIndex: -1,
        title: widget.stallName,
       child: ChangeNotifierProvider<MyMenuModel>(
          create: (BuildContext context) => MyMenuModel(widget.id,widget.walletDao),
          child: Container(
            color:screenBackground ,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Consumer<MyMenuModel>(
                    builder: (context, mymenumodel, child) {
                      _myMenuModel = mymenumodel;
                      mymenumodel.stallId=widget.id;
                      return mymenumodel.isLoading ? Center(child: CircularProgressIndicator(),) :
                      mymenumodel.menuItems.isEmpty ? Center(child: Text("No menu available for this stall"),) :
                      Container(
                        child: Column(
                          children: mymenumodel.cartItems.isEmpty?
                          <Widget>[
                            Expanded(
                              flex: 1,
                              child: ListView.builder(
                                itemCount: mymenumodel.getMenuCategories().length,
                                itemBuilder: (context, index) {
                                  return MenuCategoryWidget(menuItems:mymenumodel.mapItems[mymenumodel.categories[index]],
                                  cartQuantityListener: this );                  
                                },
                              ),
                            ),
                          ]:
                          <Widget>[
                             Expanded(
                              flex: 1,
                              child: ListView.builder(
                                itemCount: mymenumodel.getMenuCategories().length,
                                itemBuilder: (context, index) {
                                  return MenuCategoryWidget(menuItems:mymenumodel.mapItems[mymenumodel.categories[index]],
                                  cartQuantityListener: this );                      
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors:[HexColor('#FCF379'),HexColor('#FA5C76')]),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                   Container(
                                     margin: EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: cartItemBorder,width: 2)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(mymenumodel.cartItems.length.toString(),
                                      style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500)
                                      
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(16.0),
                                    child: GestureDetector(
                                      child: Text("View cart",
                                        style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white)
                                      ),
                                      onTap: () async {
                                        //await Navigator.of(context).pushNamed('/cart');
                                        await showModalBottomSheet(
                                          context: context, 
                                          builder:(context) =>
                                          Container(
                                            height:  MediaQuery.of(context).size.height * 0.75,
                                           
                                            decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0),topRight: Radius.circular(16.0)),
                                            color: screenBackground,
                                            
                                          ),
                                             
                                            child: CartScreenBottomSheet(widget.networkClient,widget.walletDao)),
                                          isScrollControlled: true,
                                          backgroundColor:Colors.transparent,
                                           
                                           //RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16)))
                                          );
                                        mymenumodel.displayStallMenuItems(widget.id);
                                        mymenumodel.getCartItems();
                                       /* controller.placeOrder();*/
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text("\u20B9 "+mymenumodel.getTotalPrice().toString(),
                                      style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white)),
                                  ),
                                ],
                              ),
                            )
                          ]
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

class MyMenuModel with ChangeNotifier{

  bool isLoading=false;
  //List<StallDataItem> stallItems;

  WalletDao _walletDao;
  int stallId;

  List<StallModifiedMenuItem> menuItems= [];
  List<StallModifiedMenuItem> cartItems=[];
  List<String> categories=[];
   Map<String,List<StallModifiedMenuItem>> mapItems=Map();
   List<Widget> menuWidgets=[];
     

  

  MyMenuModel(int stallId, WalletDao walletDao) {
    this._walletDao = walletDao;
     this.stallId=stallId;

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


  List<String> getMenuCategories(){
    if(categories.isNotEmpty){
      categories.clear();
      mapItems.clear();
    }
    for(var item in menuItems){
      if(mapItems.containsKey(item.category))
          mapItems[item.category].add(item);
      else
         {
           List<StallModifiedMenuItem> tempList=[item];
            mapItems[item.category]=tempList;
         }    
    }
       mapItems.keys.forEach((k) => categories.add(k));
      
     return categories;

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
    getCartItems();
  }

   Future<Null> getCartItems() async {
    print("try: dget cart items called in Menu Screen");
    cartItems = await _walletDao.getAllCartItems();
    // isLoading = false;
    notifyListeners();
    print("Updated CartItems = $cartItems");
  }
   
  int getTotalPrice(){
         int price=0;
         for(var item in cartItems){
           price+=item.quantity*item.currentPrice;
         }
         return price;
    
     }


}
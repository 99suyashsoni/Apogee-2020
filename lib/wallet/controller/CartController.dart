import 'dart:convert';
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/shared/network/errorState.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/StallModifiedMenuItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';

class CartController with ChangeNotifier {
  int state=0;
  String message="";
  WalletDao _walletDao;
  CustomHttpNetworkClient _networkClient;
  List<StallModifiedMenuItem> cartItems = [
   /* CartItem(
      basePrice: 200,
      currentPrice: 150,
      discount: 50,
      isVeg: true,
      itemId: 1,
      itemName: "Item 1",
      quantity: 2,
      vendorId: 2,
      vendorName: "Vendor 1"
    ),
    CartItem(
      basePrice: 200,
      currentPrice: 200,
      discount: 0,
      isVeg: false,
      itemId: 2,
      itemName: "Item 2",
      quantity: 1,
      vendorId: 2,
      vendorName: "Vendor 1"
    )*/
  ];
  bool isLoading = false;

// aks
  // CartController() {
  //   this._walletDao = WalletDao();
  //   this._networkClient = CustomHttpNetworkClient(
  //     baseUrl: prefix0.baseUrl,
  //     headers: headerMap
  //   );
  //    isLoading = true;
  //    loadCartItems();
  // }


  CartController({
    WalletDao walletDao,
    CustomHttpNetworkClient networkClient
  }): this._walletDao = walletDao,
      this._networkClient = networkClient {
     isLoading = true;
     loadCartItems();
  }


  Future<Null> loadCartItems() async {
    cartItems = await _walletDao.getAllCartItems();
    isLoading = false;
    notifyListeners();
    print("Updated CartItems = $cartItems");
  }

  Future<Null> cartItemQuantityChanged(int id, int quantity) async {
    if(quantity >= 0) {
      if(quantity == 0) {
        cartItems.removeWhere((item) => item.itemId == id);
        notifyListeners();
        var result = await _walletDao.deleteCartItem(id);
        print("Reslut for delting item from cart = $result");
      } else {
        cartItems.firstWhere((item) => item.itemId == id).quantity = quantity;
        notifyListeners();
        _walletDao.updateCartItemQuantity(id, quantity);
      }
    }
  }

  int getTotalPrice(){
      int price=0;
    for(var item in cartItems){
          price+=item.quantity*item.currentPrice;
    }
    return price;
  }

  Future<Null> placeOrder() async {
    isLoading = true;
    notifyListeners();
    cartItems.sort((item1, item2) => item1.stallId.compareTo(item2.stallId));
    Map<int, List<StallModifiedMenuItem>> map = groupBy(cartItems, (StallModifiedMenuItem item) => item.stallId);
    Map<String, dynamic> finalMap = Map();
    map.forEach((int key, List<StallModifiedMenuItem> value) {
      Map<String, dynamic> vendorMap = Map();
      value.forEach((StallModifiedMenuItem item) {
        vendorMap.addAll(item.toMapForOrder());
      });
      finalMap.addEntries([MapEntry(key.toString(), vendorMap)]);
    });
    Map<String, dynamic> body = {
      "orderdict": finalMap
    };
    print("Final map sent = $body");
    ErrorState errorState =await _networkClient.post("wallet/orders", json.encode(body), (response) async {
      await _walletDao.clearAllCartItems();
      cartItems.clear();
      isLoading = false;
      notifyListeners();
    },);
     if(errorState.state==2){
      state=2;
      message=errorState.message;
      isLoading=false;
      notifyListeners();
    }

  }

  @override
  void dispose() {
    print("try: dispose called on close cart");
    // As a safety measure, just before the cart is disposed, I update the database with the list that the controller has maintained
    // This is a logical step as the user would always see the data that was maintained by the controller. So, if we save the last
    // set of data that was maintained by the controller, there would never be any cases of data inconsistency visible to the user
    _walletDao.insertCartItems(cartItems);
    super.dispose();
  }
  
}
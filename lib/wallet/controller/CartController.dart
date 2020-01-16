import 'dart:convert';
import 'dart:io';
import 'package:apogee_main/shared/constants/strings.dart' as prefix0;
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/CartItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';

class CartController with ChangeNotifier {
  WalletDao _walletDao;
  CustomHttpNetworkClient _networkClient;
  Map<String, String> headerMap = {HttpHeaders.authorizationHeader: "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyOTg2LCJ1c2VybmFtZSI6Im91dGd1eSIsImV4cCI6MTU3OTQwNTYyMCwiZW1haWwiOiIifQ.Pci9SeEJ5Vb4q4Vtr3jjYVE9E3rYVhF44K8PcYOk03U"};
  List<CartItem> cartItems = [
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

  CartController() {
    this._walletDao = WalletDao();
    this._networkClient = CustomHttpNetworkClient(
      baseUrl: prefix0.baseUrl,
      headers: headerMap
    );
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

  Future<Null> placeOrder() async {
    isLoading = true;
    notifyListeners();
    cartItems.sort((item1, item2) => item1.vendorId.compareTo(item2.vendorId));
    Map<int, List<CartItem>> map = groupBy(cartItems, (CartItem item) => item.vendorId);
    Map<String, dynamic> finalMap = Map();
    map.forEach((int key, List<CartItem> value) {
      Map<String, dynamic> vendorMap = Map();
      value.forEach((CartItem item) {
        vendorMap.addAll(item.toMapForOrder());
      });
      finalMap.addEntries([MapEntry(key.toString(), vendorMap)]);
    });
    Map<String, dynamic> body = {
      "orderdict": finalMap
    };
    _networkClient.post("wallet/orders", json.encode(body), (response) async {
      await _walletDao.clearAllCartItems();
      cartItems.clear();
      isLoading = false;
      notifyListeners();
    },);
  }

  @override
  void dispose() {
    // As a safety measure, just before the cart is disposed, I update the database with the list that the controller has maintained
    // This is a logical step as the user would always see the data that was maintained by the controller. So, if we save the last
    // set of data that was maintained by the controller, there would never be any cases of data inconsistency visible to the user
    _walletDao.insertCartItems(cartItems);
    super.dispose();
  }
}
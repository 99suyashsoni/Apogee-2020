import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/CartItem.dart';
import 'package:flutter/cupertino.dart';

class CartController with ChangeNotifier {
  WalletDao _walletDao;
  List<CartItem> cartItems = [
    CartItem(
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
    )
  ];

  CartController() {
    this._walletDao = WalletDao();
    // loadCartItems();
  }

  Future<Null> loadCartItems() async {
    cartItems = await _walletDao.getAllCartItems();
    print("Updated CartItems = $cartItems");
  }

  Future<List<CartItem>> getCartItems() async {
    await _walletDao.getAllCartItems();
    return cartItems;
  }
}
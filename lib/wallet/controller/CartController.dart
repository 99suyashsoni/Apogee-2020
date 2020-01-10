import 'package:apogee_main/wallet/data/database/WalletDao.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/CartItem.dart';
import 'package:flutter/cupertino.dart';

class CartController with ChangeNotifier {
  WalletDao _walletDao;
  List<CartItem> cartItems;

  CartController() {
    this._walletDao = WalletDao();
    loadCartItems();
  }

  Future<Null> loadCartItems() async {
    cartItems = await _walletDao.getAllCartItems();
    print("Updated CartItems = $cartItems");
  }

  Future<List<CartItem>> getCartItems() async {
    return await _walletDao.getAllCartItems();
  }
}
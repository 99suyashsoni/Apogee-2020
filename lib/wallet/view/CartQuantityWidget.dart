import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:flutter/material.dart';

abstract class CartQuantityListener {
  void onQuantityChanged(int itemId, int quantity);
}

class CartQuantityWidget extends StatelessWidget {
  CartQuantityListener cartQuantityListener;
  int quantity;

  CartQuantityWidget({
    @required this.cartQuantityListener,
    this.quantity = 1
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        color: cartQuantityButtonBackground,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                bottomLeft: Radius.circular(5.0)
              ),
            ),
            child: Center(child: Icon(Icons.remove, color: cartQuantityButtonBackground, size: 20.0,)),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(quantity.toString(), style: Theme.of(context).textTheme.title.copyWith(color: Colors.white),),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5.0),
                bottomLeft: Radius.circular(5.0)
              ),
            ),
            child: Center(child: Icon(Icons.add, color: cartQuantityButtonBackground, size: 20.0,)),
          ),
        ],
      ),
    );
  }
}
import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:apogee_main/shared/utils/HexColor.dart';
import 'package:flutter/material.dart';

abstract class CartQuantityListener {
  void onQuantityChanged({@required int id, @required int quantity});
}

class CartQuantityWidget extends StatelessWidget {
  CartQuantityListener cartQuantityListener;
  int quantity;
  int itemId;

  CartQuantityWidget({
    @required this.cartQuantityListener,
    this.quantity = 1,
    @required this.itemId
  });

  @override
  Widget build(BuildContext context) {
    
    return quantity==0 ?
      Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        height: 32,
        decoration: BoxDecoration(
          gradient:LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors:[HexColor('#FCF379'),HexColor('#FA5C76')]),
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        child: GestureDetector(
          onTap: () {
            quantity += 1;
            cartQuantityListener.onQuantityChanged(id: itemId,quantity: quantity);      
          },
          child:
            Center(
              child: Text(
                'Add +',
                style: Theme.of(context).textTheme.body2.copyWith(color: cartAddQuantity),
          ),
            ),
        ),
    )
    :
    Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
         GestureDetector(
            onTap: () {
              quantity -= 1;
              if(quantity >= 0) {
                cartQuantityListener.onQuantityChanged(quantity: quantity, id: itemId);
              }
            },
            onLongPressEnd: (delegator) {
              quantity = 0;
              cartQuantityListener.onQuantityChanged(id: itemId, quantity: quantity);
            },
            child: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                gradient:LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors:[HexColor('#FCF379'),HexColor('#FA5C76')]
                ),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              child: Center(child: Icon(Icons.remove, color: cartAddQuantity, size: 16,)),
            ),
          ),
          Container(
            height: 24,
            margin: EdgeInsets.symmetric(horizontal: 4.0),
           
            child: Center(
              child: Text(quantity.toString(), style: Theme.of(context).textTheme.title.copyWith(fontSize:16,color: stallDescription),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              quantity += 1;
              cartQuantityListener.onQuantityChanged(
                id: itemId,
                quantity: quantity
              );
            },
            child: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                gradient:LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors:[HexColor('#FCF379'),HexColor('#FA5C76')]
                ),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              child: Center(child: Icon(Icons.add, color: cartAddQuantity, size: 16,)),
            ),
          )
      ],
    )
          ;

  }

  
}
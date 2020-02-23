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
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 32,

      decoration: BoxDecoration(
       gradient:LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: quantity==0?[HexColor('#FCF379'),HexColor('#FA5C76')]:[Colors.transparent,Colors.transparent]),
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Row(
        children: getQuauntityLayout(quantity,context),
        
      ),
    );
  }

  List<Widget> getQuauntityLayout(int quantity,BuildContext context){
    List<Widget> returnList=[];
    if(quantity!=0){
      return returnList=[ GestureDetector(
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.0),
                  bottomLeft: Radius.circular(5.0)
                ),
              ),
              child: Center(child: Icon(Icons.remove, color: Colors.red, size: 20.0,)),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(quantity.toString(), style: Theme.of(context).textTheme.title.copyWith(color: Colors.white),),
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5.0),
                  bottomRight: Radius.circular(5.0)
                ),
              ),
              child: Center(child: Icon(Icons.add, color: Colors.red, size: 20.0,)),
            ),
          ),
        ];
    }
    else{
      return returnList=[
        GestureDetector(
          onTap: () {
              quantity += 1;
              cartQuantityListener.onQuantityChanged(
                id: itemId,
                quantity: quantity
              );      
           },
          child: Text(
                  'Add +',
                  style: Theme.of(context).textTheme.body2.copyWith(color: cartAddQuantity),
           
          ),
        ),
      ];
    }

  }
}
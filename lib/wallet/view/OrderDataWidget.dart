
import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/Orders.dart';
import 'package:flutter/material.dart';

class OrderDataWidget extends StatelessWidget {
  Orders orders;
  /*CartQuantityListener cartQuantityListener;*/

   OrderDataWidget({
    @required this.orders,
   // @required this.cartQuantityListener
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                color: borderColor,
              )
          )
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(bottom: 4.0),
                    child: Text(orders.orderId.toString(), style: Theme.of(context).textTheme.title)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
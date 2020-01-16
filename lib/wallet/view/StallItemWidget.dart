import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/CartItem.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/StallDataItem.dart';
import 'package:apogee_main/wallet/view/CartQuantityWidget.dart';
import 'package:flutter/material.dart';

class StallItemWidget extends StatelessWidget {
  StallDataItem stallDataItem;
  /*CartQuantityListener cartQuantityListener;*/

  StallItemWidget({
    @required this.stallDataItem,
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
                    child: Text(stallDataItem.stallName, style: Theme.of(context).textTheme.title)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
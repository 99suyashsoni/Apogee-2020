import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/StallModifiedMenuItem.dart';
import 'package:apogee_main/wallet/view/CartQuantityWidget.dart';
import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  StallModifiedMenuItem item;
  CartQuantityListener cartQuantityListener;

  MenuItemWidget({
    @required this.item,
    @required this.cartQuantityListener
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16,0, 16, 16),
      //TODO: Max lines, size to all text boxes
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              child: Image.asset(item.isVeg?'assets/veg.png':'assets/non_veg.png',height: 16,width: 16,),
              margin: EdgeInsets.only(top:4.0,right: 4.0),
            ),
         Expanded(
            child: Container(
              // margin: EdgeInsets.only(left: 8.0,right: 8.0),
              child: 
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(item.itemName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.body2.copyWith(fontSize:16.0,color: menuScreenItemColor),
                    ),
                    Padding(padding: EdgeInsets.only(top:4),
                    child: item.discount==0?
                      Text(
                        '\u20B9 ${item.basePrice}',
                        style:Theme.of(context).textTheme.body2.copyWith(fontSize:12.0,color: menuScreenItemPrice),
                      ):  Row(
                        children:<Widget>[
                          Text(
                            '\u20B9 ${item.basePrice}',
                            style:Theme.of(context).textTheme.body2.copyWith(fontSize:12.0,color: menuScreenItemPrice,decoration: TextDecoration.lineThrough),
                         ),
                          Text(
                        '  \u20B9 ${item.currentPrice}',
                        style:Theme.of(context).textTheme.body2.copyWith(fontSize:12.0,color: menuScreenItemPrice),
                      ),
                       Text(
                        '  ~${item.discount}%',
                        style:Theme.of(context).textTheme.body2.copyWith(fontSize: 12.0,color: menuScreenItemPrice),
                      )
                        ],
                      )
                    )
                  ],
                ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(8.0,0,0,8.0),
            child: CartQuantityWidget(cartQuantityListener: cartQuantityListener, itemId: item.itemId, quantity: item.quantity,),
          )
        ],
      ),
    );
  }
}

//  children: <Widget>[
//           Container(
//             margin: EdgeInsets.only(right: 8.0),
//             child: Icon(
//               Icons.ac_unit,
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Column(
//               children: <Widget>[
//                 Container(
//                     margin: EdgeInsets.only(bottom: 4.0),
//                     child: Text(item.itemName, style: Theme.of(context).textTheme.title)
//                 ),
               
//                 Row(
//                   children: <Widget>[
//                     Container(
//                       margin: EdgeInsets.only(right: 4.0),
//                       child: Stack(
//                         children: <Widget>[
//                           Text("\u20B9 ${item.basePrice.toString()}", style: Theme.of(context).textTheme.subtitle.copyWith(color: Colors.black)),
//                           item.discount != 0 ? Container(
//                             height: 5.0,
//                             color: strikeThroughLine,
//                           ) : Opacity(
//                             opacity: 0.0,
//                             child: Container(),
//                           )
//                         ],
//                       ),
//                     ),
//                     item.discount == 0 ? Container() : Container(
//                       child: Text("\u20B9 ${item.currentPrice.toString()}", style: Theme.of(context).textTheme.subtitle.copyWith(color: strikeThroughLine),),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//           CartQuantityWidget(cartQuantityListener: cartQuantityListener, itemId: item.itemId, quantity: item.quantity,)
//         ],
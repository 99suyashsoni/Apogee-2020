// import 'package:apogee_main/shared/constants/appColors.dart';
// import 'package:apogee_main/wallet/data/database/dataClasses/CartItem.dart';
// import 'package:apogee_main/wallet/view/CartQuantityWidget.dart';
// import 'package:flutter/material.dart';

// class CartItemWidget extends StatelessWidget {
//   CartItem item;
//   CartQuantityListener cartQuantityListener;

//   CartItemWidget({
//     @required this.item,
//     @required this.cartQuantityListener 
//   });
  
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
//       margin: EdgeInsets.symmetric(vertical: 4.0),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: borderColor, 
//           )
//         )
//       ),
//       child: Row(
//         children: <Widget>[
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
//                   margin: EdgeInsets.only(bottom: 4.0),
//                   child: Text(item.itemName, style: Theme.of(context).textTheme.title)
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(bottom: 4.0),
//                   child: Text(item.vendorName, style: Theme.of(context).textTheme.subtitle)
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
//       ),
//     );
//   }
// }
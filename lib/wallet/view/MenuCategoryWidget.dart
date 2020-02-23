import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/StallModifiedMenuItem.dart';
import 'package:apogee_main/wallet/view/MenuItemWidget.dart';
import 'package:flutter/material.dart';

import 'CartQuantityWidget.dart';

class MenuCategoryWidget extends StatelessWidget {

CartQuantityListener cartQuantityListener;
List<StallModifiedMenuItem> menuItems;
bool isCart;
List<Widget> menuWidgets=[] ;
//Map<String,List<StallModifiedMenuItem>> menuMap;
List<String> categories;
  MenuCategoryWidget({
    @required this.menuItems,
    @required this.cartQuantityListener,
    @required this.isCart,
    //@required this.categories,
    
  });

  @override
  Widget build(BuildContext context) {
    menuWidgets.clear();
    int totalStallPrice=0;
    for(var menuItem in menuItems){
       totalStallPrice+=menuItem.currentPrice*menuItem.quantity;
        menuWidgets.add(MenuItemWidget(cartQuantityListener: cartQuantityListener,item: menuItem));
             }
      List<Widget> menuWidgetsFinal=[] ;  
      menuWidgetsFinal.clear();    
       menuWidgetsFinal.add(
      isCart?
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          Expanded(
                      child: Align(
               alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(isCart?menuItems[0].stallName??" ":menuItems[0].category??" ",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,    
                  style: Theme.of(context).copyWith().textTheme.headline.copyWith(color: menuScreenItemColor,fontSize: 24),
                  textAlign: TextAlign.left,
                  ),
                ),
            ),
          ) ,
          Align(
             alignment: Alignment.centerRight,
              child: Container(
                 margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(totalStallPrice.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,    
                style: Theme.of(context).copyWith().textTheme.headline.copyWith(color: menuScreenItemColor,fontSize: 24),
                textAlign: TextAlign.left,
                ),
              ),
          ) 
          ],
        ),
      )
      : Padding(
        padding: const EdgeInsets.fromLTRB(16.0,16.0,16.0,16.0),
        child: Align(
           alignment: Alignment.centerLeft,
            child: Text(isCart?menuItems[0].stallName??" ":menuItems[0].category??" ",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,    
            style: Theme.of(context).copyWith().textTheme.headline.copyWith(color: menuScreenItemColor,fontSize: 24),
            textAlign: TextAlign.left,
            ),
        ),
      )); 

      menuWidgetsFinal.addAll(menuWidgets);
    return Container(
      
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
        children: menuWidgetsFinal,
        )
    );
  }
}
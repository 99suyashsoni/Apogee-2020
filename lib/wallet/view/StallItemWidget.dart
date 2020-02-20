import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/StallDataItem.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
     
      margin: EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
     
      decoration: BoxDecoration(
         borderRadius: new BorderRadius.all(Radius.circular(8)),
         color: Colors.black
      ),
      child: Column(
          
          children: <Widget>[
             Expanded(
               flex: 1,
                            child: CachedNetworkImage(
  imageUrl:stallDataItem.imageUrl,
  imageBuilder: (context, imageProvider) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8)),
      image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.fill,
          //colorFilter:
            //  ColorFilter.mode(Colors.red, BlendMode.colorBurn)
            ),
    ),
  ),
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
),
             ),
            new Expanded(
              flex: 1,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
               
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: new Text(
                stallDataItem.stallName,
                maxLines: 2,
                overflow:TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: new TextStyle(
                  fontSize: 14.0,
                  
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                  ),
                ),
               
               Row(
                 children: <Widget>[
                   Expanded(
                     flex:1,
                     child: Divider(color: Colors.white,height: 1,thickness: 1,indent: 8,)
                   ),
                   Expanded(
                     flex:2,
                     child: Divider(color: Colors.black,height: 1,thickness: 1,indent: 8,)
                   )
                 ],
               ),
               // new Text('Coffee, shakes , sandwiches and more .....'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                                    child: new Text(
                'Shakes, Sandwiches, Beverages & more ------------------',
                maxLines: 2,
                overflow:TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: new TextStyle(
                  fontSize: 12.0,
                  
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                  ),
                ),
              ],
            ))
          ],
        ),
     
    );
  }
}
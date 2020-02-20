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
  imageUrl: stallDataItem.imageUrl,
  fit: BoxFit.cover,
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
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                stallDataItem.stallName,
                textAlign: TextAlign.left,
                style: new TextStyle(
                  fontSize: 14.0,
                  
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                  ),
                ),
               
                Divider(color:Colors.white,indent: 8.0,height: 1.0,thickness: 1.0),
               // new Text('Coffee, shakes , sandwiches and more'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                'Shakes, Sandwiches, Beverages & more',
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
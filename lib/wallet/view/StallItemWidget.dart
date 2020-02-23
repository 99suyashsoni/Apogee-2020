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
     
      // margin: EdgeInsets.fromLTRB(8.0,0.0,8.0,8.0),
     
      decoration: BoxDecoration(
         borderRadius: new BorderRadius.all(Radius.circular(8)),
         color: cardBackground
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
  placeholder: (context, url) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Image.asset('assets/stall_placeholder.png',fit: BoxFit.fill,),
    
  ),
  errorWidget: (context, url, error) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Image.asset('assets/stall_placeholder.png',fit:BoxFit.fill,),
  ),
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
                style: Theme.of(context).textTheme.body2.copyWith(fontWeight: FontWeight.w500,color: Colors.white)
                  ),
                ),
               
               Row(
                 children: <Widget>[
                   Expanded(
                     flex:1,
                     child: Divider(color: offStallNameDivider16,height: 2,thickness: 2,indent: 8,)
                   ),
                   Expanded(
                     flex:2,
                     child: Divider(color:Colors.transparent,height: 1,thickness: 1,indent: 8,)
                   )
                 ],
               ),
               // new Text('Coffee, shakes , sandwiches and more .....'),
               //TODO: Remove harded coded text for stall description.
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                                    child: new Text(
                'Shakes, Sandwiches, Beverages & more',
                maxLines: 2,
                overflow:TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style:Theme.of(context).textTheme.subtitle.copyWith(fontSize: 12,color: stallDescription),
                  ),
                ),
              ],
            ))
          ],
        ),
     
    );
  }
}
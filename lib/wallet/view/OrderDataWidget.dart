
import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:apogee_main/wallet/data/database/dataClasses/Orders.dart';
import 'package:flutter/material.dart';

abstract class OtpSeenListener {
  void onOtpSeenClicked({@required int orderId});
}

class OrderDataWidget extends StatelessWidget {
  Orders orders;
  OtpSeenListener otpSeenListener;

   OrderDataWidget({
    @required this.orders,
    @required this.otpSeenListener
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
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(bottom: 4.0),
                    child: Text(orders.orderId.toString(), style: Theme.of(context).textTheme.title)
                ),
                Container(
                    margin: EdgeInsets.only(bottom: 4.0),
                    child: Text(getStatus(orders.status),
                        style: Theme.of(context).textTheme.title
                    )
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Text(orders.otpSeen? orders.otp.toString(): "otp"),
                  onTap: (){
                    if(!orders.otpSeen){
                        otpSeenListener.onOtpSeenClicked(orderId: orders.orderId);
                    }

                  },
                ),
                Container(
                    margin: EdgeInsets.only(bottom: 4.0),
                    child: Text(orders.stallName,
                        style: Theme.of(context).textTheme.title,
                    )
                ),
              ],
            )
          )
        ],
      ),
    );
  }

  String getStatus( int status){

    switch(status){
      case 0:
        return "pending";
        break;
      case 1:
        return "accepted";
        break;
      case 2:
        return "ready";
        break;
      case 3:
        return "finished";
        break;
      case 4:
        return "declined";
        break;
      default:
        return "unknown";
    }
  }
}
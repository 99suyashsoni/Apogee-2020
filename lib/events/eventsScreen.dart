import 'dart:js';

import 'package:apogee_main/events/data/EventsModel.dart';
import 'package:apogee_main/shared/UIMessageListener.dart';
import 'package:flutter/material.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return  Screen(
      title: "Events",
      child:ChangeNotifierProvider<EventsModel>(
         create: (BuildContext context) => EventsModel(),
         child: EventList(),
         ),
      selectedTabIndex: 0,
    );
  
  }

}

class EventList extends StatelessWidget implements UIMessageListener{

  @override
  Widget build(BuildContext context) {
    final _eventsModel = Provider.of<EventsModel>(context);

    return Expanded(
      child:FutureBuilder(
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          else if(snapshot.connectionState == ConnectionState.done){
            //TODO: update list
          }
          else {
            onAlertMessageRecived(message: "Something went wrong!",);
            return Container();
          }    
        },
      ) ,

    );
  }

  @override
  void onAlertMessageRecived({String message, String title = "Alert", List<Widget> actions}) {
    // TODO: implement onAlertMessageRecived
  }

  @override
  void onAuthenticationExpiered() {
    // TODO: implement onAuthenticationExpiered
  }

  @override
  void onSnackbarMessageRecived({String message}) {
    // TODO: implement onSnackbarMessageRecived
  }

  @override
  void onToastMessageRecived({String message}) {
    // TODO: implement onToastMessageRecived
  }

}
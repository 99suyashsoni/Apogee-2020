import 'package:apogee_main/events/data/EventsModel.dart';
import 'package:flutter/material.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<EventsModel>(
    create: (BuildContext context) => EventsModel(),
    child: Screen(
      title: "Events",
      child: EventList(),
      selectedTabIndex: 0,
    ), 
    );
  
  }

}

class EventList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }

}
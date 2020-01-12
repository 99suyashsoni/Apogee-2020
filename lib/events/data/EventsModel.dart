import 'dart:convert';

import 'package:apogee_main/events/data/dataClasses/Events.dart';
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:flutter/cupertino.dart';
import 'package:apogee_main/events/data/database/EventsDao.dart';

class EventsModel with ChangeNotifier{
EventsDao _eventsDao;
List<Events> events;

CustomHttpNetworkClient _networkClient = CustomHttpNetworkClient(baseUrl: 'https://www.bits-oasis.org/',headers:{"Authorization":""},uiMessageListener:_uiMessageListener );

EventsModel(){
  this._eventsDao = EventsDao();
  fetchEvents(); 
}

Future<Null> fetchEvents() async{
  _networkClient.get('registration/events', insertAllEvents);
}

Future<void> insertAllEvents(String json) async{
  List<dynamic> body = jsonDecode(json);
  List<Events> newEvents = body.map((dynamic item) => Events.fromJson(item)).toList();
  print('$newEvents');
  }

Future<List<Events>> getAllEvents() async{
  
 return await _eventsDao.getAllEvents(); 
  
}
}
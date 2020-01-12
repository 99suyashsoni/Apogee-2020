import 'dart:convert';
import 'dart:io';

import 'package:apogee_main/events/data/dataClasses/Events.dart';
import 'package:apogee_main/shared/UIMessageListener.dart';
import 'package:apogee_main/shared/constants/strings.dart';
import 'package:apogee_main/shared/network/CustomHttpNetworkClient.dart';
import 'package:flutter/cupertino.dart';
import 'package:apogee_main/events/data/database/EventsDao.dart';

class EventsModel with ChangeNotifier{
EventsDao _eventsDao;
List<Events> events;
UIMessageListener _uiMessageListener;
CustomHttpNetworkClient _networkClient ;

EventsModel(this._uiMessageListener){
  this._eventsDao = EventsDao();
  this._networkClient =  CustomHttpNetworkClient(baseUrl:baseUrl,headers:{HttpHeaders.authorizationHeader:jwt},uiMessageListener: _uiMessageListener  );
}

Future<Null> fetchEvents() async{
  _networkClient.get('registration/events', (json) async{
  List<dynamic> body = jsonDecode(json);
  List<Events> newEvents = body.map((dynamic item) => Events.fromJson(item)).toList();
  print('$newEvents');
  _eventsDao.insertAllEvents(newEvents);
  });
}


Future<List<Events>> getAllEvents() async{
  
 return await _eventsDao.getAllEvents(); 
  
}
}
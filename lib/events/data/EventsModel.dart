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
List<Events> events = [];
bool isLoading = false;
UIMessageListener _uiMessageListener;
CustomHttpNetworkClient _networkClient ;

EventsModel(this._uiMessageListener){
  this._eventsDao = EventsDao();
  this._networkClient =  CustomHttpNetworkClient(baseUrl:baseUrl,headers:{HttpHeaders.authorizationHeader:jwt},uiMessageListener: _uiMessageListener  );
  fetchEvents();
}

Future<Null> fetchEvents() async{
  isLoading = true;
notifyListeners();
  _networkClient.get('registrations/events', (json) async{
   var body = jsonDecode(json);
 _eventsDao.insertAllEvents(body);
 isLoading = false;
 getAllEvents();
 notifyListeners();
  });
}


Future<Null> getAllEvents() async{

  events = await _eventsDao.getAllEvents();
  print('events:$events'); 
  isLoading = false;
  notifyListeners();
}
}
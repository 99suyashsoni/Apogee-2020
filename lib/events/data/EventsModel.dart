import 'package:apogee_main/events/data/dataClasses/EventsData.dart';
import 'package:flutter/cupertino.dart';
import 'package:apogee_main/events/data/database/EventsDao.dart';

class EventsModel with ChangeNotifier{
EventsDao _eventsDao;
List<EventsData> events;

EventsModel(){
  this._eventsDao = EventsDao();

}

Future<List<EventsData>> getAllEvents() async{
  return await _eventsDao.getAllEvents();
}
}
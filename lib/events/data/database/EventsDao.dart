import 'dart:convert';

import 'package:apogee_main/events/data/dataClasses/Events.dart';
import 'package:apogee_main/shared/database_helper.dart';

class EventsDao{

Future<Null> insertAllEvents(Map<String,dynamic> eventsJson) async{
  var database = await databaseInstance();
  var body = eventsJson['data'] as List<dynamic>;
  var rawEventList = body.map((f) => f['events']).toList();
  print('raweventList: $rawEventList');
  await database.transaction((transaction) async{
   await transaction.delete("events_data");
   for(var events in rawEventList){
     for(var event in events){
       print('body:$event');
     await transaction.rawInsert("""INSERT OR IGNORE INTO events_data(event_id,name,about,rules,time,date,details,venue,contact) VALUES(?,?,?,?,?,?,?,?,?) """,[
       int.parse(event["id"].toString()) ?? 0,
       event["name"].toString() ??"",
       event["about"].toString() ??"",
       event["rules"].toString() ??"",
       event["timings"].toString() ??"",
       event["date_time"].toString().split("T")[0] ??"",
       event["details"].toString() ??"",
       event["venue"].toString() ??"",
       event["contact"].toString() ??""
     ]);
   }
   }
  });
}

Future<List<Events>> getAllEvents() async{
  var database = await databaseInstance();
  List<Map<String,dynamic>> events = await database.rawQuery("SELECT * FROM events_data");
  if(events == null || events.isEmpty)
  return [];
  List<Events> eventList = [];
  for(var event in events){
    eventList.add(Events.fromMap(event));
  }
  return eventList;
}

Future<List<String>> getDates() async{
  var database = await databaseInstance();
  List<Map<String,dynamic>> dates = await database.rawQuery("SELECT DISTINCT date from events_data WHERE date!='TBA' OR date!=' ' ORDER BY date");
  if(dates==null||dates.isEmpty)
   return [];
  List<String> dateList =[];  
  for(var date in dates){
    if(date!=' ')
    dateList.add(date["date"].toString().trim());
  }

  return dateList;
}

Future<List<Events>> getEventsByDate(String date) async{
  var database = await databaseInstance();
  List<Map<String,dynamic>> events = await database.rawQuery("""SELECT * FROM events_data WHERE date = ? ORDER BY time""",[date]);
  if(events == null || events.isEmpty)
  return [];
  List<Events> eventList = [];
  for(var event in events){
    eventList.add(Events.fromMap(event));
  }
  return eventList;
}

}
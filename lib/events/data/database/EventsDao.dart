import 'package:apogee_main/events/data/dataClasses/Events.dart';
import 'package:apogee_main/shared/database_helper.dart';

class EventsDao{

Future<Null> insertAllEvents(Map<String,dynamic> eventsJson) async{
  var database = await databaseInstance();
  var body = eventsJson['data'] as List;
  var rawEventList = body.map((f) => f['events']).toList();
  print('body : $rawEventList');
  await database.transaction((transaction) async{
   await transaction.delete("events_data");
   for(var events in rawEventList.take(2)){
     for(var event in events){
     await transaction.rawInsert("""INSERT INTO events_data(event_id,name,about,rules,time,date,details,venue,contact) VALUES(?,?,?,?,?,?,?,?,?) """,[
       int.parse(event["id"].toString()) ?? 0,
       event["name"].toString() ??"",
       event["about"].toString() ??"",
       event["rules"].toString() ??"",
       event["timings"].toString() ??"",
       event["date_time"].toString() ??"",
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
}
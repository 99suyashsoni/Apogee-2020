import 'package:apogee_main/events/data/dataClasses/Events.dart';
import 'package:apogee_main/shared/database_helper.dart';

class EventsDao{

Future<Null> insertAllEvents(List<dynamic> eventsJson) async{
  var database = await databaseInstance();
  await database.transaction((transaction) async{
   database.delete("events_data");
   for(var events in eventsJson){
     transaction.rawInsert("""INSERT INTO events_data(event_id,name,about,rules,time,date,details,venue,contact) VALUES(?,?,?,?,?,?,?,?,?) """,[
       int.parse(events["id"].toString()) ??0,
       events["name"].toString() ??"",
       events["about"].toString() ??"",
       events["rules"].toString() ??"",
       events["timings"].toString() ??"",
       events["date_time"].toString() ??"",
       events["details"].toString() ??"",
       events["venue"].toString() ??"",
       events["contact"].toString() ??""
     ]);
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
class EventsData{
  List<RawEvent> allEvents;

  EventsData({this.allEvents});

}

class RawEvent{
  String category;
  List<Events> events;

  RawEvent({
    this.category,
    this.events
  });

}

class Events{
    final int id;
    String name;
    String about;
    String rules;
    String time;
    String date;
    String venue;
    String details;
    String contact;

Events({
    this.id,
    this.name,
    this.about,
    this.rules,
    this.time,
    this.date,
    this.venue,
    this.details,
    this.contact
});




factory Events.fromMap(Map<String,dynamic> response) => Events(
    id : int.parse(response["event_id"].toString()),
    name : response["name"].toString(),
    about : response["about"].toString(),
    rules : response["rules"].toString(),
    time : response["time"].toString(),
    date : response["date"].toString(),
    venue : response["venue"].toString(),
    details : response["details"].toString(),
    contact : response["contact"].toString()
);

}
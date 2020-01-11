class EventsData{
    int id;
    String name;
    String about;
    String rules;
    String time;
    String date;
    String venue;
    String details;
    String contact;

EventsData({
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

factory EventsData.fromMap(Map<String,dynamic> response) => EventsData(
    id : int.parse(response["event_id"].toString()),
    name : response["name"].toString(),
    about : response["about"].toString(),
    rules : response["rules"].toString(),
    time : response["time"].toString(),
    date : response["date"].toString,
    venue : response["venue"].toString(),
    details : response["details"].toString(),
    contact : response["contact"].toString()
);
}
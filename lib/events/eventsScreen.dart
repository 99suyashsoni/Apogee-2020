
import 'package:apogee_main/events/data/EventsModel.dart';
import 'package:apogee_main/events/data/dataClasses/Events.dart';
import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:flutter/material.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:apogee_main/shared/constants/app_theme_data.dart';

class EventsScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return  Screen(
      title: "Events",
      selectedTabIndex: 2,
      child: EventList(),
    );
  
  }
}


class EventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  
    return Container(
      child:
      Column(
        children:<Widget>[
          Expanded(
          flex: 1,
          child: Consumer<EventsModel>(
            builder: (context,controller,child){
              return controller.isLoading?Center(child: CircularProgressIndicator(),):
              controller.events.isEmpty? Center(child: Text('No data',style: TextStyle(color: Colors.black),),):
              Column(
                 crossAxisAlignment:CrossAxisAlignment.center,
                 children:<Widget>[
                SizedBox(height: 20.0,),
                 Expanded(
                   flex: 1,
                   child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.dates.length,
                            itemBuilder: (context,index){
                            return GestureDetector(
                               onTap: (){
                               controller.getEventsByDate(controller.dates[index]);
                               },
                            child: Padding(padding: EdgeInsets.all(8.0),
                            child:Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top:30.0),
                             child: Dates(eventDate: controller.dates[index],)
                             ) ,
                             ),
                         );
                       },
                     ),
                   ),
                 Expanded(
                   flex: 6,
                child:ListView.builder(
                itemCount: controller.events.length,
                itemBuilder: (context,index){
                  return EventCard(event: controller.events[index],);
                },
              ),
        ),],);
      } ,
      ),
        ),
        ],),
         );
   
  }

}

class Dates extends StatelessWidget{
  final String eventDate;
  String date;
  Dates({@required this.eventDate});
  @override
  Widget build(BuildContext context) {
      if(eventDate.isEmpty)
        date = '';
      if(eventDate.endsWith('19')){
         date ='Day 1';
       }
       else if(eventDate.endsWith('20'))
         date ='Day 2';
       else if(eventDate.endsWith('21'))
         date='Day 3';
       else 
         date='Day 4';  
    return Container(
       child: Text(date,style: eventCardThemeData.textTheme.subhead,),
    );
  }

}
class EventCard extends StatelessWidget{
final Events event;
EventCard({@required this.event});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: eventCardBackground
      ),
      child: Column(
        children: <Widget>[
          Row(
             children: <Widget>[
                 Container(
                   child: Expanded(
                     flex:1,
                     child: Text(event.name,style:eventCardThemeData.textTheme.headline),
                   ),
                 ),
                 Container(child: Icon(Icons.bookmark_border,color: eventBookmark,))
             ],
          ),
          SizedBox(
            height:20.0
          ),
          Container(
            child: Text(event.about,
            style: eventCardThemeData.textTheme.body1,),
          ),
          SizedBox(
            height: 20.0
          ) ,
          Container(child: Text(event.date,style: eventCardThemeData.textTheme.body2,),alignment: Alignment.bottomRight,) 
        ],
      ),
    );
  }

}



import 'package:apogee_main/events/data/EventsModel.dart';
import 'package:apogee_main/events/data/dataClasses/Events.dart';
import 'package:flutter/material.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EventsScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return  Screen(
      title: "Events",
      child: EventList(),
      selectedTabIndex: 2,
    );
  
  }
}

String formatDate(String date){
  return new DateFormat.MMMd().format(DateTime.parse(date));
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
                             decoration: BoxDecoration(
                               color: Colors.accents[index % Colors.accents.length],
                               boxShadow: [new BoxShadow(
                                 color: Colors.grey[100],
                                 blurRadius: 20.0,
                               ),],
                               shape: BoxShape.circle
                             ),
                             child: Center(child: Text(formatDate(controller.dates[index]),style: TextStyle(color: Colors.white),))
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
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child:Card(
                        elevation: 2.0,
                        child: Column(
                           mainAxisSize: MainAxisSize.max,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Text(controller.events[index].name,
                                 style: TextStyle(fontSize: 20.0,color: Colors.black),
                                 ),
                               ),
                            
                              ],
                            ),
                         ),
              );
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


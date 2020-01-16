import 'package:apogee_main/events/data/EventsModel.dart';
import 'package:flutter/material.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return  Screen(
      title: "Events",
      child:ChangeNotifierProvider<EventsModel>(
         create: (BuildContext context) => EventsModel(),
         child: EventList(),
         ),
      selectedTabIndex: 2,
    );
  
  }
}

class EventList extends StatelessWidget {
 EventList();
  @override
  Widget build(BuildContext context) {
  
    return Container(
      child: Column(children: <Widget>[
        Expanded(
          flex: 1,
          child: Consumer<EventsModel>(
            builder: (context,controller,child){
              return controller.isLoading?Center(child: CircularProgressIndicator(),):
              controller.events.isEmpty? Center(child: Text('No data',style: TextStyle(color: Colors.black),),):
              Container(
                child: ListView.builder(
                itemCount: controller.events.length,
                itemBuilder: (context,index){
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                       Text(controller.events[index].name,
                       style: TextStyle(fontSize: 20.0,color: Colors.black),),
                        SizedBox(height: 10.0,),
                      ],),
                  );
                },
              ),
             
              );
            } ,
          ),
        )
      ],),
    );
   
  }

}

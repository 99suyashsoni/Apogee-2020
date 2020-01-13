import 'package:apogee_main/events/data/EventsModel.dart';
import 'package:apogee_main/events/data/dataClasses/Events.dart';
import 'package:apogee_main/shared/UIMessageListener.dart';
import 'package:flutter/material.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatelessWidget implements UIMessageListener{
  @override
  Widget build(BuildContext context) {

    return  Screen(
      title: "Events",
      child:ChangeNotifierProvider<EventsModel>(
         create: (BuildContext context) => EventsModel(this),
         child: EventList(nuiMessageListener: this,),
         ),
      selectedTabIndex: 2,
    );
  
  }

  @override
  void onAlertMessageRecived({String message, String title = "Alert", List<Widget> actions}) {
    // TODO: implement onAlertMessageRecived
  }

  @override
  void onAuthenticationExpiered() {
    // TODO: implement onAuthenticationExpiered
  }

  @override
  void onSnackbarMessageRecived({String message}) {
    // TODO: implement onSnackbarMessageRecived
  }

  @override
  void onToastMessageRecived({String message}) {
    // TODO: implement onToastMessageRecived
  }

}

class EventList extends StatelessWidget {
 final UIMessageListener nuiMessageListener;
 EventList({@required this.nuiMessageListener}); 
  @override
  Widget build(BuildContext context) {
    final _eventsModel = Provider.of<EventsModel>(context);

    return FutureBuilder(
        future: _eventsModel.getAllEvents(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              final events = (snapshot.data as List<Events>).toList();
              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context,index){
                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                       Text(events[index].name,
                       style: TextStyle(fontSize: 20.0,color: Colors.black),),
                        SizedBox(height: 10.0,),
                      ],),
                  );
                },
              );
            }
            if(snapshot.hasError){
             nuiMessageListener.onSnackbarMessageRecived(message: "Error fetching events!");
              print('error fetching events ');
              return Container();
            }
          }
          else {
           nuiMessageListener.onAlertMessageRecived(message: "Something went wrong!",);
            return Container();
          }    
          return Center(child: Text('No data',style: TextStyle(color: Colors.black),),);
        },
        
      );
  }

}
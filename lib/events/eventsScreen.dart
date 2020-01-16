
import 'package:apogee_main/events/data/EventsModel.dart';
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


import 'package:apogee_main/events/data/EventsModel.dart';
import 'package:apogee_main/events/data/dataClasses/Events.dart';
import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:flutter/material.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:provider/provider.dart';
import 'package:apogee_main/shared/constants/app_theme_data.dart';

class EventsScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return  Screen(
      title: "Events",
<<<<<<< HEAD
=======
      child: EventList(),
      endColor: topLevelScreensGradientEndColor,
      screenBackground: orderScreenBackground,
      startColor: topLevelScreensGradientStartColor,
>>>>>>> fe075689815c0e0ae2c4d83756a3d58e7426fe3b
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
              controller.events.isEmpty? Center(child: Text('No data',style: cardThemeData.textTheme.headline,),):
              EventView(ncontroller: controller);
      } ,
      ),
        ),
        ],),
         );
   
  }

}

class EventView extends StatefulWidget{
  final EventsModel ncontroller;
  EventView({@required this.ncontroller});
  @override
  State<StatefulWidget> createState() => EventViewState();
  
}

class EventViewState extends State<EventView> with SingleTickerProviderStateMixin{
  PageController _pageController;
  TabController _tabController;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: widget.ncontroller.dates.length, vsync: this);
  }
    void _nextPage(int delta) {
    final int newIndex = _tabController.index + delta;
    if (newIndex < 0 || newIndex >= _tabController.length) return;
    _tabController.animateTo(newIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
       
      children: <Widget>[
        SizedBox(height: 20.0,),

        new TabBar(
                    controller: _tabController,
                    tabs: List<Widget>.generate(widget.ncontroller.dates.length,(int index){
                          return new Tab(
                             child: Padding(padding: EdgeInsets.all(8.0),
                             child:Container(
                               height: 190,
                               width: 200,
                             alignment: Alignment.center,
                             margin: EdgeInsets.only(top:30.0),
                             child: Dates(eventDate: widget.ncontroller.dates[index],)
                             ) ,
                   ),
                );
              }
             ),
           
          ),

        PageView.builder(controller: _pageController,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index){
          _nextPage(index);
        },
        itemCount: widget.ncontroller.dates.length,
        itemBuilder:(_,index){
        widget.ncontroller.getEventsByDate(widget.ncontroller.dates[index]);
        return EventPage(eventList: widget.ncontroller.events);
  }),
      ],
    );
  }

  @override
  void dispose(){
    super.dispose();
    _pageController.dispose();
    _tabController.dispose();
  }

}

class EventPage extends StatelessWidget{
  final List<Events> eventList;
  EventPage({@required this.eventList});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
                  flex: 6,
                  child:ListView.builder(
                  itemCount: eventList.length,
                  itemBuilder: (context,index){
                    return EventCard(event: eventList[index],);
                  },
                ),
          ),
    );
  }

}

class Dates extends StatelessWidget{
  final String eventDate;
  String date;
  Dates({@required this.eventDate});
  @override
  Widget build(BuildContext context) {
      //TODO: change dates according to Apogee dates
      if(eventDate.endsWith('19')){
         date ='Day 1';
       }
       else if(eventDate.endsWith('20'))
         date ='Day 2';
       else if(eventDate.endsWith('21'))
         date='Day 3';
       else if(eventDate.endsWith('22'))
         date='Day 4';  
       else if(eventDate.endsWith('23'))
        date ='Day 5';
        else
          return Container();  
    return Container(
       child: Text(date,style: cardThemeData.textTheme.title,),
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
                     child: Text(event.name,style:cardThemeData.textTheme.headline),
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
            style: cardThemeData.textTheme.body1,),
          ),
          SizedBox(
            height: 20.0
          ) ,
          Container(child: Text(event.date,style: cardThemeData.textTheme.body2,),alignment: Alignment.bottomRight,) 
        ],
      ),
    );
  }

}


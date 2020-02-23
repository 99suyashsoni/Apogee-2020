
import 'package:apogee_main/events/data/EventsModel.dart';
import 'package:apogee_main/events/data/dataClasses/Events.dart';
import 'package:apogee_main/shared/constants/appColors.dart';
import 'package:flutter/material.dart';
import 'package:apogee_main/shared/screen.dart';
import 'package:provider/provider.dart';
import 'package:apogee_main/shared/constants/app_theme_data.dart';
import '../shared/constants/appColors.dart';
import '../shared/constants/app_theme_data.dart';

class EventsScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return  Screen(
      title: "Events",
      child: EventList(),
      endColor: eventsGradientEndColor,
      screenBackground: orderScreenBackground,
      startColor: eventsGradientStartColor,
      selectedTabIndex: 2,
    );
  
  }
}

              
         
class EventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  
    return Container(
      child:
      Consumer<EventsModel>(
        builder: (context,controller,child){
          return controller.isLoading?Center(child: CircularProgressIndicator(),):
          controller.events.isEmpty? Center(child: Text('No data',style: cardThemeData.textTheme.headline,),):
          Container(child: EventView(ncontroller: controller));
      } ,
      )     );
   
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
     final initialPage =
        widget.ncontroller.events.indexWhere((events) => events.date == "2019-10-19");

    if (initialPage == -1) {
      _pageController = PageController();
    } else {
      _pageController = PageController(initialPage: initialPage);
    }
   _tabController = TabController(length: widget.ncontroller.dates.length, vsync: this);
  }
   
void _nextPage(int delta) {
  print(':called');
    final int newIndex = _tabController.index + delta;
    if (newIndex < 0 || newIndex >= _tabController.length) return;
    _tabController.animateTo(newIndex);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      // Container(height: 20.0,),

    Container(
      child: new TabBar(
          
          controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          tabs: List<Widget>.generate(widget.ncontroller.dates.length,(int index){
      return new Tab(
         //child: Padding(padding: EdgeInsets.all(8.0),
         child:Container(
        //   padding: EdgeInsets.all(8.0),
        // alignment: Alignment.center,
        // margin: EdgeInsets.only(top:30.0),
         child: Dates(eventDate: widget.ncontroller.dates[index],)
         ) ,
         //  ),
      );
          }
           ),
           
          ),
    ),

      Expanded(
              child: PageView.builder(controller: _pageController,
              scrollDirection: Axis.horizontal,
              
              onPageChanged: (index){
                     _nextPage(index);
             },
          itemCount: widget.ncontroller.dates.length,
          itemBuilder:(_,index){
          widget.ncontroller.getEventsByDate(widget.ncontroller.dates[index]);
          return EventPage(eventList: widget.ncontroller.events);
  }),
      ),
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
    return Column(
      children: <Widget>[
        Expanded(
                    flex: 1,
                    child:ListView.builder(
                    itemCount: eventList.length,
                    itemBuilder: (context,index){
                      return EventCard(event: eventList[index],);
                    },
                  ),
            ),
      ],
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
       child: Text(date,style: cardThemeData.textTheme.subhead,),
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
        color: orderCardBackground
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
              child: Text(event.details.split(">")[1],overflow: TextOverflow.ellipsis,
              style: cardThemeData.textTheme.subtitle,),
            ),
          SizedBox(
            height: 20.0
          ) ,
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(event.time,style: cardThemeData.textTheme.subhead,),
                SizedBox(width:2,),
                Text(',',style:cardThemeData.textTheme.subhead),
                SizedBox(width:2),
                Text(event.venue,style: cardThemeData.textTheme.subhead,)
              ],
            )
            ,alignment: Alignment.bottomRight,) 
        ],
      ),
    );
  }

}


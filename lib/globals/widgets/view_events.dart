import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ujap/controllers/home.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/attend_meeting.dart';
import 'package:ujap/globals/widgets/confirmation_attendance.dart';
import 'package:ujap/globals/widgets/curve_containers.dart';
import 'package:ujap/pages/drawer_page.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/confirmed_attendance.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/event_tabbar/apercu.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/event_tabbar/participants.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/message_controller.dart';
import 'package:ujap/services/notifications.dart';
import 'package:ujap/services/presence.dart';
import 'package:ujap/services/searches/search_service.dart';
import 'package:url_launcher/url_launcher.dart';

List eventStatuscurrentEvent;
int events_attendedcurrentEvent;
int events_allocationcurrentEvent;
List eventsAttended_clientcurrentEvent;

class ViewEvent extends StatefulWidget {
  final Map eventDetail;
  final bool pastEvent;
  ViewEvent({Key key, @required this.eventDetail,this.pastEvent}) : super(key : key);
  @override
  _ViewEventState createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent> with SingleTickerProviderStateMixin  {
  TabController _tab;
  int _tabIndex = 0;
  List attendees = [];

  _geteventstatus()async{
    setState(() {
      eventStatuscurrentEvent = events_status.where((s) {
        return s['event_id'].toString().toLowerCase() == widget.eventDetail['id'].toString().toLowerCase();
      }).toList();
      events_attendedcurrentEvent = int.parse( eventStatuscurrentEvent[0]['accepted_clients'].length.toString());
      events_allocationcurrentEvent = int.parse(eventStatuscurrentEvent[0]['allocation'].toString());
      eventsAttended_clientcurrentEvent =  eventStatuscurrentEvent[0]['accepted_clients'];
      print('ATTENDED :'+eventsAttended_clientcurrentEvent.toString());

    });
  }

  getDatas()async*{
    setState(() {
       eventStatuscurrentEvent = eventStatuscurrentEvent;
       events_attendedcurrentEvent = events_attendedcurrentEvent;
       events_allocationcurrentEvent = events_allocationcurrentEvent;
       eventsAttended_clientcurrentEvent = eventsAttended_clientcurrentEvent;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _geteventstatus();
    _tab = new TabController(length: 2, vsync: this);
    _getAttendees();
  }
  void _getAttendees() async {
    await getEventAttendess(widget.eventDetail['id']).then((value) => setState(() => attendees = value));
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getDatas(),
      builder: (context, snapshot) {
        return Scaffold(
          body: Stack(
            children: [
              SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(0),
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Hero(
                              transitionOnUserGestures: true,
                              tag: widget.eventDetail['id'],
                              child: Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: ClipPath(
                                    clipper: CurvedBottom(),
                                    child: Container(
                                      height: screenwidth < 700
                                          ? screenheight / 2.8
                                          : screenheight / 2.7,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          image: DecorationImage(
                                              fit: widget.eventDetail['filename'].toString() == "null" || widget.eventDetail['filename'].toString() == "" ? BoxFit.contain : BoxFit.cover,
                                              image: widget.eventDetail['filename'].toString() == "null" || widget.eventDetail['filename'].toString() == "" ? AssetImage("assets/no_image_available.png") : NetworkImage("https://ujap.checkmy.dev/storage/events/${widget.eventDetail['id']}/${widget.eventDetail['filename']}")
                                          )
                                      ),
                                    ),
                                  )
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          child: Text(widget.eventDetail['name'].toString(), style: TextStyle(fontSize: screenwidth < 700 ? screenheight / 40 : 30, fontFamily: 'Google-Bold',
                                              fontWeight: FontWeight.bold,
                                              color:  Colors.black87),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 8),
                                          child: Row(
                                            children: [
                                              Icon(Icons.location_on,size: screenwidth < 700 ? screenwidth/25 : screenwidth/30,color: Colors.grey[600],),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Expanded(
                                                child: Text(widget.eventDetail['address'].toString() == "null" ? 'TBA' : widget.eventDetail['address'].toString(), style: TextStyle(
                                                    fontSize: screenwidth < 700
                                                        ? screenheight / 65
                                                        : 20,
                                                    fontFamily: 'Google-Bold',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[600]),),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(vertical: 5),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: screenwidth < 700 ? screenwidth/25 : screenwidth/30,
                                                height: screenwidth < 700 ? screenwidth/25 : screenwidth/30,
                                                child: Image(
                                                  color: Colors.grey[600],
                                                  image:  AssetImage('assets/view_events_icons/city.png'),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(widget.eventDetail['city'].toString() == "null" ? 'TBA' : widget.eventDetail['city'].toString() , style: TextStyle(
                                                  fontSize: screenwidth < 700
                                                      ? screenheight / 65
                                                      : 20,
                                                  fontFamily: 'Google-Bold',
                                                  fontWeight: FontWeight.bold,
                                                  color:  Colors.grey[600]),),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                width: screenwidth < 700 ? screenwidth/25 : screenwidth/30,
                                                height: screenwidth < 700 ? screenwidth/25 : screenwidth/30,
                                                child: Image(
                                                  color: Colors.grey[600],
                                                  image:  AssetImage('assets/view_events_icons/state.png'),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(widget.eventDetail['state'].toString() == "null" ? 'TBA' : widget.eventDetail['state'].toString() , style: TextStyle(
                                                  fontSize: screenwidth < 700
                                                      ? screenheight / 65
                                                      : 20,
                                                  fontFamily: 'Google-Bold',
                                                  fontWeight: FontWeight.bold,
                                                  color:  Colors.grey[600]),),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(vertical: 5),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: screenwidth < 700 ? screenwidth/25 : screenwidth/30,
                                                height: screenwidth < 700 ? screenwidth/25 : screenwidth/30,
                                                child: Image(
                                                  color: Colors.grey[600],
                                                  image:  AssetImage('assets/view_events_icons/country.png'),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(widget.eventDetail['country'].toString() == "null" ? 'TBA' : widget.eventDetail['country'].toString() , style: TextStyle(
                                                fontSize: screenwidth < 700
                                                    ? screenheight / 65
                                                    : 20,
                                                fontFamily: 'Google-Bold',
                                                fontWeight: FontWeight.bold,
                                                color:  Colors.grey[600],),),
                                            ],
                                          ),

                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: ()=> this.launchMap(widget.eventDetail['address']),
                                    child: Container(
                                      width: screenwidth < 700 ? screenwidth/8 : screenwidth/13,
                                      height: screenwidth < 700 ? screenwidth/8 : screenwidth/13,
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.circular(1000.0),
                                        border: Border.all(color: kPrimaryColor.withOpacity(0.2),width: 3),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.4),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 0), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Center(
                                          child: Image.asset('assets/view_events_icons/google_map.png',
                                            color: Colors.white,
                                            fit: BoxFit.cover,
                                          )
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              child: TabBar(
                                  indicatorColor: kPrimaryColor,
                                  onTap: (index){
                                    setState(() {
                                      _tabIndex = index;
                                      print(attendees.toString());
                                    });
                                  },
                                  controller: _tab,
                                  tabs: [
                                    Tab(
                                      child: AnimatedDefaultTextStyle(
                                        duration: Duration(
                                            milliseconds: 400
                                        ),
                                        child: Text("Aperçu"),
                                        style: TextStyle(
                                            fontSize: screenwidth < 700 ? screenwidth/30 : 20,
                                            fontWeight: FontWeight.w700,
                                            color: _tabIndex == 0 ? Colors.black : Colors.grey[400]
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: AnimatedDefaultTextStyle(
                                        duration: Duration(
                                            milliseconds: 400
                                        ),
                                        child: Text("Participants"),
                                        style: TextStyle(
                                            fontSize: screenwidth < 700 ? screenwidth/30 : 20,
                                            fontWeight: FontWeight.w700,
                                            color: _tabIndex == 1 ? Colors.black : Colors.grey[400]
                                        ),
                                      ),
                                    )
                                  ]
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: _tabIndex == 0 ? screenheight/7 : screenheight/3,
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              child: TabBarView(
                                physics: NeverScrollableScrollPhysics(),
                                controller: _tab,
                                children: [
                                  ApercuTab(
                                    data: widget.eventDetail,
                                    attendees: attendees,
                                    attended: events_attendedcurrentEvent,
                                  ),
                                  Participants(
                                    participants: eventsAttended_clientcurrentEvent,
                                    type: widget.eventDetail['type'].toString(),
                                    // eventsAttended_client: eventsAttended_clientcurrentEvent,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _tabIndex == 1 ? Container() :  Container(
                        child:  eventStatuscurrentEvent[0]['accepted_clients'].toString().contains('client_id: '+userdetails['id'].toString()) || eventStatuscurrentEvent[0]['declined_clients'].toString().contains('client_id: '+userdetails['id'].toString()) ?
                        ConfirmAttendance(widget.eventDetail,attendees,eventStatuscurrentEvent) :
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                          height: 60,
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  width: screenwidth/2,
                                  decoration: BoxDecoration(
                                      color: !SelfChecker().isPresent(toCheck: attendees) ? Color.fromRGBO(1, 80, 147, 0.9) : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Color.fromRGBO(1, 80, 147, 0.9))
                                  ),
                                  alignment: Alignment.center,
                                  child: Builder(
                                    builder:(context)=> FlatButton(
                                        padding: const EdgeInsets.all(0),
                                        onPressed: (){
                                            confirmation(context,widget.eventDetail['ticket']['id'].toString(),'0',widget.eventDetail);
                                        },
                                        child: Text('Indisponible ce jour',
                                          style: TextStyle(
                                              fontSize: screenwidth < 700 ? screenheight/53 : 25,
                                              fontFamily: 'Google-Bold',
                                              fontWeight: FontWeight.bold,
                                              color: !SelfChecker().isPresent(toCheck: attendees) ?  Colors.white : kPrimaryColor
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: Container(
                                      width: screenwidth/2,
                                      decoration: BoxDecoration(
                                          color: SelfChecker().isPresent(toCheck: attendees) ? Color.fromRGBO(1, 80, 147, 0.9) : Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Color.fromRGBO(1, 80, 147, 0.9))
                                      ),
                                      alignment: Alignment.center,
                                      child: Builder(
                                        builder:(context)=>  FlatButton(
                                          onPressed: (){
                                            confirmation(context,widget.eventDetail['ticket']['id'].toString(),'1',widget.eventDetail);
                                          },
                                          child: Center(
                                            child: Text('Confirmer ma présence',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/53 : 25,fontFamily: 'Google-Bold',fontWeight: FontWeight.bold,color:  SelfChecker().isPresent(toCheck: attendees) ? Colors.white : kPrimaryColor),textAlign: TextAlign.center,),
                                          ),
                                        ),
                                      )
                                  )
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    child: Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(1000.0)
                        ),
                        child: Icon(Icons.arrow_back, color: Colors.white,size: 26,)),
                    onTap: (){
                      setState(() {
                        filterSearchService.filter(past: pastTicketMatches);
                        if (notifPage){
                          Navigator.of(context).pop(null);
                        }else{
                          if (taskList.toString() != "[]"){
                            taskList.clear();
                          }
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen(false)));
                        }
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }

  launchMap(String address) async {
    String query = Uri.encodeComponent(address);
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    }
  }
}

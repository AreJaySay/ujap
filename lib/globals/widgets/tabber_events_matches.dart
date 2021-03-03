import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/events_sub_pages_variables.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/confirmation_attendance.dart';
import 'package:ujap/globals/widgets/view_matches.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/events_list_data.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/navigate_match_events.dart';
import 'package:ujap/services/searches/search_service.dart';

List eventStatusEvents;
double events_attendedEvents = 0;
List eventsAttended_clientEvents;
double events_allocationEvents = 0;
int allocation = 0;
int participant = 0;

class View_events_tabbar extends StatefulWidget {
  final Map eventDetail;
  final String _matchID,type,matchName;
  List attendedMeeting;
  List eventStatus;
  View_events_tabbar(this.eventDetail,this._matchID,this.type,this.attendedMeeting,this.matchName,this.eventStatus);
  @override
  _View_events_tabbarState createState() => _View_events_tabbarState();
}

class _View_events_tabbarState extends State<View_events_tabbar>  {
  TabController _tabController;
  var _clientName = "";
  var _clientLastname = "";
  var _clientTelephone = "";
  var _clientEmail = "";
  var _clientCountry = "";
  var _attend_pass = "No";
  List _clientsAttended;
  List _local;

  List _attendedMeeting;
  
  getData_Attended(){
    setState(() {
      eventStatusEvents = widget.eventStatus.where((s) {
        return s['event_id'].toString().toLowerCase() == widget._matchID.toString().toLowerCase();
      }).toList();

       events_attendedEvents = double.parse( eventStatusEvents[0]['accepted_clients'].length.toString());
        participant = int.parse(eventStatusEvents[0]['accepted_clients'].length.toString());
       events_allocationEvents = double.parse(eventStatusEvents[0]['allocation'].toString());
        allocation = int.parse(eventStatusEvents[0]['allocation'].toString());
       eventsAttended_clientEvents =  eventStatusEvents[0]['accepted_clients'];

      // _attendedMeeting = attended_Meeting.where((s){
      //   print('MEETING ID'+s.toString().replaceAll(userdetails.toString(), '').toString());
      //   return s.toString().replaceAll(userdetails.toString(), '') == widget._matchID.toString();
      // }).toList();
      //
      print('MEETING CURRENT ATTENDED :'+eventsAttended_clientEvents.toString());
    });
  }

  Stream attendedData()async*{
    setState(() {
      widget.attendedMeeting = widget.attendedMeeting;
      eventStatusEvents = eventStatusEvents;

      events_attendedEvents = events_attendedEvents;
      participant = participant;
      events_allocationEvents = events_allocationEvents;
      allocation = allocation;
      eventsAttended_clientEvents =  eventsAttended_clientEvents;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData_Attended();
  }

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
      stream: attendedData(),
      builder: (context, snapshot) {
        return Container(
          width: screenwidth,
          height: screenwidth < 700 ? screenheight/2.3 : screenheight/2.6 ,
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenwidth/20),
                  constraints: BoxConstraints.expand(height: screenwidth < 700 ? 40 : 60,),
                  child: TabBar(
                    physics: NeverScrollableScrollPhysics(),
                    isScrollable: false,
                    indicatorColor:  Color.fromRGBO(1, 80, 147, 0.9),
                    indicatorWeight: 3.0,
                    unselectedLabelColor: Colors.grey[300],
                    labelColor: Colors.black,
                    labelPadding: EdgeInsets.only(left: screenheight/400),
                    labelStyle:  TextStyle(fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/60 : 20),
                    tabs: [
                      Container(
                        width: screenwidth < 700 ? screenwidth/7 : screenwidth/5,
                        child: new Tab(text: 'Aperçu'),
                      ),

                      Container(
                        width: screenwidth < 700 ? screenwidth/2 : screenwidth/3,
                        child: new Tab(text: 'Participants'),
                      ),
                    ],
                    onTap: (index){
                      setState(() {
                        events_tabbarview_index = index.toString();
                        print(events_tabbarview_index.toString());
                        filterSearchService.filter(tabbar: events_tabbarview_index, past: pastTicketMatches);
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: screenheight/50,
                ),
                Expanded(
                  child: Container(
                    child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                      Container(
                        width: screenwidth,
                        height: screenheight,
                        child: ListView(
                          padding: EdgeInsets.all(0),
                          children: [
                            Container(
                              width: screenwidth,
                              height: screenwidth < 700 ? screenheight/10 : screenheight/11,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: screenwidth/20),
                                    width: screenwidth,
                                    alignment: Alignment.centerLeft,
                                    child: Text("Nom du match".toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/100 : 13,color: Color.fromRGBO(44, 87, 122, 0.9),),),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: screenwidth/20),
                                    alignment: Alignment.centerLeft,
                                    child: Text(widget.matchName.toString(),style: TextStyle(fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/60 : 22,color: Colors.black,),),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: screenwidth/20),
                                    width: screenwidth,
                                    alignment: Alignment.centerLeft,
                                    child: Text("Date du match".toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/100 : 13,color: Color.fromRGBO(44, 87, 122, 0.9),),),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(child:
                                          Container(
                                            padding: EdgeInsets.only(left: screenwidth/20),
                                            alignment: Alignment.centerLeft,
                                            child: Text(matchDate.toString(),style: TextStyle(fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/60 : 22,color: Colors.black,),),
                                          )
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child:  Container(
                                            width: screenwidth/2,
                                            padding: EdgeInsets.only(left: screenwidth < 700 ? 20 : 40),
                                            alignment: Alignment.centerLeft,
                                            child: Text( matchTime.toString(),style: TextStyle(fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/60  : 22,color: Colors.black,),),
                                            decoration: BoxDecoration(
                                                border: Border(left: BorderSide(color: Colors.black))
                                            ),
                                          )
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenheight/80,
                            ),
                            Container(
                              width: screenwidth,
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: screenheight/60,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: screenwidth/20),
                                    width: screenwidth,
                                    alignment: Alignment.centerLeft,
                                    child: Text('Participants inscrits'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/100 : 13,color: Colors.black,),),
                                  ),
                                  SizedBox(
                                    height: screenheight/100,
                                  ),
                                  events_attendedEvents == 0 && widget.attendedMeeting == null || events_allocationEvents == 0.0 ? Container(
                                    padding: EdgeInsets.symmetric(horizontal: screenwidth/20),
                                    child: Text("Aucun participant enregistré pour l’instant".toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/100 : 13,color: Colors.grey[600],),),
                                  ) : Column(
                                    children: <Widget>[
                                      Container(
                                        height: screenwidth < 700 ? screenheight/40 : 15,
                                        width: screenwidth/2.5,
                                        padding: EdgeInsets.only(left: screenwidth < 700 ? 0 : 20),
                                        alignment: Alignment.centerLeft,
                                        child: SliderTheme(
                                          child: widget.type == "event" || widget.type == "meeting" ? Slider(
                                            value: widget.attendedMeeting != null ? double.parse(widget.attendedMeeting.length.toString()) : events_attendedEvents,
                                            max:  20,
                                            min: 0,
                                            activeColor: Color.fromRGBO(48, 170, 219, 0.9),
                                            inactiveColor: Colors.grey[300],
                                            onChanged: (double value) {},
                                          ) : Slider(
                                            value: events_attendedEvents > events_allocationEvents ? 0 : events_attendedEvents,
                                            max:  events_allocationEvents == 0 ? 1000 : events_allocationEvents,
                                            min: 0,
                                            activeColor: Color.fromRGBO(48, 170, 219, 0.9),
                                            inactiveColor: Colors.grey[300],
                                            onChanged: (double value) {},
                                          ),
                                          data: SliderTheme.of(context).copyWith(
                                            trackHeight: screenwidth < 700 ? 7 : 8,
                                            thumbColor: Colors.transparent,
                                            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0.0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: screenwidth < 700 ? 3 : 7,
                                      ),
                                      Container(
                                          padding: EdgeInsets.symmetric(horizontal: screenwidth/20),
                                          width: screenwidth/2.5,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(participant == 1 ? " ${participant.toString()} participant" : "${participant.toString()} participants",style: TextStyle(fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/90 : 13,color: Colors.grey[600],),),
                                              SizedBox(
                                                height: screenwidth < 700 ? 3 : 7,
                                              ),
                                              (allocation-participant) == 0 || (allocation-participant) == 1 ? Text(allocation < participant ? '0 billet disponible' : (allocation-participant).toString()+' billet disponible',style: TextStyle(fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/90 : 13,color: Colors.grey[600],),)
                                              : Text(allocation < participant ? '0 billet disponible' : (allocation-participant).toString()+' billets disponible',style: TextStyle(fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/90 : 13,color: Colors.grey[600],),),
                                            ],
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            currentindex != 0 ? Container() : Builder(
                              builder:(context)=> GestureDetector(
                                child: Container(
                                  height: screenwidth < 700 ? 60 : screenwidth/14,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Color.fromRGBO(1, 80, 147, 0.9))
                                  ),
                                  margin: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 20 : 45),
                                  child: Container(
                                    child: Center(
                                      child: Text('Annuler présence ',style: TextStyle(fontSize: screenwidth < 700 ? screenwidth/23 : 20,fontFamily: 'Google-Bold', color: kPrimaryColor,),textAlign: TextAlign.left,),
                                    ),
                                  ),
                                ),
                                onTap: (){
                                 setState(() {
                                   confirmation(context,ticketID,'0',widget.eventDetail);
                                   eventType = widget.type.toString();
                                   eventID = widget._matchID.toString();
                                 });
                                },
                            ),
                            ),
                          ],
                        ),
                      ),
                          widget.attendedMeeting == null ? Container() :
                          Container(
                        width: screenwidth,
                        height: screenheight,
                        child: eventsAttended_clientEvents.length != 0 || widget.attendedMeeting.length != 0 ?
                        ListView.builder(
                            padding: EdgeInsets.all(0),
                            physics: BouncingScrollPhysics(),
                            itemCount: eventsAttended_clientEvents.toString() == "[]" ? widget.attendedMeeting.length : eventsAttended_clientEvents.length,
                            itemBuilder: (context, index){
                              List _localclients;

                              if (eventsAttended_clientEvents.toString() != "[]"){
                                _localclients = events_clients.where((s){
                                  return s['id'].toString().toLowerCase() == eventsAttended_clientEvents[index]['client_id'].toString().toLowerCase();
                                }).toList();
                              }

                              return Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
                                      spreadRadius: -10,
                                      blurRadius: 5,
                                      offset: Offset(0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Container(
                                  width: screenwidth,
                                  margin: EdgeInsets.symmetric(vertical: screenwidth/90,horizontal: screenwidth/40),
                                  padding: EdgeInsets.symmetric(vertical: screenwidth/40,horizontal: screenwidth/30),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey[300]),
                                    borderRadius: BorderRadius.circular(screenwidth/80),
                                  ),
                                  child: Container(
                                    width: screenwidth,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(1000.0),
                                              boxShadow: [
                                                BoxShadow(
                                                    color:  _localclients[0]['filename'].toString() == "null" || _localclients[0]['filename'].toString() == "" ? Colors.white : Colors.grey[400],
                                                    blurRadius: 2,
                                                    offset: Offset(3,2)
                                                )
                                              ],
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: _localclients[0]['filename'].toString() == "null" || _localclients[0]['filename'].toString() == "" ? AssetImage('assets/messages_icon/no_profile.png') : NetworkImage("https://ujap.checkmy.dev/storage/clients/${_localclients[0]['filename']}")
                                            )
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                             Row(
                                              children: <Widget>[
                                                Text(eventsAttended_clientEvents.toString() == "[]" ? widget.attendedMeeting[index]['clients']['name'].toString() : _localclients[0]['name'].toString(),style: TextStyle(
                                                    fontSize: screenwidth < 700 ? screenwidth/30 : screenwidth/37,
                                                    fontFamily: 'Google-Bold',
                                                    color: Colors.grey[800],
                                                    fontWeight: FontWeight.bold
                                                ),
                                                ),
                                                Text( eventsAttended_clientEvents.toString() == "[]" ? widget.attendedMeeting[index]['clients']['lastname'].toString() : _localclients[0]['lastname'].toString(),style: TextStyle(
                                                fontSize: screenwidth < 700 ? screenwidth/30 : screenwidth/37,
                                                    fontFamily: 'Google-Bold',
                                                    color: Colors.grey[800],
                                                    fontWeight: FontWeight.bold
                                                                ),
                                                   ),

                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(_localclients[0]['email'].toString(),style: TextStyle(
                                                fontSize: screenwidth < 700 ? screenwidth/30 : screenwidth/37,
                                                color: Colors.grey[800],
                                                fontWeight: FontWeight.w400
                                            ),
                                            ),
                                          ],
                                        ),
                                      )
                                     ],
                                    ),
                                  ),
                                ),
                              );
                            }

                        ) : Container(
                          width: screenwidth,
                          height: screenheight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? screenwidth/5 : screenwidth/3.5),
                                child: Image(
                                  color: Colors.grey[600],
                                  image: AssetImage('assets/no_clients_attended.png'),
                                ),
                              ),
                              SizedBox(
                                height: screenwidth/30,
                              ),
                              Text('Aucun participant'.toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenwidth/30 : screenwidth/40,fontFamily: 'Google-Bold', color: Colors.grey[700],fontWeight: FontWeight.bold),),
                            ],
                          ),
                        )
                      ),

                    ]),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );

  }
}
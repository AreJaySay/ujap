import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/variables/events_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/variables/video.dart';
import 'package:ujap/globals/widgets/appbar_icons.dart';
import 'package:ujap/globals/widgets/confirmation_attendance.dart';
import 'package:ujap/globals/widgets/curve_containers.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/matches.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/no_data_fetch.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/past_events_matches.dart';
import 'package:ujap/services/ad_listener.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/navigate_match_events.dart';
import 'package:ujap/services/notifications.dart';
import 'package:ujap/services/searches/search_service.dart';

import '../../drawer_page.dart';
import 'download_pdf 2.dart';

class EventsList extends StatefulWidget {
  @override
  _EventsListState createState() => _EventsListState();
}

class _EventsListState extends State<EventsList> {
  var _finaleventsTime;
  var _timeConvertedString= "";
  int _timeConverted;
  int _finalTimeEvent;
  var _dateConvertedString = "";
  var _dateConvertedDayYear = "";
  List _AwayteamName;
  List _HometeamName;
  List _eventStatus;
  var _ticketID = "";
  List eventsAttended_client;

  bool _ticketColorattend = false;
  bool _ticketColorpass = false;

  List _ticketColors;

  Stream searchBox()async*{
    setState(() {
      showsearchBox = showsearchBox;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:  matchservice.search$,
      builder: (context, snapshot) {
        return Column(
          children: [
            Expanded(
              child: ClipPath(
                clipper: CurvedTop(),
                child: Container(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        child: Image(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/new_app_icon.png'),
                        ),
                      ),
                      Container(
                       width: double.infinity,
                       height: screenheight,
                        color: kPrimaryColor,
                        child: snapshot.data == null || teamNameData == null ?
                        No_events_data_yet() :
                        Container(
                          width: double.infinity,
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              StreamBuilder(
                                stream: searchBox(),
                                builder: (context, snapshots) {
                                  return showsearchBox ? Container() :  Container(
                                    width: screenwidth,
                                    padding: EdgeInsets.symmetric(horizontal: 20,),
                                    child: Center(child: Text( snapshot.data.length > 1 ? 'évènements et matchs à venir'.toUpperCase() : 'évènements et matchs à venir'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Colors.white,fontSize: 15),)),
                                  );
                                }
                              ),
                              snapshot.data.length == 0 ?
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 40,vertical: screenwidth < 700 ? 15 : 40),
                                width: screenwidth,
                                height: screenwidth < 700 ? screenheight / 4.5 : screenheight /3.5,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(screenwidth/40)
                                ),
                                child: Container(
                                  width: screenwidth < 700 ? screenwidth/3 : screenwidth/3.5,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: screenwidth/4,
                                        height:  screenwidth/4,
                                        child: Image(
                                          color: Colors.grey[700],
                                          fit: BoxFit.cover,
                                          image: AssetImage('assets/home_icons/no_events.png'),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                            width: screenwidth,
                                            child: ListView(
                                              padding: EdgeInsets.all(0),
                                              children: [
                                                Container(
                                                    width: screenwidth,
                                                    alignment: Alignment.center,
                                                    child: Text("AUCUN RÉSULTAT".toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/65  : 20,fontFamily: 'Google-Bold',color: Colors.grey[700]),)),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                    width: screenwidth,
                                                    alignment: Alignment.center,
                                                    child: Text("Vous pouvez voir tous les matchs ici.".toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/90  : 20,fontFamily: 'Google-Bold',color: Colors.grey[500]),)),
                                              ],
                                            )),
                                      ),

                                    ],
                                  ),
                                ),
                              ) : CarouselSlider.builder(
                                options: CarouselOptions(
                                  viewportFraction: 0.8,
                                  initialPage: 0,
                                  autoPlay: snapshot.data.length == 1 || snapshot.data.length == 0 ? false : true,
                                  autoPlayInterval: Duration(seconds: 5),
                                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                                  scrollDirection: Axis.horizontal,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  scrollPhysics: snapshot.data.length == 1 || snapshot.data.length == 0 ?  NeverScrollableScrollPhysics() : null,
                                ),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, int index, int pageViewIndex) {
                                  double _eventTicket = 0;
                                  var dayFormateDay_year = "";

                                  if (snapshot.data != null){
                                    attendedEventMatch.add(snapshot.data[index]);
                                  }

                                  if (snapshot.data[index]['match'].toString() != '[]'.toString()) {
                                    _AwayteamName = teamNameData.where((s) {
                                      return s['id'].toString().toLowerCase() == snapshot.data[index]['match']['visitor_team_id'].toString().toLowerCase();
                                    }).toList();

                                    _HometeamName = teamNameData.where((s) {
                                      return s['id'].toString().toLowerCase() == snapshot.data[index]['match']['home_team_id'].toString().toLowerCase();
                                    }).toList();

                                  }

                                  // DATE AND TIME
                                  if (snapshot.data[index]['sched_time'].toString() !=
                                      'null') {
                                    var _text = snapshot.data[index]['sched_time'].toString();
                                    _finaleventsTime = _text.substring(0, 5);
                                    _timeConvertedString = _text.substring(3, 5);
                                    _timeConverted = int.parse(_finaleventsTime.substring(
                                        0, 2));

                                    if (_timeConverted > 12) {
                                      _finalTimeEvent = _timeConverted - 12;
                                    }
                                    else {
                                      _finalTimeEvent =
                                          int.parse(_finaleventsTime.substring(0, 2));
                                    }
                                  }

                                  if (snapshot.data[index]['sched_date'].toString() !=
                                      'null') {
                                    var dateFormate = DateFormat("MM").format(DateTime.parse(snapshot.data[index]['sched_date']));
                                    var dateFormateDay_year = DateFormat("yyyy").format(DateTime.parse(snapshot.data[index]['sched_date']));
                                     dayFormateDay_year = DateFormat("d").format(DateTime.parse(snapshot.data[index]['sched_date']));

                                    _dateConvertedString = dateFormate;
                                    _dateConvertedDayYear = dateFormateDay_year;
                                    //
                                  }

                                  if (events_status != null){
                                    _eventStatus = events_status.where((s) {
                                      return s['event_id'].toString().toLowerCase() == snapshot.data[index]['id'].toString().toLowerCase();
                                    }).toList();
                                    if (_eventStatus[0]['accepted_clients'].toString() != "null"){
                                      events_attended = double.parse( _eventStatus[0]['accepted_clients'].length.toString());
                                    }
                                    _eventTicket = double.parse(_eventStatus[0]['allocation'].toString());

                                    eventsAttended_client =  _eventStatus[0]['accepted_clients'];

                                  }


                                  return Stack(
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: ListView(
                                            padding: EdgeInsets.all(0),
                                            children: [
                                              Container(
                                                height: screenheight / 15,
                                                width: screenwidth,
                                                decoration: BoxDecoration(
                                                    color: Color.fromRGBO(248, 248, 248, 0.9),
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(snapshot.data[index]['name'].toString().toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black,fontSize: 13),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        Text(snapshot.data[index]['sched_date'] == null ? 'TBA' : dayFormateDay_year+' '+monthDate[int.parse(_dateConvertedString.toString())].toString()+'.'+' '+_dateConvertedDayYear.toString().toUpperCase(),style: TextStyle(fontSize: 12,fontFamily: 'Google-Medium',color: Colors.black),),
                                                        SizedBox(
                                                          width: screenwidth < 700 ? 5 : 15,
                                                        ),
                                                        Text(snapshot.data[index]['sched_time'] == null ? 'TBA' :  _timeConverted.toString()+':'+_timeConvertedString.toString(),style: TextStyle(fontSize: 12,fontFamily: 'Google-Medium',color: Colors.black),),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: screenwidth,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        width: screenwidth,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            SizedBox(
                                                              height: screenwidth < 700 ? screenwidth/50 : screenwidth/100,
                                                            ),
                                                            snapshot.data[index]["match"]["home_court"] == 1 ?
                                                            Container(
                                                              height: 65,
                                                              width: 65,
                                                              child: Image(
                                                                  fit: BoxFit.cover,
                                                                  image:  _HometeamName == null ?
                                                                  AssetImage('assets/no_image_available.png') :
                                                                  NetworkImage('https://ujap.checkmy.dev/storage/teams/'+ _HometeamName[0]['logo'])
                                                              ),
                                                            ) :
                                                            Container(
                                                              height: 65,
                                                              width: 65,
                                                              child: Image(
                                                                  fit: BoxFit.cover,
                                                                  image:  _AwayteamName == null ?
                                                                  AssetImage('assets/no_image_available.png') :
                                                                  NetworkImage('https://ujap.checkmy.dev/storage/teams/'+ _AwayteamName[0]['logo'])
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height:  screenwidth/50,
                                                            ),
                                                            snapshot.data[index]["match"]["home_court"] == 1 ?
                                                            Container(
                                                              margin: EdgeInsets.symmetric(horizontal: 15),
                                                              alignment: Alignment.center,
                                                              child: Text(_HometeamName[0]['name'].toString().toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/78  : 20,fontFamily: 'Google-Bold',color: Colors.grey[800]),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 2,),
                                                            ) :
                                                            Container(
                                                              width: screenwidth/4,
                                                              alignment: Alignment.center,
                                                              child: Text( _AwayteamName[0]['name'].toString().toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/78  : 20,fontFamily: 'Google-Bold',color: Colors.grey[800]),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,maxLines: 2,),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Text('VS',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/32 : 35,color: Color.fromRGBO(20, 74, 119, 0.9),fontFamily: 'Google-Bold'),),
                                                    Expanded(
                                                      child: Container(
                                                        width: screenwidth,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            SizedBox(
                                                              height: screenwidth < 700 ? screenwidth/50 : screenwidth/100,
                                                            ),
                                                            snapshot.data[index]["match"]["home_court"] == 1 ?
                                                            Container(
                                                              height: 65,
                                                              width: 65,
                                                              child: Image(
                                                                  fit: BoxFit.cover,
                                                                  image:  _AwayteamName == null ?
                                                                  AssetImage('assets/no_image_available.png') :
                                                                  NetworkImage('https://ujap.checkmy.dev/storage/teams/'+ _AwayteamName[0]['logo'])
                                                              ),
                                                            ) :
                                                            Container(
                                                              height: 65,
                                                              width: 65,
                                                              child: Image(
                                                                  fit: BoxFit.cover,
                                                                  image:  _HometeamName == null ?
                                                                  AssetImage('assets/no_image_available.png') :
                                                                  NetworkImage('https://ujap.checkmy.dev/storage/teams/'+ _HometeamName[0]['logo'])
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height:  screenwidth/50,
                                                            ),
                                                            snapshot.data[index]["match"]["home_court"] == 1 ?
                                                            Container(
                                                              width: screenwidth/4,
                                                              alignment: Alignment.center,
                                                              child: Text( _AwayteamName[0]['name'].toString().toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/78  : 20,fontFamily: 'Google-Bold',color: Colors.grey[800]),textAlign: TextAlign.center,
                                                              ),
                                                            ) :
                                                            Container(
                                                              margin: EdgeInsets.symmetric(horizontal: 15),
                                                              alignment: Alignment.center,
                                                              child: Text(_HometeamName[0]['name'].toString().toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/78  : 20,fontFamily: 'Google-Bold',color: Colors.grey[800]),textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: (){
                                          print(snapshot.data[index]);
                                          setState(() {
                                            if(videoPlayerController != null && chewieController != null && chewieController.isPlaying){
                                              videoPlayerController.pause();
                                              chewieController.pause();
                                            }
                                            indexmatch = index;
                                            datamatch = snapshot.data[index];
                                            adListener.update(false);
                                            navigateMatch(index,context,snapshot.data[index]);
                                            notifPage = false;
                                          });
                                        },
                                      ),
                                      myPass_events.toString().contains('ticket_id: '+snapshot.data[index]['ticket']['id'].toString()) ?
                                      Container() :
                                      events_attended == _eventTicket &&  !myAttended_events.toString().contains('ticket_id: '+snapshot.data[index]['ticket']['id'].toString()) ? Container() : Builder(
                                        builder:(context)=> GestureDetector(
                                          child: snapshot.data[index]['type'].toString() == 'event' ? Container() :
                                         _eventTicket == 0.0 ? Container() : Container(
                                            height: screenwidth < 700 ? screenwidth/1.5 : screenwidth/2,
                                            alignment: Alignment.bottomCenter,
                                                child: Container(
                                              width: screenwidth < 700 ? screenwidth/7: 80,
                                              height: screenwidth < 700 ? screenwidth/7 : 80,
                                              child:  myAttended_events.toString().contains('ticket_id: '+snapshot.data[index]['ticket']['id'].toString()) || myPass_events.toString().contains('ticket_id: '+snapshot.data[index]['ticket']['id'].toString()) ?
                                               Image(
                                                color: Colors.green.withOpacity(0.9),
                                                image:  AssetImage('assets/home_icons/green_ticket.png')
                                              ) : Image(
                                                color:  kPrimaryColor,
                                                image: AssetImage('assets/home_icons/ticket.png'),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(1000),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: kPrimaryColor.withOpacity(0.4),
                                                      spreadRadius: 2,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 0), // changes position of shadow
                                                    ),
                                                  ],
                                              ),
                                              padding: EdgeInsets.all(screenwidth < 700 ? screenwidth/40 : 15),
                                            ),
                                          ),
                                          onTap: (){
                                            setState(() {
                                              print(ticketFilename);
                                              getTicketData(snapshot.data[index]['ticket']['id'].toString()).then((value){
                                                setState((){
                                                  ticketFilename = value[0]['filename'];
                                                });
                                                print('TICKET DETAILS :'+value.toString()+ticketdownloadID);
                                              });
                                              navigateTicket(index,context,snapshot.data[index]);
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  );
                                }
                              ),
                              SizedBox(
                                height: screenwidth < 700 ? 30 : 0,
                              )
                            ],
                          ),
                        )
                      ),
                    ],
                  )
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}

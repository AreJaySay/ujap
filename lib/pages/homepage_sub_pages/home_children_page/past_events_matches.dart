import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/variables/video.dart';
import 'package:ujap/globals/widgets/curve_containers.dart';
import 'package:ujap/globals/widgets/view_events.dart';
import 'package:ujap/pages/homepage.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/events_list_data.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/view_event.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/matches.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/no_data_fetch.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/no_data_fetch_past_events.dart';
import 'package:ujap/services/ad_listener.dart';
import 'package:ujap/services/navigate_match_events.dart';
import 'package:ujap/services/searches/search_service.dart';

List<Map> attendedEventMatch = List<Map>();
List backup_attendedEventMatch;

class Past_events_matches extends StatefulWidget {
  @override
  _Past_events_matchesState createState() => _Past_events_matchesState();
}

class _Past_events_matchesState extends State<Past_events_matches> {
  var _finaleventsTime;
  var _timeConvertedString= "";
  int _timeConverted;
  int _finalTimeEvent;
  var _dateConvertedString = "";
  var _dateConvertedDayYear = "";
  List _teamName;
  List _hometeamName;

//
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: middleservice.search$,
      builder: (context, snapshot) {
        return Container(
          width: screenwidth,
          child:  ListView(
            padding: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 20 : 40),
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                margin: EdgeInsets.only(top: screenwidth/25,),
                width: screenwidth < 700 ? screenwidth/3.8 : screenwidth/5.5,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenwidth < 700 ? 10 : 15),
                    gradient: LinearGradient(
                      colors: [Color.fromRGBO(5, 93, 157, 0.9),Color.fromRGBO(30, 139, 195, 0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('évènements'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Colors.white,fontSize:screenheight/65 ),),
                      Text('et matchs'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Colors.white,fontSize:  screenheight/65),),
                      Text('passés'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Colors.white,fontSize: screenheight/65),),
                    ],
                  ),
                ),
              ),
              Container(
                height: screenwidth/10,
                child: snapshot.data == null || teamNameData == null  ?
                No_data_middle() :
                snapshot.data.length == 0 ?
                Container(
                  width: screenwidth,
                  height: screenwidth < 700 ? screenheight/4 : screenheight/3.5,
                  child: Row(
                    children: [
                      Container(
                        width: screenwidth/1.5,
                        height: screenheight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: screenwidth/5,
                              height: screenwidth/5,
                              child: Image(
                                color: Colors.grey[700],
                                fit: BoxFit.contain,
                                image: AssetImage('assets/home_icons/no_events.png'),
                              ),
                            ),
                            SizedBox(
                              width: screenwidth/50,
                            ),
                            Container(
                              height: screenheight,
                              padding: EdgeInsets.only(top: screenwidth/40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Pas d'évènements".toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70  : 20,fontFamily: 'Google-Bold',color: Colors.grey[700]),),
                                  Text("/matchs passés!".toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70  : 20,fontFamily: 'Google-Bold',color: Colors.grey[700]),),],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ) : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics:  BouncingScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, int index){
                    var dayFormateDay_year = "";

                    if (snapshot.data != null){
                      attendedEventMatch.add(snapshot.data[index]);
                    }

                    if (snapshot.data[index]['match'].toString() != 'null'){
                      _teamName = teamNameData.where((s){
                        return s['id'].toString().toLowerCase() == snapshot.data[index]['match']['visitor_team_id'].toString().toLowerCase();
                      }).toList();

                      _hometeamName = teamNameData.where((s){
                        return s['id'].toString().toLowerCase() == snapshot.data[index]['match']['home_team_id'].toString().toLowerCase();
                      }).toList();
                    }

                    // DATE AND TIME
                    if (snapshot.data[index]['sched_time'].toString() != 'null'){
                      var _text =  snapshot.data[index]['sched_time'].toString();
                      _finaleventsTime = _text.substring(0,5);
                      _timeConvertedString = _text.substring(3,5);
                      _timeConverted = int.parse(_finaleventsTime.substring(0,2));

                      if (_timeConverted > 12){
                        _finalTimeEvent = _timeConverted-12;
                      }
                      else{
                        _finalTimeEvent = int.parse(_finaleventsTime.substring(0,2));
                      }
                    }

                    if (snapshot.data[index]['sched_date'].toString() != 'null') {
                      var dateFormate = DateFormat("MM").format(DateTime.parse(snapshot.data[index]['sched_date']));
                      var dateFormateDay_year = DateFormat("yyyy").format(DateTime.parse(snapshot.data[index]['sched_date']));
                      dayFormateDay_year = DateFormat("d").format(DateTime.parse(snapshot.data[index]['sched_date']));

                      _dateConvertedString = dateFormate;
                      _dateConvertedDayYear = dateFormateDay_year;

                    }

                    return  Row(
                      children: [
                        snapshot.data[index]['type'].toString() == 'match' ?
                        GestureDetector(
                          child: Container(
                            width: screenwidth < 700 ? int.parse(snapshot.data[index]['match']['visitor_score'].toString()) == int.parse(snapshot.data[index]['match']['home_score'].toString()) ?
                            screenwidth/3  : screenwidth/3.5 : screenwidth/4,
                            margin: EdgeInsets.only(left: screenwidth < 700 ? 15 : 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                snapshot.data == null || teamNameData == null?
                                Container () :
                                Text( snapshot.data[index]['sched_date'].toString() == "null" ? 'TBA' : dayFormateDay_year+' '+monthDate[int.parse(_dateConvertedString.toString())].toString()+'.'+' '+_dateConvertedDayYear.toString(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/80 : 20,fontFamily: 'Google-Bold'),),
                                SizedBox(
                                  height: screenwidth/50,
                                ),
                                Container(
                                  width: screenwidth/2,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[200],
                                        blurRadius: 2.0, // has the effect of softening the shadow
                                        spreadRadius: 2.0, // has the effect of extending the shadow
                                        offset: Offset(
                                          0.0, // horizontal, move right 10
                                          0.0, // vertical, move down 10
                                        ),
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: screenwidth < 700 ? 30 : 50,
                                        padding: EdgeInsets.all(screenwidth < 700 ? 2 : 7),
                                        child: Image(
                                            fit: BoxFit.contain,
                                            image:  snapshot.data[index]['type'].toString() == 'event' ?
                                            NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Los_Angeles_Lakers_logo.svg/1000px-Los_Angeles_Lakers_logo.svg.png') :
                                            NetworkImage('https://ujap.checkmy.dev/storage/teams/'+ _hometeamName[0]['logo'])
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: screenwidth/7,
                                              child: Text(_hometeamName[0]['name'].toString(),style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black,fontSize: screenwidth < 700 ? screenheight/90 : 15 ),
                                                overflow: TextOverflow.ellipsis,
                                              maxLines: 1,),
                                            ),
                                            snapshot.data[index]['match']['home_score'].toString() == 'null' ? Container(
                                              child: Text('TBA',style: TextStyle(fontFamily: 'Google-Bold',color: Color.fromRGBO(5, 93, 157, 0.9),fontSize: screenwidth < 700 ?  screenheight/90 : 14 ),),

                                            ) :   Row(
                                              children: [
                                                Text(snapshot.data[index]['match']['home_score'].toString(),style: TextStyle(fontFamily: 'Google-Bold',color: Color.fromRGBO(5, 93, 157, 0.9),fontSize: screenwidth < 700 ?  screenheight/90 : 14 ),),
                                                SizedBox(
                                                  width: screenwidth < 700 ? 2 : 5,
                                                ),
                                                int.parse(snapshot.data[index]['match']['visitor_score'].toString()) == int.parse(snapshot.data[index]['match']['home_score'].toString()) ?
                                                Text('tirage au sort'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Color.fromRGBO(104, 204, 46, 0.9),fontSize: screenwidth < 700 ?  screenheight/90 : 14 )) :
                                                int.parse(snapshot.data[index]['match']['visitor_score'].toString()) > int.parse(snapshot.data[index]['match']['home_score'].toString()) ? Container() : Text('Victoire'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Color.fromRGBO(104, 204, 46, 0.9),fontSize: screenwidth < 700 ?  screenheight/90 : 14 ),),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  padding: EdgeInsets.all(3),
                                  height: screenwidth < 700 ? screenwidth/12.5 : screenwidth/14.5,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: screenwidth < 700 ? screenwidth/12.5 : screenwidth/14.5,
                                  padding: EdgeInsets.all(3),
                                  width: screenwidth/2,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(244, 241, 241, 0.9),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[300],
                                        blurRadius: 0.0, // has the effect of softening the shadow
                                        spreadRadius: 0.0, // has the effect of extending the shadow
                                        offset: Offset(
                                          0.0, // horizontal, move right 10
                                          screenwidth < 700 ?1.0:2.0, // vertical, move down 10
                                        ),
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: screenwidth < 700 ? 30 : 50,
                                        padding: EdgeInsets.all(screenwidth < 700 ? 4 : 7),
                                        child:  Image(
                                            fit: BoxFit.contain,
                                            image:  snapshot.data[index]['type'].toString() == 'event' ?
                                            NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Los_Angeles_Lakers_logo.svg/1000px-Los_Angeles_Lakers_logo.svg.png') :
                                            NetworkImage('https://ujap.checkmy.dev/storage/teams/'+ _teamName[0]['logo'])
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: screenwidth/7,
                                              child: Text(_teamName[0]['name'].toString(),style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black,fontSize: screenwidth < 700 ? screenheight/90 : 15 ),
                                                overflow: TextOverflow.ellipsis,),
                                            ),
                                            snapshot.data[index]['match']['visitor_score'].toString() == 'null' ? Container(
                                              child: Text('TBA',style: TextStyle(fontFamily: 'Google-Bold',color: Color.fromRGBO(5, 93, 157, 0.9),fontSize: screenwidth < 700 ?  screenheight/90 : 14 ),),

                                            ) :   Row(
                                              children: [
                                                Text(snapshot.data[index]['match']['visitor_score'].toString(),style: TextStyle(fontFamily: 'Google-Bold',color: Color.fromRGBO(5, 93, 157, 0.9),fontSize: screenwidth < 700 ?  screenheight/90 : 14 ),),
                                                SizedBox(
                                                  width: screenwidth < 700 ? 2 : 5,
                                                ),
                                                int.parse(snapshot.data[index]['match']['visitor_score'].toString()) == int.parse(snapshot.data[index]['match']['home_score'].toString()) ?
                                                Text('tirage au sort'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Color.fromRGBO(104, 204, 46, 0.9),fontSize: screenwidth < 700 ?  screenheight/90 : 14 )) :
                                                int.parse(snapshot.data[index]['match']['visitor_score'].toString()) < int.parse(snapshot.data[index]['match']['home_score'].toString()) ? Container() : Text('Victoire'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Color.fromRGBO(104, 204, 46, 0.9),fontSize: screenwidth < 700 ?  screenheight/90 : 14 ),),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),

                                )
                              ],
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              pastTicketMatches = true;
                              filterSearchService.filter(past: pastTicketMatches);
                            });
                            navigateMatch(index,context,snapshot.data[index]);
                          },
                        ) :
                        GestureDetector(
                          child: Container(
                            width: screenwidth < 700 ? screenwidth/3.8 : screenwidth/5.5,
                            margin: EdgeInsets.only(left: screenwidth < 700 ? 15 : 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                snapshot.data == null || teamNameData == null || events_clients == null || snapshot.data == null ?
                                Container () :
                                Text( snapshot.data[index]['sched_date'].toString() == 'null' ? 'TBA' : dayFormateDay_year+' '+monthDate[int.parse(_dateConvertedString.toString())].toString()+'.'+' '+_dateConvertedDayYear.toString(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/80 : 20,fontFamily: 'Google-Bold'),),
                                SizedBox(
                                  height: screenheight/110,
                                ),
                                Expanded(
                                  child: Container(
                                    height: screenheight,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Stack(
                                      children: [
                                        Container(
                                          padding: snapshot.data[index]['filename'].toString() != 'null' ? EdgeInsets.all(0) : EdgeInsets.all(8),
                                          width: screenwidth,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey[400]),
                                              borderRadius: BorderRadius.circular(10),
                                              image: snapshot.data[index]['filename'].toString() != 'null' ? DecorationImage(
                                                  fit:  BoxFit.cover,
                                                  image: NetworkImage('https://ujap.checkmy.dev/storage/events/'+snapshot.data[index]['id'].toString()+'/'+snapshot.data[index]['filename'])
                                              ) : null,
                                          ),
                                          child:  snapshot.data[index]['filename'].toString() != 'null' ? Container() : Image(
                                            color: Colors.grey[800],
                                            fit:  BoxFit.cover,
                                            image:  AssetImage('assets/no_image_available.png'),
                                          ),
                                        ),
                                        Container(
                                          width: screenwidth,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(vertical: 3),
                                            width: screenwidth,
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.4),
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10.0),
                                                  topLeft: Radius.circular(10.0)),
                                            ),
                                            child: Text(snapshot.data[index]['name'].toString(),style: TextStyle(color: Colors.white,fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ?  screenwidth/35 : 20),
                                              textAlign: TextAlign.center,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          alignment: Alignment.topCenter,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              Navigator.push(context, PageTransition(
                                  child: snapshot.data[index]['type'].toString() != "meeting" ? ViewEvent(
                                    eventDetail: snapshot.data[index],
                                    pastEvent: true,
                                  ) : ViewEventDetails(
                                    eventDetail: snapshot.data[index],
                                    pastEvent: true,
                                  ),
                                  type: PageTransitionType.topToBottom
                              ));
                              pastTicketEvents = true;
                              if(videoPlayerController != null && chewieController != null && chewieController.isPlaying){
                                videoPlayerController.pause();
                                chewieController.pause();
                              }
                              adListener.update(false);
//                              show_ads = false;
                            });
                            // navigateEvents(index,context,snapshot.data[index]);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }
    );

  }
}
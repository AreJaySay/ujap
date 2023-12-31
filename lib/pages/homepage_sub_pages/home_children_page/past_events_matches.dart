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
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                margin: EdgeInsets.only(top: screenwidth/25,),
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: 140,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenwidth < 700 ? 10 : 15),
                    gradient: LinearGradient(
                      colors: [kPrimaryColor,Color.fromRGBO(30, 139, 195, 0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('évènements'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Colors.white),),
                    SizedBox(
                      height: 2,
                    ),
                    Text('et matchs'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Colors.white),),
                    SizedBox(
                      height: 2,
                    ),
                    Text('passés'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Colors.white),),
                  ],
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
                                  Text("Pas d'évènements".toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Colors.grey[700]),),
                                  Text("/matchs passés!".toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Colors.grey[700]),),],
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
                      attendedEventMatch.add(snapshot.data[snapshot.data.length - 1 - index]);
                    }

                    if (snapshot.data[snapshot.data.length - 1 - index]['match'].toString() != 'null'){
                      _teamName = teamNameData.where((s){
                        return s['id'].toString().toLowerCase() == snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_team_id'].toString().toLowerCase();
                      }).toList();

                      _hometeamName = teamNameData.where((s){
                        return s['id'].toString().toLowerCase() == snapshot.data[snapshot.data.length - 1 - index]['match']['home_team_id'].toString().toLowerCase();
                      }).toList();
                    }

                    // DATE AND TIME
                    if (snapshot.data[snapshot.data.length - 1 - index]['sched_time'].toString() != 'null'){
                      var _text =  snapshot.data[snapshot.data.length - 1 - index]['sched_time'].toString();
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

                    if (snapshot.data[snapshot.data.length - 1 - index]['sched_date'].toString() != 'null') {
                      var dateFormate = DateFormat("MM").format(DateTime.parse(snapshot.data[snapshot.data.length - 1 - index]['sched_date']));
                      var dateFormateDay_year = DateFormat("yyyy").format(DateTime.parse(snapshot.data[snapshot.data.length - 1 - index]['sched_date']));
                      dayFormateDay_year = DateFormat("d").format(DateTime.parse(snapshot.data[snapshot.data.length - 1 - index]['sched_date']));

                      _dateConvertedString = dateFormate;
                      _dateConvertedDayYear = dateFormateDay_year;

                    }

                    return  Row(
                      children: [
                        snapshot.data[snapshot.data.length - 1 - index]['type'].toString() == 'match' ?
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(left: screenwidth < 700 ? 15 : 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                snapshot.data == null || teamNameData == null?
                                Container () :
                                Text( snapshot.data[snapshot.data.length - 1 - index]['sched_date'].toString() == "null" ? 'TBA' : dayFormateDay_year+' '+monthDate[int.parse(_dateConvertedString.toString())].toString()+'.'+' '+_dateConvertedDayYear.toString(),style: TextStyle(fontSize: 12,fontFamily: 'Google-Bold'),),
                                SizedBox(
                                  height: screenwidth/50,
                                ),
                                snapshot.data[snapshot.data.length - 1 - index]['match']['home_court'] == 1 ? Container(
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
                                        width: 40,
                                        child: Image(
                                            fit: BoxFit.contain,
                                            image: snapshot.data[snapshot.data.length - 1 - index]['type'].toString() == 'event' ?
                                            NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Los_Angeles_Lakers_logo.svg/1000px-Los_Angeles_Lakers_logo.svg.png') :
                                            NetworkImage('https://ujap.checkmy.dev/storage/teams/'+ _hometeamName[0]['logo'])
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(_hometeamName[0]['name'].toString(),style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black,fontSize: 11),
                                                overflow: TextOverflow.ellipsis,
                                              maxLines: 1,),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString() == 'null' ? Container(
                                                child: Text('TBA',style: TextStyle(fontFamily: 'Google-Bold',color: kPrimaryColor,fontSize: 11),),

                                              ) :   Row(
                                                children: [
                                                  int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) == 0 && int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) == 0 ?
                                                  Container() :
                                                  Text(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString(),style: TextStyle(fontFamily: 'Google-Bold',color: kPrimaryColor,fontSize: 12),),
                                                  SizedBox(
                                                    width: screenwidth < 700 ? 2 : 5,
                                                  ),
                                                  int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) == 0 && int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) == 0  ?
                                                  Container(child: Text('Le match a été annulé'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Color.fromRGBO(104, 204, 46, 0.9),fontSize: 9),overflow: TextOverflow.ellipsis,)) :
                                                  int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) == int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) && int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) > 0 && int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) > 0 ?
                                                  Text('Match nul') :
                                                  int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) > int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) ? Container() :
                                                  Text('Victoire'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Color.fromRGBO(104, 204, 46, 0.9),fontSize: 9),),

                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  height: 45,
                                  width: 170,
                                ) : Container(
                                  height: 45,
                                  width: 170,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                                      _teamName.toString() == "[]" ?
                                      Container(
                                        width: 30,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image:  NetworkImage('https://static.thenounproject.com/png/340719-200.png')
                                            ),
                                            borderRadius: BorderRadius.circular(1000)
                                        ),
                                        height: 30,
                                      ) : Container(
                                        width: 30,
                                        padding: EdgeInsets.all(5),
                                        child:  Image(
                                            fit: BoxFit.contain,
                                            image: NetworkImage('https://ujap.checkmy.dev/storage/teams/'+ _teamName[0]['logo'])
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: _teamName.toString() == "[]" ? screenwidth/3.7 : screenwidth/4.5,
                                              child: Text( _teamName.toString() == "[]" ? "Pas de nom d'équipe adverse".toUpperCase() : _teamName[0]['name'].toString().toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black,fontSize: 11),
                                                overflow: TextOverflow.ellipsis,),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString() == 'null' ? Container(
                                              child: Text('TBA',style: TextStyle(fontFamily: 'Google-Bold',color: kPrimaryColor,fontSize: 11),),

                                            ) :   Row(
                                              children: [
                                                int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) == 0 && int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) == 0  ?
                                                Container() :
                                                Text(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString(),style: TextStyle(fontFamily: 'Google-Bold',color: kPrimaryColor,fontSize: 12 ),),
                                                SizedBox(
                                                  width: screenwidth < 700 ? 2 : 5,
                                                ),
                                                int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) == 0 && int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) == 0 ?
                                                Container(
                                                    child: Text('Le match a été annulé'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Color.fromRGBO(104, 204, 46, 0.9),fontSize: 9),overflow: TextOverflow.ellipsis,)) :
                                                int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) == int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) &&  int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) > 0 && int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) > 0  ?
                                                Text('Match nul') :
                                                int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) < int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) ? Container() :
                                                Container(
                                                  child: Text('Victoire'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Color.fromRGBO(104, 204, 46, 0.9),fontSize: 9),),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                snapshot.data[snapshot.data.length - 1 - index]['match']['home_court'] == 1 ? Container(
                                  height: 45,
                                  width: 170,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                                      _teamName.toString() == "[]" ?
                                      Container(
                                          width: 30,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image:  NetworkImage('https://static.thenounproject.com/png/340719-200.png')
                                            ),
                                            borderRadius: BorderRadius.circular(1000)
                                          ),
                                        height: 30,
                                      ) : Container(
                                        width: 30,
                                        padding: EdgeInsets.all(5),
                                        child:  Image(
                                            fit: BoxFit.contain,
                                            image: NetworkImage('https://ujap.checkmy.dev/storage/teams/'+ _teamName[0]['logo'])
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: _teamName.toString() == "[]" ? screenwidth/3.7 : screenwidth/4.5,
                                              child: Text( _teamName.toString() == "[]" ? "Pas de nom d'équipe adverse".toUpperCase() : _teamName[0]['name'].toString().toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black,fontSize: 11),
                                                overflow: TextOverflow.ellipsis,),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString() == 'null' ? Container(
                                              child: Text('TBA',style: TextStyle(fontFamily: 'Google-Bold',color: kPrimaryColor,fontSize: 11),),

                                            ) :   Row(
                                              children: [
                                                int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) == 0 && int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) == 0  ?
                                                Container() :
                                                Text(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString(),style: TextStyle(fontFamily: 'Google-Bold',color: kPrimaryColor,fontSize: 12 ),),
                                                SizedBox(
                                                  width: screenwidth < 700 ? 2 : 5,
                                                ),
                                                int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) == 0 && int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) == 0 ?
                                                Container(
                                                    child: Text('Le match a été annulé'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Color.fromRGBO(104, 204, 46, 0.9),fontSize: 9),overflow: TextOverflow.ellipsis,)) :
                                                int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) == int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) &&  int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) > 0 && int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) > 0  ?
                                                Text('Match nul') :
                                                int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) < int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) ? Container() :
                                                Container(
                                                    child: Text('Victoire'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Color.fromRGBO(104, 204, 46, 0.9),fontSize: 9),),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ) : Container(
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
                                        width: 40,
                                        child: Image(
                                            fit: BoxFit.contain,
                                            image: snapshot.data[snapshot.data.length - 1 - index]['type'].toString() == 'event' ?
                                            NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Los_Angeles_Lakers_logo.svg/1000px-Los_Angeles_Lakers_logo.svg.png') :
                                            NetworkImage('https://ujap.checkmy.dev/storage/teams/'+ _hometeamName[0]['logo'])
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(_hometeamName[0]['name'].toString(),style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black,fontSize: 11),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString() == 'null' ? Container(
                                                child: Text('TBA',style: TextStyle(fontFamily: 'Google-Bold',color: kPrimaryColor,fontSize: 11),),

                                              ) :   Row(
                                                children: [
                                                  int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) == 0 && int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) == 0 ?
                                                  Container() :
                                                  Text(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString(),style: TextStyle(fontFamily: 'Google-Bold',color: kPrimaryColor,fontSize: 12),),
                                                  SizedBox(
                                                    width: screenwidth < 700 ? 2 : 5,
                                                  ),
                                                  int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) == 0 && int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) == 0  ?
                                                  Container(child: Text('Le match a été annulé'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Color.fromRGBO(104, 204, 46, 0.9),fontSize: 9),overflow: TextOverflow.ellipsis,)) :
                                                  int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) == int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) && int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) > 0 && int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) > 0 ?
                                                  Text('Match nul') :
                                                  int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['visitor_score'].toString()) > int.parse(snapshot.data[snapshot.data.length - 1 - index]['match']['home_score'].toString()) ? Container() :
                                                  Text('Victoire'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Color.fromRGBO(104, 204, 46, 0.9),fontSize: 9),),

                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  height: 45,
                                  width: 170,
                                )
                              ],
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              pastTicketMatches = true;
                              filterSearchService.filter(past: pastTicketMatches);
                            });
                            navigateMatch(index,context,snapshot.data[snapshot.data.length - 1 - index]);
                          },
                        ) :
                        GestureDetector(
                          child: Container(
                            width: 140,
                            margin: EdgeInsets.only(left: screenwidth < 700 ? 15 : 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                snapshot.data == null || teamNameData == null || events_clients == null || snapshot.data == null ?
                                Container () :
                                Text( snapshot.data[snapshot.data.length - 1 - index]['sched_date'].toString() == 'null' ? 'TBA' : dayFormateDay_year+' '+monthDate[int.parse(_dateConvertedString.toString())].toString()+'.'+' '+_dateConvertedDayYear.toString(),style: TextStyle(fontSize: 12,fontFamily: 'Google-Bold'),),
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
                                          padding: snapshot.data[snapshot.data.length - 1 - index]['filename'].toString() != 'null' ? EdgeInsets.all(0) : EdgeInsets.all(8),
                                          width: screenwidth,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey[400]),
                                              borderRadius: BorderRadius.circular(10),
                                              image: snapshot.data[snapshot.data.length - 1 - index]['filename'].toString() != 'null' ? DecorationImage(
                                                  fit:  BoxFit.cover,
                                                  image: NetworkImage('https://ujap.checkmy.dev/storage/events/'+snapshot.data[snapshot.data.length - 1 - index]['id'].toString()+'/'+snapshot.data[snapshot.data.length - 1 - index]['filename'])
                                              ) : null,
                                          ),
                                          child:  snapshot.data[snapshot.data.length - 1 - index]['filename'].toString() != 'null' ? Container() :
                                          Center(
                                            child: Image(
                                              width: 80,
                                              color: kPrimaryColor,
                                              fit:  BoxFit.cover,
                                              image:  AssetImage('assets/no_image_available.png'),
                                            ),
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
                                            child: Text(snapshot.data[snapshot.data.length - 1 - index]['name'].toString(),style: TextStyle(color: Colors.white,fontFamily: 'Google-Medium',fontSize: 12),
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
                                  child: snapshot.data[snapshot.data.length - 1 - index]['type'].toString() != "meeting" ? ViewEvent(
                                    eventDetail: snapshot.data[snapshot.data.length - 1 - index],
                                    pastEvent: true,
                                  ) : ViewEventDetails(
                                    eventDetail: snapshot.data[snapshot.data.length - 1 - index],
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
                            });
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
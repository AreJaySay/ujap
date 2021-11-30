import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/events_sub_pages_variables.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/globals/widgets/view_events.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/filter_events.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/no_data_yet.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/view_event.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/matches.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/navigate_match_events.dart';
import 'package:ujap/services/searches/search_service.dart';
import 'package:http/http.dart' as http;

List<String> attended_Meeting = List<String>();
Map newConfirmed;

class Events_listview extends StatefulWidget {
  @override
  _Events_listviewState createState() => _Events_listviewState();
}

class _Events_listviewState extends State<Events_listview> {

  var _finaleventsTime;
  var _timeConvertedString= "";
  int _timeConverted;
  int _finalTimeEvent;
  var _dateConvertedString = "";
  var _dateConvertedDayYear = "";
  List _teamName;
  List _hometeamName;
  int _daysbetween;
  List _attendedMeeting;
  List _eventStatus;
  List<String> _listChecker = List<String>();

  ScrollController _scrollController;
  bool _isOnTop = true;

  _scrollListener() {
    setState(() {
      scrollPosition = _scrollController.position.pixels;
    });
  }

  _scrollToTop() {
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
    setState(() => _isOnTop = true);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
        stream: filterSearchService.search$,
        builder: (context, snapshot) {
          return Container(
            width: screenwidth,
            height: screenheight,
            child: snapshot.data == null || teamNameData == null ?
            No_events_data() :
            Stack(
              children: [
                Container(
                  width: screenwidth,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  height: screenwidth < 700 ? screenheight/5 : screenheight/4.7,
                  margin: EdgeInsets.only(top: screenwidth < 700 ? screenwidth/2.5 : screenwidth/4.5,left: screenwidth < 700 ? screenwidth/15 :  screenwidth/18,right:  screenwidth < 700 ? screenwidth/15 :  screenwidth/18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenwidth < 700 ? screenwidth/30 : screenwidth/50,
                      ),
                      Image(
                        fit: BoxFit.contain,
                        width:  screenwidth < 700 ? 70 : screenwidth/6,
                        image: AssetImage('assets/sad.jpg'),
                      ),
                      SizedBox(
                        height: screenwidth < 700 ? screenwidth/40 : screenwidth/80,
                      ),
                      Expanded(
                        child: Container(
                            width: screenwidth,
                            height: screenheight,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text( !history_eventsmatches ? 'Pas d’évènement/match trouvé'.toUpperCase() : 'Pas d’historique trouvé'.toUpperCase(),style: TextStyle(fontSize: screenheight/60 ,fontFamily: 'Google-Bold',fontWeight: FontWeight.bold,color: Colors.black54),
                              textAlign: TextAlign.center,
                            )),
                      ),
                      Expanded(
                        child: Container(
                          width: screenwidth,
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.symmetric(horizontal: screenwidth/10),
                          height: screenheight,
                          child: Text('Tous les évènements/matchs auxquels vous avez participés apparaîtront ici.',textAlign: TextAlign.center,style: TextStyle(fontSize: screenheight/70 ,fontFamily: 'Google-Regular',fontWeight: FontWeight.bold,color: Colors.black54.withOpacity(0.3))),
                        ),
                      ),
                      SizedBox(
                        height: screenwidth/30,
                      ),
                    ],
                  ),
                ),
                NotificationListener<ScrollUpdateNotification>(
                  child: Container(
                    margin: EdgeInsets.only(top: 180),
                    child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(0),
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        itemCount:snapshot.data.length,
                        itemBuilder: (context, int index){
                          var dayFormateDay_year = "";

                          if (events_status != null){
                            _eventStatus = events_status.where((s) {
                              return s['event_id'].toString().toLowerCase() == snapshot.data[index]['id'].toString().toLowerCase();
                            }).toList();
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

                          if (snapshot.data[index]['sched_date'].toString() != 'null'){

                            var dateFormate = DateFormat("MM").format(DateTime.parse(snapshot.data[index]['sched_date']));
                            var dateFormateDay_year = DateFormat("yyyy").format(DateTime.parse(snapshot.data[index]['sched_date']));
                            dayFormateDay_year = DateFormat("d").format(DateTime.parse(snapshot.data[index]['sched_date']));

                            DateTime dateTimeCreatedAt = DateTime.parse(snapshot.data[index]['sched_date']);
                            DateTime dateTimeNow = DateTime.now();
                            final differenceInDays = dateTimeNow.difference(dateTimeCreatedAt).inDays;
                            _daysbetween = differenceInDays;

                            _dateConvertedString = dateFormate;
                            _dateConvertedDayYear = dateFormateDay_year;

                          }

                          bool _mathsymbol = false;

                          if (history_eventsmatches){
                            _mathsymbol = int.parse(DateFormat("yyyyMMdd").format(DateTime.parse(snapshot.data[index]['sched_date'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'')))) < int.parse(DateFormat("yyyyMMdd").format(DateTime.now()));
                          }
                          else{
                            _mathsymbol = int.parse(DateFormat("yyyyMMdd").format(DateTime.parse(snapshot.data[index]['sched_date'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'')))) >= int.parse(DateFormat("yyyyMMdd").format(DateTime.now()));
                          }

                          if (myAttended_events.toString().contains('client_id: '+userdetails['id'].toString()) || attended_Meeting.toString().contains(snapshot.data[index]['id'].toString()+userdetails['name'].toString())){
                            if(_mathsymbol){
                              if(!myAttended_events.toString().contains('ticket_id: '+snapshot.data[index]['ticket']['id'].toString()) && !attended_Meeting.toString().contains(snapshot.data[index]['id'].toString()+userdetails.toString()) && !attended_Meeting.toString().contains(snapshot.data[index]['id'].toString()+userdetails['name'].toString())){

                              }else{
                                _listChecker.add(snapshot.data[index].toString());
                              }
                            }
                          }


//                          snapshot.data[index]['id'].toString().toLowerCase() &&
                          return myAttended_events.toString().contains('client_id: '+userdetails['id'].toString()) || attended_Meeting.toString().contains(snapshot.data[index]['id'].toString()+userdetails['name'].toString()) ? Stack(
                            children: [
                              Container(
                                  child: _mathsymbol ?
                                  Container(
                                    child: !myAttended_events.toString().contains('ticket_id: '+snapshot.data[index]['ticket']['id'].toString()) && !attended_Meeting.toString().contains(snapshot.data[index]['id'].toString()+userdetails.toString()) && !attended_Meeting.toString().contains(snapshot.data[index]['id'].toString()+userdetails['name'].toString())? Container() :
                                    snapshot.data[index]['type'].toString() == 'match' ?
                                    GestureDetector(
                                      child: Container(
                                        height: screenwidth < 700 ? screenheight/4.5 : screenheight/4.7,
                                        margin: EdgeInsets.only(bottom: screenwidth < 700 ? 15 : 25,left: screenwidth < 700 ? screenwidth/15 :  screenwidth/18,right:  screenwidth < 700 ? screenwidth/15 :  screenwidth/18),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: screenheight/15,
                                              width: screenwidth,
                                              padding: EdgeInsets.symmetric(horizontal: screenwidth/30),
                                              decoration: BoxDecoration(
                                                  color:Color.fromRGBO(248, 248, 248, 0.9),
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 0 : 20 ),
                                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                                        child: Row(
                                                          children: [
                                                            Text("Nom du match:".toUpperCase() ,style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70  : 20,fontFamily: 'Google-Bold',color: Colors.grey[600]),),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Container(
                                                                width: screenwidth/3,
                                                                child: Text(snapshot.data[index]['name'].toString().toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70  : 20,fontFamily: 'Google-Bold',color: Colors.grey[800]),overflow: TextOverflow.ellipsis,)),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 3,
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 0 : 20 ),
                                                        padding: EdgeInsets.symmetric(horizontal: 20),
                                                        child: Row(
                                                          children: [
                                                            Text("Date du match:".toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70  : 20,fontFamily: 'Google-Bold',color: Colors.grey[600]),),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(DateFormat("d").format(DateTime.parse(snapshot.data[index]['sched_date'])).toString().toUpperCase()+' '+monthDate[int.parse(DateFormat("MM").format(DateTime.parse(snapshot.data[index]['sched_date'])).toString())].toString()+'.'+' '+DateFormat("yyyy").format(DateTime.parse(snapshot.data[index]['sched_date'])).toString().toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70  : 20,fontFamily: 'Google-Bold',color: Colors.grey[800]),),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(snapshot.data[index]['sched_time'].toString().substring(0,5),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70  : 20,fontFamily: 'Google-Bold',color: Colors.grey[800]),),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Container(
                                                    width: screenwidth/4,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          width : screenwidth < 700 ? screenwidth/5 : screenwidth/5,
                                                          height:  screenwidth < 700 ? screenwidth/5 : screenwidth/7,
                                                          child: Container(
                                                            child: Image(
                                                                fit: BoxFit.contain,
                                                                image:  NetworkImage('https://ujap.checkmy.dev/storage/teams/'+_hometeamName[0]['logo'].toString())
                                                            ),

                                                          ),
                                                        ),
                                                        Container(
                                                          width : screenwidth < 700 ? screenwidth/5 : screenwidth/5,
                                                          child: Center(
                                                            child: Text(_hometeamName[0]['name'].toString().toUpperCase(),textAlign: TextAlign.center,style: TextStyle(fontSize: screenwidth < 700 ? screenheight/78  : 20,fontFamily: 'Google-Bold',color: Colors.grey[800]),),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: screenwidth/4,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          height: screenwidth < 700 ? screenwidth/20 : screenwidth/20,
                                                          alignment: Alignment.center,
                                                          child: Container(
                                                            width : screenwidth < 700 ? screenwidth/5 : screenwidth/7,
                                                            height: screenwidth < 700 ? screenwidth/5 : screenwidth/7,
                                                            child: Image(
                                                              fit: BoxFit.contain,
                                                              color: Color.fromRGBO(204, 44, 65, 0.9),
                                                              image: AssetImage('assets/home_icons/staples_icon.png'),
                                                            ),
                                                          ),
                                                        ),
                                                        Text('VS',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/40 : 35,color: Color.fromRGBO(20, 74, 119, 0.9),fontFamily: 'Google-Bold'),),
                                                        SizedBox(
                                                          height: 3,
                                                        ),
                                                        Text('FRANCE - PRO B',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/85 : 17,fontFamily: 'Google-Bold',fontWeight: FontWeight.bold),),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: screenwidth/4,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                                      children: [
                                                        Container(
                                                          width : screenwidth < 700 ? screenwidth/7 : screenwidth/5,
                                                          height:  screenwidth < 700 ? screenwidth/7 : screenwidth/7,
                                                          child: Container(
                                                              child: Image(
                                                                fit: BoxFit.contain,
                                                                image:  NetworkImage('https://ujap.checkmy.dev/storage/teams/'+_teamName[0]['logo'].toString())
                                                            ),

                                                          ),
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets.only(top: 10),
                                                          child: Center(
                                                            child: Text(_teamName[0]['name'].toString().toUpperCase(),textAlign: TextAlign.center,style: TextStyle(fontSize: screenwidth < 700 ? screenheight/78  : 20,fontFamily: 'Google-Bold',color: Colors.grey[800]),),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: (){
                                        setState(() {
                                          navigateMatch(index,context,snapshot.data[index]);
                                        });
                                      },
                                    ) : GestureDetector(
                                      child: Container(
                                        height: screenwidth < 700 ? screenheight/5 : screenheight/4.7,
                                        width: screenwidth,
                                        margin: EdgeInsets.only(bottom: screenwidth < 700 ? 15 : 25,left: screenwidth < 700 ? screenwidth/15 :  screenwidth/18,right:  screenwidth < 700 ? screenwidth/15 :  screenwidth/18),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: screenwidth < 700 ? screenheight/5 : screenheight/4.7,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: Stack(
                                                children: [
                                                  snapshot.data[index]['filename'].toString() == "null" ?
                                                  Container(
                                                    height: screenwidth < 700 ? screenheight/5 : screenheight/4.7,
                                                    width: screenwidth,
                                                    child: Container(
                                                      padding: EdgeInsets.only(top: 10),
                                                      width: screenwidth,
                                                      child: Image(
                                                          fit: BoxFit.contain,
                                                          image: AssetImage('assets/no_image_available.png')
                                                      ),
                                                    ),
                                                    padding: EdgeInsets.all(20),
                                                  ) :
                                                  Container(
                                                    width: screenwidth,
                                                    height: screenwidth < 700 ? screenheight/5 : screenheight/4.7,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage('https://ujap.checkmy.dev/storage/events/'+snapshot.data[index]['id'].toString()+'/'+snapshot.data[index]['filename'])
                                                        )
                                                    ),
                                                  ),
                                                  Container(
                                                    width: screenwidth,
                                                    height: screenwidth < 700 ? screenheight/5 : screenheight/4.7,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.black.withOpacity( snapshot.data[index]['filename'].toString() == "null" ? 0.2 : 0.4),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: screenwidth,
                                              height: screenwidth < 700 ? screenheight/5 : screenheight/4.7,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: screenheight/15,
                                                    width: screenwidth,
                                                    decoration: BoxDecoration(
                                                      color:Color.fromRGBO(248, 248, 248, 0.9),
                                                      borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(10.0),
                                                          topRight: Radius.circular(10.0)),
                                                    ),
                                                    padding: EdgeInsets.symmetric(horizontal: screenwidth/30),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 0 : 20 ),
                                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                                              child: Row(
                                                                children: [
                                                                  Text( snapshot.data[index]['type'].toString().toLowerCase() == 'event' ? "NOM DE L'évènement:".toUpperCase() : "NOM DE L RÉUNION:".toUpperCase() ,style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70  : 20,fontFamily: 'Google-Bold',color: Colors.grey[600]),),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Container(
                                                                      width: screenwidth/3,
                                                                      child: Text(snapshot.data[index]['name'].toString().toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70  : 20,fontFamily: 'Google-Bold',color: Colors.grey[800]),overflow: TextOverflow.ellipsis,)),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 0 : 20 ),
                                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                                              child: Row(
                                                                children: [
                                                                  Text( snapshot.data[index]['type'].toString().toLowerCase() == 'event' ? "date de l'évènement:".toUpperCase() : "Date de la réunion:".toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70  : 20,fontFamily: 'Google-Bold',color: Colors.grey[600]),),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(DateFormat("d").format(DateTime.parse(snapshot.data[index]['sched_date'])).toString().toUpperCase()+' '+monthDate[int.parse(DateFormat("MM").format(DateTime.parse(snapshot.data[index]['sched_date'])).toString())].toString()+'.'+' '+DateFormat("yyyy").format(DateTime.parse(snapshot.data[index]['sched_date'])).toString().toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70  : 20,fontFamily: 'Google-Bold',color: Colors.grey[800]),),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(snapshot.data[index]['sched_time'].toString().substring(0,5),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70  : 20,fontFamily: 'Google-Bold',color: Colors.grey[800]),),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: (){
                                        setState(() {
                                          Navigator.push(context, PageTransition(
                                              child: snapshot.data[index]['type'].toString() != "meeting" ? ViewEvent(
                                                eventDetail: snapshot.data[index],
                                                pastEvent: _mathsymbol ? false : true,
                                              ) : ViewEventDetails(
                                                eventDetail: snapshot.data[index],
                                                pastEvent: _mathsymbol ? false : true,
                                              ),
                                              type: PageTransitionType.topToBottom
                                          ));
                                        });
                                      },
                                    ),
                                  ) : Container()
                              ),

                            ],
                          ) : Container(
                          );
                        }

                    ),
                  ),
                  onNotification: (ScrollNotification notification) {
                    if (_scrollController.position.userScrollDirection != ScrollDirection.forward){
                      setState(() {
                        hideFloatingbutton = true;
                      });
                    }else{
                      hideFloatingbutton = false;
                    }
                  },
                ),
                !hideFloatingbutton ? Container() : Container(
                  width: screenwidth,
                  height: screenheight,
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.only(right: screenwidth/30,bottom: screenwidth/20),
                  child:  Container(
                    width: screenwidth < 700 ? screenwidth/7 : screenwidth/12,
                    height: screenwidth < 700 ? screenwidth/7 : screenwidth/12,
                    child: FloatingActionButton(
                      heroTag: 'btn3',
                      backgroundColor: kPrimaryColor,
                      onPressed:  _scrollToTop,
                      child: Icon(Icons.arrow_upward,size: screenwidth < 700 ? screenwidth/20 : screenwidth/30,),
                    ),

                  ),
                )
              ],
            ),
          );
        }
    );
  }
}
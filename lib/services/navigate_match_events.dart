import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/variables/events_sub_pages_variables.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/widgets/view_events.dart';
import 'package:ujap/globals/widgets/view_matches.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/matches.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/view_ticket.dart';

var _finaleventsTime;
var _timeConvertedString= "";
int _timeConverted;
int _finalTimeEvent;
var _dateConvertedString = "";
var _dateConvertedDayYear = "";
List _teamName;
List _eventStatus;
var ticketID = "";
var type = "";

bool _ticketColorattend = false;
bool _ticketColorpass = false;

List _ticketColors;


navigateMatch(index,context,Map _pastMatchsList){
  // MATCH
  if (_pastMatchsList['sched_time'].toString() != 'null'){
    var _text =  _pastMatchsList['sched_time'].toString();
    _finaleventsTime = _text.substring(0,5);
    _timeConverted = int.parse(_finaleventsTime.substring(0,2));
    var timeConvertedString = _text.substring(3,5);
    var _timetopass;


     matchTime = _timeConverted.toString()+':'+timeConvertedString.toString();
     hideFloatingbutton = false;
  }
  else{
     matchTime = 'TBA';
  }

  // MATCH DATE
  if (_pastMatchsList['sched_date'].toString() != 'null'){
    var dateFormate = DateFormat("MM").format(DateTime.parse(_pastMatchsList['sched_date']));
    var dateFormateDay_year = DateFormat("yyyy").format(DateTime.parse(_pastMatchsList['sched_date']));
    var dayFormateDay_year = DateFormat("d").format(DateTime.parse(_pastMatchsList['sched_date']));

    var _dateConvertedString = dateFormate;
    var _dateConvertedDayYear = dateFormateDay_year;

     matchDate = dayFormateDay_year.toString()+' '+monthDate[int.parse(_dateConvertedString.toString())].toString()+'.'+' '+_dateConvertedDayYear.toString();
  }
  else{
     matchDate  = 'TBA';
  }


  String _matchID = _pastMatchsList['id'].toString();
  String _image = 'https://ujap.checkmy.dev/storage/events/'+_pastMatchsList['id'].toString()+'/'+_pastMatchsList['filename'].toString();
  String _visitorID = _pastMatchsList['match']['visitor_team_id'].toString();
  String _homeID = _pastMatchsList['match']['home_team_id'].toString();
  String _courtID  = _pastMatchsList['match']['home_court'].toString();
  ticketID = _pastMatchsList['ticket']['id'].toString();
  type = _pastMatchsList['type'].toString();

  Navigator.push(context, PageTransition(child: View_matches(
      _pastMatchsList,_matchID,_image,_visitorID,_homeID,_courtID,ticketID,type,_pastMatchsList['name']
  ),type: PageTransitionType.topToBottom,alignment: Alignment.center, curve: Curves.easeIn,));


}

navigateTicket(index,context,Map _tikcetDatas){
  // MATCH
  if (_tikcetDatas['sched_time'].toString() != 'null'){
    var _text =  _tikcetDatas['sched_time'].toString();
    _finaleventsTime = _text.substring(0,5);
    _timeConverted = int.parse(_finaleventsTime.substring(0,2));
    var timeConvertedString = _text.substring(3,5);
    var _timetopass;

    if (_timeConverted > 12){
      _timetopass = _timeConverted-12;
    }
    else{
      _timetopass = int.parse(_finaleventsTime.substring(0,2));
    }

    matchTime = _timeConverted.toString()+':'+timeConvertedString.toString();
    hideFloatingbutton = false;
  }
  else{
    matchTime = 'TBA';
  }

  // MATCH DATE
  if (_tikcetDatas['sched_date'].toString() != 'null'){
    var dateFormate = DateFormat("MM").format(DateTime.parse(_tikcetDatas['sched_date']));
    var dateFormateDay_year = DateFormat("yyyy").format(DateTime.parse(_tikcetDatas['sched_date']));
    var dayFormateDay_year = DateFormat("d").format(DateTime.parse(_tikcetDatas['sched_date']));

    var _dateConvertedString = dateFormate;
    var _dateConvertedDayYear = dateFormateDay_year;

    matchDate = dayFormateDay_year.toString()+' '+monthDate[int.parse(_dateConvertedString.toString())].toString()+'.'+' '+_dateConvertedDayYear.toString();
  }
  else{
    matchDate  = 'TBA';
  }

  String _matchID = _tikcetDatas['id'].toString();
  String _image = 'https://ujap.checkmy.dev/storage/events/'+_tikcetDatas['id'].toString()+'/'+_tikcetDatas['filename'].toString();
  String _visitorID = _tikcetDatas['match']['visitor_team_id'].toString();
  String _homeID = _tikcetDatas['match']['home_team_id'].toString();
  ticketID = _tikcetDatas['ticket']['id'].toString();

  Navigator.push(context, PageTransition(child:  Ticket_homepage(
      _matchID,_image,_visitorID,_homeID,ticketID,_tikcetDatas['name']
  ),type: PageTransitionType.rightToLeftWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));


}
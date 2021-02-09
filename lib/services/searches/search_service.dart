import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/variables/events_sub_pages_variables.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/widgets/appbar_icons.dart';
import 'package:ujap/globals/widgets/view_matches.dart';
import 'package:ujap/services/api.dart';

class FilterSearchService{
  BehaviorSubject<List> _event = BehaviorSubject.seeded(eventsData);

  Stream get search$=>_event.stream;

  List get current=>_event.value;

  filter({String searchBox = "", String viewData ="", int convertedDateFilter = 0, int convertDateFilterTo = 99999999999, String statusData = "", String tabbar = "", bool past = false}) async
  {

    events_tabbarview_index = tabbar;
    pastTicketMatches = past;


    List newData = eventsData.where((s){
      if (searchBox.toString().toLowerCase().contains('AM'.toString().toLowerCase())){
        return DateFormat("MMMM d,yyyy").format(DateTime.parse(s['sched_date'])).toString().toLowerCase().contains(searchBox.toString().toLowerCase())
            || int.parse(s['sched_time'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'').substring(0,2).toString()) <= 12 ||
            s['sched_time'].toString().toLowerCase().contains(searchBox.toString().toLowerCase()) ||
            s['name'].toString().toLowerCase().contains(searchBox.toString().toLowerCase()) ||
            s['type'].toString().toLowerCase().contains(searchBox.toString().toLowerCase());
      }
      else if(searchBox.toString().toLowerCase().contains('PM'.toString().toLowerCase())){
        return DateFormat("MMMM d,yyyy").format(DateTime.parse(s['sched_date'])).toString().toLowerCase().contains(searchBox.toString().toLowerCase())
            || int.parse(s['sched_time'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'').substring(0,2).toString()) > 12 ||
            s['sched_time'].substring(0,5).toString().toLowerCase().contains(searchBox.toString().toLowerCase()) ||
            s['name'].toString().toLowerCase().contains(searchBox.toString().toLowerCase())||
            s['type'].toString().toLowerCase().contains(searchBox.toString().toLowerCase());
      }
      else{
        return DateFormat("MMMM d,yyyy").format(DateTime.parse(s['sched_date'])).toString().toLowerCase().contains(searchBox.toString().toLowerCase())
            ||  s['name'].toString().toLowerCase().contains(searchBox.toString().toLowerCase())||
            s['type'].toString().toLowerCase().contains(searchBox.toString().toLowerCase());
      }
    }).toList().where((s){
      if (s['end_date'].toString() == 'null'){
        return int.parse(DateFormat("yyyyMMdd").format(DateTime.parse(s['sched_date'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'')))) >= convertedDateFilter;
      }
      else if (convertedDateFilter != 0 || convertDateFilterTo != 99999999999){
        return int.parse(DateFormat("yyyyMMdd").format(DateTime.parse(s['sched_date'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'')))) > convertedDateFilter && int.parse(DateFormat("yyyyMMdd").format(DateTime.parse(s['end_date'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'')))) <= convertDateFilterTo;
      }
      else{
        return int.parse(DateFormat("yyyyMMdd").format(DateTime.parse(s['sched_date'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'')))) > convertedDateFilter &&  int.parse(DateFormat("yyyyMMdd").format(DateTime.parse(s['end_date'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'')))) < convertDateFilterTo;
      }
    }).toList().where((s){

      var _dateNow = DateTime.now().toString();
      var _dateDayConvertedTo = _dateNow.substring(0,10);

      if (statusData.toString().toLowerCase() == "Newest".toString().toLowerCase()){
        return int.parse(DateFormat("yyyyMMdd").format(DateTime.parse(s['sched_date'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'')))) > int.parse(DateFormat("yyyyMMdd").format(DateTime.now()));
      }
      else if(statusData.toString().toLowerCase() == "Ongoing".toString().toLowerCase()){
        return int.parse(DateFormat("yyyyMMdd").format(DateTime.parse(s['sched_date'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'')))) == int.parse(DateFormat("yyyyMMdd").format(DateTime.now()));
      }
      else{
        return int.parse(DateFormat("yyyyMMdd").format(DateTime.parse(s['sched_date'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'')))) > 0;
      }
    }).toList().where((s){
      return s['type'].toString().toLowerCase().contains(viewData.toString().toLowerCase());
    }).toList();

    _event.add(newData);
  }

  addData({List event,double events_attendedmatch, double events_allocationmatch, List eventsAttended_clientmatch, List eventStatusmatch})
  {
    events_attendedmatch = events_attendedmatch;
    events_allocationmatch = events_allocationmatch;
    eventStatusmatch = eventStatusmatch;
    if (eventStatusmatch != null){
      eventsAttended_clientmatch =  eventStatusmatch[0]['declined_clients'];
    }

    if (newData.toString() != "[]"){
      _event.add(event);
    }
  }
}
FilterSearchService filterSearchService = FilterSearchService();



List newData;

class MatchDataService{
  BehaviorSubject<List> _event = BehaviorSubject.seeded(matchLength);

  Stream get search$=>_event.stream;

  List get current=>_event.value;


  filter({String searchBox = ""}) async
  {

    newData = matchLength.where((s){
      if (searchBox.toString().toLowerCase().contains('AM'.toString().toLowerCase())){
        return DateFormat("MMMM d,yyyy").format(DateTime.parse(s['sched_date'])).toString().toLowerCase().contains(searchBox.toString().toLowerCase())
            || int.parse(s['sched_time'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'').substring(0,2).toString()) <= 12 ||
            s['sched_time'].toString().toLowerCase().contains(searchBox.toString().toLowerCase()) ||
            s['name'].toString().toLowerCase().contains(searchBox.toString().toLowerCase()) ||
            s['type'].toString().toLowerCase().contains(searchBox.toString().toLowerCase());
      }
      else if(searchBox.toString().toLowerCase().contains('PM'.toString().toLowerCase())){
        return DateFormat("MMMM d,yyyy").format(DateTime.parse(s['sched_date'])).toString().toLowerCase().contains(searchBox.toString().toLowerCase())
            || int.parse(s['sched_time'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'').substring(0,2).toString()) > 12 ||
            s['sched_time'].substring(0,5).toString().toLowerCase().contains(searchBox.toString().toLowerCase()) ||
            s['name'].toString().toLowerCase().contains(searchBox.toString().toLowerCase())||
            s['type'].toString().toLowerCase().contains(searchBox.toString().toLowerCase());
      }
      else{
        return DateFormat("MMMM d,yyyy").format(DateTime.parse(s['sched_date'])).toString().toLowerCase().contains(searchBox.toString().toLowerCase())
            ||  s['name'].toString().toLowerCase().contains(searchBox.toString().toLowerCase())||
            s['type'].toString().toLowerCase().contains(searchBox.toString().toLowerCase());
      }
    }).toList();

      _event.add(newData);


  }

  addData({List event})
  {
    getEvents_status();

    if (newData == null){
      _event.add(event);
    }
  }
  updateAll({List data}){
    _event.add(data);
  }
}
MatchDataService matchservice = MatchDataService();




class MiddleDataService{
  BehaviorSubject<List> _event = BehaviorSubject.seeded(middlematchEvents);

  Stream get search$=>_event.stream;

  List get current=>_event.value;

  filter({String searchBox = ""}) async
  {

     newData = middlematchEvents.where((s){
      if (searchBox.toString().toLowerCase().contains('AM'.toString().toLowerCase())){
        return DateFormat("MMMM d,yyyy").format(DateTime.parse(s['sched_date'])).toString().toLowerCase().contains(searchBox.toString().toLowerCase())
            || int.parse(s['sched_time'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'').substring(0,2).toString()) <= 12 ||
            s['sched_time'].toString().toLowerCase().contains(searchBox.toString().toLowerCase()) ||
            s['name'].toString().toLowerCase().contains(searchBox.toString().toLowerCase()) ||
            s['type'].toString().toLowerCase().contains(searchBox.toString().toLowerCase());
      }
      else if(searchBox.toString().toLowerCase().contains('PM'.toString().toLowerCase())){
        return DateFormat("MMMM d,yyyy").format(DateTime.parse(s['sched_date'])).toString().toLowerCase().contains(searchBox.toString().toLowerCase())
            || int.parse(s['sched_time'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'').substring(0,2).toString()) > 12 ||
            s['sched_time'].substring(0,5).toString().toLowerCase().contains(searchBox.toString().toLowerCase()) ||
            s['name'].toString().toLowerCase().contains(searchBox.toString().toLowerCase())||
            s['type'].toString().toLowerCase().contains(searchBox.toString().toLowerCase());
      }
      else{
        return DateFormat("MMMM d,yyyy").format(DateTime.parse(s['sched_date'])).toString().toLowerCase().contains(searchBox.toString().toLowerCase())
            ||  s['name'].toString().toLowerCase().contains(searchBox.toString().toLowerCase())||
            s['type'].toString().toLowerCase().contains(searchBox.toString().toLowerCase());
      }
    }).toList();

    _event.add(newData);
  }

  addData({List event})
  {

    if (newData.toString() != "[]"){
      _event.add(event);
    }
  }

}
MiddleDataService middleservice = MiddleDataService();






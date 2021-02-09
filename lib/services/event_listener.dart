import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/searches/search_service.dart';

class EventDataService{
  BehaviorSubject<List> _event = BehaviorSubject.seeded([]);

  Stream get search$=>_event.stream;

  List get current=>_event.value;


  filter({String searchBox = ""}) async
  {

    newData = this.current.where((s){
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

    if (newData.toString() != "[]"){
      _event.add(event);
    }
    print(this.current);
  }
  appendNew({Map data})
  {
    getEvents_status();
    this.current.add(data);
    _event.add(this.current);
  }

}
EventDataService eventservice = EventDataService();
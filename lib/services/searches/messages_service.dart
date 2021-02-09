import 'dart:collection';
import 'dart:convert';

import 'package:kt_dart/collection.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/variables/messages_sub_pages_variables.dart';
import 'package:ujap/globals/widgets/appbar_icons.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/create_new_group.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/message_data.dart';
import 'package:ujap/services/searches/search_service.dart';

searchMessageFilter(){
  List _local;
  List _ownMessages;


   _ownMessages = ownMessages_backup.where((s){
    return s['name'].toString().toLowerCase().contains(searchBoxMessage.toString().toLowerCase());
  }).toList();


  // messages.addData(data: _ownMessages);
}

class Messagerecentservice{
  BehaviorSubject<List> _event = BehaviorSubject.seeded(privateMessages);

  Stream get search$=>_event.stream;

  List get current=>_event.value;

  filter({String searchBox = ""}) async
  {
    newData = ownMessages.where((s){
      return s['name'].toString().toLowerCase().contains(searchBox.toString().toLowerCase()) || s['lastname'].toString().toLowerCase().contains(searchBox.toString().toLowerCase()) || s['name'].toString().toLowerCase().contains(searchBox.toString().toLowerCase()) || s['lastname'].toString().toLowerCase().contains(searchBox.toString().toLowerCase());
    }).toList();

    _event.add(newData);


  }


  addData({List event})
  {

    ownMessages_client = ownMessages_client;
    showsearchBox = showsearchBox;

      if (newData.toString() != "[]") {
          _event.add(event);
      }
  }

}
Messagerecentservice messagerecentservice = Messagerecentservice();


class Messagepublicservice{
  BehaviorSubject<List> _event = BehaviorSubject.seeded(privateMessages);

  Stream get search$=>_event.stream;

  List get current=>_event.value;

  filter({String searchBox = ""}) async
  {
      newData = privateMessages.where((s){
        return s['members'][0]['detail']['name'].toString().toLowerCase().contains(searchBox.toString().toLowerCase()) || s['members'][0]['detail']['lastname'].toString().toLowerCase().contains(searchBox.toString().toLowerCase());
      }).toList();

    _event.add(newData);


  }


  addData({List event})
  {

    ownMessages_client = ownMessages_client;

    if (newData.toString() != "[]") {
        _event.add(event);
    }
  }

}
Messagepublicservice messageservice = Messagepublicservice();


class Messageprivateservice{
  BehaviorSubject<List> _event = BehaviorSubject.seeded(clean);

  Stream get search$=>_event.stream;

  List get current=>_event.value;

  filter({String searchBox = ""}) async
  {
    newData = clean.where((s){
      return s['name'].toString().toLowerCase().contains(searchBox.toString().toLowerCase());
    }).toList();

    _event.add(newData);


  }

  updateAll({List data}){
    _event.add(data);
  }
  addData({List event})
  {

    addMembers = addMembers;

    if (newData.toString() != "[]"){
        _event.add(event);
    }
  }

}
Messageprivateservice messageservice_private = Messageprivateservice();
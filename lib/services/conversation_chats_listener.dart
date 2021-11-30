import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/new_compose_message.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/conversation_listener.dart';
import 'package:ujap/services/message_controller.dart';
import 'package:ujap/services/pushnotification.dart';
class ChatListener {
  BehaviorSubject<List> _chats = BehaviorSubject.seeded([]);
  Stream get stream$ => _chats.stream;
  List get current => _chats.value;
  int current_channelID = 0;

  updateChannelID({int id }) => this.current_channelID = id;
  int getChannelID() => this.current_channelID;
  updateAll({List data}){
    _chats.add(data);
    conversationService.sort();
  }
  append({Map data}){
    try{
      print('SUCCESS APPEND');
      this.current.add(data);
      _chats.add(this.current);
    }
    catch(e){
      print("ERROR APPEND : $e");
    }
  }
  removeLocals(){
    try{
      this.current.removeWhere((element) => element['foo'] != null && element['foo'] == "local");
      _chats.add(this.current);
    }catch(e){
      print("ERROR REMOVAL: $e");
    }
  }

}
ChatListener chatListener = ChatListener();
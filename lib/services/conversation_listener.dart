import 'dart:convert';
import 'dart:io';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/services/conversation_chats_listener.dart';
import 'package:ujap/services/message_controller.dart';
import 'package:ujap/services/new_messages_counter.dart';
class ConversationService{
  BehaviorSubject<List> conversation = BehaviorSubject.seeded([]);
  Stream get convo => conversation.stream;
  List get currentConvo => conversation.value;
  final String urlString = "https://ujap.checkmy.dev/api/client";
  updateAll({List data}){
    conversation.add(data);
    this.sort();

  }
  sort(){
    try{
      NMessageCounter().countFetcher(this.currentConvo);

      currentConvo.sort((a,b) {
        if(a['last_convo'] != null && b['last_convo'] != null){
          return DateTime.parse(b['last_convo']['date_sent'].toString()).compareTo(DateTime.parse(a['last_convo']['date_sent'].toString()));
        }
        return - 1;
      });
      conversation.add(currentConvo);
    }catch(e){
      print("Sorting Error : $e");
    }

  }
  append({Map data}){
    currentConvo.add(data);
    conversation.add(currentConvo);
    this.sort();
  }
  appendNewMessageOnConvo({int convoId, Map data})
  {
    try{
      currentConvo.where((element) => int.parse(element['id'].toString()) == convoId).toList()[0]['messages'].add(data);

      conversation.add(currentConvo);
      this.sort();
      print("Append success by ${userdetails['id']}");
    }catch(e){
      print("ERROR on append : $e");
    }
  }
  updateUnreadMessage(int channelID) {
    try{
      this.currentConvo.where((element) => int.parse(element['id'].toString()) == channelID).toList()[0]['unread_messages'] += 1;
      conversation.add(this.currentConvo);
      NMessageCounter().countFetcher(this.currentConvo);
    }catch(e){
      print("ERROR : $e");
    }
  }
  readMessage({int on}) {
    this.currentConvo.where((element) => int.parse(element['id'].toString()) == on).toList()[0]['unread_messages'] = 0;
    conversation.add(this.currentConvo);
    NMessageCounter().countFetcher(this.currentConvo);
    this.readMessageServer(on);
  }
  readMessageServer(int channelId) async {
    try{
      await http.put("${this.urlString}/channel/read_message",headers: {
        HttpHeaders.authorizationHeader : "Bearer $accesstoken",
        "accept" : "application/json"
      }, body: {
        "channel_id" : "$channelId",
        "client_id" : "${userdetails['id']}"
      }).then((value) {
        var data = json.decode(value.body);
        print(data);
      });
      return true;
    }catch(e){
      print("Error readMessageServer : $e");
      return null;
    }
  }
  updateLastConvo({int onId, Map data}){
    this.currentConvo.where((element) => int.parse(element['id'].toString()) == onId).toList()[0]['last_convo'] = data;
    conversation.add(this.currentConvo);
    this.sort();
  }
  getMessageConvo({int convoId}){
    if(checkConvoExist(convoId: convoId)){
      return currentConvo.where((element) => int.parse(element['id'].toString()) == convoId).toList()[0];
    }else{
      //fetch from server
    }
  }
  deleteChannelLoc(int channelid) {
    currentConvo.removeWhere((element) => int.parse(element['id'].toString()) == channelid);
    conversation.add(currentConvo);
    this.deleteChannel(channelid,);
  }
  Future deleteChannel(int channelid) async {
    try{
      final respo = await http.put("$urlString/channel/${channelid}/remove_for/${userdetails['id']}",headers: {
        "accept" : "application/json",
         HttpHeaders.authorizationHeader : "Bearer $accesstoken"
      },);
    }catch(e){
      print('CANNOT REMOVE CONVO :'+e.toString());
    }
  }
  Future deletegroupChannel(int id)async{
    try{
      final respo = await http.delete("$urlString/channel/delete?id=$id",headers: {
        "accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer $accesstoken"
      },);
    }catch(e){

    }
  }
  Map checker(List<int> memberIds) {
    for(var convos in this.currentConvo){
      List<int> toCheck = [];
      for(var members in convos['members']){
        toCheck.add(int.parse(members['client_id'].toString()));
      }
      toCheck.sort();
      if(listEquals(memberIds, toCheck)){
        print("EXIST");
        return convos;
      }
    }
    return null;
  }
  Future readServer() async {
    try{
      await http.put("$urlString/channel/read_message",body: {

      });
    }catch(e){

    }
  }
  Future<Map> checkConvoMembersExist({List<int> memberIds}) async {
    print("MEMBER IDS : $memberIds");
    memberIds.sort();
    if(memberIds.length== 0){
      try{
        Map data = this.currentConvo.where((element) => element['members'].length == 1 && int.parse(element['members'][0]['client_id'].toString()) == int.parse(userdetails['id'].toString())).toList()[0];
        print("JUST ME");
        return data;
      }catch(e){
        memberIds = [int.parse(userdetails['id'].toString())];

        if(checker(memberIds) != null){
          return checker(memberIds);
        }
        return await this.createChannel(memberIds);
      }
    }else{
      for(var convos in this.currentConvo){
        List<int> toCheck = [];
        for(var members in convos['members']){
          toCheck.add(int.parse(members['client_id'].toString()));
        }
        toCheck.sort();
        if(listEquals(memberIds, toCheck)){
          print("EXIST");
          chatListener.updateAll(data: convos['messages']);
          return convos;
        }
      }
    }
    print("Does not Exist");
    memberIds.remove(int.parse(userdetails['id'].toString()));
    return await this.createChannel(memberIds);
  }
  bool checkConvoExist({int convoId}){
    for(var items in currentConvo){
      if(items['id'] == convoId){
        return true;
      }
    }
    return false;
  }
  Future addMember(int channelId, int id) async {
    try{

      final respo = await http.post("$urlString/channel/add-member",headers: {
        HttpHeaders.authorizationHeader : "Bearer $accesstoken",
        "accept" : "application/json"
      }, body: {
        "client_id" : id.toString(),
        "channel_id" : channelId.toString()
      });
      var data = json.decode(respo.body);
      if(respo.statusCode == 200){
        this.currentConvo.where((element) => int.parse(element['id'].toString()) == channelId).toList()[0]['members'].add(data);
        messagecontroller.sendmessage('', 'Vous avez été ajouté à un groupe', id, true, "a_member");
        return data;
      }
      return null;
    }catch(e){
      print("ERROR ADDING MEMBER : $e");
      return null;
    }
  }
  Future createChannel(List<int> memberIds) async {
    try{
      final respo = await http.post("$urlString/channel/add",headers: {
        HttpHeaders.authorizationHeader : "Bearer $accesstoken",
        "accept" :"application/json"
      },body: {
        "name" : "ec0fc0100c4fc1ce4eea230c3dc10360",
        "client_id" : userdetails['id'].toString()
      });
      var data = json.decode(respo.body);
      if(respo.statusCode == 200){
        this.append(data: data);
        for(var x in memberIds){
          await this.addMember(data['id'], x);
        }
        chatListener.updateAll(data: []);
        chatListener.updateChannelID(id: data['id']);
        print("DATA : $data");
        return data;
      }
      print("ERROR : ${respo.reasonPhrase}");
    }catch(e){
      print("ERROR : $e");
      return null;
    }
  }

}

ConversationService conversationService = ConversationService();
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:ujap/globals/variables/messages_sub_pages_variables.dart';
import 'package:ujap/globals/widgets/appbar_icons.dart';
import 'package:ujap/globals/widgets/banner.dart';
import 'package:ujap/globals/widgets/show_flushbar.dart';
import 'package:ujap/pages/drawer_page.dart';
import 'package:ujap/pages/homepage.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/new_compose_message.dart';
import 'package:ujap/services/ad_listener.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/event_listener.dart';
import 'package:ujap/services/message_controller.dart';
import 'package:ujap/services/notifications.dart';
import 'package:ujap/services/sample_sqlite.dart';

var messagingToken = "";

void addToDb({String itemid, String messageTypes}) async {
  var id = await DatabaseHelper.instance.insert(Todo( itemid: itemid, messageType: messageTypes));
  // taskList.insert(0, Todo(id: id, itemid: itemid.toString(), messageType: messageTypes));
  print('DATAS :'+id.toString());
}

// SEND NOTIFICATION ON CLIENT
final String TokenServer = 'AAAAul-TWVQ:APA91bEbjbQq6LFzBXst8KDbr_PKlCFHXtQoxOAhJBMhVbTXQUI5lTo_kAGclXh-qKS54dDALWTme8YxYWR19g-kim2CXsydSzO76oMdsBojSWBK98viVtdCbIjpVrRKrRiZwYM-wEBu';
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
class PushNotification {
  Future getFCMToken ()async{
    fcmToken = await firebaseMessaging.getToken();
  }
  void subscribe(int id) {
    firebaseMessaging.subscribeToTopic('Subscription$id');
  }
  void unsubscribe(int id) {
    firebaseMessaging.unsubscribeFromTopic('Subscription$id');
  }
  void _deleteTask(int id) async {
    await DatabaseHelper.instance.delete(id);
    taskList.removeWhere((element) => element.itemid == id);
  }
  Future initListen(context) async {
    firebaseMessaging.configure(
      onMessage: (Map message) async {
        try{
          if(Platform.isAndroid){
            print("Android MESSAGE : $message");
            if(message['data']['type'] == "message"){
              if(message['data']['refresh'] == 'false'){
                if (message['data']['sender'].toString() == userdetails['name'].toString()){
                }else if (message['data']['reason'].toString() == 'deletegroup'){
                }else{
                  var mappedData = json.decode(message['data']['data']);
                  messagecontroller.messagechecker(context, mappedData);
                  print('OR DIDI NASULOD :'+message.toString());
                }
              }else{
                if (message['data']['sender'].toString() == userdetails['name'].toString()){
                }else if (message['data']['reason'].toString() == 'deletegroup'){
                }else{
                  messagecontroller.messageHandler(message['data'],context);
                }
              }
              getPersonMessage();
            }else if(message['data']['type'] == "event"){
              var mappedData = json.decode(message['data']['data']);
              eventservice.appendNew(data: mappedData);
              NotificationDisplayer().showNotification(mappedData['type'].toString() == 'event' ? 'Nouvel événement programmé.' : mappedData['type'].toString() == 'match' ? 'Un nouveau match a été programmé.' : 'Une nouvelle réunion a été programmée.', "Annonce nouvelle Ujap", context, mappedData['id'].toString(),mappedData['type'].toString());
              notificationIndicator = true;
              notificID = mappedData['id'].toString();
              notificType = 'Event';
              getEvents();

            }else{
              var mappedData = json.decode(message['data']['data']);
              bannerDisplay.update(mappedData);
              print('ADVERTISEMENT :'+mappedData.toString());
              AdListener().showAd(context,mappedData);
              notificID = mappedData['id'].toString();
              notificType = 'Event';
            }
          }else{
            print("IOS MESSAGE : $message");
            if(message['type'] == 'message'){
              if(message['refresh'] == 'false'){
                if (message['sender'].toString() == userdetails['name'].toString()){
                }else if (message['reason'].toString() == 'deletegroup'){

                }else if (!message['recievers'].toString().contains(userdetails['id'].toString())){

                }else{
                  var mappedData = json.decode(message['data']);
                  messagecontroller.messagechecker(context, mappedData);
                }
              }else{
                if (message['sender'].toString() == userdetails['name'].toString()){
                }else if (message['reason'].toString() == 'deletegroup'){

                }else{
                  messagecontroller.messageHandler(message['data'],context);
                }
              }
              getPersonMessage();

            }else if(message['type'] == "event"){
              print('EVENT ANDRIOD :'+message.toString());
              var mappedData = json.decode(message['data']);
              eventservice.appendNew(data: mappedData);
              NotificationDisplayer().showNotification(mappedData['type'].toString() == 'event' ? 'Nouvel événement programmé.' : mappedData['type'].toString() == 'match' ? 'Un nouveau match a été programmé.' : 'Une nouvelle réunion a été programmée.', "Nouvel évènement", context, mappedData['id'].toString(),mappedData['type'].toString(),image: "");
              notificationIndicator = true;
              notificID = mappedData['id'].toString();
              notificType = 'Event';
              getEvents();

            }else{
              var mappedData = json.decode(message['data']);
              bannerDisplay.update(mappedData);
              AdListener().showAd(context, mappedData);
              notificID = mappedData['id'].toString();
              notificType = 'Event';
            }
          }
        }catch(e){
          Messagecontroller().printWrapped("onMessage Error : $e");
        }
        // Navigator.pushReplacement(
        //   context,
        //   PageRouteBuilder(pageBuilder: (_, __, ___) => MainScreen(false)),
        // );
      },
      onLaunch: (Map<String, dynamic> message) async {
        try{
          if(Platform.isAndroid){
            print("Android MESSAGE : $message");
            if(message['data']['type'] == "message"){
              if(message['data']['refresh'] == 'false'){
                if (message['data']['sender'].toString() == userdetails['name'].toString()){
                }else if (message['data']['reason'].toString() == 'deletegroup'){
                }else{
                  var mappedData = json.decode(message['data']['data']);
                  messagecontroller.messagechecker(context, mappedData);
                  print('OR DIDI NASULOD :'+message.toString());
                }
              }else{
                if (message['data']['sender'].toString() == userdetails['name'].toString()){
                }else if (message['data']['reason'].toString() == 'deletegroup'){
                }else{
                  messagecontroller.messageHandler(message['data'],context);
                }
              }
              getPersonMessage();
            }else if(message['data']['type'] == "event"){
              var mappedData = json.decode(message['data']['data']);
              eventservice.appendNew(data: mappedData);
              NotificationDisplayer().showNotification(mappedData['type'].toString() == 'event' ? 'Nouvel événement programmé.' : mappedData['type'].toString() == 'match' ? 'Un nouveau match a été programmé.' : 'Une nouvelle réunion a été programmée.', "Annonce nouvelle Ujap", context, mappedData['id'].toString(),mappedData['type'].toString());
              notificationIndicator = true;
              notificID = mappedData['id'].toString();
              notificType = 'Event';
              getEvents();

            }else{
              var mappedData = json.decode(message['data']['data']);
              bannerDisplay.update(mappedData);
              print('ADVERTISEMENT :'+mappedData.toString());
              AdListener().showAd(context,mappedData);
              notificID = mappedData['id'].toString();
              notificType = 'Event';
            }
          }else{
            print("IOS MESSAGE : $message");
            if(message['type'] == 'message'){
              if(message['refresh'] == 'false'){
                if (message['sender'].toString() == userdetails['name'].toString()){
                }else if (message['reason'].toString() == 'deletegroup'){

                }else if (!message['recievers'].toString().contains(userdetails['id'].toString())){

                }else{
                  var mappedData = json.decode(message['data']);
                  messagecontroller.messagechecker(context, mappedData);
                }
              }else{
                if (message['sender'].toString() == userdetails['name'].toString()){
                }else if (message['reason'].toString() == 'deletegroup'){

                }else{
                  messagecontroller.messageHandler(message['data'],context);
                }
              }
              getPersonMessage();

            }else if(message['type'] == "event"){
              print('EVENT ANDRIOD :'+message.toString());
              var mappedData = json.decode(message['data']);
              eventservice.appendNew(data: mappedData);
              NotificationDisplayer().showNotification(mappedData['type'].toString() == 'event' ? 'Nouvel événement programmé.' : mappedData['type'].toString() == 'match' ? 'Un nouveau match a été programmé.' : 'Une nouvelle réunion a été programmée.', "Nouvel évènement", context, mappedData['id'].toString(),mappedData['type'].toString(),image: "");
              notificationIndicator = true;
              notificID = mappedData['id'].toString();
              notificType = 'Event';
              getEvents();

            }else{
              var mappedData = json.decode(message['data']);
              bannerDisplay.update(mappedData);
              AdListener().showAd(context, mappedData);
              notificID = mappedData['id'].toString();
              notificType = 'Event';
            }
          }
        }catch(e){
          Messagecontroller().printWrapped("onMessage Error : $e");
        }
        return ;
      },
      onResume: (Map<String, dynamic> message) async {
        try{
          if(Platform.isAndroid){
            print("Android MESSAGE : $message");
            if(message['data']['type'] == "message"){
              if(message['data']['refresh'] == 'false'){
                if (message['data']['sender'].toString() == userdetails['name'].toString()){
                }else if (message['data']['reason'].toString() == 'deletegroup'){
                }else{
                  var mappedData = json.decode(message['data']['data']);
                  messagecontroller.messagechecker(context, mappedData);
                  print('OR DIDI NASULOD :'+message.toString());
                }
              }else{
                if (message['data']['sender'].toString() == userdetails['name'].toString()){
                }else if (message['data']['reason'].toString() == 'deletegroup'){
                }else{
                  messagecontroller.messageHandler(message['data'],context);
                }
              }
              getPersonMessage();
            }else if(message['data']['type'] == "event"){
              var mappedData = json.decode(message['data']['data']);
              eventservice.appendNew(data: mappedData);
              NotificationDisplayer().showNotification(mappedData['type'].toString() == 'event' ? 'Nouvel événement programmé.' : mappedData['type'].toString() == 'match' ? 'Un nouveau match a été programmé.' : 'Une nouvelle réunion a été programmée.', "Annonce nouvelle Ujap", context, mappedData['id'].toString(),mappedData['type'].toString());
              notificationIndicator = true;
              notificID = mappedData['id'].toString();
              notificType = 'Event';
              getEvents();

            }else{
              var mappedData = json.decode(message['data']['data']);
              bannerDisplay.update(mappedData);
              print('ADVERTISEMENT :'+mappedData.toString());
              AdListener().showAd(context,mappedData);
              notificID = mappedData['id'].toString();
              notificType = 'Event';
            }
          }else{
            print("IOS MESSAGE : $message");
            if(message['type'] == 'message'){
              if(message['refresh'] == 'false'){
                if (message['sender'].toString() == userdetails['name'].toString()){
                }else if (message['reason'].toString() == 'deletegroup'){

                }else if (!message['recievers'].toString().contains(userdetails['id'].toString())){

                }else{
                  var mappedData = json.decode(message['data']);
                  messagecontroller.messagechecker(context, mappedData);
                }
              }else{
                if (message['sender'].toString() == userdetails['name'].toString()){
                }else if (message['reason'].toString() == 'deletegroup'){

                }else{
                  messagecontroller.messageHandler(message['data'],context);
                }
              }
              getPersonMessage();

            }else if(message['type'] == "event"){
              print('EVENT ANDRIOD :'+message.toString());
              var mappedData = json.decode(message['data']);
              eventservice.appendNew(data: mappedData);
              NotificationDisplayer().showNotification(mappedData['type'].toString() == 'event' ? 'Nouvel événement programmé.' : mappedData['type'].toString() == 'match' ? 'Un nouveau match a été programmé.' : 'Une nouvelle réunion a été programmée.', "Nouvel évènement", context, mappedData['id'].toString(),mappedData['type'].toString(),image: "");
              notificationIndicator = true;
              notificID = mappedData['id'].toString();
              notificType = 'Event';
              getEvents();

            }else{
              var mappedData = json.decode(message['data']);
              bannerDisplay.update(mappedData);
              AdListener().showAd(context, mappedData);
              notificID = mappedData['id'].toString();
              notificType = 'Event';
            }
          }
        }catch(e){
          Messagecontroller().printWrapped("onMessage Error : $e");
        }
        return ;
      }
    );
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true,
            badge: true,
            alert: true,
            provisional: true
        )
    );
    firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("SETTINGS : $settings");
    });
  }
}

class ReceiveNotific{
  String notificID = "";
  String notificType = "";
}

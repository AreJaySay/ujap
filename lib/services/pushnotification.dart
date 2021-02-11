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
import 'package:ujap/globals/widgets/banner.dart';
import 'package:ujap/globals/widgets/show_flushbar.dart';
import 'package:ujap/pages/drawer_page.dart';
import 'package:ujap/pages/homepage.dart';
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

    print('FCM TOKEN RETURN :'+fcmToken.toString());
  }
  void subscribe(int id) {
    print('subscribed to : Subscription$id');
    firebaseMessaging.subscribeToTopic('Subscription$id');
  }
  void unsubscribe(int id) {
    print('subscribed to : Subscription$id');
    firebaseMessaging.unsubscribeFromTopic('Subscription$id');
  }
  Future initListen(context) async {
    firebaseMessaging.configure(
      onMessage: (Map message) async {
        print("CHECK MESSAGE : $message");
        try{
          if(Platform.isAndroid){
            print("Android MESSAGE : $message");
            if(message['data']['type'] == "message"){
              if(message['data']['refresh'] == 'false'){
                if (message['data']['sender'].toString() == userdetails['name'].toString()){
                }else{
                  var mappedData = json.decode(message['data']['data']);
                  messagecontroller.messagechecker(context, mappedData);
                }
              }else{
                if (message['data']['sender'].toString() == userdetails['name'].toString()){
                }else{
                  messagecontroller.messageHandler(message['data'],context);
                }
              }
              getPersonMessage();
            }else if(message['data']['type'] == "event"){
              var mappedData = json.decode(message['data']['data']);

              eventservice.appendNew(data: mappedData);
              NotificationDisplayer().showNotification(mappedData['type'].toString() == 'event' ? 'New Event has been scheduled.' : mappedData['type'].toString() == 'match' ? 'New Match has been scheduled.' : 'New Meeting has been scheduled.', "Nouvel évènement", context);
              notificationIndicator = true;
               addToDb(itemid: mappedData['id'].toString(),messageTypes: 'Event');
              getEvents();

            }else{
              var mappedData = json.decode(message['data']['data']);
              bannerDisplay.update(mappedData);
              AdListener().showAd(context,mappedData);
            }

          }else{
            print("IOS MESSAGE : $message");
            if(message['type'] == 'message'){
              if(message['refresh'] == 'false'){
                var mappedData = json.decode(message['data']);
                messagecontroller.messagechecker(context, mappedData);
                getPersonMessage();
              }else{
                messagecontroller.messageHandler(message['data'],context);
                getPersonMessage();
              }
            }else if(message['type'] == "event"){
              var mappedData = json.decode(message['data']);

              eventservice.appendNew(data: mappedData);
              NotificationDisplayer().showNotification(mappedData['type'].toString() == 'event' ? 'New Event has been scheduled.' : mappedData['type'].toString() == 'match' ? 'New Match has been scheduled.' : 'New Meeting has been scheduled.', "Nouvel évènement", context);
              notificationIndicator = true;
               addToDb(itemid: mappedData['id'].toString(),messageTypes: 'Event');
              getEvents();

            }else{
              print("SHOW AD!");
              var mappedData = json.decode(message['data']);
              bannerDisplay.update(mappedData);
              AdListener().showAd(context, mappedData);
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
                var mappedData = json.decode(message['data']['data']);
                messagecontroller.messagechecker(context, mappedData);
              }else{
                messagecontroller.messageHandler(message['data'],context);
                getPersonMessage();
              }
            }else if(message['data']['type'] == "event"){
              var mappedData = json.decode(message['data']['data']);

              eventservice.appendNew(data: mappedData);
              NotificationDisplayer().showNotification(mappedData['type'].toString() == 'event' ? 'New Event has been scheduled.' : mappedData['type'].toString() == 'match' ? 'New Match has been scheduled.' : 'New Meeting has been scheduled.', "Nouvel évènement", context);
              notificationIndicator = true;
               addToDb(itemid: mappedData['id'].toString(),messageTypes: 'Event');
              getEvents();

            }else{
              print("SHOW AD!");
              var mappedData = json.decode(message['data']['data']);
              bannerDisplay.update(mappedData);
              AdListener().showAd(context,mappedData);
            }

          }else{
            print("IOS MESSAGE : $message");
            if(message['type'] == 'message'){
              if(message['refresh'] == 'false'){
                var mappedData = json.decode(message['data']);
                messagecontroller.messagechecker(context, mappedData);
              }else{
                messagecontroller.messageHandler(message['data'],context);
                getPersonMessage();
              }
            }else if(message['type'] == "event"){
              var mappedData = json.decode(message['data']);

              eventservice.appendNew(data: mappedData);
              NotificationDisplayer().showNotification(mappedData['type'].toString() == 'event' ? 'New Event has been scheduled.' : mappedData['type'].toString() == 'match' ? 'New Match has been scheduled.' : 'New Meeting has been scheduled.', "Nouvel évènement", context);
              notificationIndicator = true;
               addToDb(itemid: mappedData['id'].toString(),messageTypes: 'Event');
              getEvents();

            }else{
              print("SHOW AD!");
              var mappedData = json.decode(message['data']);
              bannerDisplay.update(mappedData);
              AdListener().showAd(context, mappedData);
            }
          }
        }catch(e){
          Messagecontroller().printWrapped("onLaunch Error : $e");
        }
        return ;
      },
      onResume: (Map<String, dynamic> message) async {
        try{
          if(Platform.isAndroid){
            print("Android MESSAGE : $message");
            if(message['data']['type'] == "message"){
              if(message['data']['refresh'] == 'false'){
                var mappedData = json.decode(message['data']['data']);
                messagecontroller.messagechecker(context, mappedData);
              }else{
                messagecontroller.messageHandler(message['data'],context);
                getPersonMessage();
              }
            }else if(message['data']['type'] == "event"){
              var mappedData = json.decode(message['data']['data']);

              eventservice.appendNew(data: mappedData);
              NotificationDisplayer().showNotification(mappedData['type'].toString() == 'event' ? 'New Event has been scheduled.' : mappedData['type'].toString() == 'match' ? 'New Match has been scheduled.' : 'New Meeting has been scheduled.', "Nouvel évènement", context);
              notificationIndicator = true;
               addToDb(itemid: mappedData['id'].toString(),messageTypes: 'Event');
              getEvents();

            }else{
              print("SHOW AD!");
              var mappedData = json.decode(message['data']['data']);
              bannerDisplay.update(mappedData);
              AdListener().showAd(context,mappedData);
            }

          }else{
            print("IOS MESSAGE : $message");
            if(message['type'] == 'message'){
              if(message['refresh'] == 'false'){
                var mappedData = json.decode(message['data']);
                messagecontroller.messagechecker(context, mappedData);
              }else{
                messagecontroller.messageHandler(message['data'],context);
                getPersonMessage();
              }
            }else if(message['type'] == "event"){
              var mappedData = json.decode(message['data']);

              eventservice.appendNew(data: mappedData);
              NotificationDisplayer().showNotification(mappedData['type'].toString() == 'event' ? 'Un nouvel  évènement a été planifié.' : mappedData['type'].toString() == 'match' ? 'Un nouveau match a été programmé.' : 'New Meeting has been scheduled.', "Nouvel évènement", context);
              notificationIndicator = true;
               addToDb(itemid: mappedData['id'].toString(),messageTypes: 'Event');
              getEvents();

            }else{
              print("SHOW AD!");
              var mappedData = json.decode(message['data']);
              bannerDisplay.update(mappedData);
              AdListener().showAd(context, mappedData);
            }
          }
        }catch(e){
          Messagecontroller().printWrapped("onResume Error : $e");
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
import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/widgets/appbar_icons.dart';
import 'package:ujap/globals/widgets/banner.dart';
import 'package:ujap/globals/widgets/show_flushbar.dart';
import 'package:ujap/pages/homepage.dart';
import 'package:ujap/services/ad_listener.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/event_listener.dart';
import 'package:ujap/services/message_controller.dart';
import 'package:ujap/services/notifications.dart';
import 'package:ujap/services/sample_sqlite.dart';

var messagingToken = "";

void addToDb({String itemid = "", String messageTypes = ""}) async {
  var id = await DatabaseHelper.instance.insert(Todo( itemid: itemid, messageType: messageTypes));
  // taskList.insert(0, Todo(id: id, itemid: itemid.toString(), messageType: messageTypes));
  print('DATAS :'+id.toString());
}

// SEND NOTIFICATION ON CLIENT
class PushNotification {
  final String serverToken = 'AAAAul-TWVQ:APA91bEbjbQq6LFzBXst8KDbr_PKlCFHXtQoxOAhJBMhVbTXQUI5lTo_kAGclXh-qKS54dDALWTme8YxYWR19g-kim2CXsydSzO76oMdsBojSWBK98viVtdCbIjpVrRKrRiZwYM-wEBu';
  FirebaseMessaging firebasemessaging = FirebaseMessaging.instance;

  void subscribe(int id) {
    firebasemessaging.subscribeToTopic('Subscription$id');
  }
  void unsubscribe(int id) async{
    firebasemessaging.unsubscribeFromTopic('Subscription$id');
    await firebasemessaging.deleteToken();
  }
  void _deleteTask(int id) async {
    await DatabaseHelper.instance.delete(id);
    taskList.removeWhere((element) => element.itemid == id);

  }

  Future<void> initialize(context)async{
    await firebasemessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await firebasemessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    firebasemessaging.getInitialMessage().then((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      if (message != null) {
        print("FIRST RECIEVER :"+notification.toString());
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      if(message.data['type'] == "message"){
        if(message.data['refresh'] == 'false'){
          if (message.data['sender'].toString() == firebasemessaging.setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          )){
          }else if (message.data['reason'].toString() == 'deletegroup'){
          }else{
            var mappedData = json.decode(message.data['data']);
            messagecontroller.messagechecker(context, mappedData);
            print('OR DIDI NASULOD :'+message.toString());
          }
        }else{
          if (message.data['sender'].toString() == userdetails['name'].toString()){
          }else if (message.data['reason'].toString() == 'deletegroup'){
          }else{
            messagecontroller.messageHandler(message.data['data'],context);
          }
        }
        getPersonMessage();
      }else if(message.data['type'] == "event"){
        var mappedData = json.decode(message.data['data']);
        eventservice.appendNew(data: mappedData);
        NotificationDisplayer().showNotification(mappedData['type'].toString() == 'event' ? 'Nouvel événement programmé.' : mappedData['type'].toString() == 'match' ? 'Un nouveau match a été programmé.' : 'Une nouvelle réunion a été programmée.', "Annonce nouvelle Ujap", context, mappedData['id'].toString(),mappedData['type'].toString());
        notificationIndicator = true;
        notificID = mappedData['id'].toString();
        notificType = 'Event';
        getEvents();
      }else{
        var mappedData = json.decode(message.data['data']);
        bannerDisplay.update(mappedData);
        print('ADVERTISEMENT :'+mappedData.toString());
        AdListener().showAd(context,mappedData);
        notificID = mappedData['id'].toString();
        notificType = 'Event';
      }
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async{
      getPersonMessage();
    });
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async{
      getPersonMessage();
    });
  }
}

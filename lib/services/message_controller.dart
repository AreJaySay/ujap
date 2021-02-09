import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/widgets/show_flushbar.dart';
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/conversation_chats_listener.dart';
import 'package:ujap/services/conversation_listener.dart';
import 'package:ujap/services/pushnotification.dart';

class Messagecontroller{
  NotificationDisplayer notificationDisplayer = new NotificationDisplayer();
  sendmessage(data, String messagetoSend,receiverId, bool refresh, String reason)async{
    try{
//      await firebaseMessaging.requestNotificationPermissions(
//        const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
//      );
      var response = await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$TokenServer',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'refresh' : refresh,
              'refresh_type' : "",
              'type' : "message",
              'status': 'done',
              'sender': userdetails['name'].toString(),
              'message': messagetoSend,
              'data': data,
            },
            'to': "/topics/Subscription$receiverId",
          },
        ),
      );
      var jsonData = json.decode(response.body);
      print('RESULT FIREBASE :'+jsonData.toString());

    }catch(e){
      print('ERROR FCM SENDING:'+e.toString());
    }
  }
  updateMembers(int id,Map clientData, [int type = 1]) {
    if(type == 1) {
      this.sendmessage(clientData, "Un nouveau membre est ajouté", id, true, "n_member");
    }else{
      this.sendmessage(clientData, "Un membre est supprimé", id, true, 'x_member');
    }
  }
  messagechecker(context,Map message){
    try{
      if(chatListener.getChannelID() != int.parse(message['channel_id'].toString())){
        conversationService.appendNewMessageOnConvo(convoId: int.parse(message['channel_id'].toString()),data: message);
        conversationService.updateUnreadMessage(int.parse(message['channel_id'].toString()));
        NotificationDisplayer().showNotification(message['message'] == null ? "Envoyé une pièce jointe" : message['message'], message['client']['name'], context);
      }else{
        chatListener.append(data: message);
        conversationService.readMessage(on: int.parse(message['channel_id'].toString()));
      }
      conversationService.updateLastConvo(onId: int.parse(message['channel_id'].toString()),data: message);
    }catch(e){
      print("ERROR ON DECODING : $e");
    }
  }
  messageHandler(Map message, context)
  {
    try{
      print("THE MESSAGE : $message");
      String body = '';
      if(message['message'] == "Conversation supprimée"){
        body = 'La conversation est supprimée définitivement';
      }else if(message['message'] == "Un nouveau membre est ajouté"){
        var mappedData = json.decode(message['data']);
        body = "Bienvenue ${mappedData['name']}";
      }else if(message['message'] == "Vous avez été ajouté à un groupe"){
        body = "Ils vous accueillent ${userdetails['name']}";
      }else{
        body = "Rien à dire";
      }
      NotificationDisplayer().showNotification(body, message['message'], context);
    }catch(e){
      print("Handler Error : $e");
    }
  }

  showFlushBar(context,Map message){
    if (message['data']['receiver'].toString() == "null"){
      showflushbar(message['data']['sender'].toString(), message['data']['message'].toString(), context);
    }else{
      if (message['data']['receiver'].toString().toUpperCase().contains(userdetails['name'].toString().toUpperCase()) ||
          message['data']['receiver'].toString().toUpperCase() == userdetails['name'].toString().toUpperCase()){
        showflushbar(message['data']['receiver'].toString(), message['data']['message'].toString(), context);
      }
    }
  }
  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  sendmessagetoServer(Map data)async{
    try{
//      await firebaseMessaging.requestNotificationPermissions(
//        const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
//      );
      for (var x = 0; x < serverFcmTokens.length; x ++){
        var response = await http.post(
          'https://fcm.googleapis.com/fcm/send',
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$TokenServer',
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{
                'body': '',
                'title': '',
                'icon': ''
              },
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'data': data,
              },
              'to': serverFcmTokens[x].toString(),
            },
          ),
        );
        var jsonData = json.decode(response.body);
        print('RESULT FIREBASE :'+jsonData.toString()+fcmToken);
      }

    }catch(e){
      print('ERROR FCM SENDING:'+e.toString());
    }
  }
}

Messagecontroller messagecontroller = Messagecontroller();
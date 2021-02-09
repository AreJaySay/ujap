import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:ujap/globals/variables/credential_variables.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/messages_sub_pages_variables.dart';
import 'package:ujap/globals/variables/profile_variables.dart';
import 'package:ujap/globals/widgets/appbar_icons.dart';
import 'package:ujap/globals/widgets/banner.dart';
import 'package:ujap/globals/widgets/show_loader.dart';
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/globals/widgets/tabber_events_matches.dart';
import 'package:ujap/globals/widgets/view_events.dart';
import 'package:ujap/globals/widgets/view_matches.dart';
import 'package:ujap/pages/drawer_page.dart';
import 'package:ujap/pages/homepage.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/events_list_data.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/view_event.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/download_pdf%202.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/create_new_group.dart';
import 'package:ujap/services/conversation_listener.dart';
import 'package:ujap/services/event_listener.dart';
import 'package:ujap/services/message_data.dart';
import 'package:ujap/services/notifications.dart';
import 'package:ujap/services/pushnotification.dart';
import 'package:ujap/services/sample_sqlite.dart';
import 'package:ujap/services/searches/messages_service.dart';
import 'package:ujap/services/searches/search_service.dart';
import 'package:flutter/material.dart';

// for headers
Map<String, String> headers = {
  HttpHeaders.authorizationHeader: "Bearer $accesstoken",
  'Accept':'application/json'
};

// LOGIN FCM TOKEN

sendFCM_token()async{
  var token = await FirebaseMessaging().getToken();
  await http.post('https://ujap.checkmy.dev/api/client/firebase/save',
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $accesstoken",
        "Accept": "application/json"
      },
      body: {
        'client_id': userdetails['id'].toString(),
        'fcm_key': token.toString(),
      }
  ).then((value) => print(value.body));
}

String serverfcmToken = "";
List<String> serverFcmTokens = List<String>();

getServerFcmToken()async{
  var response = await http.get("https://ujap.checkmy.dev/api/client/user-fcms",
      headers: headers
  );
  List _serverToken = json.decode(response.body);
  if (response.statusCode == 200){
    for (var x = 0 ; x <_serverToken.length; x++){
      if (_serverToken[x]['firebase_token'].toString() != ""){
        serverFcmTokens.add(_serverToken[x]['firebase_token'].toString());
      }
    }
    print('SERVER FCM TOKENS:'+serverFcmTokens.length.toString());
   // List serverfcmToken = _serverToken[0]['firebase_token'];
  }
}

getTeams()async{
  var response = await http.get('https://ujap.checkmy.dev/api/client/teams',
      headers: headers
  );
  String _eventsLocal = response.body.toString();
  List _events =  json.decode(_eventsLocal);
  if (response.statusCode == 200){
      teamNameData = _events;
  }
  else
  {

  }
}

List myAttended_events;
List myPass_events;
List myAccepted_events;
List finalMatchAttended;
List finalEventAttended;
List finalMeetingAttended;

getEvents()async{
  var response = await http.get('https://ujap.checkmy.dev/api/client/events',
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $accesstoken",
        "Accept": "application/json"
      }
  );
  var _localevents =  json.decode(response.body);
  if (response.statusCode == 200){
    List _events = _localevents;

      // _events.sort((a, b) {
      //     return a['sched_date'].toLowerCase().compareTo(b['sched_date'].toLowerCase());
      // });
      // matchservice.updateAll(data: _events);
      eventsfirstData = _events;
      eventsData = _events;

      _events.sort((a, b) {
        return a['sched_date'].toLowerCase().compareTo(b['sched_date'].toLowerCase());
      });
      filterSearchService.addData(event: _events);

      matchLength = eventsfirstData.where((s){
        return s['type'].toString().toLowerCase() == 'match'.toString().toLowerCase() && int.parse(DateFormat("yyyyMMdd").format(DateTime.parse(s['sched_date'].toString().toLowerCase().replaceAll(new RegExp(r'[^\w\s]+'),'')))) >= int.parse(DateFormat("yyyyMMdd").format(DateTime.now()));;
      }).toList();
      matchservice.addData(event: matchLength);


      middlematchEvents = eventsfirstData.where((s){
        return int.parse(DateFormat("yyyyMMdd").format(DateTime.parse(s['sched_date'].toString().toLowerCase().replaceAll(new RegExp(r'[^\w\s]+'),'')))) < int.parse(DateFormat("yyyyMMdd").format(DateTime.now()));
      }).toList();
      middleservice.addData(event: middlematchEvents);

      if (middlematchEvents != null){
        middlematchEvents.sort((a, b) {
          return a['sched_date'].toLowerCase().compareTo(b['sched_date'].toLowerCase()) ;
        });
      }

      matchData = eventsfirstData.where((s){
        return s['type'].toString().toLowerCase() == 'event'.toString().toLowerCase() && int.parse(DateFormat("yyyyMMdd").format(DateTime.parse(s['sched_date'].toString().toLowerCase().replaceAll(new RegExp(r'[^\w\s]+'),'')))) >= int.parse(DateFormat("yyyyMMdd").format(DateTime.now())) || s['type'].toString().toLowerCase() == 'meeting'.toString().toLowerCase() && int.parse(DateFormat("yyyyMMdd").format(DateTime.parse(s['sched_date'].toString().toLowerCase().replaceAll(new RegExp(r'[^\w\s]+'),'')))) >= int.parse(DateFormat("yyyyMMdd").format(DateTime.now()));
        ;
      }).toList();
      eventservice.addData(event: matchData);

      if (matchData != null){
        matchData.sort((a, b) {
          return a['sched_date'].toLowerCase().compareTo(b['sched_date'].toLowerCase()) ;
        });
      }
  }
  else
  {
    print('RETURN EVENTS'+_localevents.toString());
  }
}

getEvents_status({String eventID = ""})async{
  var response = await http.get('https://ujap.checkmy.dev/api/client/events-status',
      headers: headers
  );
  var jsonData = json.decode(response.body);
  if (response.statusCode == 200){
    if (jsonData.toString() != "{}"){

      events_status = jsonData;
      List _local = jsonData;

      if(userdetails != null){
        if (_local != null && eventID != ""){
          eventStatusmatch = events_status.where((s) {
            return s['event_id'].toString().toLowerCase() == eventID.toString().toLowerCase();
          }).toList();
          events_attendedmatch = double.parse( eventStatusmatch[0]['accepted_clients'].length.toString());
          events_allocationmatch = double.parse(eventStatusmatch[0]['allocation'].toString());
          eventsAttended_clientmatch =  eventStatusmatch[0]['declined_clients'];
          filterSearchService.addData(eventStatusmatch: eventStatusmatch,events_attendedmatch: events_attendedmatch, events_allocationmatch: events_allocationmatch, eventsAttended_clientmatch: eventsAttended_clientmatch);

          eventStatusEvents = events_status.where((s) {
            return s['event_id'].toString().toLowerCase() == eventID.toString().toLowerCase();
          }).toList();

          events_attendedEvents = double.parse( eventStatusEvents[0]['accepted_clients'].length.toString());
          participant = int.parse(eventStatusEvents[0]['accepted_clients'].length.toString());
          events_allocationEvents = double.parse(eventStatusEvents[0]['allocation'].toString());
          allocation = int.parse(eventStatusEvents[0]['allocation'].toString());
          eventsAttended_clientEvents =  eventStatusEvents[0]['accepted_clients'];

          eventStatuscurrentEvent = events_status.where((s) {
            return s['event_id'].toString().toLowerCase() == eventID.toString().toLowerCase();
          }).toList();
          events_attendedcurrentEvent = int.parse( eventStatuscurrentEvent[0]['accepted_clients'].length.toString());
          events_allocationcurrentEvent = int.parse(eventStatuscurrentEvent[0]['allocation'].toString());
          eventsAttended_clientcurrentEvent =  eventStatuscurrentEvent[0]['accepted_clients'];

          eventStatuscurrentMeeting = events_status.where((s) {
            return s['event_id'].toString().toLowerCase() == eventID.toString().toString().toLowerCase();
          }).toList();
          events_attendedcurrentMeeting = int.parse( eventStatuscurrentMeeting[0]['accepted_clients'].length.toString());
          events_allocationcurrentMeeting = int.parse(eventStatuscurrentMeeting[0]['allocation'].toString());
          eventsAttended_clientcurrentMeeting =  eventStatuscurrentMeeting[0]['accepted_clients'];
        }

        myAttended_events = events_status.where((s){
          return s['accepted_clients'].toString().contains('client_id: '+userdetails['id'].toString()) && !s['declined_clients'].toString().contains('client_id: '+userdetails['id'].toString());
        }).toList();

        myPass_events = events_status.where((s){
          return s['declined_clients'].toString().contains('client_id: '+userdetails['id'].toString());
        }).toList();

        List attendedEventsMatches = events_status.where((s){
          return s['accepted_clients'].toString().contains('client_id: '+userdetails['id'].toString()) && !s['declined_clients'].toString().contains('client_id: '+userdetails['id'].toString());
        }).toList();

        finalMatchAttended = attendedEventsMatches.where((s){
          return s['type'].toString().toLowerCase().contains('match'.toString().toLowerCase());
        }).toList();

        finalMeetingAttended = attendedEventsMatches.where((s){
          return s['type'].toString() == 'meeting'.toString();
        }).toList();

        finalEventAttended = attendedEventsMatches.where((s){
          return s['type'].toString() == 'event'.toString();
        }).toList();
      }
    }


  }
}

List client_backup;

getEvents_clients(context)async{
  var response = await http.get('https://ujap.checkmy.dev/api/client/clients',
      headers: headers
  );
  var jsonData = json.decode(response.body);
  if (response.statusCode == 200){
      events_clients = jsonData;
      client_backup = events_clients;
      send_userEmail(context);
  }
  else
  {

  }
}


List pdfData;
var selectedTicket = "";
List myTicketrequest;

getTicketData(localTicketID)async{
  var response = await http.get('https://ujap.checkmy.dev/api/client/documents/get-ticket-documents-all/$localTicketID',
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $accesstoken",
        "Accept": "application/pdf"
      },
  );
  var jsonData = json.decode(response.body);
  if (response.statusCode == 200){
    pdfData = jsonData;
    // uploadPDF();
    ticketdownloadID = localTicketID.toString();
    ticketFilename = pdfData[0]['filename'];
    print('TICKET DETAIS :'+ticketFilename.toString());
  }
  else
  {

  }
}

List ticket_requests;

get_ticket_requests(context,_ticketID)async{
  var response = await http.get('https://ujap.checkmy.dev/api/client/ticket-request/all',
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $accesstoken",
      "Accept": "application/pdf"
    },
  );
  var jsonData = json.decode(response.body);
  if (response.statusCode == 200){
    List _ticket_requests = jsonData;
    ticket_requests = jsonData;

    print ('MY TICKET REQUEST :'+ticket_requests.toString());

    if (_ticket_requests != null){

      if (_ticketID != ""){
        List _ticketrequest = ticket_requests.where((s){
          return s['ticket_id'].toString() == _ticketID.toString();
        }).toList();

        myTicketrequest = _ticketrequest.where((s){
          return s['client_id'].toString() == userdetails['id'].toString();
        }).toList();
      }
    }

    if (myTicketrequest != null){
      if (myTicketrequest.length != 0){
        print ('MY TICKET REQUEST :'+myTicketrequest[0]['status'].toString());
        if ( myTicketrequest.length != 0 && myTicketrequest[0]['status'].toString() == "0" ){
          showSnackBar(context, 'Accepteur de demande de ticket. Vous pouvez maintenant assister à ce match.');
        }
      }
    }

  }
}



//////// MESSAGES ////////////

List privateMessages;
List privateMessages_to_search;
List ownMessages;

getPersonMessage()async{
    try{
      var response = await http.get(
          'https://ujap.checkmy.dev/api/client/member/channels/${userdetails['id'].toString()}',
          headers: headers
      );
      var jsonData = json.decode(response.body);
      if (response.statusCode == 200) {
        ownMessages = jsonData;

        if(ownMessages != null){
          for (var x = 0 ; x < ownMessages.length; x ++) {
            privateMessages = ownMessages.where((s) {
              return s['members'].length == 2 && s['last_convo'].toString() != "null" ;
            }).toList();
            messageservice_private.updateAll(data: ownMessages.where((elements) => elements['members'].length > 2).toList());
          }
        }else{
          privateMessages = ownMessages;
        }
        conversationService.updateAll(data: jsonData);
        print('MESSAGE RETURN :'+ownMessages.toString());
      }
      else {
        print("TITS");
      }
    }catch(e){
      print("ERROR DIDI");
    }
}

getCurrent_channel(channelId)async{
  var response = await http.get(
      'https://ujap.checkmy.dev/api/client/channel/messages?channel_id=$channelId',
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $accesstoken",
        "Accept": "application/json"
      }
  );
  var jsonData = json.decode(response.body);
  var jsonResult = jsonData['messages'];
  if (response.statusCode == 200) {
   return jsonResult;

  }
  return null;
}

List current_channel_messages_dynamic = [];
List current_channel_messages;


List ownMessages_backup;

sendMessage_compose(context,sentTime,attachment)async {
  var response = await http.post('https://ujap.checkmy.dev/api/client/chat/send',
    headers: headers,
    body: attachment.toString() == "null" ? {
      'receiver_id': receiverID_public.toString(),
      'sender_id': userdetails['id'].toString(),
      'message': messageToclient_public.toString(),
      'date_sent': sentTime.toString()
    } : {
      'filename': attachment.toString(),
      'receiver_id': receiverID_public.toString(),
      'sender_id': userdetails['id'].toString(),
      'message': messageToclient_public.toString(),
      'date_sent': sentTime.toString()
    },
  );
  var jsonData = json.decode(response.body);
  print('RETURN PDF :'+jsonData.toString());
  if (response.statusCode == 200) {
    getPersonMessage();
    messageToclient_public = "";
    sendmessageTo = "";
    checkConnection = "";
//    add_caption.text = "";
    
    // sendAndRetrieveMessage();
    print('SUCCESS');
    message_compose_open = false;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    currentindex = 2;
    Navigator.pushReplacement(context,PageTransition(child: MainScreen(false),type: PageTransitionType.fade));
  }
  else {

  }
}

// GROUP CHAT

var checkConnection = "";

createChannel(context, bool isConversation,_groupChatName)async{
  print('asdasdasddfd :'+isConversation.toString());
  var response = await http.post('https://ujap.checkmy.dev/api/client/channel/add',
    headers:
      headers,
    body: {
      'name': isConversation ? 'public' : _groupChatName.toString(),
      'client_id': userdetails['id'].toString()
    },
  );
  var jsonData = json.decode(response.body);
  print('RETURN :'+jsonData.toString());
  if (response.statusCode == 200){
    senderID = jsonData['id'].toString();
    checkConnection =  jsonData['result'].toString();
    message_compose_open = true;
    hideLoading = false;
    addMembers = true;

    AddChannel(context);

  }
  else
  {

  }
}

AddChannel(context)async{
  print('asddfdfdfdf');
  var response = await http.post('https://ujap.checkmy.dev/api/client/channel/add-member',
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $accesstoken",
      "Accept": "application/json"
    },
    body: {
      'channel_id': senderID.toString(),
      'client_id': receiverID_public.toString()
    },
  );
  var jsonData = json.decode(response.body);
  print('ADD MEMBER'+jsonData.toString());
  if (response.statusCode == 200){
    getPersonMessage();

    print('CHANNEL IS CREATED :'+checkConnection.toString());

    addMembers = true;
    hideLoading = false;
  }
  else
  {

  }
}

final String _endpoint = "https://ujap.checkmy.dev/api/client/channel/send";

final List<Material> convoGroup = [];
List currentRoomsMessage = [];
List members;
var seenMessages_group = "";
List clean;
List clean_backup;
List chatmembers;

mute_currentChat(context,String client_id,String status)async{
  showloader(context);
  var response = await http.post('https://ujap.checkmy.dev/api/client/chat/mute-client',
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $accesstoken",
        "Accept": "application/json"
      },
      body: {
        "client_id": userdetails['id'].toString(),
        "contact_id": client_id,
        "status": status,
      }
  );
  var jsonData = json.decode(response.body);
  print('RETURN MUTE :'+jsonData.toString());
  if (response.statusCode == 200){
  Navigator.of(context).pop(null);
  get_mutedChat();
  }
  else
  {

  }
}

List container_convo = [];

List mutedClients;
var jsonDataMessage;
List client_Messages = [];

List person_messages;


var success_deleted = "";

delete_current_convo(context,_channelID)async{
  showloader(context);
  print(_channelID);
  var response = await http.delete('https://ujap.checkmy.dev/api/client/channel/delete?id=${_channelID.toString()}',
    headers: {
      HttpHeaders.authorizationHeader: "Bearer $accesstoken",
      "Accept": "application/json"
    },
  );
  var jsonData = json.decode(response.body);
  print('RETURN :'+jsonData.toString());
  if (jsonData != null){
    get_data();
    print('DAPAT KUMADI');
    success_deleted = "true";
    getPersonMessage();
    Navigator.of(context).pop(null);
    showSnackBar(context, 'La conversation a bien été supprimée.');
  }
}

Future getEventAttendess(e_id) async {
  try{
    return await http.get('https://ujap.checkmy.dev/api/client/meeting/attendees/$e_id',headers: {
      HttpHeaders.authorizationHeader: "Bearer $accesstoken",
      "Accept": "application/json"
    }).then((value) {
      var data = json.decode(value.body);
      print("ATTENDEES : $data");
      if(value.statusCode == 200){
        return data;
      }
      return [];
    });
  }catch(e){

  }
}
get_mutedChat()async{
  var response = await http.get('https://ujap.checkmy.dev/api/client/chat/muted-clients?client_id=${userdetails['id'].toString()}',
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $accesstoken",
        "Accept": "application/json"
      },
  );
  var jsonData = json.decode(response.body);
  if (response.statusCode == 200 ){
    List _mutedClients = jsonData;
    mutedClients = _mutedClients.where((s){
      return s['status'].toString() == '1';
    }).toList();
    print('MUTED CLIENTS :'+mutedClients.toString());
  }
}



/////// PROFILE ///////////

send_userEmail(context)async{
  var response = await http.post('https://ujap.checkmy.dev/api/client/forgot-password',
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $accesstoken",
        "Accept": "application/json"
      },
      body: {
        'email': userdetails['email'].toString(),
      }
  );
  var jsonData = json.decode(response.body);
  var _events_clients = jsonData;
  if (response.statusCode == 200){
      resetCode = jsonData['code'].toString();
      forgotPassword = jsonData['reset_token'].toString();
  }

}

bool passwordSuccess = false;

changePassword(context)async{
  var response = await http.post('https://ujap.checkmy.dev/api/client/password-reset',
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $accesstoken",
        "Accept": "application/json"
      },
      body: {
        'email': userdetails['email'].toString(),
        'password': change_Password == "" ? pass.toString() : change_Password.toString(),
        'reset_token': forgotPassword.toString()
      }
  );
  var jsonData = json.decode(response.body);
  var _events_clients = jsonData;
  if (response.statusCode == 200){
      showSnackBar(context, 'Votre mot de passe a été mis à jour avec succès.!');
      Navigator.of(context).pop(null);
      passwordSuccess = true;
  }
  else
  {
  }
}


// ADVERTISEMENTS

List backupAds;

 Future getall_Ads()async{
  var response = await http.get('https://ujap.checkmy.dev/api/client/ads',
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $accesstoken",
        "Accept": "application/json"
      }
  );
  var jsonData = json.decode(response.body);
  if (response.statusCode == 200){
     List _get_ads = jsonData;
     backupAds = _get_ads;
      if (backupAds.toString() != "[]" ){
        get_ads = _get_ads.where((s){
          return s['status'].toString().contains('1');
        }).toList();
        if (get_ads.toString() != "[]"){
           addToDb(itemid: get_ads[0]['id'].toString(),messageTypes: 'Advertisement');
           bannerDisplay.update(get_ads[0]);
        }
      }
     getEvents();
     return get_ads;
     // getEvents_status();
    }
  return null;
}



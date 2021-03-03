import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/controllers/home.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/view_events.dart';
import 'package:ujap/pages/drawer_page.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/view_event.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/new_compose_message.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/conversation_chats_listener.dart';
import 'package:ujap/services/conversation_listener.dart';
import 'package:ujap/services/event_listener.dart';
import 'package:ujap/services/member_traversal.dart';
import 'package:ujap/services/navigate_match_events.dart';

showflushbar(sender,msg,context){
  return GestureDetector(
    child: Flushbar(
      maxWidth: screenwidth/1.050,
      flushbarPosition: FlushbarPosition.TOP,
      messageText: Container(
        padding: EdgeInsets.only(left: 5),
        child: Container(
          width: screenwidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(sender.toString(),style: TextStyle(color: Colors.white,fontSize: screenwidth < 700 ? screenwidth/35: screenwidth/50,fontFamily: 'Google-Bold'),),
              Text(msg.toString(),style: TextStyle(color: Colors.white,fontSize: screenwidth < 700 ? screenwidth/40: screenwidth/50),),
            ],
          ),
        ),
      ),
      icon: Container(
        margin: EdgeInsets.only(left: 5),
        width: 70,
        height: 50,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(('assets/new_app_icon.png'))
            )
        ),
      ),
      duration: Duration(seconds: 7),
      backgroundColor: kPrimaryColor,
      // leftBarIndicatorColor: Colors.black,
      borderRadius: 5,
      dismissDirection: FlushbarDismissDirection.VERTICAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      // leftBarIndicatorColor: Colors.black,
      // borderRadius: 10,
      // aroundPadding: EdgeInsets.only(bottom:10.0,top: 10.0),
    )..show(context),
    onTap: (){
    },
  );
}
class NotificationDisplayer {
  showNotification(String body, String title, context,String channelID,String notif_type,{String image = ""}) => Flushbar(
    onTap: (text){
      if (notif_type.toString() == "message"){
        List _currentMessage = ownMessages.where((element) => element['id'].toString() == channelID.toString()).toList();
        print('MESSAGE DATA'+_currentMessage.toString());

        conversationService.readMessage(on: _currentMessage[0]['id']);
        chatListener.updateChannelID(id: _currentMessage[0]['id']);
        if(Platform.isIOS){
          conversationService.checkConvoMembersExist(memberIds: MemberTraverser().getIds(from: _currentMessage[0]['members'])).then((value) {
            Navigator.push(context, PageTransition(child: NewComposeMessage(value, _currentMessage[0] == null? null : _currentMessage[0]), type: PageTransitionType.topToBottom));
          });
        }else{
          Future.delayed(Duration.zero, () async{
            Map dd = await conversationService.checkConvoMembersExist(memberIds: MemberTraverser().getIds(from: _currentMessage[0]['members']));
            Navigator.push(context, PageTransition(child: NewComposeMessage(dd, _currentMessage[0] == null? null : _currentMessage[0]), type: PageTransitionType.topToBottom));
          });
        }
      }else if (notif_type.toString() == "event" || notif_type.toString() == "meeting"){
        List _currentEvent = eventsData.where((element) => element['id'].toString() == channelID.toString()).toList();
        Navigator.push(context, PageTransition(
            child: notif_type != "meeting" ? ViewEvent(
              eventDetail: _currentEvent[0],
              pastEvent: false,
            ) : ViewEventDetails(
              eventDetail: _currentEvent[0],
              pastEvent: false,
            ),
            type: PageTransitionType.topToBottom
        ));
      }else{
        List _currentEvent = eventsData.where((element) => element['id'].toString() == channelID.toString()).toList();
        int index;
        navigateMatch(index,context,_currentEvent[0]);
      }
    },
    maxWidth: screenwidth/1.050,
    flushbarPosition: FlushbarPosition.TOP,
    messageText: Container(
      padding: EdgeInsets.only(left: 5),
      child: Container(
        width: screenwidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.toString(),style: TextStyle(color: Colors.white,fontSize: screenwidth < 700 ? screenwidth/35: screenwidth/50,fontFamily: 'Google-Bold'),),
            Text(body.toString(),style: TextStyle(color: Colors.white,fontSize: screenwidth < 700 ? screenwidth/40: screenwidth/50),),
          ],
        ),
      ),
    ),
    icon: Container(
      width: 100,
      height: 50,
      child: Center(
        child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
              color: image.toString() == "null" ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(1000),
              image: image != "" ? DecorationImage(
                  fit: BoxFit.cover,
                  image: image.toString() == "null" ? AssetImage('assets/messages_icon/no_profile.png') : NetworkImage('https://ujap.checkmy.dev/storage/clients/${image}'),
              ) : DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/logo_shadow.png'),
              )
          ),
        ),
      ),
    ),
    duration: Duration(seconds: 10),
    backgroundColor: kPrimaryColor,
    // leftBarIndicatorColor: Colors.black,
    borderRadius: 5,
    dismissDirection: FlushbarDismissDirection.VERTICAL,
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    // leftBarIndicatorColor: Colors.black,
    // borderRadius: 10,
    // aroundPadding: EdgeInsets.only(bottom:10.0,top: 10.0),
  )..show(context);

  actionFunction(){
    print('DAPAT MAKADI');
  }
}
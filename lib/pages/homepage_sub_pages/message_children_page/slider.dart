import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/matches.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/confirmation_dialog.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/convo_settings_page.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/new_compose_message.dart';
import 'package:ujap/services/conversation_chats_listener.dart';
import 'package:ujap/services/conversation_listener.dart';
import 'package:ujap/services/member_traversal.dart';
import 'package:ujap/services/message_controller.dart';
import 'package:ujap/services/pushnotification.dart';
import 'package:ujap/services/string_formatter.dart';
import 'package:http/http.dart' as http;

List<String> channelMembersID = List<String>();
// bool navigateNotific = false;

class MySlider extends StatefulWidget {
  final int id;
  final int index;
  final Map data;
  final SlidableController slidableController;
  MySlider({Key key, @required this.id, @required this.index, @required this.data, @required this.slidableController}) : super(key : key);
  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  int dateBetween;

  static Widget _getActionPane(int index) {
    switch (index % 4) {
      case 0:
        return SlidableBehindActionPane();
      case 1:
        return SlidableStrechActionPane();
      case 2:
        return SlidableScrollActionPane();
      case 3:
        return SlidableDrawerActionPane();
      default:
        return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    if (widget.data['last_convo'] != null){
      final birthday = DateTime.parse(widget.data['last_convo']['date_sent']);
      final date2 = DateTime.now();
      dateBetween  = date2.difference(birthday).inDays;
    }
    return Slidable(
      controller: widget.slidableController,
      closeOnScroll: true,
      key: Key(widget.id.toString()),
        child:  GestureDetector(
          onTap: () async {
            List clientDetails;
            for (var x = 0; x <widget.data['messages'].length; x++ ){
              channelMembersID.add(widget.data['messages'][x]['sender_id'].toString());

              clientDetails = events_clients.where((s){
                return s['id'].toString() == widget.data['messages'][x]['sender_id'].toString();
              }).toList();
            }
            print('CHANNEL ID :'+widget.data.toString());
            setState(() {
              conversationService.readMessage(on: widget.id);
              chatListener.updateChannelID(id: widget.id);
            });
            if(Platform.isIOS){
              conversationService.checkConvoMembersExist(memberIds: MemberTraverser().getIds(from: widget.data['members'])).then((value) {
                Navigator.push(context, PageTransition(child: NewComposeMessage(value, clientDetails == null? null : clientDetails[0]), type: PageTransitionType.topToBottom));
              });
            }else{
              Future.delayed(Duration.zero, () async{
                Map dd = await conversationService.checkConvoMembersExist(memberIds: MemberTraverser().getIds(from: widget.data['members']));
                Navigator.push(context, PageTransition(child: NewComposeMessage(dd, clientDetails == null? null :  clientDetails[0]), type: PageTransitionType.topToBottom));
              });
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.black54,width: 0.5))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: screenwidth < 700 ? 40 : 60,
                  height: screenwidth < 700 ? 40 : 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1000),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 2,
                        offset: Offset(2,3)
                      )
                    ],
                    image: imageFetcher(widget.data['members'])
                  ),
                  child: widget.data['members'].length > 2 ?
                  ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: memberGroup(widget.data['members'], 0)['detail']['filename'].toString() == "null" || memberGroup(widget.data['members'], 0)['detail']['filename'].toString() == "" ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${memberGroup(widget.data['members'], 0)['detail']['filename']}")
                              )
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: memberGroup(widget.data['members'], 1)['detail']['filename'].toString() == "null" || memberGroup(widget.data['members'], 1)['detail']['filename'].toString() == "" ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${memberGroup(widget.data['members'], 1)['detail']['filename']}")
                                      )
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: memberGroup(widget.data['members'], 2)['detail']['filename'].toString() == "null" || memberGroup(widget.data['members'], 2)['detail']['filename'].toString() == "" ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${memberGroup(widget.data['members'], 2)['detail']['filename']}")
                                      )
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ) : Container(),
                ),
                const SizedBox(width: 10,),
               Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Text("${kahampang(widget.data['members'], widget.data['name'])}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: screenwidth < 700 ? 17 : 19
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenwidth < 700 ? 0 : 7,
                        ),
                        Container(
                          width: double.infinity,
                          child: Text("${widget.data['last_convo'] == null ? "Pas de message" : "${widget.data['last_convo']['sender_id'] == userdetails['id'] ? "Toi" : widget.data['last_convo']['client']['name']} : ${widget.data['last_convo']['filename'] == null ? widget.data['last_convo']['message'] == null ? "" : widget.data['last_convo']['message'] : "A envoyé une pièce jointe"}"}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: screenwidth < 700 ? 14.5 : 16,
                              color: Colors.grey[600],
                              fontStyle: widget.data['last_convo'] == null || widget.data['last_convo']['filename'] == null ? FontStyle.normal : FontStyle.italic,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    widget.data['unread_messages'] == 0 || widget.data['unread_messages'] == null ? Container() :
                    Container(
                      padding: const EdgeInsets.all(2),
                      constraints: BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                        maxWidth: 20,
                        maxHeight: 20
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(1000)
                      ),
                      child: FittedBox(
                        child: Text((widget.data['unread_messages']).toString(),style: TextStyle(
                            color: Colors.white
                        ),),
                      ),
                    ),
                    widget.data['last_convo'] == null ? Container() : Container(
                      child: dateBetween == 0 ? Text(DateFormat('kk:mm').format(DateTime.parse(widget.data['last_convo']['date_sent'])),style: TextStyle(fontSize: screenwidth < 700 ? 13 : 16,color: Colors.grey, fontFamily: "Google-medium")) :
                      dateBetween == 1 ? Text('Yesterday',style: TextStyle(fontSize: screenwidth < 700 ? 13 : 16,color: Colors.grey, fontFamily: "Google-medium"),) :
                      dateBetween > 1 ? Text('${dateBetween.toString()} days ago',style: TextStyle(fontSize: screenwidth < 700 ? 13 : 16,color: Colors.grey, fontFamily: "Google-medium"),) :
                      dateBetween > 7 ? Text('A week ago',style: TextStyle(fontSize: screenwidth < 700 ? 13 : 16,color: Colors.grey, fontFamily: "Google-medium"),) :
                      Text(DateFormat("d").format(DateTime.parse(widget.data['last_convo']['date_sent'])).toString().toUpperCase()+' '+monthDate[int.parse(DateFormat("MM").format(DateTime.parse(widget.data['last_convo']['date_sent'])).toString())].toString()+'.'+' '+DateFormat("yyyy").format(DateTime.parse(widget.data['last_convo']['date_sent'])).toString().toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? 13 : 16,color: Colors.grey, fontFamily: "Google-medium"),),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),

        secondaryActions: [
          widget.data['members'].length > 2 ? IconSlideAction(
            color: Colors.grey[900],
            onTap: (){
              List<int> _ids =[];
              for(var member in widget.data['members']){
                setState(() {
                  _ids.add(int.parse(member['client_id'].toString()));
                });
              }
              setState(() {
                _ids.remove(int.parse(userdetails['id'].toString()));
              });
              print(_ids);
              if ( widget.data['members'][0]['detail']['id'].toString() == userdetails['id'].toString()){
                confirmaction(context: context,channelID: widget.id,type: 'groupleader',receiverIds: _ids);
                conversationService.readMessage(on: widget.id);
              }else{
                print('DAPAT DIDI HIYA MASULOD');
                confirmaction(context: context,channelID: widget.id,type: 'groupmember',receiverIds: _ids);
                conversationService.readMessage(on: widget.id);
              }
            },
            iconWidget: widget.data['members'][0]['detail']['id'].toString() == userdetails['id'].toString() ? Icon(Icons.delete,color: Colors.white,) : Icon(Icons.exit_to_app,color: Colors.white,size: 25,),
          )
              :
          IconSlideAction(
            color: Colors.grey[900],
            onTap: (){
              List<int> _ids =[];
              for(var member in widget.data['members']){
                setState(() {
                  _ids.add(int.parse(member['client_id'].toString()));
                });
              }
              setState(() {
                _ids.remove(int.parse(userdetails['id'].toString()));
              });
              print(_ids);
              confirmaction(context: context, channelID: widget.id,type: 'private',receiverIds: _ids);
              conversationService.readMessage(on: widget.id);
            },
            iconWidget:Icon(Icons.delete,color: Colors.white,),
          ),
          IconSlideAction(
            color: kPrimaryColor,
            onTap: ()=>Navigator.push(context, PageTransition(child: ConvoSettingsPage(widget.data, widget.id), type: null)),
            iconWidget: Icon(Icons.settings,color: Colors.white,),
          )
        ],
        actionPane: _getActionPane(widget.index)
    );
  }
}

DecorationImage imageFetcher(List members){
  if(members.length > 2){
    //karuyag signgon group
    return null;
  }else if(members.length == 1 || members.length == 0){
    return DecorationImage(
        fit: BoxFit.cover,
        image: members[0]['detail']['filename'].toString() == "null" || members[0]['detail']['filename'] .toString() == "" ?  AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${members[0]['detail']['filename']}")
    );
  }else{
    if(members[1] == null){
      return  DecorationImage(
          fit: BoxFit.cover,
          image: members[0]['detail']['filename'].toString() == "null" || members[0]['detail']['filename'] .toString() == "" ?  AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${members[0]['detail']['filename']}")
      );
    }
    if(members[0]['client_id'] == userdetails['id']){
      return DecorationImage(
          fit:  BoxFit.cover,
          image: members[1]['detail']['filename'].toString() == "null" || members[1]['detail']['filename'] .toString() == "" ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${members[1]['detail']['filename']}")
      );
    }else{
      return DecorationImage(
          fit:  BoxFit.cover,
          image: members[1]['detail']['filename'].toString() == "null" || members[1]['detail']['filename'] .toString() == "" ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${members[0]['detail']['filename']}")
      );
    }
  }
}

String kahampang(List member,name){
  if(member.length == 1 || member.length == 0){
    return "Juste toi";
  }else if(member.length > 2){
    if(name == "ec0fc0100c4fc1ce4eea230c3dc10360"){
      List names = [];
      for(var mem in member){
        names.add(mem['detail']['name']);
      }
      return names.join(',');
    }
    return name;
  }
  else{
    if(member[1] == null){
      return "Juste toi";
    }
    if(member[0]['client_id'] == userdetails['id']){
      return member[1]['detail']['name'];
    }
    return member[0]['detail']['name'];
  }
}
Map memberGroup(List member, int targetIndex){
  return member[targetIndex];
}

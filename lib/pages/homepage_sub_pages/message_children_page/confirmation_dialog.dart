import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:http/http.dart'as http;
import 'package:ujap/pages/drawer_page.dart';
import 'package:ujap/services/conversation_listener.dart';
import 'package:ujap/services/message_controller.dart';
import 'package:ujap/services/navigate_match_events.dart';
import 'package:ujap/services/searches/search_service.dart';

Future leaveGroup({int channelID, String message = "", List<int> receiverIds, String reason = "", Map channelDetails})async {
  try {
    Map body;
    body = {
      "channel_id": "${channelID.toString()}",
      "sender_id": "${userdetails['id'].toString()}",
      "message": "$message",
      "date_sent": "${DateTime.now()}"
    };
    await http.post(
        Uri.parse("${conversationService.urlString}/channel/send"), headers: {
      HttpHeaders.authorizationHeader: "Bearer $accesstoken",
      "accept": "application/json"
    }, body: body).then((respo) {
      var data = json.decode(respo.body);
      if (respo.statusCode == 200) {
        print('LEAVE CONVO SUCCESS');
      } else {
        print('ERROR sss :' + respo.body.toString());
      }
    });
  } catch (e) {
    print('SENDING ERROR :' + e.toString());
  }
}

confirmaction({context, int channelID, String type = "", List<int> receiverIds}){
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          content: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              for (var x = 0; x < 2; x++)
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop(null);
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close,size: screenwidth < 700 ? 30 : 40,),
                      backgroundColor: kPrimaryColor,
                    ),
                  ),
                ),
              Container(
                width: screenwidth,
                height: screenwidth < 700 ? screenwidth/4.2 : screenwidth/5,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        width: screenwidth,
                        child: Text( type.toString() == 'private' ? 'Supprimer définitivement cette conversation.' : type.toString() == 'groupmember' ? 'Quittez définitivement le groupe actuel.' : 'Supprimer définitivement le groupe actuel.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Google-Medium',color: Colors.black87,fontSize: screenwidth < 700 ? screenheight/53 : 25 ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Container(
                        width: screenwidth,
                        child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  child: Container(
                                    width:  attend_pass  != "Yes" ? screenwidth/2.5 : screenwidth/2,
                                    height: screenheight,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(horizontal: screenwidth/30,vertical: 5),
                                    child: Text('Annuler',style: TextStyle(fontFamily: 'Google-Medium',color: Colors.black54,fontSize: screenwidth < 700 ? screenheight/53 : 25 )),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey[600]),
                                        borderRadius: BorderRadius.circular(screenwidth/40)
                                    ),
                                  ),
                                  onTap: (){
                                    Navigator.of(context).pop(null);
                                  },
                                ),
                              ),
                              Expanded(
                                child: Builder(
                                  builder: (context)=> GestureDetector(
                                      child: Container(
                                        width: attend_pass  != "Yes" ? screenwidth/2.5 : screenwidth/2,
                                        height: screenheight,
                                        margin: EdgeInsets.symmetric(horizontal: screenwidth/30,vertical: 5),
                                        alignment: Alignment.center,
                                        child: Text('Confirmer',style: TextStyle(fontFamily: 'Google-Medium',color: Colors.white,fontSize: screenwidth < 700 ? screenheight/53 : 25 )),
                                        decoration: BoxDecoration(
                                            color:  kPrimaryColor,
                                            border: Border.all(color:  kPrimaryColor),
                                            borderRadius: BorderRadius.circular(screenwidth/40)
                                        ),
                                      ),
                                      onTap: (){
                                        if (type.toString() == 'groupleader'){
                                          conversationService.deletegroupChannel(channelID);
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen(false)));
                                          for(var id in receiverIds){
                                            Messagecontroller().sendmessage('', 'Le chat de groupe créé par ${userdetails['name'].toString()+' '+userdetails['lastname'].toString()} a été supprimé', id, true, 'deletegroup',null);
                                          }
                                        }else if (type.toString() == 'groupmember'){
                                          print('MEMBER CLIENT ');
                                          conversationService.deleteChannelLoc(channelID);
                                          leaveGroup(channelID: channelID,message: '${userdetails['name'].toString()+" "+userdetails['lastname']} a quitté le groupe.',receiverIds: receiverIds);
                                          for(var id in receiverIds){
                                            Messagecontroller().sendmessage('', 'La conversation avec ${userdetails['name'].toString()+' '+userdetails['lastname'].toString()} a été supprimée', id, true, 'deletegroup',null);
                                          }
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen(false)));
                                        }else{
                                          conversationService.deleteChannelLoc(channelID);
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen(false)));
                                        }
                                      }
                                  ),
                                ),
                              ),
                            ]
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      });
}
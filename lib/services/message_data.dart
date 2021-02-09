import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/messages_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:http/http.dart' as http;
import 'package:ujap/globals/widgets/message_no_data.dart';
import 'package:ujap/globals/widgets/shemmering_loader.dart';
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/pages/drawer_page.dart';
import 'package:ujap/pages/homepage.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/matches.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/searches/messages_service.dart';
import 'package:ujap/services/searches/search_service.dart';

List public_messages;
var _LatestMessage = "";
List currentRooms;
List<Material> convo = [];
var _convoClient = "";
List<String> messageDeleted = List<String>();
List<String> seen_Messages = List<String>();
List<String> mutedConvo = List<String>();
var seenMessages = "";
var convoClient_ID = "";
List<String> messageSeen = [];
List publicMessages;

get_data(){
  if (message_channel != null){
    publicMessages = message_channel.where((s){
      return s['name'].toString() == "public" && s['members'].length != 0;
    }).toList();
  }
}

class Messages_public extends StatefulWidget {
  @override
  _Messages_publicState createState() => _Messages_publicState();
}

class _Messages_publicState extends State<Messages_public> {
  List<String> _seenLocal = [];
  List<String> _localMessage = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seenLocal = messageSeen;
    print('DELETED :'+messageDeleted.toString());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: messageservice.search$,
      builder: (context, snapshot) {
        return Container(
              width: double.infinity,
              height: double.infinity,
              child:  privateMessages == null || ownMessages == null || snapshot.data == null ? Message_no_data() :
              ownMessages.length == 0 || snapshot.data.length == 0 || privateMessages.length == 0 ? noData("PAS ENCORE DE MESSAGES") :
              ListView.builder(
                primary: false,
                padding: EdgeInsets.only(bottom: screenwidth/10),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){
                 List convoDetails;
                 Map _seenMessage;

                 List _localDetails = snapshot.data[snapshot.data.length - index - 1]['members'];

                 convoDetails = _localDetails.where((s){
                   return s['detail']['id'].toString() != userdetails['id'].toString();
                 }).toList();

                 DateTime dateTimeCreatedAt = DateTime.parse(snapshot.data[snapshot.data.length - index - 1]['created_at'].toString().substring(0,10));
                 DateTime dateTimeNow = DateTime.now();
                 final differenceInDays = dateTimeNow.difference(dateTimeCreatedAt).inDays;
                 daysbetween = differenceInDays;

                 String _seen = '{"clientname" : "${convoDetails[0]['detail']['name'].toString()}","messagesLength" : "${snapshot.data[snapshot.data.length - index - 1]['unread_messages'].toString()}"}';
                 _seenMessage = json.decode(_seen);

                  return Container(
                    child: Container(
                      width: double.infinity,
                      height: screenwidth < 700 ? screenwidth/6 : screenwidth/8,
                      child: GestureDetector(
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Container(
                            width: screenwidth,
                            height: screenwidth < 700 ? screenheight/13.5 : screenheight/12,
                            padding: const EdgeInsets.symmetric(horizontal: 20,),
                            margin: EdgeInsets.only(top: 3),
                            child: Row(
                              children: [
                                Container(
                                  width:  screenwidth < 700 ? screenwidth/8 : screenwidth/10,
                                  height:  screenwidth < 700 ? screenwidth/8 : screenwidth/10,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(1000),
                                    border: Border.all(color: Colors.black,width: 2),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: convoDetails[0]['detail']['filename'].toString() == 'null' || convoDetails[0]['detail']['filename'].toString() == '' ?
                                        AssetImage('assets/messages_icon/no_profile.png') :
                                        NetworkImage('https://ujap.checkmy.dev/storage/clients/'+convoDetails[0]['detail']['filename'].toString())
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenheight/80,
                                ),
                                !isCollapsed ? Container() :
                                Expanded(
                                  flex: screenwidth < 700 ? 4 : 8,
                                  child: Container(
                                    width: screenwidth,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: screenwidth,
                                            child: Text(convoDetails[0]['detail']['name'].toString()+' '+convoDetails[0]['detail']['lastname'].toString(),style: TextStyle(color: Colors.black,fontFamily: 'Google-Bold',fontSize: screenheight/65 ),overflow: TextOverflow.ellipsis,)),
                                        SizedBox(
                                          height: screenheight/170,
                                    ),
                                       Container(
                                          width: screenwidth,
                                          child: snapshot.data[snapshot.data.length - index - 1]['last_convo']['sender_id'].toString() != userdetails['id'].toString() ? Container(
                                            child: Text(snapshot.data[snapshot.data.length - index - 1]['last_convo']['message'].toString(),style: TextStyle(color: Colors.grey[350],fontFamily: 'Google-Bold',fontSize: screenheight/80)
                                            ),
                                          ) :
                                          Text('Vous : '+snapshot.data[snapshot.data.length - index - 1]['last_convo']['message'].toString(),style: TextStyle(color: Colors.grey[350],fontFamily: 'Google-Bold',fontSize: screenheight/80  )
                                            ,overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),

                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: screenheight/80,
                                ),
                                !mutedClients.toString().contains('contact_id: '+convoDetails[0]['detail']['id'].toString()) ?
                                Container() :
                                Container(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.volume_off,size: screenwidth/19,color: Colors.grey[500],),
                                ),
                                SizedBox(
                                  width: screenheight/80,
                                ),
                                Expanded(
                                  flex: 2,
                                  child:
                                  client_Messages == "[]" ? Container() :
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: screenwidth/1,
                                    child: Column(
                                        mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
                                        children: [
                                          snapshot.data[snapshot.data.length - index - 1] == null ? Container() : Container(
                                            child: daysbetween >= 0 ? Container(
                                              width: screenwidth,
                                              alignment: Alignment.centerRight,
                                              child : Text( DateFormat("ddMMMMyyyy").format(DateTime.parse(DateTime.now().toString())).toString() == DateFormat("ddMMMMyyyy").format(DateTime.parse(snapshot.data[snapshot.data.length - index - 1]['last_convo']['created_at'].toString())).toString() ? snapshot.data[snapshot.data.length - index - 1]['last_convo']['date_sent'].toString() : DateFormat("dd").format(DateTime.parse(snapshot.data[snapshot.data.length - index - 1]['created_at'].toString())).toString()+' '+monthDate[int.parse(DateFormat("MM").format(DateTime.parse(snapshot.data[snapshot.data.length - index - 1]['created_at'].toString())).toString())].toString()+'. '+DateFormat("yyyy").format(DateTime.parse(snapshot.data[snapshot.data.length - index - 1]['created_at'].toString())).toString(),style: TextStyle(color: Colors.grey[400],fontFamily: 'Google-Medium',fontSize: screenwidth < 700 ?  screenheight/85 : 15),)
                                              ) : Container(
                                              width: screenwidth,
                                              alignment: Alignment.centerRight,
                                              child: Text(daysbetween == 1 ? '1d' : daysbetween < 7 ? '${daysbetween}d' : daysbetween < 14 ? '${daysbetween}w' : daysbetween < 31 ? '${daysbetween}w' : daysbetween < 61 ? '${daysbetween}m' : '${daysbetween}m',style: TextStyle(color: Colors.grey[400],fontFamily: 'Google-Bold',fontSize: screenheight/60 )),
                                            ),
                                          ),
                                          seen_Messages.toString().contains(_seenMessage.toString()) ? Container() : Container(
                                            child: snapshot.data[snapshot.data.length - index - 1]['unread_messages'].toString() == "0" ? Container() : Container(
                                              width: screenwidth,
                                              alignment: Alignment.centerRight,
                                              padding: EdgeInsets.only(bottom: 10),
                                              child: Container(
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    color: Color.fromRGBO(5, 93, 157, 0.9),
                                                    borderRadius: BorderRadius.circular(3)
                                                ),
                                                child: Text(snapshot.data[snapshot.data.length - index - 1]['unread_messages'].toString(),style: TextStyle(color: Colors.white,fontFamily: 'Google-Bold',fontSize: screenheight/75 )),
                                              ),
                                            ),
                                          )
                                        ]
                                    ),
                                  ),
                                )
                              ],
                              // caption: mutedClients.toString().contains('contact_id: '+snapshot.data[snapshot.data.length - index - 1]['id'].toString()) ? 'Unmute' : 'Mute',
                              // color: Colors.white,
                              // icon: mutedClients.toString().contains('contact_id: '+snapshot.data[snapshot.data.length - index - 1]['id'].toString()) ? Icons.volume_up : Icons.volume_off,
                            ),
                          ),
                          secondaryActions: <Widget>[
                            // Builder(
                            Container(
                              child :IconSlideAction(
                                iconWidget: Container(
                                    color: Colors.white,
                                    alignment: Alignment.center,
                                    child: Center(
                                      child: Tooltip(
                                        child: Container(
                                          height: 60,
                                          padding: EdgeInsets.all(5),
                                          child: Column(
                                            mainAxisAlignment:   MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[700],
                                                      borderRadius: BorderRadius.circular(1000.0)
                                                  ),
                                                  child: Icon( mutedClients.toString().contains('contact_id: '+convoDetails[0]['detail']['id'].toString()) ? Icons.volume_up : Icons.volume_off,color: Colors.white,)),],
                                          ),
                                        ),
                                        message: mutedClients.toString().contains('contact_id: '+convoDetails[0]['detail']['id'].toString()) ? 'Désactiver la sourdine' : 'Muette',
                                      ),
                                    )),
                                onTap: (){
                                  if ( mutedClients.toString().contains('contact_id: '+convoDetails[0]['detail']['id'].toString())){
                                    mute_currentChat(context,convoDetails[0]['detail']['id'].toString(),'0');
                                    showSnackBar(context, 'Vous avez réactivé ${convoDetails[0]['detail']['name'].toString()},Votre conversation sera à nouveau disponible.');
                                  }
                                  else{
                                    mute_currentChat(context,convoDetails[0]['detail']['id'].toString(),'1');
                                    showSnackBar(context, "Tu étais muet ${convoDetails[0]['detail']['name'].toString()}, Votre conversation ne sera disponible que si vous l'avez réactivée.");
                                  }
                                },
                              ),
                            ),
                           Container(
                                child: IconSlideAction(
                                  iconWidget: Container(
                                    color: Colors.white,
                                   alignment: Alignment.center,
                                   child: Center(
                                     child: Tooltip(
                                       child: Container(
                                         height: 60,
                                         width: 60,
                                         padding: EdgeInsets.all(5),
                                         child: Column(
                                           mainAxisAlignment:   MainAxisAlignment.spaceEvenly,
                                           children: [
                                             Container(
                                               padding: EdgeInsets.all(5),
                                                 decoration: BoxDecoration(
                                                   color: Colors.red,
                                                   borderRadius: BorderRadius.circular(1000.0)
                                                 ),
                                                 child: Icon(Icons.delete,color: Colors.white,)),
                                           ],
                                         ),
                                       ),
                                       message: 'supprimer la conversation en cours',
                                     ),
                                   )),
                                  onTap: (){
                                    setState(() {
                                      delete_current_convo(context,snapshot.data[snapshot.data.length - index - 1]['last_convo']['channel_id'].toString());
                                    });
                                  },
//                      onTap: () => _showSnackBar('Delete'),
                              ),
                            ),
                          ],
                        ),
                        onTap: ()async{
                          setState(() {
                            if (mutedClients.toString().contains('contact_id: '+snapshot.data[snapshot.data.length - index - 1]['id'].toString()+userdetails.toString())){
                              showSnackBar(context, 'Vous avez désactivé cette conversation avec ${snapshot.data[snapshot.data.length - index - 1]['name'].toString()}');
                            }
                            else{
//                              messagebox_public.text = "";
                              messageToclient_public = "";
//                              sendMessage_show = false;
                              view_message_convo = true;
                              convoClient_ID = snapshot.data[snapshot.data.length - index - 1]['id'].toString();
                              print('CLIENT :'+senderID);
                              senderName = snapshot.data[snapshot.data.length - index - 1]['name'].toString();
                              convoClient_email = snapshot.data[snapshot.data.length - index - 1]['email'].toString();
                              senderProfilePict = snapshot.data[snapshot.data.length - index - 1]['filename'].toString();
                              // senderID = channelID;
//                              channelID = snapshot.data[snapshot.data.length - index - 1]['last_convo']['channel_id'].toString();

                              if (searchPage){
                                searchPage = false;
                              }
                              if (!seen_Messages.toString().contains('{"clientname" : "${convoDetails[0]['detail']['name'].toString()+userdetails.toString()}","messagesLength" : "${snapshot.data[snapshot.data.length - index - 1]['unread_messages'].toString()}"}')){
                                if (seen_Messages.toString() != "null"){
                                  print('MAY SULOD :'+seen_Messages.toString());
                                  List<String> _seen = List<String>();

                                  _seen.add(_seenMessage.toString());
                                  seen_Messages.add(_seen.toString());
                                }else{
                                  seen_Messages = [_seenMessage.toString()];
                                }
                              }
                            }
                          });

                          SharedPreferences prefs_deleted = await SharedPreferences.getInstance();
                          prefs_deleted.setStringList('seenMessages', seen_Messages);

                        },
                      ),
                    ),
                  );
                },
              ),
            );
      }
    );
  }
}

Widget noData(_msg){
  return Container(
    width: screenwidth,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.message,size: screenwidth < 700 ? 40 : 45,color: Colors.black87.withOpacity(0.7),),
          SizedBox(
            height: 15,
          ),
          Container(
            width: screenwidth,
              child: Center(child: Text(_msg,style: TextStyle(color: Colors.black87.withOpacity(0.5),fontFamily: 'Google-Bold',fontSize: screenheight/55 )))),
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenwidth/8),
              width: screenwidth,
              child: Text("Cliquez sur composer un nouveau message pour démarrer la conversation avec d'autres clients."
                ,style: TextStyle(color: Colors.grey[350],fontFamily: 'Google-Bold',fontSize: screenheight/70 ,
                ),textAlign: TextAlign.center,
              )
          ),
        ],
      ),
    ),
  );
}


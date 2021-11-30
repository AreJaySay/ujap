import 'dart:io';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/show_loader.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/new_compose_message.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/new_group_page.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/slider.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/conversation_chats_listener.dart';
import 'package:ujap/services/conversation_listener.dart';
import 'package:ujap/services/image_uploader.dart';
import 'package:ujap/services/member_traversal.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  List _clients = [];
  Map selected;
  TextEditingController _search = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _clients = events_clients;
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text("Nouveau message",style: TextStyle(
            color: Colors.white
          ),),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  onChanged: (text){
                    setState(() {
                      _clients = events_clients.where((s){
                        return s['name'].toString().toLowerCase().contains(text.toLowerCase());
                      }).toList();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Rechercher un récepteur',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search)
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: FlatButton(
                        onPressed: ()=> Navigator.push(context, PageTransition(child: NewGroupPage(toAdd: false,), type: PageTransitionType.bottomToTop)),
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          children: [
                            Container(
                              width: screenwidth < 700 ? 25 : 40,
                              height: screenwidth < 700 ? 25 : 40,
                              child: Image.asset("assets/messages_icon/add_group.png"),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text("Créer un nouveau groupe",style: TextStyle(
                                fontFamily: "Google-Bold",
                                fontSize: screenwidth < 700 ? screenwidth/30 : screenwidth/35
                              ),),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Text("Suggéré",style: TextStyle(
                        color: Colors.black54,
                        fontSize: screenwidth/33
                      ),),
                    ),
                    for(var contacts in _clients)...{
                      contacts['email'].toString() == userdetails['email'].toString() ? Container() : Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: FlatButton(
                          onPressed: ()async{
                            List<int> dd = [];
                            List clientDetails;

                            List checkerList = ownMessages.where((s){
                              print(contacts['id'].toString());
                              if (s['members'][1]['client_id'].toString() == contacts['id'].toString()){
                                return s['members'][1]['client_id'].toString() == contacts['id'].toString()  && s['members'].length == 2;
                              }else{
                                return s['members'][0]['client_id'].toString() == contacts['id'].toString()  && s['members'].length == 2;
                              }
                            }).toList();


                            if (checkerList.toString() == "[]"){
                              showloader(context);
                              selected = contacts;
                              if(userdetails['id'] != selected['id']){
                                dd = [userdetails['id'],selected['id']];
                              }
                              await conversationService.checkConvoMembersExist(memberIds: dd).then((value) {
                                Navigator.of(context).pop(null);
                                Navigator.push(context, PageTransition(child: NewComposeMessage(value,null), type: PageTransitionType.leftToRightWithFade));
                              });
                            }else{
                              print('GINGAMIT NA'+ checkerList[0]['id'].toString());
                              for (var x = 0; x <checkerList[0]['messages'].length; x++ ){
                                channelMembersID.add(checkerList[0]['messages'][x]['sender_id'].toString());
                              }
                              setState(() {

                                clientDetails = events_clients.where((s){
                                  return s['id'].toString() == contacts['id'].toString();
                                }).toList();

                                conversationService.readMessage(on: checkerList[0]['id']);
                                chatListener.updateChannelID(id: checkerList[0]['id']);
                              });
                              if(Platform.isIOS){
                                conversationService.checkConvoMembersExist(memberIds: MemberTraverser().getIds(from: checkerList[0]['members'])).then((value) {
                                  Navigator.push(context, PageTransition(child: NewComposeMessage(value,clientDetails[0]), type: PageTransitionType.topToBottom));
                                });
                              }else{
                                Future.delayed(Duration.zero, () async{
                                  Map dd = await conversationService.checkConvoMembersExist(memberIds: MemberTraverser().getIds(from: checkerList[0]['members']));
                                  Navigator.push(context, PageTransition(child: NewComposeMessage(dd,clientDetails[0]), type: PageTransitionType.topToBottom));
                                });
                              }
                            }
                          },
                          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 0),
                          child: Row(
                            children: [
                              Container(
                                width: screenwidth < 700 ? 40 : 60,
                                height: screenwidth < 700 ? 40 : 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(1000),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[300],
                                      blurRadius: 2,
                                      offset: Offset(2,3)
                                    )
                                  ],
                                  image: DecorationImage(
                                    fit: contacts['filename'] == null ? BoxFit.contain : BoxFit.cover,
                                    image: contacts['filename'].toString() == "null" || contacts['filename'].toString() == "" ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${contacts['filename']}")
                                  )
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text("${contacts['name']} "+" ${contacts['lastname']}",style: TextStyle(
                                  fontFamily: "Google-Bold",
                                  fontSize: screenwidth < 700 ? screenwidth/30 : screenwidth/40
                                ),),
                              )
                            ],
                          ),
                        ),
                      )
                    }
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

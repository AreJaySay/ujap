import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/variables/video.dart';
import 'package:ujap/globals/widgets/searchpage_children/events_homepage.dart';
import 'package:ujap/globals/widgets/searchpage_children/message_homepage.dart';
import 'package:ujap/globals/widgets/searchpage_children/myAttended_homepage.dart';
import 'package:ujap/globals/widgets/view_events.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/events_list_data.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/view_event.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/matches.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/past_events_matches.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/new_compose_message.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/slider.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/conversation_chats_listener.dart';
import 'package:ujap/services/conversation_listener.dart';
import 'package:ujap/services/member_traversal.dart';
import 'package:ujap/services/message_data.dart';
import 'package:ujap/services/navigate_match_events.dart';

class GlobalSearchPage extends StatefulWidget {
  @override
  _GlobalSearchPageState createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends State<GlobalSearchPage> {
  TextEditingController searchBox = new TextEditingController();
  bool keyboardvisible = false;
  List navigaTors = ['ALL','ÉVÉNEMENTS','RÉUNIONS','ALLUMETTES'];
  List navMessage = ['ALL','MESSAGES','MESSAGES DE GROUPE'];
  List messageLocal;
  int navIndex = 0;
  List myeventsData = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    backup_attendedEventMatch = attendedEventMatch;
    messageLocal = ownMessages;
    if(videoPlayerController != null && chewieController != null && chewieController.isPlaying){
      videoPlayerController.pause();
      chewieController.pause();
    }
    KeyboardVisibility.onChange.listen((bool visible) {
     setState(() {
       keyboardvisible = visible;
       // eventsData = eventsfirstData;
       // attendedEventMatch = backup_attendedEventMatch;
       // ownMessages = messageLocal;
       navIndex = 0;
     });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight( screenwidth < 700 ? 110 : screenwidth/6),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kPrimaryColor,
          flexibleSpace: Container(
            width: screenwidth,
            height: screenheight,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: screenwidth,
                  child: SafeArea(
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.arrow_back,color: Colors.white,size: screenwidth < 700 ? screenwidth/15 : 35,),
                          onPressed: (){
                            setState(() {
                              if (myeventsData.toString() != "[]"){
                                myeventsData.clear();
                              }
                            });
                            Navigator.of(context).pop(null);
                          },
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 3),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: TextField(
                              controller: searchBox,
                              style: TextStyle(color: Colors.grey[800],fontSize: screenwidth < 700 ? 15 : 20,fontFamily: 'Google-Medium'),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search_outlined),
                                border: InputBorder.none,
                                suffixIcon:  searchBox.text.isEmpty ? null : GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.circular(1000.0)
                                      ),
                                      child: Icon(Icons.close,size: 25,color: Colors.white,),
                                    ),
                                  ),
                                  onTap: (){
                                    setState(() {
                                      searchBox.text = "";
                                      eventsData = eventsfirstData;
                                      attendedEventMatch = backup_attendedEventMatch;
                                      ownMessages = messageLocal;
                                      navIndex = 0;
                                    });
                                  },
                                ),
                                hintText: 'Chercher ...',
                                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6),fontSize: screenwidth < 700 ? 15 : 20,fontFamily: 'Google-Regular'),
                              ),
                              onChanged: (text){
                                setState(() {
                                  if (currentindex == 0){
                                    attendedEventMatch = backup_attendedEventMatch.where((s){
                                      return s['name'].toString().toLowerCase().contains(text.toString().toLowerCase()) || (s['type'].toString().toLowerCase()+'s').contains(text.toString().toLowerCase()) ||
                                          DateFormat("MMMM d,yyyy").format(DateTime.parse(s['sched_date'])).toString().toLowerCase().contains(text.toString().toLowerCase());
                                    }).toList();
                                  }else if(currentindex == 1){
                                    eventsData = eventsfirstData.where((s){
                                      return s['name'].toString().toLowerCase().contains(text.toString().toLowerCase()) || (s['type'].toString().toLowerCase()+'s').contains(text.toString().toLowerCase()) ||
                                          DateFormat("MMMM d,yyyy").format(DateTime.parse(s['sched_date'])).toString().toLowerCase().contains(text.toString().toLowerCase());
                                    }).toList();
                                  }else{
                                    print('MESSAGE SULOD'+messageLocal.toString());
                                    ownMessages = messageLocal.where((s){
                                      return kahampang(s['members'], s['name'].toString()).toLowerCase().contains(text.toString().toLowerCase());
                                    }).toList();
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: screenwidth,
                    height: screenheight,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: currentindex == 2 ? navMessage.length : navigaTors.length,
                            itemBuilder: (context , index){
                              return GestureDetector(
                                child: Container(
                                  height: screenheight,
                                  alignment: Alignment.centerLeft,
                                  child: Text(currentindex == 2 ? navMessage[index].toString() : navigaTors[index].toString(),style: TextStyle(fontFamily: 'Google-regular',color: index == navIndex ? Colors.white : Colors.white.withOpacity(0.7),fontWeight: index == navIndex ? FontWeight.w700 : FontWeight.w500,fontSize: screenwidth < 700 ? screenwidth/35 : screenwidth/50),),
                                  margin: EdgeInsets.only(right: screenwidth/20),
                                ),
                                onTap: (){
                                  setState(() {
                                    navIndex = index;
                                    if (index == 1){
                                      if (currentindex == 0){
                                        attendedEventMatch = backup_attendedEventMatch.where((s){
                                          return s['type'].toString().toLowerCase() == 'event';
                                        }).toList();
                                      }
                                      else if (currentindex == 1){
                                        eventsData = eventsfirstData.where((s){
                                          return s['type'].toString().toLowerCase() == 'event';
                                        }).toList();
                                      }else{
                                        ownMessages = messageLocal.where((s){
                                          return s['members'].length  == 2;
                                        }).toList();
                                      }
                                    }else if(index == 2){
                                      if (currentindex == 0){
                                        attendedEventMatch = backup_attendedEventMatch.where((s){
                                          return s['type'].toString().toLowerCase() == 'meeting';
                                        }).toList();
                                      }
                                      else if (currentindex == 1){
                                        eventsData = eventsfirstData.where((s){
                                          return s['type'].toString().toLowerCase() == 'meeting';
                                        }).toList();
                                      }else{
                                        ownMessages = messageLocal.where((s){
                                          return s['members'].length > 2;
                                        }).toList();
                                      }
                                    }else if(index == 3){
                                      if (currentindex == 0){
                                        attendedEventMatch = backup_attendedEventMatch.where((s){
                                          return s['type'].toString().toLowerCase() == 'match';
                                        }).toList();
                                      }
                                      if (currentindex == 1){
                                        eventsData = eventsfirstData.where((s){
                                          return s['type'].toString().toLowerCase() == 'match';
                                        }).toList();
                                      };
                                    }else{
                                      if (currentindex == 2){
                                        ownMessages = messageLocal;
                                      }else{
                                        eventsData = eventsfirstData;
                                      }
                                    }
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        navIndex != 0 || currentindex == 2 ? Container() : PopupMenuButton<int>(
                          icon: Icon(Icons.arrow_drop_down,size: screenwidth < 700 ? screenwidth/12 : 40,color: Colors.white,),
                          itemBuilder: (context)=>[
                            PopupMenuItem(
                              value: 1,
                              child: Text(
                                 "Événements/matchs passés",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: Text(
                                "En cours  évènements/matchs",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                          onSelected: (index){
                            setState(() {
                              print(index.toString());
                              if (currentindex == 0){
                                if (index == 1){
                                  attendedEventMatch = backup_attendedEventMatch.where((s){
                                    return int.parse(DateFormat("yyyyMMdd").format(DateTime.parse(s['sched_date'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'')))) <= int.parse(DateFormat("yyyyMMdd").format(DateTime.now()));
                                  }).toList();
                                }else{
                                  attendedEventMatch = backup_attendedEventMatch.where((s){
                                    return int.parse(DateFormat("yyyyMMdd").format(DateTime.parse(s['sched_date'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'')))) > int.parse(DateFormat("yyyyMMdd").format(DateTime.now()));
                                  }).toList();
                                }
                              }else{
                                  if (index == 1){
                                    eventsData = eventsfirstData.where((s){
                                      return int.parse(DateFormat("yyyyMMdd").format(DateTime.parse(s['sched_date'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'')))) <= int.parse(DateFormat("yyyyMMdd").format(DateTime.now()));
                                    }).toList();
                                  }else{
                                    eventsData = eventsfirstData.where((s){
                                      return int.parse(DateFormat("yyyyMMdd").format(DateTime.parse(s['sched_date'].toString().replaceAll(new RegExp(r'[^\w\s]+'),'')))) > int.parse(DateFormat("yyyyMMdd").format(DateTime.now()));
                                    }).toList();
                                }
                              }
                            });
                          },
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Container(
        width: screenwidth,
        height: screenheight,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: eventsData.length == 0 || eventsData == null || attendedEventMatch.length == 0 || attendedEventMatch.toString() == "[]" || ownMessages.length == 0 ?
        Container(
          width: screenwidth,
          height: screenheight,
          padding: EdgeInsets.only(bottom: 50),
          decoration: BoxDecoration(
              color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: screenwidth < 700 ? screenwidth/3 : screenwidth/3.5,
                height:screenwidth < 700 ? screenwidth/3 : screenwidth/3.5,
                child: currentindex == 2 ? Icon(Icons.chat,size: screenwidth/7,) : Image(
                  color: Colors.grey[700],
                  fit: BoxFit.cover,
                  image: AssetImage('assets/home_icons/no_events.png'),
                ),
              ),
              Container(
                  child: Column(
                    children: [
                      Text("Aucun messages trouvé".toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/65  : 20,fontFamily: 'Google-Bold',color: Colors.grey[700]),),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Vous verrez tous vos messages ici.".toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/90  : 20,fontFamily: 'Google-Bold',color: Colors.grey[500]),),
                    ],
                  )),
            ],
          ),
        ) :
        ListView.builder(
          itemCount: currentindex == 0 ? attendedEventMatch.length : currentindex == 1 ? eventsData.length : ownMessages.length,
          itemBuilder: (context, index){
            List<String> currentMessage = List<String>();

            if (ownMessages != null){
              for(var x =0;x<ownMessages.length;x++){
                if (ownMessages[index]['messages'].toString() == "[]" && ownMessages[index]['members'].length == 2){
                }else{
                  currentMessage.add(ownMessages[index]['messages'].toString());
                }
              }
            }

            if (currentMessage.toString() == "[]" && currentindex == 2){
                return Container();
               }else{
                 for(var x =0;x<ownMessages.length;x++){
                   if (ownMessages[index]['last_convo'] == null && ownMessages[index]['members'].length == 2 && currentindex == 2){
                     // conversationService.deleteChannelLoc(snapshot.data[x]['id']),
                   }else{
                     if (currentindex == 2){
                       if (ownMessages[index]['messages'].toString() != "[]" || ownMessages[index]['members'].length > 2){
                         return GestureDetector(
                           child: currentindex == 0 ? MyAttendedHomepage(attendedEventMatch,index) : currentindex == 1 ? EventsHomepage(eventsData,index) : MessageHomepage(ownMessages,index),
                           onTap: (){
                             setState(() {
                               if (currentindex == 2){
                                 conversationService.readMessage(on: ownMessages[index]['id']);
                                 chatListener.updateChannelID(id: ownMessages[index]['id']);
                                 if(Platform.isIOS){
                                   conversationService.checkConvoMembersExist(memberIds: MemberTraverser().getIds(from:ownMessages[index]['members'])).then((value) {
                                     Navigator.push(context, PageTransition(child: NewComposeMessage(value), type: PageTransitionType.topToBottom));
                                   });
                                 }else{
                                   Future.delayed(Duration.zero, () async{
                                     Map dd = await conversationService.checkConvoMembersExist(memberIds: MemberTraverser().getIds(from: ownMessages[index]['members']));
                                     Navigator.push(context, PageTransition(child: NewComposeMessage(dd), type: PageTransitionType.topToBottom));
                                   });
                                 }
                               }else{
                                 if (eventsData[index]['type'].toString().toLowerCase() == 'match'){
                                   navigateMatch(index,context,eventsData[index]);
                                 }else{
                                   Navigator.push(context, PageTransition(
                                       child: eventsData[index]['type'].toString() != "meeting" ? ViewEvent(
                                         eventDetail: eventsData[index],
                                         pastEvent: false,
                                       ) : ViewEventDetails(
                                         eventDetail: eventsData[index],
                                         pastEvent: false,
                                       ),
                                       type: PageTransitionType.topToBottom
                                   ));
                                 }
                               }
                             });
                           },
                         );
                       }
                     }else{
                       return GestureDetector(
                         child: currentindex == 0 ? MyAttendedHomepage(attendedEventMatch,index) : currentindex == 1 ? EventsHomepage(eventsData,index) : MessageHomepage(ownMessages,index),
                         onTap: (){
                           setState(() {
                             if (currentindex == 2){
                               conversationService.readMessage(on: ownMessages[index]['id']);
                               chatListener.updateChannelID(id: ownMessages[index]['id']);
                               if(Platform.isIOS){
                                 conversationService.checkConvoMembersExist(memberIds: MemberTraverser().getIds(from:ownMessages[index]['members'])).then((value) {
                                   Navigator.push(context, PageTransition(child: NewComposeMessage(value), type: PageTransitionType.topToBottom));
                                 });
                               }else{
                                 Future.delayed(Duration.zero, () async{
                                   Map dd = await conversationService.checkConvoMembersExist(memberIds: MemberTraverser().getIds(from: ownMessages[index]['members']));
                                   Navigator.push(context, PageTransition(child: NewComposeMessage(dd), type: PageTransitionType.topToBottom));
                                 });
                               }
                             }else{
                               if (eventsData[index]['type'].toString().toLowerCase() == 'match'){
                                 navigateMatch(index,context,eventsData[index]);
                               }else{
                                 Navigator.push(context, PageTransition(
                                     child: eventsData[index]['type'].toString() != "meeting" ? ViewEvent(
                                       eventDetail: eventsData[index],
                                       pastEvent: false,
                                     ) : ViewEventDetails(
                                       eventDetail: eventsData[index],
                                       pastEvent: false,
                                     ),
                                     type: PageTransitionType.topToBottom
                                 ));
                               }
                             }
                           });
                         },
                       );
                     }
                   }
                 }
               }
          },
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujap/controllers/home.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/events_sub_pages_variables.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/messages_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/variables/video.dart';
import 'package:ujap/globals/widgets/appbar_icons.dart';
import 'package:ujap/globals/widgets/banner.dart';
import 'package:ujap/globals/widgets/show_loader.dart';
import 'package:ujap/pages/client_profile_page/view_profile_pict.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/filter_events.dart';
import 'package:ujap/pages/homepage_sub_pages/event_parent_page.dart';
import 'package:ujap/pages/homepage_sub_pages/home_parent_page.dart';
import 'package:ujap/pages/homepage_sub_pages/message_parent_page.dart';
import 'package:ujap/services/ad_listener.dart';
import 'package:ujap/services/api.dart';
import 'package:http/http.dart' as http;
import 'package:ujap/services/new_messages_counter.dart';
import 'package:ujap/services/pushnotification.dart';
import 'package:ujap/services/string_formatter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

List<String> notificationsBackup = List<String>();
bool notificationIndicator = false;
bool notificationIndicatiorMessages = false;
List<String> ads = List<String>();
bool showProfilePict = false;

class Homepage extends StatefulWidget {
  bool showAds;
  Homepage(this.showAds);
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  GlobalKey _key = new GlobalKey();
  List _checkAds = [];
  bool _show_hide_ads = false;
  int itemindex = 0;
  List<Future> myFuture;

  // Stream _listener;
  Stream nav() async* {
    setState(() {
      itemindex = currentindex;
    });
    yield itemindex;
  }

  List<Widget> pagecontents = [
    Event_parent(),
    Home_parent(),
    Message_homepage(),
  ];
  getAds() async {
     if ( backupAds.toString() != "[]" && widget.showAds && currentindex == 1){
      print('YES NASULOD');
       await getall_Ads().then((value) async {
         if(value != null && value.length > 0){
           if(value[0]['ad_type'] != 1){
             adListener.showAd(context, value[0]);
             return ;
           }
           adListener.update(true);
           bannerDisplay.update(value[0]);
//           setState(() {
//             show_ads = true;
//           });
           if(value[0]['position'] == 3)
           {
             if(value[0]['type'] != 'image'){
               setState(() {
                 videoPlayerController = VideoPlayerController.network('${StringFormatter().strToObj(value[0]['content'])['location']}');
               });
               await videoPlayerController.initialize();
               setState(() {
                 chewieController = ChewieController(
                   videoPlayerController: videoPlayerController,
                   autoPlay: true,
                   looping: false,
                   showControls: false,
                   showControlsOnInitialize: false,
                 );
               });
             }
           }
         }
       });
     }

  }
  @override
  void initState(){
      sendFCM_token();
      getServerFcmToken();
      getEvents_clients(context);
      get_mutedChat();
      getPersonMessage();
      getEvents_status();
      get_ticket_requests(context,"");
      getTeams();
      getAds();
      bannerDisplay.stream$.listen((event) {
        print("HOME AD : $event");
        if(this.mounted){
          setState(() {
            adData = event;
          });
        }else{
          adData = event;
        }
      });
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      super.initState();
      notificationsBackup = notificationsBackup;
      if (serverFcmTokens.toString() != "[]"){
        serverFcmTokens.clear();
      }
      showcalendar = false;
      hideFloatingbutton = false;
      events_filter_open = false;
      message_compose_open = false;
      view_message_convo = false;
      floating_action = false;
      tosearch = "";
      attend_pass = "";
      searchbox_filter = "";
      convertedDate_filter = 0;
      convertedDate_filter_to = 99999999999;
      try{
        PushNotification().initialize(context);
      }catch(e){
        print("PUSH NOTIFICATION ERROR : $e");
      }
    }

  @override
  void dispose() {
    // TODO: implement dispose
    if(videoPlayerController != null && chewieController != null && chewieController.isPlaying){
      videoPlayerController.pause();
      chewieController.pause();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    double screenwidth = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setEnabledSystemUIOverlays([]);
    return StreamBuilder(
      stream: indexListener.stream,
      builder: (context, snapshot) {
        return GestureDetector(
          child: Stack(
            children: [
              Scaffold(
                key: _key,
                resizeToAvoidBottomInset: true,
                body: Stack(
                  children: [
                    pagecontents[snapshot.data],
                    Container(
                      child: get_ads == null || get_ads.length == 0 || get_ads[0]['filename'].toString() == "null" ?
                      Container() :
                      currentindex == 2 || currentindex == 0 ? Container() : Container(
                        width: double.infinity,
                        height: double.infinity,
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          child: StreamBuilder<bool>(
                            stream: adListener.stream$,
                            builder: (context, snapshot) => snapshot.hasData && snapshot.data ? Container(
                              height: screenwidth < 700 ? screenwidth/1.8 : screenwidth/2.7,
                              alignment: Alignment.bottomCenter,
                              child: bannerDisplay.showBanner(context, position: 3),
                            ) : Container(),
                          ),

                          onTap: ()async{
                            print(get_ads.toString());
                            String url = '${StringFormatter().cleaner(StringFormatter().strToObj(get_ads[0]['content'])['location'])}';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar:  StreamBuilder<int>(
                  stream: nMessageCounter.stream$,
                  builder: (context, snapshot) {

                    return BottomNavigationBar(
                      currentIndex: itemindex,
                      onTap: (index) {
                        setState(() {
                          currentindex = index;
                          indexListener.update(data: index);
                          itemindex = index;
                          showsearchBox = false;
                          // if(_chewieController != null && _videoPlayerController != null && _chewieController.isPlaying){
                          //   _videoPlayerController.pause();
                          //   _chewieController?.dispose();
                          //   show_ads = false;
                          // }
                          if (currentindex == 2){
                            print('INDEX'+currentindex.toString());
                            notificationIndicatiorMessages = false;
                          }

                        });
                        if(videoPlayerController != null && chewieController != null && chewieController.isPlaying){
                          videoPlayerController.pause();
                          chewieController.pause();
                          adListener.update(false);
//                          setState(() {
//                            show_ads = false;
//                          });
                        }
                      },
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          title: Text(
                            '',
                          ),
                          icon: Container(
                            width: screenwidth < 700 ? screenwidth/17 : screenwidth/25,
                            height: screenwidth < 700 ?  screenwidth/17 :  screenwidth/25,
                            child: Image(
                              color: currentindex == 0 ? Color.fromRGBO(5, 93, 157, 0.6) : Colors.grey,
                              image: AssetImage('assets/home_icons/events.png'),
                            ),
                          ),
                        ),
                        BottomNavigationBarItem(
                          title: Text(
                            '',
                          ),
                          icon: !isCollapsed ? Container() : Icon(Icons.favorite,),
                        ),
                        BottomNavigationBarItem(
                          title: Text(
                            '',
                          ),
                          icon: Container(
                            width: screenwidth < 700 ? screenwidth/17 : screenwidth/25,
                            height: screenwidth < 700 ?  screenwidth/17 :  screenwidth/25,
                            child: Stack(
                              children: [
                                Image(
                                  color: currentindex == 2 ? Color.fromRGBO(5, 93, 157, 0.6) : Colors.grey,
                                  image: AssetImage('assets/home_icons/chat.png'),
                                ),
                                snapshot.data != 0 ? Positioned(
                                    right: 0,
                                    child: Container(
                                      width: screenwidth < 700 ? screenwidth/34 : screenwidth/50,
                                      height: screenwidth < 700 ? screenwidth/34 : screenwidth/50,
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(1000)
                                      ),
                                      child: FittedBox(
                                        child: Text("${snapshot.data}",style: TextStyle(
                                            color: Colors.white
                                        ),),
                                      ),
                                    )
                                ) : Container()
                              ],
                            ),
                          ),
                        ),
                      ],

                    );
                  }
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                floatingActionButton: !isCollapsed ? Container() : Container(
                  margin: EdgeInsets.only(top: 20),
                  height: screenwidth < 700 ? screenwidth/5.5 : 100,
                  width: screenwidth < 700 ? screenwidth/5.5 : 100,
                  child: new FloatingActionButton(
                    heroTag: "btn1",
                    backgroundColor: Colors.white,
                    elevation: 1.0,
                    onPressed: (){
                      setState(() {
                        indexListener.update(data: 1);
                        hideFloatingbutton = false;
                        showcalendar = false;
                        events_filter_open = false;
                        message_compose_open = false;
                        view_message_convo = false;
                        floating_action = false;
                        attend_pass = "";
                        showticket = false;
                        showsearchBox = false;
                        currentindex = 1;
                        print(currentindex.toString());
                        itemindex = currentindex;
                      });
                    },
                    child: new Container(
                      padding: EdgeInsets.all(3),
                      child: Image(
                        fit: BoxFit.cover,
                          image: AssetImage('assets/logo_shadow.png')
                      ),
                    ),
                  ),
                ),
              ),
              !events_filter_open && !message_compose_open ? Container() :
              GestureDetector(
                child: Container(
                  width: screenwidth,
                  height: screenheight,
                  color: Colors.black.withOpacity(0.4),
                ),
                onTap: (){
                  setState(() {
                    events_filter_open = false;
                    message_compose_open = false;
                    myEvents = "";
                    fromDate = "";
                    toDate = "";
                    view_data_filter = "";
                    status_data_filter = "";
                  });
                },
              ),
              Events_filter(),
            ],
          ),
          onTap: (){
            setState(() {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            });
          },
        );
      }
    );
  }
}
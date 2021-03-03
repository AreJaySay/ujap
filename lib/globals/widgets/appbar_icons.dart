import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/container_data.dart';
import 'dart:math' as math;
import 'package:ujap/globals/variables/events_sub_pages_variables.dart';
import 'package:ujap/globals/variables/messages_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/search_page.dart';
import 'package:ujap/pages/client_profile_page/profile_page.dart';
import 'package:ujap/pages/drawer_page.dart';
import 'package:ujap/pages/homepage.dart';
import 'package:ujap/services/ad_listener.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/notifications.dart';
import 'package:ujap/services/pushnotification.dart';
import 'package:ujap/services/searches/search_service.dart';

bool showsearchBox = false;
String notificID = "";
String notificType = "";

class Appbar_icons extends StatefulWidget {
  @override
  _Appbar_iconsState createState() => _Appbar_iconsState();
}

class _Appbar_iconsState extends State<Appbar_icons> {

  Stream hideAppBar() async* {
    setState(() {
      searchPage = searchPage;
      notificationIndicator = notificationIndicator;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return StreamBuilder(
    //   stream: hideAppBar(),
    //   builder: (context, snapshot) {
        return Expanded(
          child: searchPage ? Container() :
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenwidth/30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                eventsData == null && ownMessages == null ? Container() : IconButton(
                  icon: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: Icon(Icons.search,color: Colors.white,size: screenwidth < 700 ? screenwidth/ 17 : 35,),
                  ),
                  onPressed: (){
                    setState(() {
                      eventsSearch = false;
                      view_message_convo = false;
                      matchservice.filter(searchBox: "");
                    });
                    Navigator.push(context, PageTransition(child:  GlobalSearchPage(
                    ),type: PageTransitionType.topToBottom,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
                  },
                ),
                SizedBox(
                  width: screenwidth/60,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Stack(
                        children: [
                          Icon(Icons.notifications_none,color: Colors.white,size: screenwidth < 700 ? screenwidth/ 17 : 35,),
                          Positioned(
                            right: 1.0,
                            child: Icon(Icons.brightness_1,
                              color: !notificationIndicator ? Colors.transparent : Color.fromRGBO(231, 175, 77, 0.9),
                              size: screenwidth < 700 ? 9 : 12,
                            ),
                          )
                        ],
                      ),
                      onPressed: (){
                        addToDb(itemid: notificID.toString(),messageTypes: notificType.toString());
                        notificationIndicator = false;
                        adListener.update(false);
                        Navigator.push(context, PageTransition(child:  Notifications(
                        ),type: PageTransitionType.leftToRightWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
                      },
                    )
                  ],
                ),
                SizedBox(
                  width: screenwidth/60,
                ),
                IconButton(
                  icon: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: Icon(Icons.person,color: Colors.white,size: screenwidth < 700 ? screenwidth/ 17 : 35,),
                  ),
                  onPressed: (){
                    eventsSearch = false;
                    adListener.update(false);
//                    setState(() {
//                      show_ads = false;
//                    });
                    Navigator.push(context, PageTransition(child:  ProfilePage(
                    ),type: PageTransitionType.rightToLeftWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));

                     },
                ),
              ],
            ),
          ),


      //   );
      // }
    );
  }
}
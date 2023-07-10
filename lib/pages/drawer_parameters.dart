import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/events_sub_pages_variables.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/messages_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/pages/client_profile_page/profile_page.dart';
import 'package:ujap/pages/homepage.dart';
import 'package:ujap/services/push_notification_enable_listener.dart';
import 'client_profile_page/profile_information.dart';

List<String> silent_notifications = [];

class Parameters extends StatefulWidget {
  @override
  _ParametersState createState() => _ParametersState();
}

class _ParametersState extends State<Parameters> {
//  Status pushStatus = IsPushEnabled().current;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.8),
        borderRadius: new BorderRadius.only(
            bottomLeft: const Radius.circular(10.0),
            bottomRight: const Radius.circular(10.0),
            topRight: const Radius.circular(10.0)),
      ),
      child: Column(
        children: [
          InkWell(
            child: Container(
              width: double.infinity,
              height: 55,
              child: Row(
                children: [
                  SizedBox(
                    width: 3,
                  ),
                  Container(
                    width: 25,
                    child: Image(
                        color: Colors.white,
                        image: AssetImage('assets/messages_icon/no_profile.png')
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Editer/voir profil',style: TextStyle(color: Colors.white,fontFamily: 'Google-Medium'),)
                ],
              ),
            ),
            onTap: (){
              setState(() {
                if (isCollapsed) {
                  drawerController.forward();
                  borderRadius = 30.0;
                } else {
                  drawerController.reverse();
                  view_message_convo = false;
                  view_message_convo_group = false;
                  borderRadius = 0.0;
                }
                showcalendar = false;
                message_compose_open = false;
                view_message_convo = false;
                floating_action = false;
                attend_pass = "";
                showticket = false;
                Navigator.push(context, PageTransition(child:  ProfilePage(
                ),type: PageTransitionType.leftToRightWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
                isCollapsed = !isCollapsed;
              });
            },
          ),
          InkWell(
            child: Container(
              width: double.infinity,
              height: 55,
              child: Row(
                children: [
                  Icon(Icons.info_outline,size: 30,color: Colors.white,),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Informations sur le profil',style: TextStyle(color: Colors.white,fontFamily: 'Google-Medium'),)
                ],
              ),
            ),
            onTap: (){
              setState(() {
                view_message_convo = false;
                view_message_convo_group = false;
              });
              Navigator.push(context, PageTransition(child: ProfileInformation(
              ),type: PageTransitionType.rightToLeftWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
            },
          ),
        ],
      ),
    );
  }
}

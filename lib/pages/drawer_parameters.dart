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
      width: screenwidth/1.7,
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.8),
        borderRadius: new BorderRadius.only(
            bottomLeft: const Radius.circular(10.0),
            bottomRight: const Radius.circular(10.0),
            topRight: const Radius.circular(10.0)),
      ),
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          FlatButton(
            child: Container(
              child: Row(
                children: [
                  Container(
                    width: screenwidth < 700 ? screenwidth/20 : 30,
                    height: screenwidth < 700 ? screenwidth/20 : 30,
                    child: Image(
                        color: Colors.white,
                        image: AssetImage('assets/messages_icon/no_profile.png')
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: screenwidth/40),
                      alignment: Alignment.centerLeft,
                      child: Text('Editer/voir profil',style: TextStyle(color: Colors.white,fontSize: screenwidth < 700 ? screenheight/60 : 20,fontFamily: 'Google-Medium'),))
                ],
              ),
            ),
            onPressed: (){
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
                events_filter_open = false;
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
          FlatButton(
            child: Container(
              child: Row(
                children: [
                  Icon(Icons.info_outline,size: screenwidth < 700 ? 25 : 30,color: Colors.white,),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: screenwidth/40),
                        alignment: Alignment.centerLeft,
                        child: Text('Informations sur le profil',style: TextStyle(color: Colors.white,fontSize: screenwidth < 700 ? screenheight/60 : 20,fontFamily: 'Google-Medium'),)),
                  )
                ],
              ),
            ),
            onPressed: (){
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

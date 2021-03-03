import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujap/controllers/home.dart';
import 'package:ujap/controllers/login_controller.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/credential_variables.dart';
import 'package:ujap/globals/variables/events_sub_pages_variables.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/view_events.dart';
import 'package:ujap/pages/credentials_sub_pages/loginpage.dart';
import 'package:ujap/pages/drawer_parameters.dart';
import 'package:ujap/pages/homepage.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/events_list_data.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/create_new_group.dart';
import 'package:ujap/services/message_data.dart';
import 'package:ujap/services/push_notification_enable_listener.dart';
import 'package:ujap/services/pushnotification.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('fr')
        ],
        title: 'Ujap',
        debugShowCheckedModeBanner: false,
        home: SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}


class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
//    IsPushEnabled().start();
//    PushNotification().getFCMToken().whenComplete(() => ));
    navigatehomepage();
    hideFloatingbutton = false;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }


  @override
  Widget build(BuildContext context) {
    screenheight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: screenwidth,
        height: screenheight,
        color: Colors.white,
        child: Center(
          child: Container(
            width: screenwidth < 700 ? screenwidth/1.9 : screenwidth/2.5,
            child: Image(
              image: AssetImage('assets/logo_shadow.png'),
            ),
          ),
        ),

      ),
    );}


  Future<void> navigatehomepage()async{
    SharedPreferences emailhistory = await SharedPreferences.getInstance();
    emailsHistory = emailhistory.getStringList('emailshistory');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pass = prefs.getString('password');
    var user = prefs.getString('username');

    SharedPreferences notifications = await SharedPreferences.getInstance();
    notificationsBackup = notifications.getStringList('notificationsData');

    SharedPreferences prefs_deleted = await SharedPreferences.getInstance();
    messageDeleted = prefs_deleted.getStringList('messageToDelete');
    silent_notifications = prefs_deleted.getStringList('notification');
    seen_Messages = prefs_deleted.getStringList('seenMessages');
    deleteMember = prefs_deleted.getStringList('deleteMember');
    mutedConvo = prefs.getStringList('mutedConvo');
    attended_Meeting = prefs_deleted.getStringList('clientmeetingAttend');

    if(( user == null && pass == null)){
      await Future.delayed(Duration(milliseconds: 1500));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Loginpage()));
    }
    else
    {
      print('HERE');
      setState(() {
        savedPass = pass;
        savedEmail = user;
        login(user, pass, context,null);
        Navigator.of(context,).pop(null);
      });
//      openLocationSetting();
    }
  }

}
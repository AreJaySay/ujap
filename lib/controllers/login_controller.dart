import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujap/controllers/home.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/widgets/show_loader.dart';
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/pages/client_profile_page/profile_page.dart';
import 'package:ujap/pages/client_profile_page/update_picture.dart';
import 'package:ujap/pages/credentials_sub_pages/loginpage.dart';
import 'package:ujap/pages/drawer_page.dart';
import 'package:ujap/services/pushnotification.dart';

bool editProfile = false;

Future login(String username, String password,context,bool loader)async{
  showloader(context);
  var response = await http.post('https://ujap.checkmy.dev/api/client/login',
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $accesstoken",
        "Accept": "application/json"
      },
      body: {
        'email': username,
        'password': password,
      }
  );
  var data = json.decode(response.body);
  print('RETURN '+response.statusCode.toString());
  if(response.statusCode == 200){
    currentindex = 1;
    indexListener.update(data: 1);
    pass = password;
    user = username;
    userdetails = data['client'];
    accesstoken = data['token'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('password', password);
    isCollapsed = true;
    usernamecontroller.text = "";
    passwordcontroller.text = "";
    if (changeProfilePict){
      Navigator.push(context, PageTransition(child: ProfilePage(
      ),type: PageTransitionType.rightToLeftWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
    }else{

      print('DIDI');
      currentindex = 1;
      Navigator.pushReplacement(context,PageTransition(child: MainScreen(true),type: PageTransitionType.fade));
    }
    PushNotification().subscribe(data['client']['id']);
  }else{
    if (usernamecontroller.text.isNotEmpty && passwordcontroller.text.isNotEmpty){
      print('NASULOD');
      if (data['message'].toString().contains('Password mismatch'.toString())){
        print(data['message'].toString());
        showSnackBar(context, 'Impossible de se connecter. Veuillez vérifier votre mot de passe.');
      }
      else if (data['message'].toString().contains('User does not exist'.toString())){
        print(data['message'].toString());
        showSnackBar(context, 'Impossible de se connecter. Veuillez vérifier votre email.');
      }
      else
      {
        print(data['message'].toString());
        showSnackBar(context, 'Problème de connexion. Veuillez vérifier à nouveau votre adresse e-mail et votre mot de passe.');
      }
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Loginpage()));
  }
}

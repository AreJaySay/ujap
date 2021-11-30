import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:ujap/globals/variables/credential_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/show_flushbar.dart';
import 'package:ujap/globals/widgets/show_loader.dart';
import 'package:ujap/pages/credentials_sub_pages/loginpage.dart';

class Enter_new_credentials extends StatefulWidget {
  @override
  _Enter_new_credentialsState createState() => _Enter_new_credentialsState();
}

class _Enter_new_credentialsState extends State<Enter_new_credentials> {
  var _useremail;
  bool keyboardvisible = false;
  TextEditingController usernamecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  _sendCode()async{
    showloader(context);
    var response = await http.post(Uri.parse('https://ujap.checkmy.dev/api/client/password-reset'),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $accesstoken",
          "Accept": "application/json"
        },
        body: {
          'email': usernamecontroller.text.toString(),
          'password': passwordcontroller.text.toString(),
          'reset_token': forgotPassword.toString()
        }
    );
    var jsonData = json.decode(response.body);
    var _events_clients = jsonData;
    if (response.statusCode == 200){
      setState(() {
        print(jsonData.toString());
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Loginpage()));
        showflushbar("","Votre adresse e-mail et votre mot de passe ont été mis à jour avec succès!", context);
      });
    }
    else
    {
      Navigator.of(context).pop(null);
      showflushbar("",jsonData['message'].toString(), context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    // KeyboardVisibility.onChange.listen((bool visible) {
    //     keyboardvisible = visible;
    // });
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: Container(
        width: screenwidth,
        height: screenheight,
        child: ListView(
          children: [
            Container(
              width: screenwidth,
              height: screenheight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenwidth/10,
                  ),
                  Container(
                    width: screenwidth,
                    height: screenheight/8,
                    child: Center(
                        child: Container(
                          width: screenwidth < 700 ? screenwidth/5 : screenwidth/7,
                          height: screenheight,
                          child: Image(
                            color: kPrimaryColor ,
                            image: AssetImage('assets/login_icons/change_password.png'),
                          ),
                        )
                    ),
                  ),
                  SizedBox(
                    height: screenwidth/50,
                  ),
                  Container(
                    width: screenwidth,
                    padding: EdgeInsets.symmetric(horizontal: screenwidth/10),
                    child: Column(
                      children: [
                        Text('Veuillez saisir votre nouvelle adresse e-mail et votre nouveau mot de passe pour continuer!',style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black54,fontSize: screenwidth < 700 ? screenheight/55 : 23),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenwidth < 700 ? screenwidth/10 : screenwidth/20,
                  ),
                  Container(
                    height: screenheight/15,
                    width: screenwidth,
                    padding: EdgeInsets.symmetric(horizontal: screenwidth/10),
                    child: TextField(
                      autofocus: true,
                      controller: usernamecontroller,
                      style: TextStyle(fontFamily: 'Google-Regular',color: Colors.black,fontSize: screenwidth < 700 ? screenheight/60 : 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal:  screenwidth < 700 ? 15 : 25,vertical: screenwidth < 700 ? 0 : 20),
                          hintText: 'Nouvelle adresse courriel',
                          hintStyle: TextStyle(fontFamily: 'Google-Medium',color: Colors.grey[300],fontSize: screenwidth < 700 ? screenheight/60 : 20),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Color.fromRGBO(5, 93, 157, 0.2),)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey[200])
                          )
                      ),
                      onChanged: (text){
                        setState(() {
                          _useremail = text;
                          print(_useremail.toString());
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: screenwidth/20,
                  ),
                  Container(
                    height: screenheight/15,
                    width: screenwidth,
                    padding: EdgeInsets.symmetric(horizontal: screenwidth/10),
                    child: TextField(
                      autofocus: true,
                      controller: passwordcontroller,
                      style: TextStyle(fontFamily: 'Google-Regular',color: Colors.black,fontSize: screenwidth < 700 ? screenheight/60 : 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal:  screenwidth < 700 ? 15 : 25,vertical: screenwidth < 700 ? 0 : 20),
                          hintText: 'Nouveau mot de passe',
                          hintStyle: TextStyle(fontFamily: 'Google-Medium',color: Colors.grey[300],fontSize: screenwidth < 700 ? screenheight/60 : 20),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Color.fromRGBO(5, 93, 157, 0.2),)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey[200])
                          )
                      ),
                      onChanged: (text){
                        setState(() {
                          _useremail = text;
                          print(_useremail.toString());
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: screenwidth/20,
                  ),
                  GestureDetector(
                    child: Container(
                        height: screenheight/18,
                        width: screenwidth,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: screenwidth/10),
                        decoration: BoxDecoration(
                            color: kPrimaryColor ,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color:  kPrimaryColor)
                        ),
                        child: Text('ENVOYER',style: TextStyle(fontFamily: 'Google-Bold',color: Colors.white,fontSize: screenwidth < 700 ? screenheight/55 : 23),)
                    ),
                    onTap: (){
                      setState(() {
                        if (usernamecontroller.text.isEmpty){
                          showflushbar("SUCCESS:",'Veuillez écrire le code de réinitialisation, il est obligatoire!', context);
                        }
                        else{
                          _sendCode();
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    child: Container(
                        height: screenheight/18,
                        width: screenwidth,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: screenwidth/10),
                        decoration: BoxDecoration(
                            color: Colors.white ,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color:  kPrimaryColor)
                        ),
                        child: Text('ANNULER',style: TextStyle(fontFamily: 'Google-Bold',color: kPrimaryColor,fontSize: screenwidth < 700 ? screenheight/55 : 23),)
                    ),
                    onTap: (){
                      setState(() {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Loginpage()));
                      });
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
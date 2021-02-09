import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/credential_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/show_flushbar.dart';
import 'package:ujap/globals/widgets/show_loader.dart';
import 'package:ujap/pages/credentials_sub_pages/enter_code.dart';

class Forgot_password extends StatefulWidget {
  @override
  _Forgot_passwordState createState() => _Forgot_passwordState();
}

class _Forgot_passwordState extends State<Forgot_password> {
  var _useremail;
  bool keyboardvisible = false;
  TextEditingController usernamecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();

  _send_userEmail()async{
    showloader(context);
    var response = await http.post('https://ujap.checkmy.dev/api/client/forgot-password',
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $accesstoken",
          "Accept": "application/json"
        },
        body: {
          'email': _useremail.toString(),
        }
    );
    var jsonData = json.decode(response.body);
    var _events_clients = jsonData;
    if (response.statusCode == 200){
      setState(() {
        Navigator.of(context).pop(null);
        print(jsonData['reset_token'].toString().toString());
        resetCode = jsonData['code'].toString();
        forgotPassword = jsonData['reset_token'].toString();
        Navigator.push(context, PageTransition(child: Reset_code(
        ),type: PageTransitionType.leftToRight,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
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
    KeyboardVisibility.onChange.listen((bool visible) {
      keyboardvisible = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: Container(
        width: screenwidth,
        height: screenheight,
        child: Stack(
          children: [
            Container(
              width: screenwidth,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: screenwidth,
                      height: screenheight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: screenwidth/5,
                          ),
                          Container(
                            width: screenwidth,
                            height: screenheight/8,
                            child: Center(
                                child: Container(
                                  width: screenwidth < 700 ? screenwidth/5 : screenwidth/7,
                                  height: screenheight,
                                  child: Image(
                                    color: Color.fromRGBO(5, 93, 157, 0.9) ,
                                    image: AssetImage('assets/login_icons/forgot_password_icon.png'),
                                  ),
                                )
                            ),
                          ),
                          SizedBox(
                            height: screenwidth/20,
                          ),
                          Container(
                            width: screenwidth,
                            padding: EdgeInsets.symmetric(horizontal: screenwidth/10),
                            child: Text('Nous avons juste besoin de votre adresse e-mail pour vous envoyer la réinitialisation de votre mot de passe!',style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black54,fontSize: screenwidth < 700 ? screenheight/55 : 23),
                              textAlign: TextAlign.center,
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
                                  hintText: 'Adresse e-mail',
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
                                    color: Color.fromRGBO(5, 93, 157, 0.9) ,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(color:  Color.fromRGBO(5, 93, 157, 0.9))
                                ),
                                child: Text('envoyer'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Colors.white,fontSize: screenwidth < 700 ? screenheight/55 : 23),)
                            ),
                            onTap: (){
                              setState(() {
                                if (usernamecontroller.text.isEmpty){
                                  showflushbar("",'Veuillez écrire votre adresse e-mail, elle est obligatoire!', context);
                                }
                                else{
                                  _send_userEmail();
                                }
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: screenwidth,
              height: screenheight,
              padding: EdgeInsets.all(20),
              alignment: Alignment.topLeft,
              child: SafeArea(
                child: GestureDetector(
                  child: Container(
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(1000.0)
                      ),
                      padding: EdgeInsets.all(3),
                      child: Icon(Icons.arrow_back_rounded,color: Colors.white,size: screenwidth/12,)),
                  onTap: (){
                    Navigator.of(context).pop(null);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
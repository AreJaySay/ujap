import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/credential_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/show_flushbar.dart';
import 'package:ujap/globals/widgets/show_loader.dart';
import 'package:http/http.dart' as http;
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/pages/credentials_sub_pages/enter_new_credentials.dart';
import 'package:ujap/pages/credentials_sub_pages/loginpage.dart';

class Reset_code extends StatefulWidget {
  @override
  _Reset_codeState createState() => _Reset_codeState();
}

class _Reset_codeState extends State<Reset_code> {
  var _useremail;
  bool keyboardvisible = false;
  TextEditingController usernamecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  var _resetCode = "";
  bool _expiredCode = false;

  _sendCode()async{
    showloader(context);
    var response = await http.get(Uri.parse('https://ujap.checkmy.dev/api/client/check-code?code=${usernamecontroller.text.toString()}'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $accesstoken",
        "Accept": "application/json"
      },
    );
    var jsonData = json.decode(response.body);
    var _events_clients = jsonData;
    if (_events_clients['result'].toString() != 'false'){
      setState(() {
        Navigator.of(context).pop(null);
        print(response.statusCode.toString());
        _resetCode = jsonData['code'].toString();
        Navigator.push(context, PageTransition(child: Enter_new_credentials(
        ),type: PageTransitionType.rightToLeft,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
      });
    }
    else
    {
      Navigator.of(context).pop(null);
      showflushbar("",'Code de réinitialisation non valide, veuillez saisir correctement le code!', context);
    }
  }

  Stream codeExpired()async*{
    setState(() {
        Future.delayed(const Duration(minutes: 15), () {
          _expiredCode = true;
        });
      _expiredCode = _expiredCode;
    });
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
    return StreamBuilder<Object>(
      stream: codeExpired(),
      builder: (context, snapshot) {
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
                        height:screenwidth/10,
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
                                image: AssetImage('assets/login_icons/send_code.png'),
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
                            Text('Le code a été envoyé à votre compte Gmail, veuillez vérifier votre boîte de réception et entrer ici le code.',style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black54,fontSize: screenwidth < 700 ? screenheight/55 : 23),
                              textAlign: TextAlign.center,
                            ),
                            // SizedBox(
                            //   height : 5,
                            // ),
                            // !_expiredCode ? Container() :  Text('Le code a expiré, cliquez sur le bouton Retour en haut pour générer un nouveau code de récupération!',style: TextStyle(fontFamily: 'Google-Medium',color: Colors.red[900],fontSize: screenwidth < 700 ? screenheight/75 : 23),
                            //   textAlign: TextAlign.center,
                            // ),
                            // SizedBox(
                            //   height: screenwidth/20,
                            // ),
                            // Text('REMARQUE: le code expirera après 15 minutes!',style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black54,fontSize: screenwidth < 700 ? screenheight/70 : 23),
                            //   textAlign: TextAlign.center,
                            // ),
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
                              hintText: 'Entrez le code',
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
                      _expiredCode ? Container() : Builder(
                         builder:(context)=> GestureDetector(
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
                                  showflushbar("",'Veuillez écrire le code de réinitialisation, il est obligatoire!', context);
                                }
                                else{
                                  _sendCode();
                                }
                              });
                            },
                          ),
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
    );
  }
}
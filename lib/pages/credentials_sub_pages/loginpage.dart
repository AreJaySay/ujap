import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujap/controllers/login_controller.dart';
import 'package:ujap/globals/variables/credential_variables.dart';

import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/curve_containers.dart';
import 'package:ujap/globals/widgets/show_flushbar.dart';
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/pages/credentials_sub_pages/confirm_close.dart';
import 'package:ujap/pages/credentials_sub_pages/forgot_password.dart';


TextEditingController usernamecontroller = new TextEditingController();
TextEditingController passwordcontroller = new TextEditingController();

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}


class _LoginpageState extends State<Loginpage> {
  var showpassword;
  bool showpassword_or_not = true;
  var _userpassword;
  bool keyboardvisible = false;

  bool _showemailsHistory = false;

  Stream show_confim()async*{
   setState(() {
     show_confirm = show_confirm;
   });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showpassword = null;
    showpassword_or_not = true;
    KeyboardVisibility.onChange.listen((bool visible) {
        keyboardvisible = visible;
        _showemailsHistory = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Stack(
      children: [
        StreamBuilder(
          stream: show_confim(),
          builder: (context, snapshot) {
            return Scaffold(
              body: GestureDetector(
                child: Container(
                  width: screenwidth,
                  height: screenheight,
                  child: ListView(
                    padding: EdgeInsets.all(0),
                    children: [
                      AnimatedContainer(
                        width: screenwidth,
                        height:  keyboardvisible ? 0 : screenwidth < 700 ?  screenheight/3: 450.0,
                        duration: Duration(milliseconds: 500),
//                  height: screenwidth < 700 ? 320.0 : 450.0,
                        decoration: BoxDecoration(
                          color: Colors.white,

                        ),
                        child: Stack(
                          children: [
                            Container(
                                width: screenwidth,
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 2.0),
                                    child:ClipPath(
                                      clipper: CurvedBottom(),
                                      child: Container(
                                        width: screenwidth,
                                        height: screenwidth < 700 ? screenheight/2.5 : 450.0,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover ,
                                                image: AssetImage("assets/login_icons/background.png"))
                                        ),
                                      ),

                                    ))),
                            Container(
                              width: screenwidth,
                              margin: EdgeInsets.only(bottom: screenwidth < 700 ? 30 : 20),
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: screenwidth < 700 ? screenwidth/2.7 : screenwidth/3.5,
                                height: screenwidth < 700 ? screenwidth/2.7 : screenwidth/3.5,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/logo.png')



                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        height:  keyboardvisible ? screenheight/30 : 0,
                        duration: Duration(milliseconds: 500),
                      ),
                      Container(
                        width: screenwidth,
                        padding: EdgeInsets.symmetric(vertical: screenwidth < 700 ? screenheight/20 : screenheight/15),
                        child: Column(
                          children: [
                            Container(
                              child: Text('Bon Retour!',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/27 : screenheight/25,fontFamily: 'Google-Medium'),),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? screenwidth/6 : screenwidth/3.5),
                              child: Text('Nous avons organisé tout pour vous, heureux que vous soyez de retour!',style: TextStyle(fontFamily: 'Google-Regular',color: Colors.grey[700],fontSize: screenwidth < 700 ? 12 : 20),textAlign: TextAlign.center,),
                            ),
                            SizedBox(
                              height: screenwidth < 700 ? 30 : 50,
                            ),
                            Container(
                              height: screenheight/3.7,
                              width: screenwidth,
                              padding: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? screenheight/20 : screenheight/15),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: screenheight/15,
                                        width: screenwidth,
                                        child: TextField(
                                          autofocus: true,
                                          controller: usernamecontroller,
                                          style: TextStyle(fontFamily: 'Google-Medium',color: Colors.black.withOpacity(0.7),fontSize: screenwidth < 700 ? screenheight/55 : 20),
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(horizontal:  screenwidth < 700 ? 15 : 25,vertical: screenwidth < 700 ? 0 : 20),
                                              hintText: 'EMAIL',
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
                                          onTap: (){
                                            setState(() {
                                              _showemailsHistory = true;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                          height: screenwidth < 700 ?  screenwidth/15 : 40),
                                      Container(
                                        height: screenheight/15,
                                        width: screenwidth,
                                        child: TextField(
                                          autofocus: true,
                                          controller: passwordcontroller,
                                          style: TextStyle(fontFamily: 'Google-Medium',color: Colors.black.withOpacity(0.7),fontSize: screenwidth < 700 ? screenheight/55 : 20),
                                          obscureText: showpassword_or_not,
                                          decoration: InputDecoration(
                                              suffixIcon: _userpassword == null || _userpassword == "" ?
                                              Container(
                                                width:  20,
                                                height: 20,
                                                margin: EdgeInsets.all( screenwidth < 700 ? 12 : 5),
                                              )
                                                  : Container(
                                                child: showpassword_or_not == true  ? GestureDetector(
                                                  child: Container(
                                                    width:  20,
                                                    height: 20,
                                                    margin: EdgeInsets.all( screenwidth < 700 ? 13 : 5),
                                                    child: Image(
                                                        color: Colors.grey[500],
                                                        image: AssetImage('assets/login_icons/hidepassword.png')
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    setState(() {
                                                      showpassword_or_not = false;
                                                    });
                                                  },
                                                ) :  GestureDetector(
                                                  child: Container(
                                                    width:  20,
                                                    height: 20,
                                                    margin: EdgeInsets.all( screenwidth < 700 ? 8 : 5),
                                                    child: Image(
                                                        color: Colors.grey[500],
                                                        image: AssetImage('assets/login_icons/showpassword.png')
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    setState(() {
                                                      showpassword_or_not = true;

                                                    });
                                                  },
                                                ),
                                              ),
                                              contentPadding: EdgeInsets.symmetric(horizontal:  screenwidth < 700 ? 15 : 25,vertical: screenwidth < 700 ? 0 : 20),
                                              hintText: 'Mot de passe'.toUpperCase(),
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
                                              _userpassword = text;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                          height: screenwidth < 700 ?  screenwidth/20 : 40),
                                      GestureDetector(
                                        child: Container(
                                          width: screenwidth,
                                          child: Text('Mot de passe oublié',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/65 : 23,color: Colors.grey[350],fontFamily: 'Google-Medium'),),
                                        ),
                                        onTap: (){
                                          Navigator.push(context, PageTransition(child: Forgot_password(
                                          ),type: PageTransitionType.rightToLeft,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
                                        },
                                      ),
                                      SizedBox(
                                          height: screenwidth < 700 ?  screenwidth/50 : 40),
                                    ],
                                  ),
                                  !_showemailsHistory ? Container () : emailsHistory == null ? Container() :
                                  Container(
                                    height: screenheight,
                                    width: screenwidth,
                                    margin: EdgeInsets.only(top: screenheight/15,bottom: screenheight/40),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.8),
                                          spreadRadius: 1,
                                          blurRadius: 5,
                                          offset: Offset(0, 2), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      height: screenheight,
                                      width: screenwidth,
                                      color: Colors.white,
                                      child: ListView.builder(
                                        padding: EdgeInsets.all(0),
                                        itemCount: emailsHistory.length,
                                        itemBuilder: (context, index){
                                          return FlatButton(
                                            child: Container(
                                              width: screenwidth,
                                              alignment: Alignment.centerLeft,
                                              child: Text(emailsHistory[index].toString(),style: TextStyle(fontSize: screenheight/55,color: Colors.black87,fontFamily: 'Google-Medium'),),
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                usernamecontroller.text = emailsHistory[index].toString();
                                                _showemailsHistory = false;
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: screenheight/16,
                              width: screenwidth,
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 30 : 50),
                              decoration: BoxDecoration(
                                  color:  Color.fromRGBO(1, 81, 147, 0.9),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Builder(
                                builder: (context)=> FlatButton(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text('Connexion',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/50 : 30,color: Colors.white,fontFamily: 'Google-Medium'),)),
                                  onPressed: (){
                                    setState(() {
                                      List<String> _firstcommit = [];
                                      if(usernamecontroller.text.isNotEmpty && passwordcontroller.text.isNotEmpty){
                                        login(usernamecontroller.text, passwordcontroller.text,context,null);
                                        _firstcommit.add(usernamecontroller.text.toString());
                                        emailsHistory = _firstcommit;
                                        print(emailsHistory.toString());
                                      }
                                      else if (usernamecontroller.text.isNotEmpty && passwordcontroller.text.isEmpty){
                                        showSnackBar(context, 'Le mot de passe est vide. veuillez remplir pour continuer!');

                                      }
                                      else if (usernamecontroller.text.isEmpty && passwordcontroller.text.isNotEmpty){
                                        showSnackBar(context, "L'e-mail est vide. veuillez remplir pour continuer!");

                                      }
                                      else
                                      {
                                        showSnackBar(context, "L'email et le mot de passe sont vides!");
                                      }
                                    });
                                  },

                                ),
                              ),
                            ),
                            SizedBox(
                                height: screenwidth < 700 ?  screenwidth/30 : 40),
                            GestureDetector(
                              child: Container(
                                height: screenheight/16,
                                width: screenwidth,
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 30 : 50),
                                child: Text('Annuler',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/50 : 30,color: Colors.grey[600],fontFamily: 'Google-Medium'),),
                              ),
                              onTap: (){
                                setState(() {
                                  show_confirm = true;
                                });
                              },
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: (){
                  setState(() {
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    _showemailsHistory = false;
                  });
                },
              ),
            );
          }
        ),
        show_confirm ? Confirm_close() : Container()
      ],
    );
  }
}
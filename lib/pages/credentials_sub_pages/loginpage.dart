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


class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}


class _LoginpageState extends State<Loginpage> {
  final TextEditingController _user = new TextEditingController();
  final TextEditingController _pass = new TextEditingController();
  bool _passVisible = false;
  bool _keyboardVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    KeyboardVisibilityController().onChange.listen((event) {
      Future.delayed(Duration(milliseconds:  100), () {
        setState(() {
          _keyboardVisible = event;
        });
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _user.dispose();
    _pass.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Scaffold(
        body: Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: screenwidth,
              child: _keyboardVisible ? Container() : Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                  child:ClipPath(
                    clipper: CurvedBottom(),
                    child: Container(
                      width: screenwidth,
                      height: 200,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover ,
                              image: AssetImage("assets/login_icons/background.png"))
                      ),
                      child: Container(
                        width: screenwidth,
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/logo_shadow.png')
                            ),
                          ),
                        ),
                      ),
                    ),
                  ))),
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _keyboardVisible ? Container() :  Align(
                      alignment: Alignment.center,
                      child: Text('Bon Retour!',style: TextStyle(fontSize: 27,fontFamily: 'Google-Medium'),),
                    ),
                    _keyboardVisible ? Container() :  SizedBox(
                      height: 5,
                    ),
                    _keyboardVisible ? Container() : Text('Nous avons organisé tout pour vous, heureux que vous soyez de retour!',style: TextStyle(fontFamily: 'Google-Regular',color: Colors.grey[700]),textAlign: TextAlign.center,),
                    SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: _user,
                      style: TextStyle(fontFamily: 'Google-Regular',),
                      decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(fontFamily: 'Google-Regular',color: Colors.grey),
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
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: _pass,
                      obscureText: _passVisible,
                      style: TextStyle(fontFamily: 'Google-Regular',),
                      decoration: InputDecoration(
                          hintText: 'Mot de passe ',
                          hintStyle: TextStyle(fontFamily: 'Google-Regular',color: Colors.grey),
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Color.fromRGBO(5, 93, 157, 0.2),)
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey[200])
                          ),
                        suffixIcon: IconButton(
                          icon: !_passVisible ? Image(
                              width: 23,
                              color: Colors.grey[500],
                              image: AssetImage('assets/login_icons/showpassword.png')
                          ) : Image(
                              width: 22,
                              color: Colors.grey[500],
                              image: AssetImage('assets/login_icons/hidepassword.png')
                          ),
                          onPressed: (){
                            setState((){
                              _passVisible = !_passVisible;
                            });
                          },
                        )
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      child: Text('Mot de passe oublié',style: TextStyle(color: kPrimaryColor.withOpacity(0.6),fontFamily: 'Google-Medium'),),
                      onTap: (){
                        Navigator.push(context, PageTransition(child: Forgot_password(
                        ),type: PageTransitionType.rightToLeft,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
                      },
                    ),
                    Spacer(),
                    Container(
                      height: 55,
                      width: screenwidth,
                      decoration: BoxDecoration(
                          color:  Color.fromRGBO(1, 81, 147, 0.9),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Builder(
                        builder: (context)=> InkWell(
                          child: Container(
                              alignment: Alignment.center,
                              child: Text('Connexion',style: TextStyle(color: Colors.white,fontFamily: 'Google-Medium'),)),
                          onTap: (){
                            setState(() {
                              List<String> _firstcommit = [];
                              if(_user.text.isNotEmpty && _pass.text.isNotEmpty){
                                login(username: _user.text, password: _pass.text, context: context,loader: null,profileinformation: false);
                                _firstcommit.add(_user.text.toString());
                                emailsHistory = _firstcommit;
                              }
                              else if (_user.text.isNotEmpty && _pass.text.isEmpty){
                                showSnackBar(context, 'Le mot de passe est vide. veuillez remplir pour continuer!');
                              }
                              else if (_user.text.isEmpty && _pass.text.isNotEmpty){
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
                      height: 15,
                    ),
                    GestureDetector(
                      child: Container(
                        height: 55,
                        width: screenwidth,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 30 : 50),
                        child: Text('Annuler',style: TextStyle(color: Colors.grey[600],fontFamily: 'Google-Medium'),),
                      ),
                      onTap: (){
                        setState(() {
                          show_confirm = true;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
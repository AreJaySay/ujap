import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/variables/profile_variables.dart';
import 'package:ujap/globals/widgets/curve_containers.dart';
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/services/api.dart';
import '../../globals/variables/other_variables.dart';

class UpdatePassword extends StatefulWidget {
  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  TextEditingController clientpassword = new TextEditingController();
  TextEditingController currentpassword = new TextEditingController();
  TextEditingController newpassword = new TextEditingController();
  bool showpassword_or_not = true;
  var _currentPassword = "";
  var _newPassword = "";
  var _confirmPassword = "";
  bool _changepassword = false;
  bool keyboardvisible = false;


  List _textfieldsName = [
    'Mot de passe actuel',
    'Nouveau mot de passe',
    'Confirmation du mot de passe'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passwordSuccess = false;
    KeyboardVisibility.onChange.listen((bool visible) {
        keyboardvisible = visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        width: screenwidth,
        height: screenheight,
        child: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    width: screenwidth,
                    height: screenwidth < 700
                        ? screenheight / 2.01
                        : screenheight / 2.2,
                    decoration: BoxDecoration(),
                    child: Stack(
                      children: [
                        Container(
                            width: screenwidth,
                            child: Padding(
                                padding:
                                const EdgeInsets.only(bottom: 2.0),
                                child: ClipPath(
                                  clipper: CurvedBottom(),
                                  child: Container(
                                    margin: EdgeInsets.all(40),
                                    width:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    height: screenwidth < 700
                                        ? screenheight / 2.3
                                        : screenheight / 2.7,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                          AssetImage(
                                              "assets/logo.png"),
                                        )),
                                  ),
                                ))),
                        Container(
                          width: screenwidth,
                          child: Padding(
                              padding:
                              const EdgeInsets.only(bottom: 2.0),
                              child: ClipPath(
                                clipper: CurvedTop(),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.topLeft,
                                  color:
                                  Color.fromRGBO(5, 93, 157, 0.9),
                                  width:
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  height: screenwidth < 700
                                      ? screenheight / 2.2
                                      : screenheight / 2.4,
                                ),
                              )),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                width: double.infinity,
                height:  screenheight/1.3,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Container(
                  width: screenwidth/1.2,
                  height:  screenheight/1.3,
                  padding: EdgeInsets.symmetric(vertical:  keyboardvisible ? 0 : 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      keyboardvisible ? Container() :  Container(
                        width: screenwidth,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(1000.0)
                              ),
                              padding: EdgeInsets.all(screenwidth < 700 ? 2 : 3),
                              child: Icon(Icons.arrow_back_rounded,color: Colors.white,size: screenwidth < 700 ? screenwidth/12 : screenwidth/18,)),
                          onTap: (){
                            setState(() {
                              Navigator.of(context).pop(null);
                            });
                          },
                        ),
                      ),
                      keyboardvisible ? Container() :   SizedBox(
                        height: screenwidth/20,
                      ),
                      Container(
                        child: Column(
                          children: [
                            keyboardvisible ? Container() : Container(
                                width: screenwidth,
                                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                                alignment: Alignment.centerLeft,
                                child: Text('Mise à jour du mot de passe'.toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/40 : 30,color: Colors.black87.withOpacity(0.7),fontFamily: 'Google-Bold',decoration: TextDecoration.none),)
                            ),
                            keyboardvisible ? Container() : SizedBox(
                              height: screenwidth/20,
                            ),
                            Container(
                              width: double.infinity,
                              height: screenheight/2.5,
                              child: ListView.builder(
                                padding: EdgeInsets.all(0),
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _textfieldsName.length,
                                itemBuilder: (context, index){
                                  return Container(
                                    width: screenwidth,
                                    margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(_textfieldsName[index].toString(),style: TextStyle(color: Colors.black54,fontFamily: 'Google-Medium',fontSize: screenwidth < 700 ? screenheight/55 : 22),),
                                        SizedBox(
                                          height: screenheight/80,
                                        ),
                                        TextField(
                                          obscureText : true,
                                          style: TextStyle(fontFamily: 'Google-Medium',fontSize: screenwidth < 700 ? screenheight/55 : 22,color: Colors.black87.withOpacity(0.7)),
                                          decoration: InputDecoration(
                                              hintText: index == 0 ? 'Insérez votre mot de passe actuel'.toString().toLowerCase() : index == 1 ? 'Insérez le nouveau mot de passe' : 'Réinsérez votre nouveau mot de passe',
                                              hintStyle: TextStyle(color: Colors.grey[300],fontFamily: 'Google-Regular',fontSize: screenwidth < 700 ? screenheight/60 : 22),
                                              contentPadding: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 20 : 40,vertical: screenwidth < 700 ? 0 : 20),
                                              border: InputBorder.none,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(color: Colors.grey[300]),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(color: Colors.blue[200]),

                                              )
                                          ),
                                          onChanged: (text){
                                            setState(() {
                                              if (index == 0){
                                                _currentPassword = text;
                                              }
                                              else if (index == 1){
                                                _newPassword = text;
                                              }
                                              else{
                                                _confirmPassword = text;
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: screenwidth/30,
                            ),
                            Builder(
                              builder: (context)=>
                                GestureDetector(
                                  child: Container(
                                    height: screenwidth < 700 ? screenwidth/8 : screenwidth/13,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    margin: EdgeInsets.symmetric(horizontal: 30),
                                    child: passwordSuccess ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: 25,
                                          height: 25,
                                          child: CircularProgressIndicator(),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text('En traitement ...',style: TextStyle(color: Colors.white,fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/55 : 22),),
                                      ],
                                    ) : Text('Changer mot de passe'.toUpperCase(),style: TextStyle(color: Colors.white,fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/55 : 22),),
                                  ),
                                  onTap: (){
                                    setState(() {
                                      if (_currentPassword.toString() == "" || _newPassword.toString() == "" || _confirmPassword.toString() == ""){
                                        showSnackBar(context, 'Tous les champs sont requis. Veuillez vérifier!');
                                      }
                                      else if (_currentPassword.toString() != pass.toString()){
                                        showSnackBar(context, 'Le mot de passe actuel est incorrect. Veuillez réessayer!');
                                      }
                                      else if (_newPassword.toString() != _confirmPassword.toString()){
                                        showSnackBar(context, 'Le nouveau mot de passe et la confirmation ne correspondent pas. Veuillez vérifier!');
                                      }
                                      else{
                                        change_Password = _confirmPassword.toString();
                                        passwordSuccess = true;
                                        changePassword(context);
                                      }
                                    });
                                  },
                                ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujap/controllers/login_controller.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/variables/profile_variables.dart';
import 'package:ujap/globals/variables/video.dart';
import 'package:ujap/globals/widgets/curve_containers.dart';
import 'package:ujap/pages/client_profile_page/change_password.dart';
import 'package:ujap/pages/client_profile_page/profile_information.dart';
import 'package:ujap/pages/client_profile_page/update_picture.dart';
import 'package:ujap/pages/client_profile_page/upload_profile_picture.dart';
import 'package:ujap/pages/client_profile_page/view_profile_pict.dart';
import 'package:ujap/pages/credentials_sub_pages/loginpage.dart';
import 'package:ujap/pages/drawer_page.dart';
import 'package:ujap/pages/homepage.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/view_message_images.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/conversation_listener.dart';
import 'package:ujap/services/pushnotification.dart';
import 'package:ujap/services/sample_sqlite.dart';
import 'package:ujap/services/searches/search_service.dart';

import '../../globals/variables/other_variables.dart';
import '../../globals/variables/other_variables.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController clientpassword = new TextEditingController();
  TextEditingController currentpassword = new TextEditingController();
  TextEditingController newpassword = new TextEditingController();
  bool showpassword_or_not = true;
  var _currentPassword = "";
  var _newPassword = "";
  var _confirmPassword = "";


  List _textfieldsName = [
    'Current password',
    'New password',
    'Confirm password'
  ];

//  Stream _profileImage() async* {
//    setState(() {
//      ClientImagefile = ClientImagefile;
//    });
//  }

  _logout()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.clear();
      userdetails = null;
      pass = null;
      user = null;
      accesstoken = null;
    });
    conversationService.updateAll(data: []);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showProfilePict = false;
    if(videoPlayerController != null && chewieController != null && chewieController.isPlaying){
      videoPlayerController.pause();
      chewieController.pause();
    }
    clientpassword.text = pass.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
//      child: StreamBuilder(
//          stream: _profileImage(),
//          builder: (context, snapshot) {
//            return
              child: Scaffold(
                body: Container(
                  width: screenwidth,
                  height: screenheight,
                  child: userdetails == null ? Center(
                    child: Container(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: <Widget>[
                             Container(
                               child: CircularProgressIndicator(
                                 backgroundColor: kPrimaryColor,
                               ),
                             ),
                             SizedBox(
                               height: 10,
                             ),
                             Text('Déconnecter ...', style: TextStyle(
                                 color: Colors.black87.withOpacity(0.5),
                                 fontSize: screenwidth < 700
                                     ? screenheight / 45
                                     : 20,
                                 fontFamily: 'Google-Bold'),)
                           ],
                         ),
                    ),
                  ) : Stack(
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
                                                    AssetImage("assets/new_app_icon.png"),
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
                                            padding: EdgeInsets.all(30),
                                            alignment: Alignment.topLeft,
                                            color:
                                            kPrimaryColor, width: MediaQuery.of(context).size.width,height: screenwidth < 700 ? screenheight / 2.2 : screenheight / 2.4,
                                            child: SafeArea(
                                              child: GestureDetector(
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: kPrimaryColor,
                                                        borderRadius: BorderRadius.circular(1000.0)
                                                    ),
                                                    padding: EdgeInsets.all(screenwidth < 700 ? 2 : 3),
                                                    child: Icon(Icons.arrow_back_rounded,color: Colors.white,size: 26,)),
                                                onTap: (){
                                                  Navigator.pushReplacement(context,PageTransition(child: MainScreen(false),type: PageTransitionType.fade));
                                                },
                                              ),
                                            ),
                                          ),
                                        )),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: screenwidth,
                        height: screenheight,
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: Container(
                                width: screenwidth / 1.2,
                                height: screenheight / 1.5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(
                                                      1000.0),
                                                  border: Border.all(
                                                      color: kPrimaryColor, width: 2)
                                              ),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    width: screenwidth < 700 ? screenwidth/3 : screenwidth/4,
                                                    height: screenwidth < 700 ? screenwidth/3 : screenwidth/4,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(1000.0),
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: userdetails['filename'].toString() == "null" ||  userdetails['filename'].toString() == "" ? AssetImage('assets/messages_icon/no_profile.png') : NetworkImage('https://ujap.checkmy.dev/storage/clients/${userdetails['filename']}')
                                                        )
                                                    ),
                                                  ),
                                                  Container(
                                                    width: screenwidth < 700 ? screenwidth/3 : screenwidth/4,
                                                    height: screenwidth < 700 ? screenwidth/3 : screenwidth/4,
                                                    alignment: AlignmentDirectional
                                                        .bottomEnd,
                                                    child: Container(
                                                      padding: EdgeInsets.all( screenwidth < 700 ? 8 : 13),
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(1000),
                                                          border: Border.all(color: Colors.white, width: 3),
                                                          color: kPrimaryColor
                                                      ),
                                                      child: Icon(Icons.edit, color: Colors.white,size: screenwidth < 700 ? 25 : 30,),
                                                        // onPressed: (){
                                                        //   Navigator.push(context, PageTransition(child: UpdatePicture()));
                                                        // },
                                                      // ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              padding: EdgeInsets.all(5),
                                            ),
                                            onTap: (){
                                              setState(() {
                                                showProfilePict = true;
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            height: screenheight / 50,
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 15),
                                            width: screenwidth,
                                              alignment: Alignment.center,
                                              child: Text(
                                                userdetails['name'].toString()+' '+userdetails['lastname'].toString(),
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: screenwidth < 700
                                                        ? screenheight / 55
                                                        : 20,
                                                    fontFamily: 'Google-Bold'),textAlign: TextAlign.center,)
                                          ),
                                          Container(
                                              child: Text(userdetails['email'].toString(), style: TextStyle(color: Colors.black87.withOpacity(0.6), fontSize: screenwidth < 700 ? screenheight / 75 : 15, fontFamily: 'Google-Medium'),)
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text('Participations'.toUpperCase(), style: TextStyle(color: Colors.black87.withOpacity(0.5), fontSize: screenwidth < 700 ? screenwidth/27 : 25, fontFamily: 'Google-Medium',fontWeight: FontWeight.w700)),
                                    Container(
                                      height: screenwidth/4,
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            width: screenwidth/5,
                                            height: screenheight,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: screenwidth < 700 ? 45 : 70,
                                                  height: screenwidth < 700 ? 45 : 70,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(1000.0),
                                                    border: Border.all(color: kPrimaryColor,width: 2)
                                                  ),
                                                  child: Text(finalMatchAttended == null ? '0' : finalMatchAttended.length.toString(),textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Google-Medium',color: kPrimaryColor,fontSize: screenwidth < 700 ? screenheight/30 : 35),),
                                                ),
                                                Container(
                                                  child: Text('Matchs',textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Google-Medium',color: Colors.black87.withOpacity(0.5),fontSize: screenwidth < 700 ? screenheight/65 : 23),),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: screenwidth/5,
                                            height: screenheight,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: screenwidth < 700 ? 45 : 70,
                                                  height: screenwidth < 700 ? 45 : 70,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(1000.0),
                                                      border: Border.all(color: kPrimaryColor,width: 2)
                                                  ),
                                                  child: Text( finalMeetingAttended == null ? '0' : finalMeetingAttended.length.toString(),textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Google-Medium',color: kPrimaryColor,fontSize: screenwidth < 700 ? screenheight/30 : 35),),
                                                ),
                                                Container(
                                                  child: Text("Réunion",textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Google-Medium',color: Colors.black87.withOpacity(0.5),fontSize: screenwidth < 700 ? screenheight/65 : 23),),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: screenwidth/5,
                                            height: screenheight,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: screenwidth < 700 ? 45 : 70,
                                                  height: screenwidth < 700 ? 45 : 70,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(1000.0),
                                                      border: Border.all(color: kPrimaryColor,width: 2)
                                                  ),
                                                  child: Text( finalEventAttended == null ? '0' : finalEventAttended.length.toString(),textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Google-Medium',color: kPrimaryColor,fontSize: screenwidth < 700 ? screenheight/30 : 35),),
                                                ),
                                                Container(
                                                  child: Text("Événements",textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Google-Medium',color: Colors.black87.withOpacity(0.5),fontSize: screenwidth < 700 ? screenheight/65 : 23),),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
//                              Mettre à jour le profil
                                    Container(
                                      height: screenheight / 20,
                                      width: screenwidth,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: screenwidth < 700 ? 30 : 50),
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(1, 81, 147, 0.9),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: InkWell(
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Text('Changer mot de passe', style: TextStyle(fontSize: screenwidth < 700 ? screenheight / 55 : 25, color: Colors.white, fontFamily: 'Google-Medium'),)),
                                        onTap: () {
                                          setState(() {
                                            Navigator.push(context, PageTransition(child: UpdatePassword(
                                            ),type: PageTransitionType.rightToLeftWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
                                          });
                                        },

                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: screenheight / 20,
                                      width: screenwidth,
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 30 : 50),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: kPrimaryColor)
                                      ),
                                      child: InkWell(
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Text('Déconnexion', style: TextStyle(fontSize: screenwidth < 700 ? screenheight / 55 : 25, color: kPrimaryColor, fontFamily: 'Google-Medium'),)
                                        ),
                                        onTap: () {
                                          setState(() {
                                            PushNotification().unsubscribe(userdetails["id"]);
                                            _logout();
                                            isCollapsed = !isCollapsed;
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(builder: (context) => Loginpage()),
                                                  (Route<dynamic> route) => false,
                                            );
                                            // Navigator.push(context, PageTransition(child: ProfileInformation(
                                            // ),type: PageTransitionType.leftToRightWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
                                          });
                                        },

                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            !showProfilePict ? Container() :
                            GestureDetector(
                              child: Container(
                                width: screenwidth,
                                height: screenheight,
                                alignment: Alignment.bottomCenter,
                                color: Colors.black.withOpacity(0.4),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  width: screenwidth,
                                  height: !showProfilePict ? 0 : screenwidth < 700 ? screenwidth/1.8 : screenwidth/3.5,
                                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20.0),
                                        topLeft: Radius.circular(20.0),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      InkWell(
                                        child: Container(
                                          width: double.infinity,
                                          height: 55,
                                          padding: EdgeInsets.symmetric(vertical: 7),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                  child: Icon(Icons.contacts_outlined),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[300],
                                                  borderRadius: BorderRadius.circular(1000.0)
                                                ),
                                                padding: EdgeInsets.all(7),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text('Voir la photo de profil',style: TextStyle(fontFamily: 'Google-medium',fontSize: screenwidth < 700 ? screenwidth/27 : screenwidth/33,color: Colors.grey[800]),)
                                            ],
                                          ),
                                        ),
                                        onTap: (){
                                          Navigator.push(context, PageTransition(child:  ViewMessageImages(
                                              userdetails['filename'].toString() == "null" || userdetails['filename'].toString() == "" ? "null" : "https://ujap.checkmy.dev/storage/clients/${userdetails['filename']}"
                                          ),type: PageTransitionType.leftToRightWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
                                        },
                                      ),
                                      InkWell(
                                        child: Container(
                                          width: double.infinity,
                                          height: 55,
                                          padding: EdgeInsets.symmetric(vertical: 7),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Icon(Icons.camera_alt),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius: BorderRadius.circular(1000.0)
                                                ),
                                                padding: EdgeInsets.all(7),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text('Prendre une photo',style: TextStyle(fontFamily: 'Google-medium',fontSize:  screenwidth < 700 ? screenwidth/27 : screenwidth/33,color: Colors.grey[800]),)
                                            ],
                                          ),
                                        ),
                                        onTap: (){
                                          setState(() {
                                            Navigator.push(context, PageTransition(child: UpdatePicture(
                                              "TakePhoto","profilepage"
                                            )));
                                          });
                                        },
                                      ),
                                      InkWell(
                                        child: Container(
                                          width: double.infinity,
                                          height: 55,
                                          padding: EdgeInsets.symmetric(vertical: 7),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Icon(Icons.folder_open),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius: BorderRadius.circular(1000.0)
                                                ),
                                                padding: EdgeInsets.all(7),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text('Photo depuis la galerie',style: TextStyle(fontFamily: 'Google-medium',fontSize:  screenwidth < 700 ? screenwidth/27 : screenwidth/33,color: Colors.grey[800]),)
                                            ],
                                          ),
                                        ),
                                        onTap: (){
                                          setState(() {
                                            Navigator.push(context, PageTransition(child: UpdatePicture(
                                                "UploadPhoto","profilepage"
                                            )));
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              onTap: (){
                                setState(() {
                                  showProfilePict = false;
                                });
                              },
                            )
                            // ViewProfilePicture(showProfilePict)
                          ],
                        ),
                      ),
                    ],
                  ),
                )
//            );
//          }
      ),
    );
  }
}

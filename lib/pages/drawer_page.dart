import 'package:flutter/material.dart';
import 'package:ujap/controllers/home.dart';
import 'package:ujap/controllers/login_controller.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/events_sub_pages_variables.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/messages_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/variables/video.dart';
import 'package:ujap/globals/widgets/appbar_icons.dart';
import 'package:ujap/pages/drawer_parameters.dart';
import 'package:ujap/pages/homepage.dart';
import 'package:ujap/services/ad_listener.dart';

var hintText = "";
var searchBy = "";
bool searchPage = false;
bool showparameters = false;


class MainScreen extends StatefulWidget {
  bool showAds = false;
  MainScreen(this.showAds);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  final Duration duration = const Duration(milliseconds: 200);

  AppBar appBar = AppBar();

  int _navBarIndex = 0;
  TabController tabController;
  double borderRadius = 0.0;

  @override
  void initState() {
    super.initState();
    if(videoPlayerController != null && chewieController != null && chewieController.isPlaying){
      videoPlayerController.pause();
      chewieController.pause();
    }
    hideFloatingbutton = false;
    drawerController = AnimationController(vsync: this, duration: duration);
  }

  @override
  void dispose() {
    drawerController.dispose();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {
         editProfile = false;
        _navBarIndex = tabController.index;
      });
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        if (!isCollapsed) {
          setState(() {
            drawerController.reverse();
            borderRadius = 0.0;
            isCollapsed = !isCollapsed;
          });
          return false;
        } else
          return true;
      },
      child: Scaffold(
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        body: Stack(
          children: <Widget>[
            menu(context),
            AnimatedPositioned(
                left: isCollapsed ? 0 : 0.8 * screenwidth,
                right: isCollapsed ? 0 : -0.2 * screenwidth,
                top: isCollapsed ? 0 : screenheight * 0.1,
                bottom: isCollapsed ? 0 : screenheight * 0.1,
                duration: duration,
                curve: Curves.fastOutSlowIn,
                child: Stack(
                  children: <Widget>[
                    dashboard(context),
                   isCollapsed ? Container() : GestureDetector(
                     child: Container(
                        width: screenwidth,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                          border: Border.all(color: kPrimaryColor.withOpacity(0.8))
                        ),
                      ),
                     onTap: (){
                       setState(() {
                         if (isCollapsed) {
                           drawerController.forward();

                           borderRadius = 30.0;
                         } else {
                           drawerController.reverse();

                           borderRadius = 0.0;
                         }

                         isCollapsed = !isCollapsed;
                       });
                     },
                   )
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }

  Widget menu(context) {
    return Scaffold(
      body: Container(
          width: screenwidth,
          height: screenheight,
          child: Stack(
            children: [
              Container(
                width: screenwidth,
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/new_app_icon.png')

                    ),
                  ),
                ),
              ),
              Container(
                width: screenwidth,
                height: screenheight,
                color: Color.fromRGBO(1, 81, 147, 0.9),
                child: Column(
                  children: [
                    SafeArea(
                      child: GestureDetector(
                        child: Container(
                          width: screenwidth,
                          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                          alignment: Alignment.centerLeft,
                          child: Container(
                              width: screenwidth < 700 ? 30 : 40,
                              height: screenwidth < 700 ? 30 : 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.blue.withOpacity(0.3),width: 1)
                              ),
                              child: Icon(Icons.close,size:  screenwidth < 700 ? 23 : 35,color: Colors.white,)),
                        ),
                        onTap: (){
                          setState(() {
                            if (isCollapsed) {
                              drawerController.forward();

                              borderRadius = 30.0;
                            } else {
                              drawerController.reverse();

                              borderRadius = 0.0;
                            }

                            isCollapsed = !isCollapsed;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: screenheight/4,
                      width: screenwidth,
                      child: Column(
                        children: [
                          Expanded(
                            child: FlatButton(
                              child: Container(
                                width: screenwidth,
                                height: screenheight/4,
                                child: Row(
                                  children: [
                                    Container(
                                      width: screenwidth < 700 ? screenwidth/17 : 30,
                                      height: screenwidth < 700 ? screenwidth/17 : 30,
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      child: Image(
                                        color: Colors.white,
                                        image: AssetImage('assets/home_icons/home.png'),
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.symmetric(horizontal: screenwidth/40),
                                        alignment: Alignment.centerLeft,
                                        child: Text('Accueil',style: TextStyle(color: Colors.white,fontSize: screenwidth < 700 ? screenheight/55 : 20,fontFamily: 'Google-Bold'),))
                                  ],
                                ),
                              ),
                              onPressed: (){
                                setState(() {
                                  currentindex = 1;
                                  indexListener.update(data: 1);
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
                                  isCollapsed = !isCollapsed;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              child: Container(
                                width: screenwidth,
                                height: screenheight/4,
                                child: Row(
                                  children: [
                                    Container(
                                      width: screenwidth < 700 ? screenwidth/17 : 30,
                                      height: screenwidth < 700 ? screenwidth/17 : 30,
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      child: Image(
                                        color: Colors.white,
                                        image: AssetImage('assets/home_icons/events.png'),
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.symmetric(horizontal: screenwidth/40),
                                        alignment: Alignment.centerLeft,
                                        child: Text('Évènements et matchs',style: TextStyle(color: Colors.white,fontSize: screenwidth < 700 ? screenheight/55 : 20,fontFamily: 'Google-Bold'),))
                                  ],
                                ),
                              ),
                              onPressed: (){
                                setState(() {
                                  currentindex = 0;
                                  indexListener.update(data: 0);
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
                                  isCollapsed = !isCollapsed;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              child: Container(
                                width: screenwidth,
                                height: screenheight/4,
                                child: Row(
                                  children: [
                                    Container(
                                      width: screenwidth < 700 ? screenwidth/17 : 30,
                                      height: screenwidth < 700 ? screenwidth/17 : 30,
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      child: Image(
                                        color: Colors.white,
                                        image: AssetImage('assets/home_icons/chat.png'),
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.symmetric(horizontal: screenwidth/40),
                                        alignment: Alignment.centerLeft,
                                        child: Text('Messages',style: TextStyle(color: Colors.white,fontSize: screenwidth < 700 ? screenheight/55 : 20,fontFamily: 'Google-Bold'),))
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
                                  currentindex = 2;
                                  indexListener.update(data: 2);
                                  showcalendar = false;
                                  events_filter_open = false;
                                  message_compose_open = false;
                                  view_message_convo = false;
                                  floating_action = false;
                                  attend_pass = "";
                                  showticket = false;
                                  isCollapsed = !isCollapsed;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              child: Container(
                                width: screenwidth,
                                height: screenheight/4,
                                child: Row(
                                  children: [
                                    Container(
                                      width: screenwidth < 700 ? screenwidth/17 : 30,
                                      height: screenwidth < 700 ? screenwidth/17 : 30,
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      child: Image(
                                        color: Colors.white,
                                        image: AssetImage('assets/home_icons/setting.png'),
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.symmetric(horizontal: screenwidth/40),
                                        alignment: Alignment.centerLeft,
                                        child: Text('Paramètres',style: TextStyle(color: Colors.white,fontSize: screenwidth < 700 ? screenheight/55 : 20,fontFamily: 'Google-Bold'),))
                                  ],
                                ),
                              ),
                              onPressed: (){
                                setState(() {
                                  if (showparameters == false){
                                    showparameters = true;
                                  }else{
                                    showparameters = false;
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                   !showparameters ? Container() : Container(
                      width: screenwidth,
                      alignment: Alignment.centerLeft,
                      child: userdetails == null ? Container() : Parameters(),
                    ),
                    // Expanded(
                    //     child: GestureDetector(
                    //       child: Container(
                    //           margin: EdgeInsets.only(bottom: screenheight/20),
                    //           width: screenwidth,
                    //           height: screenheight,
                    //           alignment: Alignment.bottomCenter,
                    //           child: Text('Déconnexion',style: TextStyle(color: Colors.white,fontSize: screenwidth < 700 ? screenheight/50 : 20,fontFamily: 'Google-Bold'),)),
                    //       onTap: (){
                    //         setState(() {
                    //
                    //         });
                    //       },
                    //     )
                    // ),

                  ],
                ),
              ),
            ],
          )

      ),
    );
    // ),
    // )
  }

  Stream showsearchbox()async*{
    setState(() {
      showsearchBox = showsearchBox;
    });
  }

  Widget dashboard(context) {
    return  Material(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      type: MaterialType.card,
      animationDuration: duration,
      color: kPrimaryColor,
      elevation: 8,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        child: StreamBuilder(
          stream: showsearchbox(),
          builder: (context, snapshot) {
            return Scaffold(
              backgroundColor: kPrimaryColor,
              resizeToAvoidBottomInset: true,
//            ),
                body: Stack(
                  children: [
                    Homepage(widget.showAds),
                   SafeArea(
                      child: Container(
                        height: screenheight,
                        width: screenwidth,
                        alignment: Alignment.topCenter,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: screenwidth/25),
                              child: IconButton(
                                  icon: !isCollapsed ? IconButton(
                                    icon: Icon(Icons.menu, color: Colors.white,size: screenwidth < 700 ? screenwidth/17 : 35,),
                                  ) :  AnimatedIcon(
                                    icon: AnimatedIcons.menu_close,
                                    progress: drawerController,
                                    color: Colors.white,size: screenwidth < 700 ? screenwidth/17 : 35,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      adListener.update(false);
                                      if (isCollapsed) {
                                        drawerController.forward();
                                        showparameters = false;
                                        borderRadius = 30.0;
                                      } else {
                                        drawerController.reverse();

                                        borderRadius = 0.0;
                                      }
                                      isCollapsed = !isCollapsed;
                                      if(videoPlayerController != null && chewieController != null && chewieController.isPlaying){
                                        videoPlayerController.pause();
                                        chewieController.pause();
                                      }
                                    });
                                  }),
                            ),
                            Appbar_icons()
                          ],
                        ),
                      ),
                    ),
                    isCollapsed ? Container() :
                    GestureDetector(
                      child: Container(
                        height: screenheight,
                        color: Colors.transparent,
                      ),
                      onTap: (){
                        setState(() {
                          if (isCollapsed) {
                            drawerController.forward();
                            showparameters = false;
                            borderRadius = 30.0;
                          } else {
                            drawerController.reverse();

                            borderRadius = 0.0;
                          }

                          isCollapsed = !isCollapsed;
                        });
                      },
                    )
                  ],
                )
            );
          }
        ),
      ),
    );
  }
}
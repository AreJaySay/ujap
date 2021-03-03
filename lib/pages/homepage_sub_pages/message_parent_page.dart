import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/messages_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/appbar_icons.dart';
import 'package:ujap/globals/widgets/curve_containers.dart';
import 'package:ujap/globals/widgets/show_flushbar.dart';
import 'package:ujap/globals/widgets/show_loader.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/download_pdf%202.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/create_new_group.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/list_of_clients.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/message_list_Data.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/new_message_page.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/slider.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/tabbarView.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/conversation_listener.dart';
import 'package:ujap/services/message_data.dart';
import 'package:ujap/services/searches/messages_service.dart';
import 'package:ujap/services/string_formatter.dart';

final add_channelKey = GlobalKey<ScaffoldState>();
bool isConversation = true;

class Message_homepage extends StatefulWidget {
  @override
  _Message_homepage_homepageState createState() =>
      _Message_homepage_homepageState();
}

class _Message_homepage_homepageState extends State<Message_homepage>
    with TickerProviderStateMixin {
  SlidableController _slidableController;
  Animation<double> _rotationAnimation;
  Color _fabColor = Colors.blue;
  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      _fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }
  PageController _pageController = new PageController();
  ScrollController _scrollControllerMessage = new ScrollController();
  AnimationController _controller;
  Animation<Offset> _offsetFloat;
  bool _contact_listview = false;
  List currentRooms;

  Stream hideSearchBox()async*{
    setState(() {
      showsearchBox = showsearchBox;
    });
  }

  List buttons = [
    {
      "name" : "Private",
      "index" : 0,
    },
    {
      "name" : "Group",
      "index" : 1
    }
  ];
  int selectedButton = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(conversationService.currentConvo == null){
      getPersonMessage();
    }
    _slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _offsetFloat = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(1.0, 0.0))
        .animate(_controller);
    _controller.forward();
    _controller.reverse();
    _scrollControllerMessage.addListener(() {
      print(_scrollControllerMessage.position.maxScrollExtent.toString());
    });

    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
  Stream searchBox()async*{
    setState(() {
      showsearchBox = showsearchBox;
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
                    onWillPop: () => SystemNavigator.pop(),
                    child:  Scaffold(
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
                                                              MediaQuery.of(context).size.width,
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
                                                          color:
                                                              kPrimaryColor,
                                                          width:
                                                              MediaQuery.of(context).size.width,
                                                          height: screenwidth < 700
                                                              ? screenheight / 3
                                                              : screenheight / 2.4,
                                                        ),
                                                      ))),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: screenheight,
                                    width: screenwidth,
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      width: screenwidth,
                                      height: screenwidth < 700 ? screenheight/1.4 : screenheight/1.3,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: screenheight/9),
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: StreamBuilder<List>(
                                          stream: conversationService.convo,
                                          builder: (context, snapshot) {
                                            List<String> locallistChecker = List<String>();
                                            if (snapshot.data != null){
                                              for(var x =0;x<snapshot.data.length;x++){
                                                if (snapshot.data[x]['last_convo'] == null && snapshot.data[x]['members'].length == 2 && snapshot.data[x]['messages'].toString() == "[]"){
                                                }else if(snapshot.data[x]['members'].length > 2 && snapshot.data[x]['messages'].toString().contains('${userdetails['name'].toString()+" "+userdetails['lastname']} a quitté le groupe.')){
                                                }else{
                                                  if (snapshot.data[x]['messages'].toString() != "[]" || snapshot.data[x]['members'].length > 2 && snapshot.data[x]['members'][0]['detail']['id'].toString() == userdetails['id'].toString()){
                                                    locallistChecker.add(snapshot.data[x].toString());
                                                  }
                                                }
                                              }
                                            }

                                            try{
                                              if(snapshot.data.length == 0){
                                                return Column(
                                                  children: [
                                                   StreamBuilder(
                                                     stream: searchBox(),
                                                     builder: (context, snapshots) {
                                                       return Container(
                                                          margin: const EdgeInsets.only(bottom: 10),
                                                          width: double.infinity,
                                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 50,
                                                                height: 50,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.grey[300],
                                                                    borderRadius: BorderRadius.circular(1000),
                                                                    image: DecorationImage(
                                                                      fit: userdetails['filename'].toString() == "null" || userdetails['filename'].toString() == "" ? BoxFit.contain : BoxFit.cover,
                                                                        image: userdetails['filename'].toString() == "null" || userdetails['filename'].toString() == "" ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${userdetails['filename']}")
                                                                    )
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                  child: Text("Messages",
                                                                    style: TextStyle(
                                                                        fontSize: screenwidth > 700 ? screenwidth/30 : screenwidth/20,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.white
                                                                    ),
                                                                  )
                                                              ),
                                                              GestureDetector(
                                                                onTap: (){
                                                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NewMessage()));
                                                                  });
                                                                },
                                                                child: Container(
                                                                  width: 25,
                                                                  height: 25,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors.white54,
                                                                      borderRadius: BorderRadius.circular(1000)
                                                                  ),
                                                                  child: Center(
                                                                    child: Icon(Icons.add,color: kPrimaryColor,size: screenwidth < 700 ? 25: 40,),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                     }
                                                   ),
                                                   Expanded(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                                        ),
                                                        child: Center(
                                                          child: noData("PAS ENCORE DE MESSAGES"),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }
                                              return Container(
                                                  width: double.infinity,
                                                  child: CustomScrollView(
                                                    physics: locallistChecker.length <= 10 ? NeverScrollableScrollPhysics() : null,
                                                    shrinkWrap: true,
                                                    controller: _scrollControllerMessage,
                                                    slivers: [
                                                      SliverToBoxAdapter(
                                                        child: Container(
                                                          margin: const EdgeInsets.only(bottom: 20),
                                                          width: double.infinity,
                                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 50,
                                                                height: 50,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.circular(1000),
                                                                  image: DecorationImage(
                                                                    fit: userdetails['filename'].toString() == "null" || userdetails['filename'].toString() == "" ? BoxFit.contain : BoxFit.cover,
                                                                    image: userdetails['filename'].toString() == "null" || userdetails['filename'].toString() == "" ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${userdetails['filename']}")
                                                                  )
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                  child: Text("Messages",
                                                                    style: TextStyle(
                                                                      fontSize: screenwidth > 700 ? screenwidth/30 : screenwidth/20,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.white
                                                                    ),
                                                                )
                                                              ),
                                                              GestureDetector(
                                                                onTap: ()=>Navigator.push(context, PageTransition(child: NewMessage(), type: PageTransitionType.leftToRightWithFade)),
                                                                child: Container(
                                                                  width: screenwidth < 700 ? 30 : 40,
                                                                  height: screenwidth < 700 ? 30 : 40,
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.white54,
                                                                    borderRadius: BorderRadius.circular(1000)
                                                                  ),
                                                                  child: Center(
                                                                    child: Icon(Icons.add,color: kPrimaryColor,size: screenwidth < 700 ? 30 : 40,),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                       if(snapshot.data.length > 0)...{
                                                         SliverList(
                                                           delegate: SliverChildListDelegate(
                                                               [
                                                                   Stack(
                                                                     children: [
                                                                       Container(
                                                                         decoration: BoxDecoration(
                                                                             color: Colors.white,
                                                                             borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                                                         ),
                                                                         child: noData("PAS ENCORE DE MESSAGES"),
                                                                         padding: EdgeInsets.symmetric(vertical: screenwidth/2),
                                                                       ),
                                                                       Container(
                                                                         color: Colors.white,
                                                                         height: screenheight,
                                                                         child: Column(
                                                                           children: [
                                                                             for(var x =0;x<snapshot.data.length;x++)...{
                                                                               if (snapshot.data[x]['last_convo'] == null && snapshot.data[x]['members'].length == 2 && snapshot.data[x]['messages'].toString() == "[]")...{

                                                                               }else if(snapshot.data[x]['members'].length > 2 && snapshot.data[x]['messages'].toString().contains('${userdetails['name'].toString()+" "+userdetails['lastname']} a quitté le groupe.'))...{

                                                                               }else...{
                                                                                 if (snapshot.data[x]['messages'].toString() != "[]" || snapshot.data[x]['members'].length > 2 && snapshot.data[x]['members'][0]['detail']['id'].toString() == userdetails['id'].toString())...{
                                                                                   MySlider(
                                                                                     id: snapshot.data[x]['id'],
                                                                                     index: x,
                                                                                     data: snapshot.data[x],
                                                                                     slidableController: _slidableController,
                                                                                   ),
                                                                                 }
                                                                               }
                                                                             }
                                                                           ],
                                                                         ),
                                                                       ),
                                                                     ],
                                                                   )
                                                               ]
                                                           ),
                                                         )
                                                       }else...{
                                                         SliverToBoxAdapter(
                                                           child: Container(
                                                             width: double.infinity,
                                                             height: screenheight - 120,
                                                             color: Colors.white54,
                                                           ),
                                                         )
                                                       }
                                                    ],
                                                  )
                                              );
                                            }catch(e){
                                              return Center(
                                                child: Container(
                                                  width: 50,
                                                  height: 50,
                                                  child: CircularProgressIndicator(
                                                  ),
                                                )
                                              );
                                            }
                                          },
                                        ),
                                        )
                                      ],
                                    )
                                  ),
                                ],
                              ),
                            )

                    ),
                  );


  }
  ImageProvider chatImage(List members){
    if(members.length > 2 || members.length == 0){
      return AssetImage("assets/new_app_icon.png");
    }else if(members.length == 1 || members.length == 0){
      if(members[0]['detail']['filename'].toString() == 'null')
      {
        return AssetImage("assets/messages_icon/no_profile.png");
      }
      return NetworkImage("http://ujap.checkmy.dev/storage/clients/${members[0]['detail']['filename']}");
    }else{
      if(members[1] == null){
        if(members[0]['detail']['filename'].toString() == 'null')
        {
          return AssetImage("assets/messages_icon/no_profile.png");
        }
        return NetworkImage("http://ujap.checkmy.dev/storage/clients/${members[0]['detail']['filename']}");
      }
      if(members[0]['client_id'] == userdetails['id']){
        if(members[1]['detail']['filename'].toString() == 'null'){
          return AssetImage("assets/messages_icon/no_profile.png");
        }
        return NetworkImage("http://ujap.checkmy.dev/storage/clients/${members[1]['detail']['filename']}");
      }else{
        if(members[0]['detail']['filename'].toString() == 'null'){
          return AssetImage("assets/messages_icon/no_profile.png");
        }
        return NetworkImage("http://ujap.checkmy.dev/storage/clients/${members[0]['detail']['filename']}");
      }
    }
  }
  tap(int index){
    setState(() {
      selectedButton = index;
    });
//    _pageController.animateToPage(index, duration: Duration(milliseconds: 600), curve: Curves.linear);
  }
  String contactName(List members, name){
    if(members.length > 2){
      if(name == "ec0fc0100c4fc1ce4eea230c3dc10360"){
        List names = [];
        for(var member in members){
          names.add(member['detail']['name']);
        }
        return names.join(',');
      }
      return name;
    }else if(members.length == 1 || members.length == 0){
      return "Juste toi";
    }else{
      if(members[1] == null){
        return "Juste toi";
      }
      if(members[0]['client_id'] == userdetails['id']){
        return members[1]['detail']['name'];
      }
      return members[0]['detail']['name'];
    }
  }
}

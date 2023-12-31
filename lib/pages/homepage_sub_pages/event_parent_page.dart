import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/events_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/appbar_icons.dart';
import 'package:ujap/globals/widgets/curve_containers.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/events_list_data.dart';
import 'package:http/http.dart' as http;

import 'event_children/filter_events.dart';

class Event_parent extends StatefulWidget {
  @override
  _Event_parentState createState() => _Event_parentState();
}

class _Event_parentState extends State<Event_parent> {

  getEvents()async{
    var response = await http.get(Uri.parse('https://ujap.checkmy.dev/api/client/events'),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $accesstoken",
          "Accept": "application/json"
        }
    );
    var _localevents =  json.decode(response.body);
    if (response.statusCode == 200){
      List _events = _localevents;
        _events.sort((a, b) {
          return a['sched_date'].toLowerCase().compareTo(b['sched_date'].toLowerCase());
      });

    }
    else
    {

    }
  }

  Stream hideTop()async*{
    setState(() {
      hideFloatingbutton = hideFloatingbutton;
    });
  }

  @override
  void initState() {
    super.initState();
    getEvents();
    searchbox_filter = "";
    searchfilter.text = "";
    view_data = "";
    convertedDate_filter = 0;
    convertedDate_filter_to = 99999999999;
    status_data = "";
    hideFloatingbutton = false;
    showCloseButton = false;
  }

  @override
  Widget build(BuildContext context) {
          return Scaffold(
              body: Container(
                width: screenwidth,
                height: screenheight,
                color: Colors.grey[200],
                child: Stack(
                  children: [
                    Container(
                      width: screenwidth,
                      height: screenwidth < 700 ? screenheight/2 : screenheight/2.2,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: screenwidth,
                            margin: EdgeInsets.only(top: 10),
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child:ClipPath(
                                    clipper: CurvedBottom(),
                                    child: Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      height: screenwidth < 700 ? screenheight/2.5 :   screenheight/1,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage("assets/logo_shadow.png"),

                                          )
                                      ),


                                    ))),
                          ),
                          Container(
                              width: screenwidth,
                              child: Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child:ClipPath(
                                    clipper: CurvedTop(),
                                    child: Container(
                                      color: kPrimaryColor,
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      height: screenwidth < 700 ? screenheight/3: screenheight/2.4,
                                    ),

                                  ))),

                        ],
                      ),
                    ),
                    Container(
                      width: screenwidth,
                      height: screenheight,
                      color: Colors.grey[200],
                      margin: EdgeInsets.symmetric(vertical: screenwidth < 700 ? screenheight/3.3 : screenheight/2.5),
                    ),
                    Container(
                      width: screenwidth,
                      height: screenheight,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child:  Events_listview(),
                    ),
                    StreamBuilder(
                      stream: hideTop(),
                      builder: (context, snapshot) {
                        return Container(
                          width: screenwidth,
                          height: screenheight,
                          alignment: Alignment.topCenter,
                          child:  Container(
                            padding: EdgeInsets.only(left: 20,right: 10),
                            width: screenwidth,
                            margin: EdgeInsets.only(top: screenwidth < 700 ? screenheight/9 :  screenheight/11),
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    child: Text('Historique',style: TextStyle(fontFamily: 'Google-Bold',color: !history_eventsmatches ? Colors.white.withOpacity(0.3) :  Colors.white),),
                                  ),
                                  onTap: (){
                                    setState(() {
                                      history_eventsmatches = true;
                                    });
                                  },
                                ),
                                GestureDetector(
                                  child: Container(
                                    width:  screenwidth < 700 ? screenwidth/1.7 : 400,
                                    padding: const EdgeInsets.all(10),
                                    child: Text('Évènements et matchs auxquels vous allez assister.',style: TextStyle(fontFamily: 'Google-Bold',color:  history_eventsmatches ? Colors.white.withOpacity(0.3) :  Colors.white),
                                    textAlign: TextAlign.center,
                                    ),
                                  ),
                                  onTap: (){
                                    setState(() {
                                      history_eventsmatches = false;
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Container(
                                    width: 25,
                                    child: Image(
                                      color: Colors.white,
                                      image: AssetImage('assets/home_icons/filter.png'),
                                    ),
                                  ),
                                  onPressed: (){
                                    setState(() {
                                      showsearchBox = false;
                                      showModalBottomSheet(
                                        backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                        context: context, builder: (context){
                                        return Events_filter();
                                      });
                                    });
                                  },
                                )
                              ],
                            ),

                          ),
                        );
                      }
                    ),
                  ],
                ),
              )
          );
  }
}

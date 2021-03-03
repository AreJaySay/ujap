import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/events_sub_pages_variables.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/appbar_icons.dart';
import 'package:ujap/globals/widgets/curve_containers.dart';
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/events_list_data.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/searches/search_service.dart';
import 'package:http/http.dart' as http;

class Event_parent extends StatefulWidget {
  @override
  _Event_parentState createState() => _Event_parentState();
}

class _Event_parentState extends State<Event_parent> {

  getEvents()async{
    var response = await http.get('https://ujap.checkmy.dev/api/client/events',
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
        // matchservice.updateAll(data: _events);

        eventsfirstData = _events;
        eventsData = _events;
        filterSearchService.addData(event: _events);

        getEvents_status();
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
//    middleController = PageController();
    searchbox_filter = "";
    searchfilter.text = "";
    view_data = "";
    convertedDate_filter = 0;
    convertedDate_filter_to = 99999999999;
    status_data = "";
    hideFloatingbutton = false;
    showCloseButton = false;
//    filterSearchService.filter();
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //     future: getEvents(),
    //     builder: (context, snapshot) {
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
                                      margin: EdgeInsets.all(30),
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width,
                                      height: screenwidth < 700 ? screenheight/2.5 :   screenheight/2.7,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage("assets/new_app_icon.png"),

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
                                    child: Text('Historique',style: TextStyle(fontFamily: 'Google-Bold',color: !history_eventsmatches ? Colors.white.withOpacity(0.3) :  Colors.white,fontSize: screenwidth < 700 ? history_eventsmatches ? screenheight/55 : screenheight/60 : 23),),
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
                                    child: Text('Evènements et matchs auxquels vous allez assister.',style: TextStyle(fontFamily: 'Google-Bold',color:  history_eventsmatches ? Colors.white.withOpacity(0.3) :  Colors.white,fontSize: screenwidth < 700 ?  history_eventsmatches ? screenheight/60 : screenheight/55 : 23),
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
                                    width: screenwidth < 700 ? screenwidth/20 : 30,
                                    height: screenwidth < 700 ? screenwidth/20 : 30,
                                    child: Image(
                                      color: Colors.white,
                                      image: AssetImage('assets/home_icons/filter.png'),
                                    ),
                                  ),
                                  onPressed: (){
                                    setState(() {
                                      showsearchBox = false;
                                     if (events_filter_open == true){
                                        print('ADFASDASD');
                                        events_filter_open = false;
                                      }
                                      else{
                                        events_filter_open = true;
                                        print('ADFASDASDdfdfd');
                                      }
                                    });
                                  },
                                )
                              ],
                            ),

                          ),
                        );
                      }
                    ),
//                    View_matches() ,
//                    View_events()
                  ],
                ),
              )
          );
    //     }
    // );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ujap/controllers/home.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/events_sub_pages_variables.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/confirmation_attendance.dart';
import 'package:ujap/globals/widgets/curve_containers.dart';
import 'package:ujap/globals/widgets/show_dialog_box.dart';
import 'package:ujap/globals/widgets/show_flushbar.dart';
import 'package:ujap/globals/widgets/show_loader.dart';
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/globals/widgets/tabber_events_matches.dart';
import 'package:ujap/pages/drawer_page.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/confirmed_attendance.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/notifications.dart';
import 'package:ujap/services/searches/search_service.dart';
import 'package:url_launcher/url_launcher.dart';

int ticket_allocation = 0;
int ticket_accepted_client = 0;
List eventsAttended_client;
double events_attendedmatch = 0;
double events_allocationmatch = 0;
List eventsAttended_clientmatch;
List eventStatusmatch;

class View_matches extends StatefulWidget {
  final Map eventDetail;
  final String _matchID,_image,_visitorID,_homeID,_courtID,_ticketID,_type, matchName;
  View_matches(this.eventDetail,this._matchID,this._image,this._visitorID,this._homeID,this._courtID,this._ticketID,this._type, this.matchName);

  @override
  _View_matchesState createState() => _View_matchesState();
}

class _View_matchesState extends State<View_matches> {
  List _coordinates = [
    ""
  ];
  List _teamNameandlogo;
  List _homeNameandlogo;
  var _attend_pass = "No";
  var _matchCourt = "";
  List _local;
  bool _isLoading = false;

   getMatchStatus(){
    setState(() {
        _teamNameandlogo = teamNameData.where((s){
          return s['id'].toString().toLowerCase() == widget._visitorID.toString().toLowerCase();
        }).toList();

        print('VISITOR :'+_teamNameandlogo.toString());

        _homeNameandlogo = teamNameData.where((s){
          return s['id'].toString().toLowerCase() == widget._homeID.toString().toLowerCase();
        }).toList();

        eventStatusmatch = events_status.where((s) {
          return s['event_id'].toString().toLowerCase() == widget._matchID.toString().toLowerCase();
        }).toList();

        events_attendedmatch = double.parse(eventStatusmatch[0]['accepted_clients'].length.toString());
        events_allocationmatch = double.parse(eventStatusmatch[0]['allocation'].toString());
        eventsAttended_clientmatch =  eventStatusmatch[0]['declined_clients'];

        print('ATTENDED ATTENDED :'+events_attendedmatch.toString());
        print('ATTENDED ALLOCATION :'+eventStatusmatch.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initStateS
    super.initState();
    getMatchStatus();
    // _get_ticket_request();
    attend_pass = "";
  }

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder(
      stream: filterSearchService.search$,
      builder: (context, snapshot) {
        return Scaffold(
                body: Container(
                  width: screenwidth,
                  height: screenheight,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: screenheight,
                    color: Colors.white,
                    child: Stack(
                      children: [
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(0),
                          children: [
                            Container(
                              width: screenwidth,
                              height: screenwidth < 700 ? screenheight/3 : screenheight/3,
                              decoration: BoxDecoration(
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
                                              height: screenwidth < 700 ? screenheight/2.8 :   screenheight/2.7,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    fit:  BoxFit.cover,
                                                    image: AssetImage('assets/home_icons/match_default.jpg')

                                                  )
                                              ),
                                            ),

                                          ))),
                                  Container(
                                      width: screenwidth,
                                      padding: EdgeInsets.only(left: screenwidth/25),
                                      margin: EdgeInsets.only(top: 40),
                                      child: Padding(
                                          padding: const EdgeInsets.only(bottom: 2.0,),
                                          child:ClipPath(
                                            clipper: CurvedTop(),

                                          ))),

                                ],
                              ),
                            ),

                            Container(
                              width: screenwidth,
                              height: screenheight/4,
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[300]))
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              width: 300,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width : screenwidth/4,
                                                    height: screenheight/9,
                                                    child: _homeNameandlogo == null ? Container() :
                                                    Image(
                                                    fit: BoxFit.contain ,
                                                    image: NetworkImage('https://ujap.checkmy.dev/storage/teams/'+_homeNameandlogo[0]['logo'].toString()),
                                                  )
                                                  ),

                                                  Container(
                                                     margin: EdgeInsets.symmetric(horizontal: 15),
                                                      child: Text(_homeNameandlogo[0]['name'].toString().toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70  : 20,fontFamily: 'Google-Bold',color: Colors.grey[800]),textAlign: TextAlign.center,)),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(bottom: screenwidth/12),
                                            height: screenheight,
                                            width: screenwidth < 700 ? screenwidth/4 : screenwidth/6,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('VS',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/30 : 35,color: Color.fromRGBO(20, 74, 119, 0.9),fontFamily: 'Google-Bold'),),
                                            ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              width: 300,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      width : screenwidth/6,
                                                      height: screenheight/9,
                                                      child: Image(
                                                        fit: BoxFit.contain ,
                                                        image: NetworkImage(_teamNameandlogo.toString() == "[]" ? "https://static.thenounproject.com/png/340719-200.png" : 'https://ujap.checkmy.dev/storage/teams/'+_teamNameandlogo[0]['logo'].toString()),
                                                      )
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.symmetric(horizontal: 15),
                                                      child: Text( _teamNameandlogo.toString() == "[]" ? "Pas de nom d'équipe adverse".toUpperCase() : _teamNameandlogo[0]['name'].toString().toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70  : 20,fontFamily: 'Google-Bold',color: Colors.grey[800]),textAlign: TextAlign.center,)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(bottom: screenwidth/40),
                                    width: screenwidth,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        // GestureDetector(
                                        //   child: Container(
                                        //     width: screenwidth/2,
                                        //     child: Text(_teamNameandlogo[0]['address'].toString(),
                                        //     textAlign: TextAlign.center,
                                        //     style: TextStyle(fontSize: screenwidth < 700 ? screenheight/60  : 20,fontFamily: 'Google-Medium',color: Colors.grey[700]),
                                        //     ),
                                        //   ),
                                        //   onTap: (){
                                        //     setState(() {
                                        //       // print(_teamNameandlogo[0]['address'].toString().replaceAll('/N', ''));
                                        //       launchMap(_teamNameandlogo[0]['address'].toString());
                                        //     });
                                        //   },
                                        // ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                            View_events_tabbar(widget.eventDetail,widget._matchID,widget._type,[],widget.matchName,eventStatusmatch),
                          ],
                        ),
                        currentindex == 0 ? Container() :
                        Container(
                          child:
                          pastTicketMatches ? Container () :
                          Container(
                            child: events_tabbarview_index == "1" ?
                            Container() :
                            Container(
                            child: events_allocationmatch == 0 ?
                            Container(
                              height: screenheight,
                              width: screenwidth,
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                  height: screenwidth/3,
                                  alignment: Alignment.centerLeft,
                                  // child: Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   crossAxisAlignment: CrossAxisAlignment.center,
                                  //   children: [
                                  //     Container(
                                  //       height: screenwidth <700 ? 25 : 50,
                                  //       width: screenwidth <700 ? 25 : 50,
                                  //       child: Image(
                                  //         color: Colors.grey,
                                  //         image:  AssetImage('assets/home_icons/green_ticket.png'),
                                  //       ),
                                  //     ),
                                  //     SizedBox(
                                  //       width: 10,
                                  //     ),
                                  //     Text('Pas de ticket disponible!'.toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/50  : 30,fontFamily: 'Google-Bold',color: Colors.grey[600]),),
                                  //   ],
                                  // )
                              ),
                            ) :
                            eventStatusmatch[0]['accepted_clients'].toString().contains('client_id: '+userdetails['id'].toString()) ?
                            Container(
                                height: screenheight,
                                alignment: Alignment.bottomCenter,
                                child: ConfirmAttendance(widget.eventDetail,null,eventStatusmatch)
                            ) :
                            events_attendedmatch >= events_allocationmatch ?
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                                height: screenheight,
                                alignment: Alignment.bottomCenter,
                                child: SafeArea(child: Text("Désolé, il n’y a plus de ticket disponible pour ce match.Veuillez attendre qu’il y en ait de nouveau.".toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/62  : 22,fontFamily: 'Google-Medium',color: Colors.grey),textAlign: TextAlign.center,)),
                              ) :
                            eventStatusmatch[0]['declined_clients'].toString().contains('client_id: '+userdetails['id'].toString()) ?
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                              width: screenwidth,
                              height: screenheight,
                              alignment: Alignment.bottomCenter,
                              child: SafeArea(child: Text("Vous avez annulé votre participation à ce match, vous ne pouvez donc plus y assister.".toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/62  : 22,fontFamily: 'Google-Bold',color: Colors.grey[500]),textAlign: TextAlign.center,)),
                            ) :
                            Container(
                              width: screenwidth,
                              height: screenheight,
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.only(bottom: screenheight/25),
                              child: _buttonActions(),
                            ),
                            ),
                          ),
                        ),
                        SafeArea(
                          child: Container(
                            margin: EdgeInsets.only(top: screenwidth/15,left: screenwidth/30),
                            height: screenwidth < 700 ? screenheight/2.8 : screenheight/2.7,
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(1000.0)
                                  ),
                                  padding: EdgeInsets.all(screenwidth < 700 ? 2 : 3),
                                  child: Icon(Icons.arrow_back_rounded,color: Colors.white,size: 26,)),
                              onTap: (){
                                setState(() {
                                  attend_pass = "";
                                  eventsSearch = false;
                                  pastTicketMatches = false;
                                  filterSearchService.filter(past: pastTicketMatches);
                                  indexListener.update(data: 1);
                                  currentindex = 1;
                                  if (notifPage){
                                    Navigator.of(context).pop(null);
                                  }else{
                                    if (taskList.toString() != "[]"){
                                      taskList.clear();
                                    }
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen(false)));
                                  }
                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
      }
    );

  }

  Widget _buttonActions(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: screenwidth,
      height: screenheight/16,
      child: Row(
        children: [
          Expanded(
              child: Builder(
                builder: (context)=>
                    GestureDetector(
                      child: Stack(
                        children: [
                          Container(
                            width: screenwidth/2,
                            decoration: BoxDecoration(
                                color:  attend_pass  == "No" || eventStatusmatch[0]['declined_clients'].toString().contains('client_id: '+userdetails['id'].toString()) ? Color.fromRGBO(1, 80, 147, 0.9) : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Color.fromRGBO(1, 80, 147, 0.9))
                            ),
                            alignment: Alignment.center,
                            child:  Text('Indisponible ce jour',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/53 : 25,fontFamily: 'Google-Bold',fontWeight: FontWeight.bold,color: attend_pass  == "No" || eventStatusmatch[0]['declined_clients'].toString().contains('client_id: '+userdetails['id'].toString()) ? Colors.white : Colors.black54),),
                          ),
                        ],
                      ),
                      onTap: (){
                        setState(() {
                          if (events_allocationmatch == 0){
                            showSnackBar(context,'Désolé, pas encore de ticket attribué pour ce match!');
                          } else{
                            eventType = "Match";
                            attend_pass = 'No';
                            confirmation(context,widget._ticketID,'0',widget.eventDetail);
                          }
                        });
                      },
                    ),
              )
          ),
          SizedBox(
            width: screenwidth/30,
          ),
          Expanded(
            child: Builder(
              builder: (context) =>
                  GestureDetector(
                    child: Stack(
                      children: [
                        Container(
                          width: screenwidth/2,
                          decoration: BoxDecoration(
                              color: attend_pass  == "Yes" || eventStatusmatch[0]['accepted_clients'].toString().contains('client_id: '+userdetails['id'].toString()) ? Color.fromRGBO(1, 80, 147, 0.9) : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Color.fromRGBO(1, 80, 147, 0.9))
                          ),
                          alignment: Alignment.center,
                          child: Text('Confirmer ma présence',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/53 : 25,fontFamily: 'Google-Bold',fontWeight: FontWeight.bold,color:  attend_pass  == "Yes" || eventStatusmatch[0]['accepted_clients'].toString().contains('client_id: '+userdetails['id'].toString()) ? Colors.white : Colors.black54),textAlign: TextAlign.center,),
                        )
                      ],
                    ),
                    onTap: (){
                      setState(() {
                        if (events_allocationmatch == 0){
                          showSnackBar(context,'Désolé, pas encore de ticket attribué pour ce match!');
                        }else{
                          eventType = "Match";
                          attend_pass = 'Yes';
                          confirmation(context,widget._ticketID,'1',widget.eventDetail);
                        }
                      });
                    },
                  ),
            ),
          ),
        ],
      ),
    );
  }

  launchMap(String address) async {
    String query = Uri.encodeComponent(address);
    String googleUrl = "https://www.google.com/maps/search/?api=1&query=$query";

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    }
  }

}
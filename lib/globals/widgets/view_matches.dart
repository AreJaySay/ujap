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
          body: ListView(
            children: [
              Stack(
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
                              color: Colors.grey[300],
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: widget.eventDetail['filename'].toString() == "null" || widget.eventDetail['filename'].toString() == "" ? AssetImage("assets/home_icons/match_default.jpg") : NetworkImage("https://ujap.checkmy.dev/storage/events/${widget.eventDetail['id']}/${widget.eventDetail['filename']}")
                                )
                            ),
                          ),

                        ))),
                  GestureDetector(
                    child: Container(
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(1000.0)
                        ),
                        padding: EdgeInsets.all(3),
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
                ],
              ),
              Container(
                height: 130,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    widget.eventDetail["match"]["home_court"] == 1 ?
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _homeNameandlogo == null ? Container() :
                          Image(
                            fit: BoxFit.contain ,
                            width: 76,
                            image: NetworkImage('https://ujap.checkmy.dev/storage/teams/'+_homeNameandlogo[0]['logo'].toString()),
                          ),
                          Text(_homeNameandlogo[0]['name'].toString().toUpperCase(),style: TextStyle(fontSize: 12,fontFamily: 'Google-Bold',color: Colors.grey[800]),textAlign: TextAlign.center,),
                        ],
                      ),
                    ) :
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            fit: BoxFit.contain ,
                            width: 80,
                            image: NetworkImage(_teamNameandlogo.toString() == "[]" ? "https://static.thenounproject.com/png/340719-200.png" : 'https://ujap.checkmy.dev/storage/teams/'+_teamNameandlogo[0]['logo'].toString()),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 120,
                            child:Text( _teamNameandlogo.toString() == "[]" ? "Pas de nom d'équipe adverse".toUpperCase() : _teamNameandlogo[0]['name'].toString().toUpperCase(),style: TextStyle(fontSize: 12,fontFamily: 'Google-Bold',color: Colors.grey[800]),maxLines: 1,overflow: TextOverflow.ellipsis,),
                          )
                        ],
                      ),
                    ),
                    Text('VS',style: TextStyle(fontSize: 25,color: Color.fromRGBO(20, 74, 119, 0.9),fontFamily: 'Google-Bold'),),
                    widget.eventDetail["match"]["home_court"] == 1 ?
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            fit: BoxFit.contain ,
                            width: 80,
                            image: NetworkImage(_teamNameandlogo.toString() == "[]" ? "https://static.thenounproject.com/png/340719-200.png" : 'https://ujap.checkmy.dev/storage/teams/'+_teamNameandlogo[0]['logo'].toString()),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 120,
                            child:Text( _teamNameandlogo.toString() == "[]" ? "Pas de nom d'équipe adverse".toUpperCase() : _teamNameandlogo[0]['name'].toString().toUpperCase(),style: TextStyle(fontSize: 12,fontFamily: 'Google-Bold',color: Colors.grey[800]),maxLines: 1,overflow: TextOverflow.ellipsis,),
                          )
                        ],
                      ),
                    ) :
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _homeNameandlogo == null ? Container() :
                          Image(
                            fit: BoxFit.contain ,
                            width: 76,
                            image: NetworkImage('https://ujap.checkmy.dev/storage/teams/'+_homeNameandlogo[0]['logo'].toString()),
                          ),
                          Text(_homeNameandlogo[0]['name'].toString().toUpperCase(),style: TextStyle(fontSize: 12,fontFamily: 'Google-Bold',color: Colors.grey[800]),textAlign: TextAlign.center,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              View_events_tabbar(widget.eventDetail,widget._matchID,widget._type,[],widget.matchName,eventStatusmatch),
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
                      height: screenwidth/3,
                      alignment: Alignment.centerLeft,
                    ) :
                    eventStatusmatch[0]['accepted_clients'].toString().contains('client_id: '+userdetails['id'].toString()) ?
                    ConfirmAttendance(widget.eventDetail,null,eventStatusmatch) :
                    events_attendedmatch >= events_allocationmatch ?
                    SafeArea(child: Text("Désolé, il n’y a plus de ticket disponible pour ce match.Veuillez attendre qu’il y en ait de nouveau.".toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/62  : 22,fontFamily: 'Google-Medium',color: Colors.grey),textAlign: TextAlign.center,)) :
                    eventStatusmatch[0]['declined_clients'].toString().contains('client_id: '+userdetails['id'].toString()) ?
                    SafeArea(child: Text("Vous avez annulé votre participation à ce match, vous ne pouvez donc plus y assister.".toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/62  : 22,fontFamily: 'Google-Bold',color: Colors.grey[500]),textAlign: TextAlign.center,)) :
                    _buttonActions(),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          )
        );
      }
    );

  }

  Widget _buttonActions(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: screenwidth,
      height: 55,
      child: Row(
        children: [
          Expanded(
              child: Builder(
                builder: (context)=>
                    GestureDetector(
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: screenwidth/2,
                            decoration: BoxDecoration(
                                color:  attend_pass  == "No" || eventStatusmatch[0]['declined_clients'].toString().contains('client_id: '+userdetails['id'].toString()) ? Color.fromRGBO(1, 80, 147, 0.9) : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Color.fromRGBO(1, 80, 147, 0.9))
                            ),
                            alignment: Alignment.center,
                            child:  Text('Indisponible ce jour',style: TextStyle(fontFamily: 'Google-Bold',fontWeight: FontWeight.bold,color: attend_pass  == "No" || eventStatusmatch[0]['declined_clients'].toString().contains('client_id: '+userdetails['id'].toString()) ? Colors.white : Colors.black54),),
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
            width: 10,
          ),
          Expanded(
            child: Builder(
              builder: (context) =>
                  GestureDetector(
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          width: screenwidth/2,
                          decoration: BoxDecoration(
                              color: attend_pass  == "Yes" || eventStatusmatch[0]['accepted_clients'].toString().contains('client_id: '+userdetails['id'].toString()) ? Color.fromRGBO(1, 80, 147, 0.9) : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Color.fromRGBO(1, 80, 147, 0.9))
                          ),
                          alignment: Alignment.center,
                          child: Text('Confirmer ma présence',style: TextStyle(fontFamily: 'Google-Bold',fontWeight: FontWeight.bold,color:  attend_pass  == "Yes" || eventStatusmatch[0]['accepted_clients'].toString().contains('client_id: '+userdetails['id'].toString()) ? Colors.white : Colors.black54),textAlign: TextAlign.center,),
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
    if (!await launchUrl(Uri.parse(googleUrl))) {
      throw 'Could not launch $googleUrl';
    }
  }

}
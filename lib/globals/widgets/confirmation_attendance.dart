import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujap/controllers/home.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/show_loader.dart';
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/globals/widgets/view_events.dart';
import 'package:ujap/pages/drawer_page.dart';
import 'package:ujap/pages/homepage.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/events_list_data.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/view_event.dart';
import 'package:ujap/services/api.dart';
import 'package:http/http.dart'as http;
import 'package:ujap/services/message_controller.dart';
import 'package:ujap/services/navigate_match_events.dart';
import 'package:ujap/services/searches/search_service.dart';

var eventType = "";
var eventID = "";
int indexmatch;
Map datamatch;
Map confirmedData;

attendCurrentmatch(context,ticket_ID,attend_or_pass,Map data)async{
  showloader(context);
  var response = await http.post(Uri.parse('https://ujap.checkmy.dev/api/client/confirmations/save'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $accesstoken",
        "Accept": "application/json"
      },
      body: {
        'client_id': userdetails['id'].toString(),
        'ticket_id': ticket_ID.toString(),
        'status': attend_or_pass.toString(),
      }
  );
  var jsonData = json.decode(response.body);
  print('RETURN OF ACCEPT: '+response.body.toString());
  if (response.statusCode == 200){
     messagecontroller.sendmessagetoServer(jsonData);
     getEvents_status(eventID: data['id'].toString());
     newConfirmed = data;
     if (data['type'].toString() == 'match'){
       navigateMatch(indexmatch,context,data);
     }else{
       Navigator.push(context, PageTransition(
           child: data['type'].toString() != "meeting" ? ViewEvent(
             eventDetail: data,
             pastEvent: false,
           ) : ViewEventDetails(
             eventDetail: data,
             pastEvent: false,
           ),
           type: PageTransitionType.topToBottom
       ));
     }
      print('REMOVE ATTENDED : '+attended_Meeting.toString()+eventID);
  }
  else
  {
    showSnackBar(context, "Impossible de traiter votre demande. peut-être un problème Internet ou une autre erreur s'est-il produit");
  }
}


confirmation(context,ticketID,attend_or_pass,data){
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          content: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              for (var x = 0; x < 2; x++)
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop(null);
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close,size: screenwidth < 700 ? 30 : 40,),
                      backgroundColor: kPrimaryColor,
                    ),
                  ),
                ),
              Container(
                width: screenwidth,
                height: screenwidth < 700 ? attend_pass  != "Yes" ? screenwidth/2.6 : screenwidth/4.2 : screenwidth/5,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        width: screenwidth,
                        child: Text( currentindex == 0 ? 'Vous ne pourrez pas être présent ? Veuillez confirmer votre choix.' : attend_pass == 'No' ? 'Vous ne pourrez pas être présent au $eventType ? Nous vous prions de nous confirmer ce choix.' : 'Souhaitez-vous confirmer votre présence?',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'Google-Medium',color: Colors.black87,fontSize: screenwidth < 700 ? screenheight/53 : 25 ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: screenwidth,
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                child: Container(
                                  width:  attend_pass  != "Yes" ? screenwidth/2.5 : screenwidth/2,
                                  height: 50,
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(horizontal: screenwidth/30,vertical: 5),
                                  child: Text('Annuler',style: TextStyle(fontFamily: 'Google-Medium',color: Colors.black54,fontSize: screenwidth < 700 ? screenheight/53 : 25 )),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey[600]),
                                      borderRadius: BorderRadius.circular(screenwidth/40)
                                  ),
                                ),
                                onTap: (){
                                    Navigator.of(context).pop(null);
                                },
                              ),
                            ),
                             Expanded(
                              child: Builder(
                                builder: (context)=> GestureDetector(
                                    child: Container(
                                      width: attend_pass  != "Yes" ? screenwidth/2.5 : screenwidth/2,
                                      height: 50,
                                      margin: EdgeInsets.symmetric(horizontal: screenwidth/30,vertical: 5),
                                      alignment: Alignment.center,
                                      child: Text('Confirmer',style: TextStyle(fontFamily: 'Google-Medium',color: Colors.white,fontSize: screenwidth < 700 ? screenheight/53 : 25 )),
                                      decoration: BoxDecoration(
                                          color:  kPrimaryColor,
                                          border: Border.all(color:  kPrimaryColor),
                                          borderRadius: BorderRadius.circular(screenwidth/40)
                                      ),
                                    ),
                                    onTap: (){
                                      attendCurrentmatch(context,ticketID,attend_or_pass,data);
                                    }
                                  ),
                              ),
                              ),
                          ]
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      });
}
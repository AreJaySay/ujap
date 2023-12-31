import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/controllers/home.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/confirmation_attendance.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/events_list_data.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/view_event.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/message_controller.dart';
import 'package:ujap/services/navigate_match_events.dart';
import '../user_data.dart';
import 'package:http/http.dart' as http;


attedCurrentMeeting({context,eventID,clientID,status,Map data})async{
  try{
    var response = await http.post(Uri.parse('https://ujap.checkmy.dev/api/client/meeting-confirmation/save'),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $accesstoken",
          "Accept": "application/json"
        },
        body: {
          'event_id': eventID.toString(),
          'client_id': userdetails['id'].toString(),
          'status': status.toString()
        }
    );
    var jsonData = json.decode(response.body);
    print('RETURN OF MEETING REQUEST :'+jsonData.toString());
    if (response.statusCode == 200)
      messagecontroller.sendmessagetoServer(jsonData);
    getEvents_status(eventID: eventID.toString());
    indexListener.update(data: 1);
    currentindex = 1;
    newConfirmed = data;
    if (data['type'].toString() == 'match'){
      navigateMatch(indexmatch,context,data);
    }else{
      Navigator.push(context, PageTransition(
          child: ViewEventDetails(
            eventDetail: data,
            pastEvent: false,
          ),
          type: PageTransitionType.topToBottom
      ));
    }
  }catch(e){
    print('GOT SOME ERROR:'+e.toString());
  }
}

confirmMeeting(Map data,{context,String eventID,String clientID,status, String localticketID}){
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          content: Stack(
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
                height: screenwidth < 700 ? attend_pass  != "Yes" ? screenwidth/3 : screenwidth/4.2 : screenwidth/5,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        width: screenwidth,
                        child: Text( currentindex == 0 ? 'Vous ne pourrez pas être présent ? Veuillez confirmer votre choix.' : attend_pass == 'No' ? 'Vous ne pourrez pas être présent au réunion ? Nous vous prions de nous confirmer ce choix. ?' : 'Souhaitez-vous confirmer votre présence?',
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
                                  height: screenheight,
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
                                      height: screenheight,
                                      margin: EdgeInsets.symmetric(horizontal: screenwidth/30,vertical: 5),
                                      alignment: Alignment.center,
                                      child: Text('Confirmer',style: TextStyle(fontFamily: 'Google-Medium',color: Colors.white,fontSize: screenwidth < 700 ? screenheight/53 : 25 )),
                                      decoration: BoxDecoration(
                                          color:  kPrimaryColor,
                                          border: Border.all(color:  kPrimaryColor),
                                          borderRadius: BorderRadius.circular(screenwidth/40)
                                      ),
                                    ),
                                    onTap: ()async{
                                        attedCurrentMeeting(context: context,eventID: eventID,clientID: clientID,status: status,data: data);
                                        attendCurrentmatch(context,localticketID,status,data);
                                      // attedCurrentMeeting(context,eventID,userdetails['id'].toString(),status);s
                                    }
                                ),
                              ),
                            ),
                          ],
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
import 'package:flutter/material.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/attend_meeting.dart';
import 'package:ujap/globals/widgets/confirmation_attendance.dart';
import 'package:ujap/services/presence.dart';

class ConfirmAttendance extends StatefulWidget {
  Map eventDetails;
  List eventStatus;
  List status;
  ConfirmAttendance(this.eventDetails,this.eventStatus,this.status);
  @override
  _ConfirmAttendanceState createState() => _ConfirmAttendanceState();
}

class _ConfirmAttendanceState extends State<ConfirmAttendance> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin:  EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 20 : 40,vertical: 30),
      height: screenheight/16,
      child:  widget.status[0]['declined_clients'].toString().contains('client_id: '+userdetails['id'].toString()) &&  widget.status[0]['declined_clients'].toString().contains('ticket_id: '+widget.eventDetails['id'].toString()) ?
          Container(
            width: screenwidth,
            child: Text('Vous avez annulé la participation à cet ${widget.eventDetails['type'].toString().toLowerCase() == 'event' ? ' évènement' : widget.eventDetails['type'].toString().toLowerCase() == 'match' ? 'match' : 'réunion'}, vous ne pouvez plus assister à cet  évènement.',
              style: TextStyle(fontSize: screenwidth < 700 ? screenheight/53 : 25,fontFamily: 'Google-Regular',color: Colors.grey),textAlign: TextAlign.center,),
          ) :
          Container(
          width: screenwidth,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color.fromRGBO(1, 80, 147, 0.9))
          ),
          alignment: Alignment.center,
          child: FlatButton(
          onPressed: (){
          if ( widget.eventDetails['type'].toString().toLowerCase() == "meeting".toString().toLowerCase()){
            print('KUMADI');
            confirmMeeting(widget.eventDetails,context: context,eventID: widget.eventDetails['id'].toString(),clientID: userdetails['id'].toString(),status: '0',localticketID: widget.eventDetails['ticket']['id'].toString());
          }
           else{
            print('KUMADI asdasdasd');
            confirmation(context,widget.eventDetails['ticket']['id'].toString(),'0',widget.eventDetails);
          }
          },
            child: Center(
              child: Text('Annuler présence ',style: TextStyle(fontSize: screenwidth < 700 ? screenwidth/23 : 20,fontFamily: 'Google-Bold', color: kPrimaryColor,),textAlign: TextAlign.left,),
            ),
          )
          // child: widget.eventStatus[0]['declined_clients'].toString().contains('client_id: '+userdetails['id'].toString()) ?
          // FlatButton(
          //   onPressed: (){
          //     if ( widget.eventStatus[0]['type'].toString().toLowerCase() == "meeting".toString().toLowerCase()){
          //       confirmMeeting(context,widget.eventDetails['id'].toString(),userdetails['id'].toString(),'1');
          //     }
          //      confirmation(context,widget.eventDetails['ticket']['id'].toString(),'1');
          //   },
          //   child: Center(
          //     child: Text('Confirmer ma présence',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/53 : 25,fontFamily: 'Google-Bold',fontWeight: FontWeight.bold,color: kPrimaryColor),textAlign: TextAlign.center,),
          //   ),
          // )
          //     : FlatButton(
          //     onPressed: (){
          //       if ( widget.eventStatus[0]['type'].toString().toLowerCase() == "meeting".toString().toLowerCase()){
          //         confirmMeeting(context,widget.eventDetails['id'].toString(),userdetails['id'].toString(),'0');
          //       }
          //       confirmation(context,widget.eventDetails['ticket']['id'].toString(),'0');
          //     },
          //   child: Center(
          //     child: Text('Indisponible ce jour',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/53 : 25,fontFamily: 'Google-Bold',fontWeight: FontWeight.bold,color: kPrimaryColor),textAlign: TextAlign.center,),
          //   ),
          // )
      ),
    );
  }
}

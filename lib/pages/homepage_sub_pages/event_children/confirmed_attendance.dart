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
      margin:  EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 20 : 40),
      height: screenheight/16,
      child:
      widget.status[0]['declined_clients'].toString().contains('client_id: '+userdetails['id'].toString()) &&  widget.status[0]['declined_clients'].toString().contains('ticket_id: '+widget.eventDetails['id'].toString()) ?
      Container(
        width: double.infinity,
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: Container(
                width: screenwidth/2,
                decoration: BoxDecoration(
                    color: !SelfChecker().isPresent(toCheck: widget.eventStatus) ? Color.fromRGBO(1, 80, 147, 0.9) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color.fromRGBO(1, 80, 147, 0.9))
                ),
                alignment: Alignment.center,
                child: Builder(
                  builder:(context)=> FlatButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: (){
                        confirmation(context,widget.eventDetails['ticket']['id'].toString(),'0',widget.eventDetails);
                      },
                      child: Text('Indisponible ce jour',
                        style: TextStyle(
                            fontSize: screenwidth < 700 ? screenheight/53 : 25,
                            fontFamily: 'Google-Bold',
                            fontWeight: FontWeight.bold,
                            color: !SelfChecker().isPresent(toCheck: widget.eventStatus) ?  Colors.white : kPrimaryColor
                        ),
                        textAlign: TextAlign.center,
                      )
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: Container(
                    width: screenwidth/2,
                    decoration: BoxDecoration(
                        color: SelfChecker().isPresent(toCheck: widget.eventStatus) ? Color.fromRGBO(1, 80, 147, 0.9) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color.fromRGBO(1, 80, 147, 0.9))
                    ),
                    alignment: Alignment.center,
                    child: Builder(
                      builder:(context)=>  FlatButton(
                        onPressed: (){
                          confirmation(context,widget.eventDetails['ticket']['id'].toString(),'1',widget.eventDetails);
                        },
                        child: Center(
                          child: Text('Confirmer ma présence',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/53 : 25,fontFamily: 'Google-Bold',fontWeight: FontWeight.bold,color:  SelfChecker().isPresent(toCheck: widget.eventStatus) ? Colors.white : kPrimaryColor),textAlign: TextAlign.center,),
                        ),
                      ),
                    )
                )
            ),

          ],
        ),
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
          setState(() {
            attend_pass = "No";
          });
          },
            child: Center(
              child: Text('Annuler présence ',style: TextStyle(fontSize: screenwidth < 700 ? screenwidth/23 : 20,fontFamily: 'Google-Bold', color: kPrimaryColor,),textAlign: TextAlign.left,),
            ),
          )
      ),
    );
  }
}

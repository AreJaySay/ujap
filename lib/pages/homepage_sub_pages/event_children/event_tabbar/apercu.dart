import 'package:flutter/material.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/services/string_formatter.dart';

class ApercuTab extends StatelessWidget {
  final Map data;
  final List attendees;
  final int attended;
  ApercuTab({this.data, this.attendees,this.attended});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            width: screenwidth,
            alignment: Alignment.centerLeft,
            child: Text( this.data['type'].toString().toLowerCase() == 'meeting' ? 'Date de la réunion'.toUpperCase() : "Date de l' évènement".toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/100 : 13,color: Color.fromRGBO(44, 87, 122, 0.9),),),
          ),
          SizedBox(
            height: screenheight/80,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(child:
                Container(
//                  padding: EdgeInsets.only(left: screenwidth/20),
                  alignment: Alignment.centerLeft,
                  child: Text(StringFormatter().date(date: DateTime.parse(data['sched_date'].toString())),style: TextStyle(fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/60 : 22,color: Colors.black,),),
                )
                ),
                Expanded(
                    flex: 2,
                    child:  Container(
                      width: screenwidth/2,
                      padding: EdgeInsets.only(left: screenwidth < 700 ? 20 : 40),
                      alignment: Alignment.centerLeft,
                      child: Text(StringFormatter().time(tt: data['sched_time'].toString()),style: TextStyle(fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/60  : 22,color: Colors.black,),),
                      decoration: BoxDecoration(
                          border: Border(left: BorderSide(color: Colors.black))
                      ),
                    )
                )
              ],
            ),
          ),
          SizedBox(
            height: screenheight/60,
          ),
          Container(
            width: screenwidth,
            alignment: Alignment.centerLeft,
            child: Text('Participants inscrits'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/100 : 13,color: Colors.black,),),
          ),
          SizedBox(
            height: screenheight/100,
          ),
          this.data['type'].toString() == 'event' ?
          Container(
            width: screenwidth,
            alignment: Alignment.centerLeft,
            child: Text(this.attended > 0 ? this.attended == 1 ? " ${this.attended.toString()} participant" : "${this.attended.toString()} participants" : "Aucun participant enregistré pour l’instant".toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/90 : 13,color: Colors.grey[600],),),
          ) :
          Container(
            width: screenwidth,
            alignment: Alignment.centerLeft,
            child: Text(this.attendees.length > 0 ? this.attendees.length == 1 ? " ${this.attendees.length.toString()} participant" : "${this.attendees.length.toString()} participants" : "Aucun participant enregistré pour l’instant".toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/90 : 13,color: Colors.grey[600],),),
          )
        ],
      ),
    );
  }
}

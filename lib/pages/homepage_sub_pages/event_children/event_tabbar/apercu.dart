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
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text( this.data['type'].toString().toLowerCase() == 'meeting' ? 'Date de la réunion'.toUpperCase() : "Date de l' évènement".toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',fontSize: 11,color: Color.fromRGBO(44, 87, 122, 0.9),),),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(StringFormatter().date(date: DateTime.parse(data['sched_date'].toString())),style: TextStyle(fontFamily: 'Google-Bold',fontSize: 16,color: Colors.black,),),
              Text(StringFormatter().time(tt: data['sched_time'].toString()),style: TextStyle(fontFamily: 'Google-Bold',fontSize: 16,color: Colors.black,),)
            ],
          ),
          Text('Participants inscrits'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',fontSize: 11,color: Colors.black,),),
          SizedBox(
            height: 10,
          ),
          this.data['type'].toString() == 'event' ?
          Text(this.attended > 0 ? this.attended == 1 ? " ${this.attended.toString()} participant" : "${this.attended.toString()} participants" : "Aucun participant enregistré pour l’instant".toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',fontSize: 10,color: Colors.grey[600],),) :
          Text(this.attendees.length > 0 ? this.attendees.length == 1 ? " ${this.attendees.length.toString()} participant" : "${this.attendees.length.toString()} participants" : "Aucun participant enregistré pour l’instant".toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',fontSize: 11,color: Colors.grey[600],),)
        ],
      ),
    );
  }
}

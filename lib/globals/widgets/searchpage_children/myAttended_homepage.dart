import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/matches.dart';

class MyAttendedHomepage extends StatefulWidget {
  final List eventList;
  final int index;
  MyAttendedHomepage(this.eventList,this.index);

  @override
  _MyAttendedHomepageState createState() => _MyAttendedHomepageState();
}

class _MyAttendedHomepageState extends State<MyAttendedHomepage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenwidth,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                blurRadius: 2.0,
                offset: Offset(0, 0),
                spreadRadius: 0
            )
          ]
      ),
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          widget.eventList[widget.index]['filename'].toString() == "null" ?
          Container(
            width: 60,
            height: 60,
            margin: EdgeInsets.all(5),
            child: Container(
              width: screenwidth,
              child: Image(
                fit: BoxFit.cover,
                color: Colors.grey[700],
                image: AssetImage('assets/no_image_available.png'),
              ),
            ),
          ) :
          Container(
            margin: EdgeInsets.all(5),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage('https://ujap.checkmy.dev/storage/events/'+widget.eventList[widget.index]['id'].toString()+'/'+widget.eventList[widget.index]['filename'])
                )
            ),
          ),
          Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.eventList[widget.index]['type'].toString().toLowerCase() == 'event' ? "Nom de l' évènement: " : 'Nom du match: ',style: TextStyle(color: Colors.grey[800],fontSize: screenwidth < 700 ? screenheight/65 : 20,fontFamily: 'Google-Medium'),),
                        Container(
                            width: screenwidth/2.8,
                            child: Text(widget.eventList[widget.index]['name'].toString(),style: TextStyle(color: Colors.grey[800],fontSize: screenwidth < 700 ? screenheight/65 : 20,fontFamily: 'Google-Regular'),maxLines: 1,overflow: TextOverflow.ellipsis,))
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Type: ',style: TextStyle(color: Colors.grey[800],fontSize: screenwidth < 700 ? screenheight/65 : 20,fontFamily: 'Google-Medium'),),
                      Text(widget.eventList[widget.index]['type'].toString(),style: TextStyle(color: Colors.grey[800],fontSize: screenwidth < 700 ? screenheight/65 : 20,fontFamily: 'Google-Regular'),)
                    ],
                  ),
                  Row(
                    children: [
                      Text("Date de l'évènement",style: TextStyle(color: Colors.grey[800],fontSize: screenwidth < 700 ? screenheight/65 : 20,fontFamily: 'Google-Medium'),),
                      SizedBox(
                        width: 5,
                      ),
                      Text(DateFormat("d").format(DateTime.parse(widget.eventList[widget.index]['sched_date'])).toString().toUpperCase()+' '+monthDate[int.parse(DateFormat("MM").format(DateTime.parse(widget.eventList[widget.index]['sched_date'])).toString())].toString()+'.'+' '+DateFormat("yyyy").format(DateTime.parse(widget.eventList[widget.index]['sched_date'])).toString().toUpperCase(),style: TextStyle(color: Colors.grey[800],fontSize: screenwidth < 700 ? screenheight/65 : 20,fontFamily: 'Google-Regular'),),
                      SizedBox(
                        width: 10,
                      ),
                      Text(widget.eventList[widget.index]['sched_time'].toString().substring(0,5),style: TextStyle(color: Colors.grey[800],fontSize: screenwidth < 700 ? screenheight/65 : 20,fontFamily: 'Google-Regular'),),
                      SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

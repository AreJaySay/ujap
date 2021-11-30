import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/variables/video.dart';
import 'package:ujap/globals/widgets/view_events.dart';
import 'package:ujap/pages/homepage.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/events_list_data.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/view_event.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/no_data_fetch.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/past_events_matches.dart';
import 'package:ujap/services/ad_listener.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/event_listener.dart';
import 'package:ujap/services/navigate_match_events.dart';
import 'package:ujap/services/notifications.dart';
import 'package:ujap/services/searches/search_service.dart';
import 'package:http/http.dart' as http;

List monthDate = ['','Jan','Fèvr','Mars','Avril','Mai','Juin','Juil','Août','Sept','Oct','Nov','Déc'];

class Bottom_listview_data extends StatefulWidget {
  @override
  _Bottom_listview_dataState createState() => _Bottom_listview_dataState();
}

class _Bottom_listview_dataState extends State<Bottom_listview_data> {
  bool _pastornot = false;

  var _finaleventsTime;
  var _timeConvertedString= "";
  int _timeConverted;
  int _finalTimeEvent;
  var _dateConvertedString = "";
  var _dateConvertedDayYear = "";
  List _teamName;
  int _daysbetween;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:  eventservice.search$,
      builder: (context, snapshot) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenwidth < 700 ? 10 : 15),
          ),
          child: snapshot.data == null || teamNameData == null ?
          Container(
            margin: EdgeInsets.symmetric(vertical: screenwidth < 700 ? 10 : 20,horizontal: screenwidth/20),
            height: screenwidth < 700 ? screenheight/4.8 : screenheight/4.5,
            width: screenwidth,
            child: loadingShimmering(),
          ) :  snapshot.data.length == 0 ?
          Container(
            width: screenwidth,
            height: screenwidth < 700 ? screenheight/3.6 : screenheight/3.5,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(screenwidth/40)
            ),
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: screenwidth < 700 ? screenwidth/3 : screenwidth/3.5,
                    height:screenwidth < 700 ? screenwidth/3 : screenwidth/3.5,
                    child: Image(
                      color: Colors.grey[700],
                      fit: BoxFit.cover,
                      image: AssetImage('assets/home_icons/no_events.png'),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        child: Column(
                          children: [
                            Text("AUCUN ÉVÉNEMENT TROUVÉ".toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/65  : 20,fontFamily: 'Google-Bold',color: Colors.grey[700]),),
                            SizedBox(
                              height: 5,
                            ),
                            Text("Vous pouvez voir tous les évènements ici.".toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/90  : 20,fontFamily: 'Google-Bold',color: Colors.grey[500]),),
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ) : ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 10),
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (context, int index){
              if (snapshot.data != null){
                attendedEventMatch.add(snapshot.data[index]);
              }
              return  GestureDetector(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Container(
                          padding: snapshot.data[index]['filename'].toString() == "null" || snapshot.data[index]['filename'].toString() == "" ? EdgeInsets.all(20) : EdgeInsets.all(0),
                          height: screenwidth < 700 ? screenheight/4.8 : screenheight/4.5,
                          width: screenwidth,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(screenwidth < 700 ? 10 : 15),

                          image: snapshot.data[index]['filename'].toString() != "null" || snapshot.data[index]['filename'].toString() != "" ? DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: NetworkImage('https://ujap.checkmy.dev/storage/events/'+snapshot.data[index]['id'].toString()+'/'+snapshot.data[index]['filename'].toString())
                          ) : null
                          ),
                          child: snapshot.data[index]['filename'].toString() == "null" || snapshot.data[index]['filename'].toString() == ""  ? Image(
                            color:  Colors.grey[800],
                            fit:  BoxFit.contain,
                            image: AssetImage('assets/no_image_available.png'),
                          ) : null,
                          margin: EdgeInsets.symmetric(vertical: screenwidth < 700 ? 10 : 20,horizontal: screenwidth/20)
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 0 : 20 ),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text( snapshot.data[index]['type'].toString().toLowerCase() == 'event' ? "NOM DE L'évènement:".toUpperCase() : "Nom de la réunion:".toUpperCase() ,style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70  : 20,fontFamily: 'Google-Bold',color: Colors.grey[600]),),
                            SizedBox(
                              width: 5,
                            ),
                            Text(snapshot.data[index]['name'].toString().toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70  : 20,fontFamily: 'Google-Bold',color: Colors.grey[800]),),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 0 : 20 ),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Text( snapshot.data[index]['type'].toString().toLowerCase() == 'event' ? "date de l'évènement:".toUpperCase() : "Date de la réunion:".toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70  : 20,fontFamily: 'Google-Bold',color: Colors.grey[600]),),
                            SizedBox(
                              width: 5,
                            ),
                            Text(DateFormat("d").format(DateTime.parse(snapshot.data[index]['sched_date'])).toString().toUpperCase()+' '+monthDate[int.parse(DateFormat("MM").format(DateTime.parse(snapshot.data[index]['sched_date'])).toString())].toString()+'.'+' '+DateFormat("yyyy").format(DateTime.parse(snapshot.data[index]['sched_date'])).toString().toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70  : 20,fontFamily: 'Google-Bold',color: Colors.grey[800]),),
                            SizedBox(
                              width: 10,
                            ),
                            Text(snapshot.data[index]['sched_time'].toString().substring(0,5),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70  : 20,fontFamily: 'Google-Bold',color: Colors.grey[800]),),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: (){
                    Navigator.push(context, PageTransition(
                        child: snapshot.data[index]['type'].toString() != "meeting" ? ViewEvent(
                          eventDetail: snapshot.data[index],
                          pastEvent: false,
                        ) : ViewEventDetails(
                          eventDetail: snapshot.data[index],
                          pastEvent: false,
                        ),
                        type: PageTransitionType.topToBottom
                    ));
                  setState(() {
                    if(videoPlayerController != null && chewieController != null && chewieController.isPlaying){
                      videoPlayerController.pause();
                      chewieController.pause();
                    }
                    adListener.update(false);
                    notifPage = false;
                  });
//
                },
              );
            },
          ),
        );
      }
    );

  }
}
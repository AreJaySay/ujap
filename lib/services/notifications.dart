import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/variables/video.dart';
import 'package:ujap/globals/widgets/appbar_icons.dart';
import 'package:ujap/globals/widgets/curve_containers.dart';
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/pages/homepage.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/view_event.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/download_pdf%202.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/matches.dart';
import 'package:ujap/pages/notification_children_page/search_notification.dart';
import 'package:ujap/services/event_listener.dart';
import 'package:ujap/services/navigate_match_events.dart';
import 'package:ujap/services/sample_sqlite.dart';
import 'package:ujap/services/searches/search_service.dart';
import 'package:ujap/services/string_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

List<Todo> taskList = new List();
bool notifPage = false;

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  var _choosenButton = "1";
  TextEditingController _searchbox = new TextEditingController();
  var _searchtext = "";
  ScrollController notificController = new ScrollController();
  bool hideTop = false;
  List<Map> dataToSearch = new List();
  List<Todo> localList = new List();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(videoPlayerController != null && chewieController != null && chewieController.isPlaying){
      videoPlayerController.pause();
      chewieController.pause();
    }
    localList = taskList;
    DatabaseHelper.instance.queryAllRows().then((value) {
      setState(() {
        value.forEach((element) {
          if (!taskList.contains(Todo(itemid: element['item_id'].toString(), messageType: element["message_type"].toString()))){
            taskList.add(Todo(id: element['id'], itemid: element['item_id'].toString(), messageType: element["message_type"].toString()));
          }
        });
      });
    }).catchError((error) {
      print(error);
    });
      print('asdasd'+taskList.length.toString());
      notificController.addListener(() {
        if (notificController.position.userScrollDirection == ScrollDirection.forward){
          setState(() {
            hideTop = false;
          });
        }else{
          setState(() {
            hideTop = true;
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
     stream: filterSearchService.search$,
      builder: (context, snapshot) {
        return Scaffold(
            body: Container(
              width: screenwidth,
              height: screenheight,
              color: Colors.white,
              child: Stack(
                children: [
                  Container(
                    width: screenwidth,
                    height: screenwidth < 700 ? screenheight/2 : screenheight/2.2,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: screenwidth,
                          margin: EdgeInsets.only(top: 10),
                          child: Padding(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              child:ClipPath(
                                  clipper: CurvedBottom(),
                                  child: Container(
                                    margin: EdgeInsets.all(30),
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    height: screenwidth < 700 ? screenheight/2.5 :   screenheight/2.7,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(

                                          image: AssetImage("assets/new_app_icon.png"),

                                        )
                                    ),


                                  ))),
                        ),
                        Container(
                            width: screenwidth,
                            child: Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child:ClipPath(
                                  clipper: CurvedTop(),
                                  child: Container(
                                    color: kPrimaryColor,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    height: screenwidth < 700 ? screenheight/3: screenheight/2.4,
                                  ),

                                ))),

                      ],
                    ),
                  ),
                  Container(
                    width: screenwidth,
                    height: screenheight,
                    padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0))
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.circular(1000.0)
                                    ),
                                    padding: EdgeInsets.all(3),
                                    child: Icon(Icons.arrow_back_rounded,color: Colors.white,size: screenwidth < 700 ? screenwidth/12 : screenwidth/20,)),
                                onTap: (){
                                  setState(() {
                                    if (taskList.toString() != "[]"){
                                      taskList.clear();
                                    }
                                  });
                                  Navigator.of(context).pop(null);
                                },
                              ),
                              Text('Notifications',style: TextStyle(color:  Colors.black87.withOpacity(0.7) ,fontSize: screenwidth < 700 ? screenwidth/19 :  screenwidth/25,fontFamily: 'Google-Bold'),),
                              IconButton(
                                icon: Icon(Icons.search_outlined,color: Colors.white,size: screenwidth/12,),
                                onPressed: (){
                                 },
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          height: hideTop ? 0 : screenwidth < 700 ? screenwidth/8 : screenwidth/13,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                child: Container(
                                  width: screenwidth/3.3,
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: _choosenButton == "1" ? kPrimaryColor : Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: _choosenButton == "1" ? Colors.transparent :  Colors.black87.withOpacity(0.5),width: 2)
                                  ),
                                  child: Center(
                                    child: Text('ALL',style: TextStyle(color:  _choosenButton == "1" ? Colors.white : Colors.black87.withOpacity(0.7) ,fontSize: screenwidth < 700 ? screenwidth/30 : 20,fontFamily: 'Google-Bold'),),
                                  ),
                                ),
                                onTap: (){
                                  setState(() {
                                    _choosenButton = '1';
                                    taskList = localList;
                                  });
                                },
                              ),
                              GestureDetector(
                                child: Container(
                                  width: screenwidth/3.3,
                                  height: screenheight,
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: _choosenButton == "2" ? kPrimaryColor : Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: _choosenButton == "2" ? Colors.transparent : Colors.black87.withOpacity(0.5),width: 2)
                                  ),
                                  child: Center(
                                    child: Text('publicités'.toUpperCase(),style: TextStyle(color:  _choosenButton == "2" ? Colors.white : Colors.black87.withOpacity(0.7) ,fontSize: screenwidth < 700 ? screenwidth/30 : 20,fontFamily: 'Google-Bold'),textAlign: TextAlign.center,),
                                  ),
                                ),
                                onTap: (){
                                  setState(() {
                                    _choosenButton = '2';
                                    for (var x = 0; x < localList.length; x++){
                                      taskList = localList.where((s){
                                        return s.messageType.toString() == 'Advertisement';
                                      }).toList();
                                    }
                                  });
                                },
                              ),
                              GestureDetector(
                                child: Container(
                                  width: screenwidth/3.3,
                                  decoration: BoxDecoration(
                                      color: _choosenButton == "3" ? kPrimaryColor : Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: _choosenButton == "3" ? Colors.transparent : Colors.black87.withOpacity(0.5),width: 2)
                                  ),
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.all(2),
                                      child: Text('ÉVÉNEMENTS / MATCHS',style: TextStyle(color:  _choosenButton == "3" ? Colors.white : Colors.black87.withOpacity(0.7) ,fontSize: screenwidth < 700 ? screenwidth/30 : 20,fontFamily: 'Google-Bold'),
                                      textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                ),
                                onTap: (){
                                  setState(() {
                                    _choosenButton = '3';
                                    for (var x = 0; x < localList.length; x++){
                                      taskList = localList.where((s){
                                        return s.messageType.toString() == 'Event';
                                      }).toList();
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Container(
                            width: screenwidth,
                            child: taskList.length == 0 ?
                            Container(
                              width: screenwidth,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.notifications,size: screenwidth < 700 ? 50 : 55,color: Colors.black87.withOpacity(0.7),),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                        width: screenwidth,
                                        child: Center(child: Text('AUCUNE NOTIFICATION TROUVÉE',style: TextStyle(color: Colors.black87.withOpacity(0.5),fontFamily: 'Google-Bold',fontSize: screenheight/55 )))),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                        padding: EdgeInsets.symmetric(horizontal: screenwidth/8),
                                        width: screenwidth,
                                        child: Text("Vous verrez ici toutes vos notifications que vous avez reçues."
                                          ,style: TextStyle(color: Colors.grey[350],fontFamily: 'Google-Bold',fontSize: screenheight/70 ,
                                          ),textAlign: TextAlign.center,
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ) : ListView.builder(
                              controller: notificController,
                              padding: EdgeInsets.only(top: 20),
                              itemCount: taskList.length,
                              itemBuilder: (context, index){
                                List eventDetails;
                                List adverTisement;

                                if (taskList[index].messageType.toString().toLowerCase() == 'Event'.toString().toLowerCase()){
                                  if (snapshot.data != null){
                                    eventDetails = snapshot.data.where((s){
                                      return s['id'].toString()+'.0' == taskList[index].itemid.toString();
                                    }).toList();
                                    if (eventDetails.toString() != "[]"){
                                      dataToSearch.add(eventDetails[0]);
                                    }
                                  }
                                }else{
                                  if (get_ads != null){
                                    adverTisement = get_ads.where((s){
                                      return s['id'].toString()+'.0' == taskList[index].itemid.toString();
                                    }).toList();
                                    if (adverTisement.toString() != '[]'){
                                      dataToSearch.add(adverTisement[0]);
                                    }
                                  }
                                }

                                return  GestureDetector(
                                  child: Slidable(
                                    actionPane: SlidableDrawerActionPane(),
                                    child: taskList[index].messageType == 'Advertisement' ?
                                     GestureDetector(
                                      child: adverTisement.toString() == "[]" || adverTisement.toString() == "null" ? Container() :  Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey[400],
                                                offset: Offset(3,2),
                                                blurRadius: 2,
                                              )
                                            ]
                                        ),
                                        margin: EdgeInsets.symmetric(vertical: 5),
                                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                        child: Row(
                                          children: [
                                          Container(
                                            width: adverTisement[0]['filename'].toString() == "null" ? 60 : 70,
                                            height: adverTisement[0]['filename'].toString() == "null" ? 60 : 70,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                  border: Border.all(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: adverTisement[0]['filename'].toString() == "null" || adverTisement[0]['content'].toString() == "null" ?  NetworkImage('https://static.thenounproject.com/png/1529460-200.png') : NetworkImage('${StringFormatter().strToObj(adverTisement[0]['content'])['location']}')
                                                  ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Container(
                                                width: screenwidth,
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:  MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("Nom de la publicité: ".toUpperCase(),style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600,fontFamily: 'Google-Bold',fontSize: 14 ),overflow: TextOverflow.ellipsis,maxLines: 1,),
                                                        Expanded(child: Text(adverTisement[0]['name'].toString(),style: TextStyle(color: Colors.black54,fontFamily: 'Google-Medium',fontSize: 14 ),overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:  MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text("Description: ".toUpperCase(),style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600,fontFamily: 'Google-Bold',fontSize: 14 ),overflow: TextOverflow.ellipsis,maxLines: 1,),
                                                        Expanded(
                                                          child: Container(
                                                              width: screenwidth < 700 ? screenwidth/2.5 : 350,
                                                              child: Text(adverTisement[0]['description'],style: TextStyle(color: Colors.black54,fontFamily: 'Google-Medium',fontSize: 14 ),overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text('Ouvrir le lien publicitaire',style: TextStyle(color: kPrimaryColor.withOpacity(0.7),fontFamily: 'Google-Medium',fontSize: 12 ),overflow: TextOverflow.ellipsis,maxLines: 1,),
                                                        Icon(Icons.arrow_forward,color: kPrimaryColor.withOpacity(0.7),size: 15,)
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: ()async{
                                        String url = "${StringFormatter().strToObj(adverTisement[0]['content'])['location']}";
                                        if (await canLaunch(url)) {
                                        await launch(url);
                                        } else {
                                        throw 'Could not launch $url';
                                        }
                                      },
                                    ) :
                                    GestureDetector(
                                      child: eventDetails.toString() == "[]" ||  eventDetails.toString() == "null" ? Container() : Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey[400],
                                              offset: Offset(3,2),
                                              blurRadius: 2,
                                            )
                                          ]
                                        ),
                                        margin: EdgeInsets.symmetric(vertical: 5),
                                        padding: EdgeInsets.symmetric(horizontal: eventDetails[0]['filename'].toString() == "null" ? 10 : 5,vertical: 5),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: eventDetails[0]['filename'].toString() == "null" ? 60 : 70,
                                              height: eventDetails[0]['filename'].toString() == "null" ? 60 : 70,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius: BorderRadius.circular(10.0),
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: eventDetails[0]['filename'].toString() == "null" ? AssetImage('assets/new_app_icon.png') : NetworkImage('https://ujap.checkmy.dev/storage/events/'+eventDetails[0]['id'].toString()+'/'+eventDetails[0]['filename'].toString())
                                                )
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Container(
                                                width: screenwidth,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: <Widget>[
                                                   Container(
                                                     child: Row(
                                                       children: <Widget>[
                                                         Text("Nom de l' évènement: ".toUpperCase(),style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600,fontFamily: 'Google-Bold',fontSize: 14 ),overflow: TextOverflow.ellipsis,maxLines: 1,),
                                                         Expanded(
                                                             child: Text(eventDetails[0]['name'].toString(),style: TextStyle(color: Colors.black54,fontFamily: 'Google-Medium',fontSize: 14 ),overflow: TextOverflow.ellipsis,maxLines: 1,)),
                                                       ],
                                                     ),
                                                   ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Text("Date de l'évènement: ".toUpperCase(),style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600,fontFamily: 'Google-Regular',fontSize: 14 ),overflow: TextOverflow.ellipsis,maxLines: 3,),
                                                        Text(DateFormat("d").format(DateTime.parse(eventDetails[0]['sched_date'])).toString().toUpperCase()+' '+monthDate[int.parse(DateFormat("MM").format(DateTime.parse(eventDetails[0]['sched_date'])).toString())].toString()+'.'+' '+DateFormat("yyyy").format(DateTime.parse(eventDetails[0]['sched_date'])).toString().toUpperCase(),style: TextStyle(color: Colors.black54,fontFamily: 'Google-Medium',fontSize: 14 ),overflow: TextOverflow.ellipsis,maxLines: 2,),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Text("Heure de début: ".toUpperCase(),style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600,fontFamily: 'Google-Regular',fontSize: 14 ),overflow: TextOverflow.ellipsis,maxLines: 2,),
                                                        Text(eventDetails[0]['sched_time'].toString().substring(0,5),style: TextStyle(color: Colors.black54,fontFamily: 'Google-Medium',fontSize: 14 ),overflow: TextOverflow.ellipsis,maxLines: 2,),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: (){
                                        if (eventDetails[0]['type'].toString().toLowerCase() != 'match'.toString().toLowerCase()){
                                          Navigator.push(context, PageTransition(
                                              child: ViewEventDetails(
                                                eventDetail: eventDetails[0],pastEvent: false,
                                              ),
                                              type: PageTransitionType.topToBottom
                                          ));
                                        }else{
                                          navigateMatch(index,context,eventDetails[0]);
                                        }
                                        setState(() {
                                          notifPage = true;
                                        });
                                      },
                                    ),
                                    secondaryActions: <Widget>[
                                      Container(
                                        child: Builder(
                                          builder:(context)=> IconSlideAction(
                                            iconWidget: Container(
                                                color: Colors.white,
                                                alignment: Alignment.center,
                                                child: Center(
                                                  child: Container(
                                                    height: 60,
                                                    width: 60,
                                                    padding: EdgeInsets.all(5),
                                                    child: Container(
                                                        padding: EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius: BorderRadius.circular(1000.0)
                                                        ),
                                                        child: Icon(Icons.delete,color: Colors.white,)),
                                                  ),
                                                )),
                                            onTap: (){
                                              _deleteTask(double.parse(taskList[index].itemid).toInt(),taskList[index].id);
                                              showSnackBar(context, 'Successfully deleted.');
                                            }
//                      onTap: () => _showSnackBar('Delete'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                ],
              ),
            )
        );
      }
    );
  }
  void _deleteTask(int id, int localID) async {
    await DatabaseHelper.instance.delete(id);
    setState(() {
      taskList.removeWhere((element) => element.id == localID);
    });
  }
}


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/view_matches.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/view_event.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/matches.dart';
import 'package:ujap/services/event_listener.dart';
import 'package:ujap/services/navigate_match_events.dart';
import 'package:ujap/services/string_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchNotifications extends StatefulWidget {
   List datatoSearchEvents;
  SearchNotifications(this.datatoSearchEvents);
  @override
  _SearchNotificationsState createState() => _SearchNotificationsState();
}

class _SearchNotificationsState extends State<SearchNotifications> {
  TextEditingController _searchbox = TextEditingController();
  List localList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    localList = widget.datatoSearchEvents;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: eventservice.search$,
      builder: (context, snapshot) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SafeArea(
                  child: Container(
                    height: screenwidth/4.5,
                    width: screenwidth,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                              padding: EdgeInsets.all(3),
                              child: Icon(Icons.arrow_back_rounded,color: kPrimaryColor,size: 26,)),
                          onTap: (){
                            Navigator.of(context).pop(null);
                            setState(() {
                              widget.datatoSearchEvents = null;
                            });
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.withOpacity(0.7),width: 2),
                            ),
                            child: TextField(
                              controller: _searchbox,
                              style: TextStyle(fontSize: screenwidth < 700 ? screenheight/45 : 20,fontFamily: 'Google-Medium'),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.search,size: screenwidth < 700 ? 25 : 30,color: kPrimaryColor.withOpacity(0.6),),
                                suffixIcon: _searchbox.text.isEmpty ? null : IconButton(
                                  icon: Icon(Icons.clear,size: screenwidth < 700 ? 25 : 30,color: kPrimaryColor,),
                                  onPressed: (){
                                    setState(() {
                                      _searchbox.text = "";
                                      _searchbox.text.isEmpty;
                                      widget.datatoSearchEvents = localList;
                                    });
                                  },
                                ),
                                hintText: 'Rechercher notifications',
                                hintStyle: TextStyle(fontSize: screenwidth < 700 ? screenheight/45 : 20,fontFamily: 'Google-Regular'),
                              ),
                              onChanged: (text){
                                setState(() {
                                  widget.datatoSearchEvents = localList.where((s){
                                    return s['name'].toString().toLowerCase().contains(_searchbox.text.toString().toLowerCase()) || s['type'].toString().toLowerCase().contains(_searchbox.text.toString().toLowerCase()) ||
                                        s['status'].toString().toLowerCase().contains(_searchbox.text.toString().toLowerCase().contains('active'.toString().toLowerCase()) ? '1'.toString().toLowerCase() : '0'.toString().toLowerCase()) ||
                                        'publicités'.toString().toLowerCase().contains(_searchbox.text.toString().toLowerCase()) ? s['type'].toString() == 'image' ||  s['type'].toString() == 'video' : s['type'].toString() == text.toString();
                                    // }).toList();;
                                  }).toList();
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: screenwidth,
                    height: screenheight,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: widget.datatoSearchEvents.toString() == "null" ?
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
                    ) :
                    ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      itemCount: widget.datatoSearchEvents.length,
                      itemBuilder: (context, index){
                        return GestureDetector(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.6),
                                    offset: Offset(3,2),
                                    blurRadius: 2
                                  )
                                ]
                            ),
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            // child:    Text(widget.datatoSearchEvents[index]['type'].toString()),
                            child: widget.datatoSearchEvents[index]['type'].toString() == 'image' || widget.datatoSearchEvents[index]['type'].toString() == 'video' ?
                             GestureDetector(
                               child: Row(
                                children: [
                                  Container(
                                    width: widget.datatoSearchEvents[index]['filename'].toString() == "null" ? 50 : 60,
                                    height:widget.datatoSearchEvents[index]['filename'].toString() == "null" ? 50 : 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: widget.datatoSearchEvents[index]['filename'].toString() == "null" ?  AssetImage('assets/messages_icon/no_profile.png') : NetworkImage('${StringFormatter().cleaner(StringFormatter().strToObj(widget.datatoSearchEvents[index]['content'])['location'])}')
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
                                              Text("Nom de la publicité: ",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600,fontFamily: 'Google-Regular',fontSize: screenheight/55 ),overflow: TextOverflow.ellipsis,maxLines: 2,),
                                              Text(widget.datatoSearchEvents[index]['name'].toString(),style: TextStyle(color: Colors.black54,fontFamily: 'Google-Medium',fontSize: screenheight/55 ),overflow: TextOverflow.ellipsis,maxLines: 2,),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:  MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Statut: ",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600,fontFamily: 'Google-Regular',fontSize: screenheight/55 ),overflow: TextOverflow.ellipsis,maxLines: 2,),
                                              Text(widget.datatoSearchEvents[index]['status'].toString() == '1' ? 'Active' : 'Inactive',style: TextStyle(color: Colors.black54,fontFamily: 'Google-Medium',fontSize: screenheight/55 ),overflow: TextOverflow.ellipsis,maxLines: 2,),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                            ),
                             onTap: ()async{
                               String url = '${StringFormatter().cleaner(StringFormatter().strToObj(widget.datatoSearchEvents[index]['content'])['location'])}';
                               if (await canLaunch(url)) {
                                 await launch(url);
                               } else {
                                 throw 'Could not launch $url';
                               }
                             },
                             ) : Row(
                              children: [
                                Container(
                                  width: widget.datatoSearchEvents[index]['filename'].toString() == "null" ? 50 : 60,
                                  height: widget.datatoSearchEvents[index]['filename'].toString() == "null" ? 50 : 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: widget.datatoSearchEvents[index]['filename'].toString() == "null" ? AssetImage('assets/new_app_icon.png') : NetworkImage('https://ujap.checkmy.dev/storage/events/'+widget.datatoSearchEvents[index]['id'].toString()+'/'+widget.datatoSearchEvents[index]['filename'].toString())
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
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text("Nom de l' évènement: ",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600,fontFamily: 'Google-Regular',fontSize: screenheight/55 ),overflow: TextOverflow.ellipsis,maxLines: 2,),
                                            Text(widget.datatoSearchEvents[index]['name'].toString(),style: TextStyle(color: Colors.black54,fontFamily: 'Google-Medium',fontSize: screenheight/55 ),overflow: TextOverflow.ellipsis,maxLines: 2,),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text("Type d' évènement: ",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600,fontFamily: 'Google-Regular',fontSize: screenheight/55 ),overflow: TextOverflow.ellipsis,maxLines: 2,),
                                            Text(widget.datatoSearchEvents[index]['type'].toString(),style: TextStyle(color: Colors.black54,fontFamily: 'Google-Medium',fontSize: screenheight/55 ),overflow: TextOverflow.ellipsis,maxLines: 2,),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text("Date de l'évènement: ",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600,fontFamily: 'Google-Regular',fontSize: screenheight/55 ),overflow: TextOverflow.ellipsis,maxLines: 3,),
                                            Text(DateFormat("d").format(DateTime.parse(widget.datatoSearchEvents[index]['sched_date'])).toString().toUpperCase()+' '+monthDate[int.parse(DateFormat("MM").format(DateTime.parse(widget.datatoSearchEvents[index]['sched_date'])).toString())].toString()+'.'+' '+DateFormat("yyyy").format(DateTime.parse(widget.datatoSearchEvents[index]['sched_date'])).toString().toUpperCase(),style: TextStyle(color: Colors.black54,fontFamily: 'Google-Medium',fontSize: screenheight/55 ),overflow: TextOverflow.ellipsis,maxLines: 2,),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text("Heure de début: ",style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w600,fontFamily: 'Google-Regular',fontSize: screenheight/55 ),overflow: TextOverflow.ellipsis,maxLines: 2,),
                                            Text(widget.datatoSearchEvents[index]['sched_time'].toString().substring(0,5),style: TextStyle(color: Colors.black54,fontFamily: 'Google-Medium',fontSize: screenheight/55 ),overflow: TextOverflow.ellipsis,maxLines: 2,),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )
                          ),
                          onTap: (){
                            if ( widget.datatoSearchEvents[index]['type'].toString().toLowerCase() != 'match'.toString().toLowerCase()){
                              Navigator.push(context, PageTransition(
                                  child: ViewEventDetails(
                                    eventDetail: widget.datatoSearchEvents[index],
                                  ),
                                  type: PageTransitionType.topToBottom
                              ));
                            }else{
                              navigateMatch(index,context,widget.datatoSearchEvents[index]);
                            }

                          },
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}


import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/variables/events_sub_pages_variables.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/messages_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/curve_containers.dart';
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/download_pdf%202.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/sendGmail.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/ticket_actions.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/view_download_pdf.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/list_of_clients.dart';
import 'package:ujap/pages/homepage_sub_pages/message_parent_page.dart';
import 'package:ujap/services/api.dart';

List teamNameandlogo;
List homeNameandlogo;
List eventsAttended_client;

class Ticket_homepage extends StatefulWidget {
  final String _matchID,_image,_visitorID,_homeID,_ticketID, matchName;
  Ticket_homepage(this._matchID,this._image,this._visitorID,this._homeID,this._ticketID,this.matchName);

  @override
  _Ticket_homepageState createState() => _Ticket_homepageState();
}

class _Ticket_homepageState extends State<Ticket_homepage> {
  List _eventStatus;
  var _attend_pass = "No";

  getData(){
    setState(() {
        teamNameandlogo = teamNameData.where((s){
          return s['id'].toString().toLowerCase() == widget._visitorID.toString().toLowerCase();
        }).toList();

        homeNameandlogo = teamNameData.where((s){
          return s['id'].toString().toLowerCase() == widget._homeID.toString().toLowerCase();
        }).toList();

        _eventStatus = events_status.where((s) {
          return s['event_id'].toString().toLowerCase() == widget._matchID.toString().toLowerCase();
        }).toList();
          events_attended = double.parse( _eventStatus[0]['accepted_clients'].length.toString());
          events_allocation = double.parse(_eventStatus[0]['allocation'].toString());

          print('ATTENDED CLIENTS :'+events_attended.toString());

          eventsAttended_client =  _eventStatus[0]['accepted_clients'];
    });
  }

  Stream compose()async*{
    setState(() {
      message_compose_open = message_compose_open;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTicketData(widget._ticketID.toString());
    getPermission();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: compose(),
      builder: (context, snapshot) {
        return Scaffold(
                body: Container(
                  width: screenwidth,
                  height: screenheight,
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: screenwidth,
//                width: screenwidth,
                    height:  screenheight,
                    color: Colors.grey[200],
                    child: Stack(
                      children: [
                        Container(
                          width: screenwidth,
                          height: screenwidth < 700 ? screenheight/2 : screenheight/2.2,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)
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

                                          height: screenwidth < 700 ? screenheight/3: screenheight/2.4,
                                        ),

                                      ))),
                            ],
                          ),
                        ),
                        Container(
                          width: screenwidth,
                          height: screenheight,
                          margin: EdgeInsets.symmetric(vertical: screenwidth < 700 ? screenheight/3.3 : screenheight/2.5),
                        ),
                        AnimatedContainer(
                          duration: Duration(seconds: 1),
                          width: screenwidth,
                          height: screenheight,
                          margin: EdgeInsets.only(top: screenwidth < 700 ? screenheight/20 : screenheight/15,bottom: 30,left: screenwidth < 700 ? 25 : 50,right:  screenwidth < 700 ? 25 : 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Container(
                                width : screenwidth,
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius: BorderRadius.circular(1000.0)
                                      ),
                                      padding: EdgeInsets.all(screenwidth < 700 ? 2 : 3),
                                      child: Icon(Icons.arrow_back_rounded,color: Colors.white,size: 26,)),
                                  onTap: (){
                                    setState(() {
                                      showticket = false;
                                      eventsAttended_client = null;
                                      eventsSearch = false;
                                      loading_indicator = "";
                                      Navigator.of(context).pop(null);
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                height: screenwidth < 700 ? 10 : 20,
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                    Container(
                                      height: screenwidth < 700 ? screenheight/4.5 : screenheight/3.8,
                                      margin: EdgeInsets.only(bottom: screenwidth < 700 ? screenheight/80 : 25),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: screenheight / 15,
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(248, 248, 248, 0.9),
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(widget.matchName.toString().toUpperCase(),style: TextStyle(fontSize: 14,fontFamily: 'Google-Bold',color: Colors.grey[800]),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(matchDate.toString(),style: TextStyle(fontSize: 14,fontFamily: 'Google-Medium',color: Colors.grey[800]),),
                                                    SizedBox(
                                                      width: screenwidth < 700 ? 5 : 15,
                                                    ),
                                                    Text(matchTime.toString(),style: TextStyle(fontSize: 14,fontFamily: 'Google-Medium',color: Colors.grey[800]),),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenwidth < 700 ? 10 : 25,
                                          ),
                                          Expanded(
                                            child: Container(
                                              width : screenwidth,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Container(
                                                    width: screenwidth/4,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        homeNameandlogo == null ? Container() : Container(
                                                          width : screenwidth < 700 ? screenwidth/5 : screenwidth/5,
                                                          height: screenwidth < 700 ? screenwidth/6 : screenwidth/6,
                                                          child: Image(
                                                            fit: BoxFit.contain,
                                                              image: NetworkImage('https://ujap.checkmy.dev/storage/teams/'+homeNameandlogo[0]['logo'].toString()),
                                                          ),

                                                        ),
                                                        homeNameandlogo == null ? Container() :
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          width: screenwidth,
                                                          child: Text(homeNameandlogo == null ? '' : homeNameandlogo[0]['name'].toString(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70 : 20,fontFamily: 'Google-Bold'),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    width: screenwidth/4,
                                                    margin: EdgeInsets.only(top:  screenheight/60,right: screenheight/60,left: screenheight/60),
                                                    height: screenheight,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          height: screenwidth < 700 ? screenwidth/20 : screenwidth/20,
                                                          alignment: Alignment.center,
                                                          child: Container(
                                                            width : screenwidth < 700 ? screenwidth/5 : screenwidth/7,
                                                            height: screenwidth < 700 ? screenwidth/5 : screenwidth/7,
                                                            child: Image(
                                                              fit: BoxFit.contain,
                                                              color: Color.fromRGBO(204, 44, 65, 0.9),
                                                              image: AssetImage('assets/home_icons/staples_icon.png'),
                                                            ),
                                                          ),
                                                        ),
                                                        Text('VS',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/40 : 35,color: Color.fromRGBO(20, 74, 119, 0.9),fontFamily: 'Google-Bold'),),
                                                        SizedBox(
                                                          height: 3,
                                                        ),
                                                        Text('FRANCE - PRO B',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/85 : 17,fontFamily: 'Google-Bold',fontWeight: FontWeight.bold),),
                                                      ],
                                                    ),
                                                  ),

                                                  Container(
                                                    width: screenwidth/4,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        teamNameandlogo == null ? Container() : Container(
                                                          width : screenwidth < 700 ? screenwidth/5 : screenwidth/5,
                                                          height: screenwidth < 700 ? screenwidth/6 : screenwidth/6,
                                                          child: Image(
                                                            fit: BoxFit.contain,
                                                            image: NetworkImage('https://ujap.checkmy.dev/storage/teams/'+teamNameandlogo[0]['logo'].toString()),
                                                          ),

                                                        ),
                                                        teamNameandlogo == null ? Container() :
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                        Container(
                                                          width: screenwidth,
                                                          child: Text(teamNameandlogo == null ? '' : teamNameandlogo[0]['name'].toString(),style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70 : 20,fontFamily: 'Google-Bold'),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 30 : 50),
                                        height: screenheight/12,
                                        width: screenwidth,
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Text('SIÈGE',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/80 : 16,fontFamily: 'Google-Bold', color: Color.fromRGBO(74, 116, 148, 0.9),),textAlign: TextAlign.left,),
                                              alignment: Alignment.centerLeft,
                                              width: screenwidth,
                                            ),
                                            SizedBox(
                                              height: screenwidth < 700 ? screenheight/60 : 20,
                                            ),
                                            Container(
                                              height: screenheight/40,
                                              width: screenwidth,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Container(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text('VIP',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/60 : 22,fontFamily: 'Google-Bold'),textAlign: TextAlign.left,),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 5,
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                          border: Border.symmetric(vertical: BorderSide(color: Colors.black,width: screenwidth < 700 ? 1 : 2))
                                                      ),
                                                      child: Text('RANG 8',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/60 : 22,fontFamily: 'Google-Bold'),textAlign: TextAlign.center,),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 4,
                                                    child: Container(
                                                      alignment: Alignment.center,
                                                      child: Text('SIÈGE 200',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/60 : 22,fontFamily: 'Google-Bold'),textAlign: TextAlign.center,),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: screenwidth < 700 ? screenheight/5 : screenheight/6,
                                          width: screenwidth,
                                          margin: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 30 : 50),
                                          child: ListView(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.all(0),
                                            physics: NeverScrollableScrollPhysics(),
                                            children: [
                                              Container(
                                                child: Text('DÉTAILS',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/80 : 16,fontFamily: 'Google-Bold', color: Color.fromRGBO(74, 116, 148, 0.9),),textAlign: TextAlign.left,),
                                                alignment: Alignment.centerLeft,
                                                width: screenwidth,
                                              ),
                                              SizedBox(
                                                height: screenheight/100,
                                              ),
                                              Container(
                                                height: screenwidth < 700 ? screenwidth/10 : screenwidth/12,
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  width :  screenwidth/2.4 ,
                                                  height: screenwidth/2.4,
                                                  alignment: Alignment.centerLeft,
                                                  child: Image(
                                                    fit: BoxFit.contain,
                                                    color: Color.fromRGBO(204, 44, 65, 0.9),
                                                    image: AssetImage('assets/home_icons/staples_icon.png'),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: screenwidth < 700 ? 0 : 10,
                                              ),
                                              Container(
                                                child: Text('Saison Régulière FRANCE - PRO B',style: TextStyle(fontSize: screenwidth < 700 ?  screenheight/50 : 30,fontFamily: 'Google-Bold', color: Colors.black,),textAlign: TextAlign.left,),
                                                alignment: Alignment.centerLeft,
                                                width: screenwidth,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ligula sapien. lacinia dapidus sem vel. auctor posuere ex. Nullam scelerisque, diam eget mallesuada dignissm.'
                                                  ,style: TextStyle(fontSize: screenwidth < 700 ? screenheight/90 : 17,fontFamily: 'Google-Regular', color: Colors.black,),textAlign: TextAlign.left,),
                                                alignment: Alignment.centerLeft,
                                                width: screenwidth,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Stack(
                                        children: [
                                          Container(
                                            width: screenwidth,
                                            padding: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 10 : 50),
                                            height: screenwidth < 700 ? screenheight/25 : 60,
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    width: screenwidth,
                                                    height: screenheight/2,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Expanded(
                                                    child:Container(
                                                      width: screenwidth,
                                                      padding: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 10 : 50),
                                                      decoration: DottedDecoration(
                                                          shape: Shape.line, linePosition: LinePosition.top,color: Colors.grey[300]
                                                      ),
                                                    )
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: screenwidth,
                                            height: screenwidth < 700 ? screenheight/25 : 60,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  width: screenwidth < 700 ? 20 : 40,
                                                  height: screenheight,
                                                  decoration: new BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius: new BorderRadius.only(
                                                        topRight: const Radius.circular(40.0),
                                                        bottomRight: const Radius.circular(40.0),
                                                      )
                                                  ),
                                                ),
                                                Container(
                                                  width: screenwidth < 700 ? 20 : 40,
                                                  height: screenheight,
                                                  decoration: new BoxDecoration(
                                                      color: Colors.grey[200],
                                                      borderRadius: new BorderRadius.only(
                                                        bottomLeft: const Radius.circular(40.0),
                                                        topLeft: const Radius.circular(40.0),
                                                      )
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  width: screenwidth,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.only(
                                        bottomLeft: const Radius.circular(10.0),
                                        bottomRight: const Radius.circular(10.0),
                                      )
                                  ),
                                  child: ListView(
                                    padding: EdgeInsets.all(0),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 10,left: screenwidth < 700 ? screenheight/15 : screenheight/7,right: screenwidth < 700 ? screenheight/15 : screenheight/7),
                                        height: screenwidth < 700 ? screenheight/7 : 200,
                                        child: Image(
                                          fit: BoxFit.fitWidth,
                                          image: NetworkImage('https://i0.wp.com/www.chriswrites.com/wp-content/uploads/find-your-mac-serial-number.png?fit=960%2C350&ssl=1'),
                                        ),
                                      ),
                                      SizedBox(
                                          height: screenwidth < 700 ? screenheight/30 : 0,
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 20 : 100),
                                        child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
                                          ,style: TextStyle(fontSize: screenwidth < 700 ? screenheight/90 : 17,fontFamily: 'Google-Regular', color: Colors.black,),textAlign: TextAlign.center,),
                                        alignment: Alignment.center,
                                        width: screenwidth,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        TicketActions(),
                      ],
                    ),
                  ),
                ),
              );
      }
    );
  }
}
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/variables/events_sub_pages_variables.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/messages_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/curve_containers.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/download_pdf%202.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/sendGmail.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/ticket_actions.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/view_download_pdf.dart';

import '../../../controllers/home.dart';
import '../../../services/api.dart';
import '../message_children_page/list_of_clients.dart';
import '../message_children_page/new_message_page.dart';

List teamNameandlogo;
List homeNameandlogo;
List eventsAttended_client;

class Ticket_homepage extends StatefulWidget {
  final Map detail;
  final String _matchID,_image,_visitorID,_homeID,_ticketID, matchName;
  Ticket_homepage(this._matchID,this._image,this._visitorID,this._homeID,this._ticketID,this.matchName,this.detail);

  @override
  _Ticket_homepageState createState() => _Ticket_homepageState();
}

class _Ticket_homepageState extends State<Ticket_homepage> {
  List _eventStatus;
  bool _downloadLoading = false;
  int _loadingPercent = 0;
  var _attend_pass = "No";

  Stream _ticket()async*{
    setState((){
      loadingIndicator = loadingIndicator;
      _downloadLoading = _downloadLoading;
    });
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTicketData(widget._ticketID.toString()).then((value){
      print("TICKET DATA ${value}");
      setState((){
        ticketFilename = value[0]['filename'];
      });
    });
    getPermission();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
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
          GestureDetector(
            child: Container(
              margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(1000.0)
                ),
                padding: EdgeInsets.all(screenwidth < 700 ? 2 : 3),
                child: Icon(Icons.arrow_back_rounded,color: Colors.white,size: 30,)),
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
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.only(left: 20,bottom: 20,right: 20,top: 80),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(248, 248, 248, 0.9),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.matchName.toString().toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black),maxLines: 1,overflow: TextOverflow.ellipsis,),
                    SizedBox(
                      height: 3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(matchDate.toString(),style: TextStyle(fontSize: 13,fontFamily: 'Google-Medium',color: Colors.black),),
                        SizedBox(
                          width: screenwidth < 700 ? 5 : 15,
                        ),
                        Text(matchTime.toString(),style: TextStyle(fontSize: 13,fontFamily: 'Google-Medium',color: Colors.black),),
                      ],
                    )
                  ],
                )),
                Container(
                  width: double.infinity,
                  height: 110,
                  child: Row(
                    children: [
                  widget.detail["match"]["home_court"] == 1 ?
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        homeNameandlogo == null ? Container() :
                        Image(
                          fit: BoxFit.contain ,
                          width: 60,
                          image: NetworkImage('https://ujap.checkmy.dev/storage/teams/'+homeNameandlogo[0]['logo'].toString()),
                        ),
                        Text(homeNameandlogo[0]['name'].toString().toUpperCase(),style: TextStyle(fontSize: 11,fontFamily: 'Google-Bold',color: Colors.grey[800]),textAlign: TextAlign.center,),
                      ],
                    ),
                  ) :
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image(
                          fit: BoxFit.contain ,
                          width: 60,
                          image: NetworkImage(teamNameandlogo.toString() == "[]" ? "https://static.thenounproject.com/png/340719-200.png" : 'https://ujap.checkmy.dev/storage/teams/'+teamNameandlogo[0]['logo'].toString()),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 100,
                          child: Text( teamNameandlogo.toString() == "[]" ? "Pas de nom d'équipe adverse".toUpperCase() : teamNameandlogo[0]['name'].toString().toUpperCase(),style: TextStyle(fontSize: 11,fontFamily: 'Google-Bold',color: Colors.grey[800]),textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,),
                        )
                      ],
                    ),
                  ),
                  Text('VS',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/30 : 35,color: Color.fromRGBO(20, 74, 119, 0.9),fontFamily: 'Google-Bold'),),
                  widget.detail["match"]["home_court"] == 1 ?
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          fit: BoxFit.contain ,
                          width: 60,
                          image: NetworkImage(teamNameandlogo.toString() == "[]" ? "https://static.thenounproject.com/png/340719-200.png" : 'https://ujap.checkmy.dev/storage/teams/'+teamNameandlogo[0]['logo'].toString()),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 100,
                          child: Text( teamNameandlogo.toString() == "[]" ? "Pas de nom d'équipe adverse".toUpperCase() : teamNameandlogo[0]['name'].toString().toUpperCase(),style: TextStyle(fontSize: 11,fontFamily: 'Google-Bold',color: Colors.grey[800]),textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,),
                        )
                      ],
                    ),
                  ) :
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        homeNameandlogo == null ? Container() :
                        Image(
                          fit: BoxFit.cover ,
                          width: 50,
                          image: NetworkImage('https://ujap.checkmy.dev/storage/teams/'+homeNameandlogo[0]['logo'].toString()),
                        ),
                        Text(homeNameandlogo[0]['name'].toString().toUpperCase(),style: TextStyle(fontSize: 11,fontFamily: 'Google-Bold',color: Colors.grey[800]),textAlign: TextAlign.center,),
                      ],
                    ),
                  )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SIÈGE',style: TextStyle(fontSize: screenwidth < 700 ? 13 : 16,fontFamily: 'Google-Bold', color: Color.fromRGBO(74, 116, 148, 0.9),),textAlign: TextAlign.left,),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text('VIP',style: TextStyle(fontFamily: 'Google-Bold'),textAlign: TextAlign.left,),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  border: Border.symmetric(vertical: BorderSide(color: Colors.black,width: screenwidth < 700 ? 1 : 2))
                              ),
                              child: Text('RANG 8',style: TextStyle(fontFamily: 'Google-Bold'),textAlign: TextAlign.center,),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text('SIÈGE 200',style: TextStyle(fontFamily: 'Google-Bold'),textAlign: TextAlign.center,),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text('DÉTAILS',style: TextStyle(fontSize: screenwidth < 700 ? 13 : 16,fontFamily: 'Google-Bold', color: Color.fromRGBO(74, 116, 148, 0.9),),textAlign: TextAlign.left,),
                      SizedBox(
                        height: 15,
                      ),
                      Image(
                        fit: BoxFit.contain,
                        width: 160,
                        color: Color.fromRGBO(204, 44, 65, 0.9),
                        image: AssetImage('assets/home_icons/staples_icon.png'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Saison Régulière FRANCE - PRO B',style: TextStyle(fontFamily: 'Google-Bold', color: Colors.black,),textAlign: TextAlign.left,),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ligula sapien. lacinia dapidus sem vel. auctor posuere ex. Nullam scelerisque, diam eget mallesuada dignissm.'
                        ,style: TextStyle(fontSize: 11,fontFamily: 'Google-Regular', color: Colors.black,),textAlign: TextAlign.left,),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      width: screenwidth,
                      decoration: DottedDecoration(
                          shape: Shape.line, linePosition: LinePosition.top,color: Colors.grey[300]
                      ),
                    ),
                    Container(
                      width: screenwidth,
                      height: 40,
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(1000),
                                bottomRight: Radius.circular(1000)
                              )
                            ),
                          ),
                          Spacer(),
                          Container(
                            width: 20,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(1000),
                                    bottomLeft: Radius.circular(1000)
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  width: double.infinity,
                  child: Center(child: Text("ACTION DE BILLET:",style: TextStyle(fontFamily: 'Google-Bold', color: Colors.grey[800],fontSize: 13),textAlign: TextAlign.center,)),
                ),
                SizedBox(
                  height: 10,
                ),
                StreamBuilder(
                  stream: _ticket(),
                  builder: (context, snapshot) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Container(
                              width: 55,
                              height: 55,
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(247, 171, 45, 0.9),
                                  borderRadius: BorderRadius.circular(1000)
                              ),
                              child: Image(
                                color: Colors.white,
                                image: AssetImage('assets/home_icons/email.png'),
                              )
                          ),
                          onTap: (){
                            opponentTeam = teamNameandlogo[0]['name'].toString();
                            sendGmailValidation = true;
                            uploadPDF();
                            Navigator.push(context, PageTransition(child:  SendGmail(
                            ),type: PageTransitionType.leftToRightWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          child: Container(
                              width: 55,
                              height: 55,
                              margin: EdgeInsets.all(5),
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(238, 124, 65, 0.9),
                                  borderRadius: BorderRadius.circular(1000)
                              ),
                              child: Image(
                                color: Colors.white,
                                image: AssetImage('assets/home_icons/message.png'),
                              )
                          ),
                          onTap: (){
                            setState(() {
                              print(ticketFilename.toString());
                              uploadPDF();
                              currentindex = 2;
                              indexListener.update(data: 2);
                              Navigator.push(context, PageTransition(child: NewMessage(), type: PageTransitionType.leftToRightWithFade));
                            });
                          },
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        _downloadLoading && loadingIndicator != 100 ?
                        Stack(
                          children: [
                            Container(
                                width: 55,
                                height: 55,
                                child: CircularProgressIndicator(
                                )),
                            Container(
                              width: 55,
                              height: 55,
                              child: Center(
                                child: Icon(Icons.file_download,color: kPrimaryColor,size: 25,),
                              ),
                            )
                          ],
                        )
                            : Builder(
                            builder: (context)=> GestureDetector(
                              child: Container(
                                  width: 55,
                                  height: 55,
                                  decoration: BoxDecoration(
                                      color: Color.fromRGBO(46, 170, 221, 0.9),
                                      borderRadius: BorderRadius.circular(1000)
                                  ),
                                  child: loadingIndicator == 100 ?
                                  Container(
                                    child: Center(
                                        child: Icon(Icons.visibility,size: 27,color: Colors.white,)),
                                  ) :
                                  Container(
                                    child: Center(
                                        child: Icon(Icons.file_download,size: 27,color: Colors.white,)),
                                  )
                              ),
                              onTap: (){
                                if (loadingIndicator == 100) {
                                  Navigator.push(context, PageTransition(child: ViewDownloadPdf(
                                  ),type: PageTransitionType.leftToRightWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
                                }
                                else{
                                  setState(() {
                                    showSnackBar_download(context, 'Démarrage du téléchargement du ticket ..',Icon(Icons.file_download));
                                    uploadPDF();
                                    _downloadLoading = true;
                                  });
                                }
                              },
                            )),
                      ],
                    );
                  }
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
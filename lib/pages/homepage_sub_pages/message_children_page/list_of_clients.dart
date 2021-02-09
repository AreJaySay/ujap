import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/messages_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/speech_to_text.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/sendGmail.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/conversation_listener.dart';

bool sendGmailValidation = false;
var clientGmail = "";
TextEditingController searchboxEvents = new TextEditingController();
var tosearch_clients = "";

class Clients_list extends StatefulWidget {
  @override
  _Clients_listState createState() => _Clients_listState();
}

class _Clients_listState extends State<Clients_list> {
  var _finaleventsTime;
  var _timeConvertedString = "";
  int _timeConverted;
  int _finalTimeEvent;
  var _dateConvertedString = "";
  var _dateConvertedDayYear = "";
  List _teamName;
  int _searchbyIndex = 2;

  List _eventsData;

  Stream _searchEvents() async* {
    setState(() {
      events_clients = client_backup.where((s){
        return s['name'].toString().toLowerCase().contains(tosearch_clients.toString().toLowerCase());
      }).toList();

    });
  }

  var searchdateevents = "";
  bool date_textfields = true;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchboxEvents.text = "";
    tosearch_clients = "";
  }

  @override
  Widget build(BuildContext context) {
    // return StreamBuilder(
    //     stream: _searchEvents(),
    //     builder: (context, snapshot) {
          return Scaffold(
              body: Stack(children: [
            Scaffold(
                appBar: AppBar(
                  backgroundColor: Color.fromRGBO(5, 93, 157, 0.9),
                  automaticallyImplyLeading: false,
                  actions: [
                    Expanded(
                      flex: 1,
                      child:
                      Container(
                        width: screenwidth,
                        height: screenheight,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios,
                              size: screenwidth < 700 ? 23 : 30),
                          onPressed: () {
                            setState(() {
                              Navigator.of(context).pop(null);
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        width: screenwidth,
                        height: screenheight,
                        alignment: Alignment.center,
                        child: TextField(
                          controller: searchboxEvents,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Google-Regular',
                              fontSize:
                                  screenwidth < 700 ? screenheight / 52 : 22),
                          decoration: InputDecoration(
                            hintText: 'Rechercher ',
                            hintStyle: TextStyle(
                                color: Colors.white30,
                                fontFamily: 'Google-Regular',
                                fontSize:
                                    screenwidth < 700 ? screenheight / 52 : 22),
                            border: InputBorder.none,
                          ),
                          onChanged: (text_search) {
                            setState(() {
                              tosearch_clients = text_search;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: searchboxEvents.text.isNotEmpty ||
                              searchboxEvents.text != ""
                          ? Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Container(),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close,
                                        size: screenwidth < 700 ? 23 : 30),
                                    onPressed: () {
                                      searchboxEvents.text = "";
                                      tosearch_clients = "";
                                    },
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Container(),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.mic_none,
                                        size: screenwidth < 700 ? 23 : 30),
                                    onPressed: () {
                                      setState(() {
                                        Navigator.push(context, PageTransition(child:  SpeechToText(
                                        ),type: PageTransitionType.rightToLeftWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
                body: Container(
                  width: screenwidth,
                  height: screenheight,
                  child: Stack(
                    children: [
                      Container(
                        width: screenwidth,
                        height: screenheight,
                        child: Center(
                          child: Container(
                            width: screenwidth / 1.5,
                            height: screenwidth / 1.5,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage("assets/logo.png"),
                            )),
                          ),
                        ),
                      ),
                      Container(
                        width: screenwidth,
                        height: screenheight,
                        color: Color.fromRGBO(5, 93, 157, 0.9),
                      ),
                      Container(
                        width: screenwidth,
                        height: screenheight,
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10)),
                        child: events_clients.length == 0
                            ? Container(
                                width: screenwidth,
                                height: screenheight,
                                decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10)),
                                margin: EdgeInsets.symmetric(
                                    horizontal: screenwidth / 18,
                                    vertical: screenwidth / 15),
                                alignment: AlignmentDirectional.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image(
                                      fit: BoxFit.contain,
                                      width: screenwidth / 2,
                                      image: AssetImage('assets/sad.jpg'),
                                    ),
                                    SizedBox(
                                      height: screenwidth / 50,
                                    ),
                                    Text(
                                      'NO RESULTS FOUND',
                                      style: TextStyle(
                                          fontSize: screenheight / 45,
                                          fontFamily: 'Google-Bold',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54),
                                    ),
                                    SizedBox(
                                      height: screenwidth / 20,
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenwidth / 8,
                                            vertical: screenwidth / 50),
                                        decoration: BoxDecoration(
                                            color:
                                                Color.fromRGBO(5, 93, 157, 0.9),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          'CLOSE',
                                          style: TextStyle(
                                              fontSize: screenheight / 60,
                                              fontFamily: 'Google-Bold',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          tosearch_clients = "";
                                          searchboxEvents.text = "";
                                        });
                                      },
                                    )
                                  ],
                                ))
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenwidth < 700
                                        ? screenwidth / 20
                                        : screenwidth / 30),
                                scrollDirection: Axis.vertical,
                                physics: BouncingScrollPhysics(),
                                itemCount: events_clients.length,
                                itemBuilder: (context, int index) {
                                  return GestureDetector(
                                    child: events_clients[index]['email'].toString() == userdetails['email'].toString() ? Container() : Container(
                                      width: screenwidth,
                                      height: screenheight / 10,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: screenwidth / 20,
                                          vertical: screenwidth / 60),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: screenwidth / 100,
                                          ),
                                          events_clients[index]['filename'].toString() == 'null' ?
                                          Container(
                                            width: 55,
                                            height: 55,
                                            margin: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  1000.0),
                                            ),
                                            child: Image(
                                              color: Colors.black87.withOpacity(0.7),
                                              image:  AssetImage('assets/messages_icon/no_profile.png'),
                                            ),
                                          ) :
                                          Container(
                                            width: 55,
                                            height: 55,
                                            margin: EdgeInsets.all(5),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(1000.0),
                                               border: Border.all(color: Colors.black),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage('https://ujap.checkmy.dev/storage/clients/'+events_clients[index]['filename'].toString())
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: screenwidth / 100,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    events_clients[index]
                                                            ['name'].toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'Google-Bold',
                                                        fontSize:
                                                            screenheight / 50),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(
                                                    height: screenwidth / 100,
                                                  ),
                                                  Text(
                                                    events_clients[index]
                                                            ['email']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black54,
                                                        fontFamily:
                                                            'Google-Medium',
                                                        fontSize:
                                                            screenheight / 65),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      Map dd = await conversationService.checkConvoMembersExist(memberIds: [userdetails['id'], int.parse(receiverID_public)]);
                                      setState(() {
                                        List receiverDetails;

                                        // if (sendGmailValidation){
                                        //   clientGmail = events_clients[index]['email'].toString();
                                        //   sendmessageTo = events_clients[index]['name'].toString();
                                        //   attachments.add(pdfFile.path);
                                        //   uploadPDF();
                                        //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SendGmail(
                                        //   )));
                                        //   // sendGmail(context,clientGmail)
                                        // }
                                        // else{
                                          try{

                                            print(sendmessageTo);
                                            setState(() {
                                              sendmessageTo = events_clients[index]['name'].toString();
                                              receiverID_public = events_clients[index]['id'].toString();
//                                              receiverDetails = events_clients[index];
                                            });
//                                            if (privateMessages != null) {
//                                              receiverDetails = privateMessages.where((s){
//                                                return s['members'].toString().contains(sendmessageTo.toString());
//                                              }).toList();
//                                            }

                                            print('RESULT : $events_clients');
                                            if(conversationService.checkConvoMembersExist(memberIds: [userdetails['id'], int.parse(receiverID_public)]) == null){
                                              createChannel(context, true, '');
                                            }else{
                                              senderID = dd['id'].toString();
                                            }

//                                            if (receiverDetails.toString() == "[]"){
//                                              createChannel(context, true, "");
//                                            }else{
//                                              senderID = receiverDetails[0]['id'].toString();
//                                            }
                                            Navigator.of(context).pop(null);
                                          }catch(e){
                                            print("$e");
                                          }
                                        // }
                                      });
                                    },
                                  );
                                }),
                      ),
//                View_matches(),
                    ],
                  ),
                ))
          ]));
        // });
  }
}

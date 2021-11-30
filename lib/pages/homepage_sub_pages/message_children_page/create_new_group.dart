import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujap/controllers/home.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/messages_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/show_loader.dart';
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/globals/widgets/speech_to_text.dart';
import 'package:ujap/pages/drawer_page.dart';
import 'package:ujap/pages/homepage_sub_pages/message_parent_page.dart';
import 'package:ujap/services/api.dart';
import 'package:http/http.dart' as http;

bool addMembers = false;
bool hideLoading = false;
List<String> deleteMember = List<String>();

class CreateNewGroup extends StatefulWidget {
  List convo_members;
  bool toAdd = false;
  CreateNewGroup(this.convo_members, this.toAdd);
  @override
  _CreateNewGroupState createState() => _CreateNewGroupState();
}

class _CreateNewGroupState extends State<CreateNewGroup> {
  TextEditingController _searchboxEvents = new TextEditingController();
  TextEditingController _createGroup = new TextEditingController();
  var _tosearch = "";
  var _searchClient = "";
  List _checked = [];

  Stream successCreate()async*{
    setState(() {
      addMembers = addMembers;
    });
  }

  removeMember(context,clientName,clientID)async{
    showloader(context);
    var response = await http.delete(Uri.parse('https://ujap.checkmy.dev/api/client/channel/delete-member?id=${clientID.toString()}'),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $accesstoken",
          "Accept": "application/json"
        },
    );
    var jsonData = json.decode(response.body);
    print('RETURN REMOVE MEMBERS :'+jsonData.toString());
    if (response.statusCode == 200){
      Navigator.of(context).pop(null);
      showSnackBar(context, '$clientName a bien été supprimé du groupe.');
    }
    else
    {
    }
  }

  List currentMember;
  //
  // getCurrentMember(){
  //   currentMember = widget.convo_members.where((s){
  //     return s[]
  //   }).toList();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_checked.isNotEmpty){
      _checked.clear();
      senderID = "";
    }
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: successCreate(),
      builder: (context, snapshot) {
        return GestureDetector(
          child: Stack(
            children: <Widget>[
              Scaffold(
                  appBar:  AppBar(
                    backgroundColor: kPrimaryColor,
                    automaticallyImplyLeading: false,
                    actions: [
                      Expanded(
                        flex: 1,
                        child:
                        Container(
                          width: screenwidth,
                          height: screenheight,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios,size: screenwidth < 700 ? 23 : 30),
                            onPressed: (){
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
                            controller: _searchboxEvents,
                            style: TextStyle(color: Colors.white, fontFamily: 'Google-Regular',fontSize: screenwidth < 700 ? screenheight/52 : 22),
                            decoration: InputDecoration(
                              hintText: 'Rechercher clients',
                              hintStyle: TextStyle( color: Colors.white30, fontFamily: 'Google-Regular',fontSize: screenwidth < 700 ? screenheight/52 : 22),
                              border: InputBorder.none,
                            ),
                            onChanged: (text_search){
                              setState(() {
                                _tosearch = text_search;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child:  _searchboxEvents.text.isNotEmpty || _searchboxEvents.text != "" ?
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Container(),
                                onPressed: (){},
                              ),
                              IconButton(
                                icon: Icon(Icons.close,size: screenwidth < 700 ? 23 : 30),
                                onPressed: (){
                                  setState(() {
                                    _searchboxEvents.text = "";
                                    _tosearch = "";
                                  });
                                },
                              ),
                            ],
                          ),
                        ) : Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Container(),
                                onPressed: (){},
                              ),
                              IconButton(
                                icon: Icon(Icons.mic_none,size: screenwidth < 700 ? 23 : 30),
                                onPressed: (){
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
                  body:  Container(
                    width: screenwidth,
                    height: screenheight,
                    color: Colors.white,
                    child: Column(
                      children: [
                        addMembers || widget.convo_members != null ?  Container () : SizedBox(
                          height: screenheight/30,
                        ),
                        addMembers|| widget.convo_members != null ?  Container () : Container(
                            width: screenwidth,
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('Nom du groupe'.toUpperCase(),style:  TextStyle(color: Colors.black54,fontFamily: 'Google-Medium',fontSize: screenwidth < 700 ? screenheight/60 : 22),)
                        ),
                        addMembers || widget.convo_members != null ? Container () : SizedBox(
                          height: screenheight/50,
                        ),
                        addMembers || widget.convo_members != null ? Container () : Container(
                          width: screenwidth,
                          height: screenwidth < 700 ? screenheight/15 : 60,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: TextField(
                            controller: _createGroup,
                            style: TextStyle(fontFamily: 'Google-Regular',fontSize: screenwidth < 700 ? screenheight/50 : 22),
                            decoration: InputDecoration(
                              suffixIcon: _searchClient == "" ? null :
                              Builder(
                                builder: (context)=> GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0))
                                    ),
                                      width : screenwidth < 700 ? screenheight/15 : 60,
                                    child: Icon(Icons.done,size: screenwidth < 700 ? 25 : 30,color: Colors.white,),
                                  ),
                                  onTap: (){
                                    setState(() {
                                      hideLoading = true;
                                      createChannel(context, false, groupChatName);
                                    });
                                  },
                                ),
                              ),
                                hintText: 'Nom de groupe',
                                hintStyle: TextStyle(color: Colors.grey[300],fontFamily: 'Google-Regular',fontSize: screenwidth < 700 ? screenheight/50 : 22),
                                contentPadding: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 20 : 40,vertical: screenwidth < 700 ? 0 : 20),
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey[300]),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.blue[200]),

                                )
                            ),
                            onChanged: (text){
                              setState(() {
                                _searchClient = text;
                                 groupChatName = text.toString();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: screenwidth,
                            height: screenheight,
                            child: Stack(
                              children: [
                                ListView.builder(
                                    padding: EdgeInsets.symmetric(
                                        vertical: screenwidth < 700
                                            ? screenwidth / 20
                                            : screenwidth / 30),
                                    scrollDirection: Axis.vertical,
                                    physics: BouncingScrollPhysics(),
                                    itemCount: events_clients.length,
                                    itemBuilder: (context, int index) {
                                      return GestureDetector(
                                        child: events_clients[index]['email'].toString() == userdetails['email'].toString() ? Container() :
                                        Container(
                                          width: screenwidth,
                                          child: Slidable(
                                            actionPane: SlidableDrawerActionPane(),
                                            actionExtentRatio: 0.25,
                                            enabled: !widget.convo_members.toString().contains(events_clients[index]['email'].toString()) ? false : true,
                                            child: Container(
                                              width: screenwidth,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.circular(10)),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 20,vertical: 5
                                                ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: screenwidth < 700 ? 60 : 80,
                                                    height: screenwidth < 700 ? 60 : 80,
                                                    margin: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(1000.0),
                                                      border: Border.all(color: Colors.black,width: 1.5),
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: events_clients[index]['filename'].toString() == 'null' ?
                                                          AssetImage('assets/messages_icon/no_profile.png') :
                                                          NetworkImage('https://ujap.checkmy.dev/storage/clients/'+events_clients[index]['filename'].toString())
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
                                                          Text(events_clients[index]['name'].toString(),style: TextStyle(color: Colors.black, fontFamily: 'Google-Bold', fontSize: screenheight / 50),
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
                                                  ),
                                                 widget.convo_members == null || deleteMember.toString().contains(events_clients[index]['name'].toString()+senderID.toString()+userdetails.toString())  ? Container(
                                                    child: !addMembers ? Container () : _checked.toString().contains(events_clients[index].toString()) ? IconButton(
                                                      icon: Icon(Icons.check_box,size: screenwidth < 700 ? 25 : 30,color: kPrimaryColor,),
                                                      onPressed: (){
                                                        setState(() {
                                                          _checked.remove(events_clients[index].toString());
                                                        });
                                                      },
                                                    ) : Builder(
                                                      builder:(context)=> IconButton(
                                                        icon: Icon(Icons.check_box_outline_blank,size: screenwidth < 700 ? 25 : 30,),
                                                        onPressed: (){
                                                          setState(() {
                                                            _checked.add(events_clients[index].toString());
                                                            receiverID_public = events_clients[index]['id'].toString();
                                                            sendmessageTo = events_clients[index]['name'].toString();
                                                            message_compose_open = false;
                                                            AddChannel(context);
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ) :
                                                 Container(
                                                   child: widget.convo_members.toString().contains(events_clients[index]['email'].toString()) ? Container(
                                                     child: Column(
                                                       children: <Widget>[
                                                         Icon(Icons.person_add_alt,size: screenwidth < 700 ? 25 : 30,),
                                                         Text('Membre',style: TextStyle(color: kPrimaryColor, fontFamily: 'Google-Bold', fontSize: screenheight / 70),),
                                                       ],
                                                     )
                                                   ) : _checked.toString().contains(events_clients[index].toString()) ?
                                                   IconButton(
                                                     icon: Icon(Icons.check_box,size: screenwidth < 700 ? 30 : 35,color: kPrimaryColor,),
                                                     onPressed: (){
                                                       setState(() {
                                                         _checked.remove(events_clients[index].toString());
                                                       });
                                                     },
                                                   ) :  Builder(
                                                     builder:(context)=> IconButton(
                                                        icon: Icon(Icons.check_box_outline_blank,size: screenwidth < 700 ? 25 : 30,),
                                                        onPressed: (){
                                                          setState(() {
                                                            print('asdasdasd');
                                                            _checked.add(events_clients[index].toString());
                                                            receiverID_public = events_clients[index]['id'].toString();
                                                            sendmessageTo = events_clients[index]['name'].toString();
                                                            AddChannel(context);
                                                          });
                                                        },
                                                      ),
                                                   ),
                                                 ),
                                                ],
                                              ),
                                            ),
                                            secondaryActions: <Widget>[
                                              Container(
                                                child: IconSlideAction(
                                                  iconWidget: Container(
                                                      color: Colors.white,
                                                      alignment: Alignment.center,
                                                      child: Center(
                                                        child: Container(
                                                          height: 60,
                                                          width: 60,
                                                          padding: EdgeInsets.all(5),
                                                          child: Column(
                                                            mainAxisAlignment:   MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              Container(
                                                                  padding: EdgeInsets.all(5),
                                                                  decoration: BoxDecoration(
                                                                      color: kPrimaryColor,
                                                                      borderRadius: BorderRadius.circular(1000.0)
                                                                  ),
                                                                  child: Icon(Icons.person_remove_alt_1_outlined,color: Colors.white,size: screenwidth < 700 ? 25 : 30)),
                                                              Text('Retirer'.toString(),style: TextStyle(color: kPrimaryColor,fontFamily: 'Google-Bold',fontSize: screenheight/75 )),
                                                            ],
                                                          ),
                                                        ),
                                                      )),
                                                  onTap: ()async{
                                                    List<String> localDeleteMember = List<String>();
                                                    setState(() {
                                                      if (deleteMember.toString().contains(events_clients[index]['name'].toString()+senderID.toString()+userdetails.toString())){
                                                        deleteMember.add(events_clients[index]['name'].toString()+senderID.toString()+userdetails.toString());
                                                      }
                                                      else{
                                                        localDeleteMember.add(events_clients[index]['name'].toString()+senderID.toString()+userdetails.toString());
                                                        deleteMember = localDeleteMember;
                                                      }
                                                      });
                                                      SharedPreferences prefs_deleted = await SharedPreferences.getInstance();
                                                      prefs_deleted.setStringList('deleteMember', deleteMember);

                                                      showSnackBar(context, 'Membre supprimé avec succès');
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ),
                        !addMembers ? Container() :
                        GestureDetector(
                          child: Container(
                            height: screenwidth < 700 ? screenwidth/7.5 : screenwidth/12,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Text('Done',style: TextStyle(color: Colors.white, fontFamily: 'Google-Bold', fontSize: screenheight / 40),)
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              currentindex = 2;
                              indexListener.update(data: 2);
                              Navigator.pushReplacement(context,PageTransition(child: MainScreen(false),type: PageTransitionType.fade));
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
              ),
              !hideLoading ? Container() : Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Groupe en cours de création, veuillez patienter ...',style: TextStyle(color: Colors.white, fontFamily: 'Google-Regular', fontSize: screenheight / 45,decoration: TextDecoration.none),textAlign: TextAlign.center,)
                    ],
                  ),
                ),
              )
            ],
          ),
          onTap: (){
            setState(() {
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            });
          },
        );
      }
    );
  }
}

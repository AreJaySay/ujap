import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:http/http.dart' as http;
import 'package:ujap/globals/widgets/show_loader.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/convo_settings_page.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/conversation_listener.dart';

bool changeName = false;

class ChangeGroupName extends StatefulWidget {
  Map channelDetails;
  ChangeGroupName(this.channelDetails);
  @override
  _ChangeGroupNameState createState() => _ChangeGroupNameState();
}

class _ChangeGroupNameState extends State<ChangeGroupName>{
  TextEditingController channelname = new TextEditingController();

  changeGroupName({String id, String name})async{
    showloader(context);
    print(name);
    var response = await http.post(Uri.parse("${conversationService.urlString}/channel/update_name"),
      body: {
         "id" : "$id",
        "name" : "$name"
      },
      headers: {
        HttpHeaders.authorizationHeader : "Bearer $accesstoken"
        }
    );
     var result = jsonDecode(response.body);
     print(result['message']);
     if (response.statusCode == 200){
       setState(() {
         channelNameSetting = channelname.text.toString();
         changeName = false;
         getPersonMessage();
       });
       Navigator.of(context).pop(null);
     }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(0),
        width: screenwidth,
        height: screenheight,
        color: Colors.black.withOpacity(0.4),
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: screenwidth,
          height: !changeName ? 0 : screenwidth < 700 ? screenwidth/1.8 : screenwidth/3.3,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Nom de groupe:'.toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenwidth/30 : 20,fontFamily: 'Google-medium',color: Colors.grey[700]),),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 15 : 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[500]),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextField(
                        controller: channelname,
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: screenwidth < 700 ? screenwidth/30 : 20,color: Colors.grey[700]),
                        decoration: InputDecoration(
                          hintText: 'Nouveau nom de groupe',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey,fontSize: screenwidth < 700 ? screenwidth/30 : 20)
                        ),
                      ),
                      height: 50,
                      width: screenwidth,
                    ),
                  ],
                ),
              ),
              Material(
                child: GestureDetector(
                  child: Container(
                    width: screenwidth,
                    height: 50,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text('Changer de nom',style: TextStyle(fontWeight: FontWeight.w500,fontSize: screenwidth < 700 ? screenwidth/25 : 20,color: Colors.white),),
                    ),
                  ),
                  onTap: (){
                    setState(() {
                      changeGroupName(id: widget.channelDetails['id'].toString(),name: channelname.text.toString());
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        setState(() {
          changeName = false;
        });
      },
    );
  }
}

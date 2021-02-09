import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/matches.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/slider.dart';

class MessageHomepage extends StatefulWidget {
  final List messageList;
  final int index;
  MessageHomepage(this.messageList,this.index);
  @override
  _MessageHomepageState createState() => _MessageHomepageState();
}

class _MessageHomepageState extends State<MessageHomepage> {
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
          SizedBox(
            width: 10,
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1000),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[300],
                      blurRadius: 2,
                      offset: Offset(2,3)
                  )
                ],
                image: imageFetcher(widget.messageList[widget.index]['members'])
            ),
            child: widget.messageList[widget.index]['members'].length > 2 ? ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: memberGroup(widget.messageList[widget.index]['members'], 0)['detail']['filename'] == null ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${memberGroup(widget.messageList[widget.index]['members'], 0)['detail']['filename']}")
                            )
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: memberGroup(widget.messageList[widget.index]['members'], 1)['detail']['filename'] == null ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${memberGroup(widget.messageList[widget.index]['members'], 1)['detail']['filename']}")
                                  )
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: memberGroup(widget.messageList[widget.index]['members'], 2)['detail']['filename'] == null ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${memberGroup(widget.messageList[widget.index]['members'], 2)['detail']['filename']}")
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
            ) : Container(),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 60,
                width: screenwidth,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Text("${kahampang(widget.messageList[widget.index]['members'], widget.messageList[widget.index]['name'].toString())}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        width: double.infinity,
                        child: Text("${widget.messageList[widget.index]['last_convo'] == null ? "Pas de message" : "${widget.messageList[widget.index]['last_convo']['sender_id'] == userdetails['id'] ? "Toi" : widget.messageList[widget.index]['last_convo']['client']['name']} : ${widget.messageList[widget.index]['last_convo']['filename'] == null ? widget.messageList[widget.index]['last_convo']['message'] == null ? "" : widget.messageList[widget.index]['last_convo']['message'] : "A envoyé une pièce jointe"}"}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontStyle: widget.messageList[widget.index]['last_convo'] == null || widget.messageList[widget.index]['last_convo']['filename'] == null ? FontStyle.normal : FontStyle.italic,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
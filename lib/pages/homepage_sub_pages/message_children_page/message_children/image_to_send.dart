import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/other_variables.dart';

class ImageToSend extends StatefulWidget {
  String b64,messageToSend,type;
  bool sendMessage;
  ImageToSend(this.b64,this.messageToSend,this.type,this.sendMessage);
  @override
  _ImageToSendState createState() => _ImageToSendState();
}

class _ImageToSendState extends State<ImageToSend> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenwidth,
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(5)
            ),
            constraints: BoxConstraints(
                maxWidth: screenwidth/1.6
            ),
            child: widget.type.toString().contains('File') ?
            GestureDetector(
              onTap: () async {
              },
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: screenheight/5,
                ),
                child: Text("UJAP.pdf",style: TextStyle(
                    color:Colors.white,fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline
                ),),
              ),
            ) : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                widget.messageToSend.toString() == "" ? SizedBox() :
                Text("${widget.messageToSend.toString()}",style: TextStyle(
                    color: Colors.white,
                    fontSize: screenwidth < 700 ? screenwidth/30 : screenwidth/47
                ),),
                Builder(
                    builder: (context) {
                      return Container(
                        constraints: BoxConstraints(
                            maxHeight: screenheight/5
                        ),
                        child: GestureDetector(
                          onTap: (){
                          },
                          onLongPress: ()async{
                          },
                          child: Image.memory(base64.decode(widget.b64)),
                        ),
                      );
                    }
                )
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}

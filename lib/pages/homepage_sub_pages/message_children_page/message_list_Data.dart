import 'package:flutter/material.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/variables/messages_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';

class Messages_listview extends StatefulWidget {
  @override
  _Messages_listviewState createState() => _Messages_listviewState();
}

class _Messages_listviewState extends State<Messages_listview> {
  @override
  Widget build(BuildContext context) {
    return  Material(
          child: InkWell(
            child:  Container(
              width: screenwidth,
              height: screenheight/13,
              margin: EdgeInsets.only(bottom: screenwidth < 700 ? 7 : 17),
              child: Row(
                children: [
                  Container(
                    width:  screenwidth > 500 ? screenwidth/8.5 : screenwidth < 700 ? screenwidth/7 : screenwidth/10,
                    height:  screenwidth < 700 ? screenwidth/7 : screenwidth/10,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(1000),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage('https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80')
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenheight/80,
                  ),
                  Expanded(
                    flex: screenwidth < 700 ? 4 : 8,
                    child: Container(
                      width: screenwidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
//                          Container(
//                              width: screenwidth,
//                              child: Text(message_channel[index]['members'][0]['channel_id'].toString(),style: TextStyle(color: Colors.black,fontFamily: 'Google-Bold',fontSize: screenheight/65 ),overflow: TextOverflow.ellipsis,)),
                          SizedBox(
                            height: screenheight/170,
                          ),
                          Container(
                            width: screenwidth,
                            child: Text('Lorem ipsum dolor sit amet, consectetur adipscing elit.',style: TextStyle(color: Colors.grey[350],fontFamily: 'Google-Bold',fontSize: screenheight/80 )
                              ,overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: screenheight/80,
                  ),
                  Expanded(
                    flex: 1,
                    child:
                    Container(
                      width: screenwidth/1,
                      child: ListView(
                        padding: EdgeInsets.all(0),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Text('02:30 PM',style: TextStyle(color: Colors.grey[350],fontFamily: 'Google-Bold',fontSize: screenheight/70 )),
                          SizedBox(
                            height: screenheight/110,
                          ),
                          Container(
                            width: screenwidth,
                            margin: EdgeInsets.only(left: screenwidth < 700 ? screenwidth/9 : screenwidth/15),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 2,horizontal: screenwidth/170),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(5, 93, 157, 0.9),
                                borderRadius: BorderRadius.circular(3)
                            ),
                            child: Text('2',style: TextStyle(color: Colors.white,fontFamily: 'Google-Bold',fontSize: screenheight/75 )),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: (){
              setState(() {
                view_message_convo = true;
              });
            },
          ),

    );
  }
}
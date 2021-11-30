import 'package:flutter/material.dart';
import 'package:ujap/globals/variables/messages_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/message_list_Data.dart';

class View_message_tabbar extends StatefulWidget {
  @override
  _View_message_tabbarState createState() => _View_message_tabbarState();
}

class _View_message_tabbarState extends State<View_message_tabbar>  {
  TabController _tabController;


  @override
  Widget build(BuildContext context) {
    return  Container(
      width: screenwidth,
      padding: EdgeInsets.symmetric(horizontal: screenwidth/20),
      height: screenheight/1.7 ,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              child: TabBar(
                isScrollable: true,
                indicatorColor:  Colors.transparent,
                indicatorWeight: 3.0,
                unselectedLabelColor: Colors.grey[300],
                labelColor: Colors.black,
                labelPadding: EdgeInsets.only(left: screenheight/400),
                labelStyle:  TextStyle(fontFamily: 'Google-Bold',fontSize: screenwidth < 700 ? screenheight/60 : 20),
                tabs: [
                  Tab(text: 'Conversations'),

                  Container(
                    width: screenwidth < 700 ? screenwidth/3.5 : screenwidth/5,
                    child: new Tab(text: 'Groups'),
                  ),
                ],
                onTap: (index){
                  setState(() {
                    messageIndex = index.toString();
                  });
                },
              ),
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey[300]))
              ),
            ),
            SizedBox(
              height: screenheight/50,
            ),
            Expanded(
              child: Container(
                child: TabBarView(children: [
                  Container(
                    width: screenwidth,
                    height: screenheight,
                    child: Messages_listview(),
                  ),
                  Container(
                    width: screenwidth,
                    height: screenheight,
                  ),

                ]),
              ),
            )
          ],
        ),
      ),
    );

  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/events_sub_pages_variables.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';

class No_events_data extends StatefulWidget {
  @override
  _No_events_dataState createState() => _No_events_dataState();
}

class _No_events_dataState extends State<No_events_data> {

  ScrollController _scrollController;
  bool _isOnTop = true;

  _scrollListener() {
    setState(() {
      scrollPosition = _scrollController.position.pixels;
      print(scrollPosition.toString());
    });
  }

  _scrollToTop() {
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
    setState(() => _isOnTop = true);
  }

//  _scrollToBottom() {
//    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
//        duration: Duration(milliseconds: 1000), curve: Curves.easeOut);
//    setState(() => _isOnTop = false);
//  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenwidth,
      height: screenheight,
      child:
      Stack(
        children: [
          NotificationListener<ScrollUpdateNotification>(
            child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.only(top: screenwidth < 700 ? screenwidth/2.5 : screenwidth/4.5,bottom: screenwidth/10),
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, int index){
                  return Stack(
                    children: [
                      GestureDetector(
                        child: Container(
                          height: screenwidth < 700 ? screenheight/5 : screenheight/4.7,
                          margin: EdgeInsets.only(bottom: screenwidth < 700 ? 15 : 25,left: screenwidth < 700 ? screenwidth/15 :  screenwidth/18,right:  screenwidth < 700 ? screenwidth/15 :  screenwidth/18),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: screenheight/15,
                                width: screenwidth,
                                padding: EdgeInsets.symmetric(horizontal: screenwidth/5),
                                decoration: BoxDecoration(
                                    color:Color.fromRGBO(248, 248, 248, 0.9),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 15,
                                      width: screenwidth,
                                      child: loadingShimmering(),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 15,
                                      width: screenwidth,
                                      child: loadingShimmering(),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          width : screenwidth < 700 ? screenwidth/5 : screenwidth/7,
                                          height:  screenwidth < 700 ? screenwidth/5 : screenwidth/7,
                                          child:  Container(
                                            child: loadingShimmering(),
                                            margin: EdgeInsets.all(10),

                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(top:  screenheight/55),
                                          height: screenheight,
                                          width: screenwidth/4,
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
                                                  child: loadingShimmering(),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                height: 20,
                                                child: loadingShimmering(),
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Container(
                                                height: 20,
                                                child: loadingShimmering(),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width : screenwidth < 700 ? screenwidth/5 : screenwidth/7,
                                          height:  screenwidth < 700 ? screenwidth/5 : screenwidth/7,
                                          alignment: Alignment.center,
                                          child:  Stack(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                child: loadingShimmering(),
                                              ),
//
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }

            ),
            onNotification: (notification) {
              setState(() {
                if (notification.metrics.pixels >= 150.0){
                  hideFloatingbutton = true;
                }
                if(notification.metrics.pixels <= 50.0){
                  hideFloatingbutton = false;
                }
              });
            },
          ),
          !hideFloatingbutton ? Container() : Container(
            width: screenwidth,
            height: screenheight,
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.only(right: screenwidth/30,bottom: screenwidth/20),
            child:  Container(
              width: screenwidth < 700 ? screenwidth/7 : screenwidth/12,
              height: screenwidth < 700 ? screenwidth/7 : screenwidth/12,
              child: FloatingActionButton(
                heroTag: 'btn4',
                backgroundColor: kPrimaryColor,
                onPressed:  _scrollToTop,
                child: Icon(Icons.arrow_upward,size: screenwidth < 700 ? screenwidth/20 : screenwidth/30,),
              ),

            ),
          )
        ],
      ),
    );
  }
}

Widget loadingShimmering(){
  return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white
        ),
      )
  );
}
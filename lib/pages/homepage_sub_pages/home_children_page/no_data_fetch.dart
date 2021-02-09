
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:ujap/globals/variables/other_variables.dart';

class No_events_data_yet extends StatefulWidget {
  @override
  _No_events_data_yetState createState() => _No_events_data_yetState();
}

class _No_events_data_yetState extends State<No_events_data_yet> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: screenwidth,
      height: screenwidth < 700 ? screenheight/3.5 : screenheight/3.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Container(
            width: screenwidth,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(' évènements et matchs à venir'.toUpperCase(),style: TextStyle(fontFamily: 'Google-Bold',color: Colors.white,fontSize: screenwidth < 700 ? screenheight/60 : 23),),
              ],
            ),
          ),
          SizedBox(
            height: screenwidth/40,
          ),
          Container(
            width: screenwidth,
            height: screenwidth < 700 ? screenheight/3.5 : screenheight/4,
            child: CarouselSlider.builder(
                options: CarouselOptions(
                  viewportFraction: 0.8,
                  initialPage: 0,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 5),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal,
                ),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return  Stack(
                    children: [
                       Container(
                          width: screenwidth < 700 ? screenheight/2.5 : screenheight/1.9 ,
                          height: screenwidth < 700 ? screenheight/4.3 : screenheight/4,
                          margin: EdgeInsets.symmetric(horizontal:  screenwidth < 700 ? 10 : 0),
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
                                          margin: EdgeInsets.only(top:  screenheight/30),
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
                                                height: 10,
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
                       Container(
                          width: screenwidth < 700 ? screenheight/2.5 : screenheight/1.9 ,
                          height:  screenwidth < 700 ? screenheight/3.7 : screenheight/3.6,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: screenwidth < 700 ? screenwidth/7 : 80,
                            height: screenwidth < 700 ? screenwidth/7 : 80,
                            child: Image(
                              color: Color.fromRGBO(5, 93, 157, 0.7),
                              image: AssetImage('assets/home_icons/ticket.png'),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(1000)
                            ),
                            padding: EdgeInsets.all(screenwidth < 700 ? 10 : 15),
                          ),

                      )
                    ],
                  );}
            ),
//
          ),

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
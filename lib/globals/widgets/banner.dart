import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/pages/homepage.dart';
import 'package:ujap/services/ad_listener.dart';
import 'package:ujap/services/percentage.dart';
import 'package:ujap/services/string_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

class BannerDisplay {
//  StreamController<Map> controller = StreamController<Map>.broadcast(sync: true);
//  Stream get stream$ => controller.stream;
//  StreamSubscription subscription;
  BehaviorSubject<Map> _adData = BehaviorSubject.seeded(null);
  Stream get stream$ => _adData.stream;
  Map get current => _adData.value;

  int get position {
    print('POSITION :'+current.toString());
    if(this.current == null) {
      return -1;
    }
    if (this.current['position'].toString() != "null"){
      return int.parse(this.current['position'].toString());
    }
  }
  update(Map data) {
    _adData.add(data);
    print("CURRENT : $current");
  }
  Widget showBanner(context, {int position}) {
    return StreamBuilder(
      stream: this.stream$,
      builder: (context, _) {
          if(_.hasData && _.data['ad_type'] == 1 && position == int.parse(_.data['position'].toString())){
            return GestureDetector(
              onTap: () async {
                String url = '${_.data["link"]}';
                if (!await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication,)) {
                  throw 'Could not launch $url';
                }
              },
              child: Stack(
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        width: double.infinity,
                        height: Percentage().calculate(num: screenheight, percent: 25),
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[300],
                                  blurRadius: 2,
                                  offset: Offset(3,3)
                              )
                            ]
                        ),
                        child: Container(
                          width: double.infinity,
                          height: Percentage().calculate(num: screenheight, percent: 30) - 10,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.black54.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                  alignment: Alignment.topCenter,
                                  fit: _.data['content'].toString() == "null" || _.data['content'].toString() == ""  ? BoxFit.contain : BoxFit.cover,
                                  colorFilter: _.data['content'].toString() == "null" || _.data['content'].toString() == ""  ? null : ColorFilter.mode(Colors.black54.withOpacity(0.3),BlendMode.srcOver),
                                  image: _.data['content'].toString() == "null" || _.data['content'].toString() == ""  ? NetworkImage('https://static.thenounproject.com/png/1529460-200.png'): NetworkImage('${StringFormatter().strToObj(_.data['content'])['location']}')

                                // image: _.data['content'].toString() == "null" || _.data['content'].toString() == ""  ? NetworkImage('https://static.thenounproject.com/png/1529460-200.png'): NetworkImage('${StringFormatter().strToObj(_.data['content'])['location']}')
                              )
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                child: Text("${_.data['name']}",maxLines: 1,overflow: TextOverflow.visible,style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white
                                ),),
                              ),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: _.data['description'].toString() == "null" ? Container() : Text("${_.data['description']}",maxLines: 2,overflow: TextOverflow.visible,style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white
                                  ),textAlign: TextAlign.left,),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                  ),
                  for (var x = 0; x < 2; x++)
                    Container(
                      padding: EdgeInsets.only(top: 3),
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        child: Container(
                            decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(1000)
                            ),
                            child: Icon(Icons.close,color: Colors.white,size: screenwidth <  700 ? 25 : 35,)),
                        onTap: (){
                          print(_.data['content'].toString());
                          adListener.update(false);
                        },
                      ),
                    )
                ],
              ),
            );
          }
          return Container();
        }


    );
  }
  double heightCounter() {
    double h;
//    double adh = 0;
    if(screenwidth < 500){
      h = screenwidth/1.1;
    }else if(screenwidth < 700){
      h = 400;
    }else{
      h = screenwidth/1.5;
    }
//    if(get_ads[0]['ad_type'] == 1){
//      adh = 80;
//    }
    return h;
  }

  double get bannerHeight {
    if(screenheight > 700)
    {
      return screenheight/7.5;
    }
    return screenheight/4.5;
  }
}
BannerDisplay bannerDisplay = BannerDisplay();
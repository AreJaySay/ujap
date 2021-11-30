import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/variables/video.dart';
import 'package:ujap/pages/drawer_page.dart';
import 'package:ujap/pages/homepage.dart';
import 'package:ujap/services/ad_listener.dart';
import 'package:ujap/services/notifications.dart';

class ViewClientDetails extends StatefulWidget {
  final Map details;
  ViewClientDetails(this.details);

  @override
  _ViewClientDetailsState createState() => _ViewClientDetailsState();
}

class _ViewClientDetailsState extends State<ViewClientDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              alignment: Alignment.topCenter,
              width: double.infinity,
              child: SafeArea(
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/new_app_icon.png",),
                      )),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              color: kPrimaryColor,
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            icon: !isCollapsed ? IconButton(
                              icon: Icon(Icons.menu, color: Colors.white,size: screenwidth < 700 ? screenwidth/17 : 35,),
                            ) :  AnimatedIcon(
                              icon: AnimatedIcons.menu_close,
                              progress: drawerController,
                              color: Colors.white,size: screenwidth < 700 ? screenwidth/17 : 35,
                            ),
                            onPressed: () {
                              setState(() {
                                adListener.update(false);
                                if (isCollapsed) {
                                  drawerController.forward();
                                  showparameters = false;
                                  borderRadius = 30.0;
                                } else {
                                  drawerController.reverse();

                                  borderRadius = 0.0;
                                }
                                isCollapsed = !isCollapsed;
                                if(videoPlayerController != null && chewieController != null && chewieController.isPlaying){
                                  videoPlayerController.pause();
                                  chewieController.pause();
                                }
                              });
                            }),
                        Row(
                          children: [
                            IconButton(
                              onPressed: (){

                              },
                              icon: Icon(Icons.search,color: Colors.white,),
                            ),
                            IconButton(
                              icon: Stack(
                                children: [
                                  Icon(Icons.notifications_none,color: Colors.white,size: 26,),
                                  Positioned(
                                    right: 1.0,
                                    child: Icon(Icons.brightness_1,
                                      color: !notificationIndicator ? Colors.transparent : Color.fromRGBO(231, 175, 77, 0.9),
                                      size: screenwidth < 700 ? 9 : 12,
                                    ),
                                  )
                                ],
                              ),
                              onPressed: (){
                                notificationIndicator = false;
                                adListener.update(false);
                                Navigator.push(context, PageTransition(child:  Notifications(
                                ),type: PageTransitionType.leftToRightWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(1000.0)
                              ),
                              child: Icon(Icons.arrow_back, color: Colors.white,size: 26,)),
                          onTap: (){
                            Navigator.of(context).pop(null);
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(child: Text(widget.details['company'].toString().toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600,fontFamily: 'Google-Bold'),textAlign: TextAlign.center,)),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.arrow_back, color: Colors.transparent,size: 26,)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight:  Radius.circular(10))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius
                                      .circular(1000.0),
                                  image: DecorationImage(
                                      image: widget.details['filename'].toString() == "null" ||  widget.details['filename'].toString() == "" ? AssetImage("assets/new_app_icon.png",) : NetworkImage("${Uri.parse('https://ujap.checkmy.dev/storage/clients/${widget.details['filename']}')}")
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Container(
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.details['name'].toString()+" "+widget.details['lastname'].toString(),style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 17),),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      widget.details['telephone'] == null ? Container() :
                                      Text(widget.details['telephone'].toString(),style: TextStyle(color: Colors.grey[800], ),),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(widget.details['email'].toString(),style: TextStyle(color: Colors.grey[800], ),),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(widget.details['company'].toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,fontFamily: 'Google-Bold')),
                          // Text("Informatique",style: TextStyle(color: Colors.blue[800],fontFamily: 'Google-medium'),),
                          widget.details['company_category'] == null ? Text('Aucune catégorie annoncée',style: TextStyle(color: Colors.grey),) :
                          Text(widget.details['company_category'].toString(),style: TextStyle(color: Colors.blue[800],fontFamily: 'Google-medium'),),
                          SizedBox(
                            height: 15,
                          ),
                          widget.details['company_description'] == "" ? Text("Pas de description disponible",style: TextStyle(color: Colors.grey[500],fontFamily: 'Google-regular'),) :
                          Text(widget.details['company_description'].toString(),
                          style: TextStyle(fontFamily: 'Google-regular'),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

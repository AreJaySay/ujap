import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/confirmation_attendance.dart';
import 'package:ujap/globals/widgets/view_matches.dart';


class RequestTicket extends StatefulWidget {
  final Map eventDetail;
  final String _matchID;
  RequestTicket(this.eventDetail,this._matchID);

  @override
  State<StatefulWidget> createState() => RequestTicketState();
}

class RequestTicketState extends State<RequestTicket>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Center(
            child: Material(
              color: Colors.transparent,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: Stack(
                  children: [
                    Container(
                      width: screenwidth/1.1,
                      height:  screenwidth < 700 ? 300 : 350,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          height:  screenwidth < 700 ? 250 : 300,
                          width: screenwidth/1.1,
                        decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0))),

                      ),
                    ),
                    Container(
                      width: screenwidth/1.1,
                      height:  screenwidth < 700 ? 300 : 350,
                      // margin: EdgeInsets.symmetric(vertical: height/5,horizontal: width/30),
                      decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                      child: Column(
                        children: [
                          Container(
                            width: screenwidth/5,
                            height: screenwidth/5,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(1000.0),
                              border: Border.all(color: kPrimaryColor,width: 2)
                            ),
                            child: Image(
                              color: kPrimaryColor,
                              image: AssetImage('assets/home_icons/ticket.png'),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    Text(ticket_allocation.toString(),style: TextStyle(fontFamily: 'Google-Medium',color: Colors.black.withOpacity(0.5),fontSize: screenwidth < 700 ? screenheight/20 : 20 ),textAlign: TextAlign.center,),
                                    Text('TOTAL',style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black87.withOpacity(0.5),fontSize: screenwidth < 700 ? screenheight/55 : 20 ),textAlign: TextAlign.center,),
                                    Text('TICKETS',style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black87.withOpacity(0.5),fontSize: screenwidth < 700 ? screenheight/55 : 20 ),textAlign: TextAlign.center,),

                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Text( (ticket_allocation - ticket_accepted_client ) < 0 ? '0' : (ticket_allocation - ticket_accepted_client ).toString(),style: TextStyle(fontFamily: 'Google-Medium',color: Colors.black.withOpacity(0.7),fontSize: screenwidth < 700 ? screenheight/15 : 20 ),textAlign: TextAlign.center,),
                                    Text((ticket_allocation - ticket_accepted_client ) > 1 ?'TICKETS' : 'TICKET',style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black87.withOpacity(0.6),fontSize: screenwidth < 700 ? screenheight/40 : 20 ),textAlign: TextAlign.center,),
                                    Text('AVAILABLE',style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black87.withOpacity(0.6),fontSize: screenwidth < 700 ? screenheight/40 : 20 ),textAlign: TextAlign.center,),

                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  children: [
                                    Text(ticket_accepted_client.toString(),style: TextStyle(fontFamily: 'Google-Medium',color: Colors.black.withOpacity(0.5),fontSize: screenwidth < 700 ? screenheight/20 : 20 ),textAlign: TextAlign.center,),
                                    Text('CLIENTS',style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black87.withOpacity(0.5),fontSize: screenwidth < 700 ? screenheight/55 : 20 ),textAlign: TextAlign.center,),
                                    Text('ATTEND',style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black87.withOpacity(0.5),fontSize: screenwidth < 700 ? screenheight/55 : 20 ),textAlign: TextAlign.center,),

                                  ],
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              width: screenwidth,
                              height: screenheight,
                              alignment: Alignment.center,
                              child: Container(
                                height: 42,
                                width: screenwidth,
                                child:(ticket_allocation - ticket_accepted_client ) <= 0 ?
                                GestureDetector(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 30),
                                    decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Center(
                                      child: Text('CLOSE',style: TextStyle(fontFamily: 'Google-Bold',color: Colors.white,fontSize: screenwidth < 700 ? screenheight/55 : 20 ),textAlign: TextAlign.center,),
                                    ),
                                  ),
                                  onTap: (){
                                    Navigator.of(context).pop(null);
                                  },
                                ) :
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 20),
                                          width: screenwidth/2,
                                          height: screenheight,
                                          decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: Center(
                                            child: Text('ACCEPT',style: TextStyle(fontFamily: 'Google-Bold',color: Colors.white,fontSize: screenwidth < 700 ? screenheight/55 : 20 ),textAlign: TextAlign.center,),
                                          ),
                                        ),
                                        onTap: (){
                                          confirmation(context,widget._matchID,'1',widget.eventDetail);
                                          attend_pass = "Yes";
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        child: Container(
                                          margin: EdgeInsets.only(right: 20),
                                          width: screenwidth/2,
                                          height: screenheight,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: kPrimaryColor)
                                          ),
                                          child: Center(
                                            child: Text('DECLINE',style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black87.withOpacity(0.6),fontSize: screenwidth < 700 ? screenheight/55 : 20 ),textAlign: TextAlign.center,),
                                          ),
                                        ),
                                        onTap: (){
                                          Navigator.of(context).pop(null);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

}
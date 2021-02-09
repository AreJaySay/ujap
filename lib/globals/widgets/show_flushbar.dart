import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:ujap/globals/variables/other_variables.dart';

showflushbar(sender,msg,context){
  return Flushbar(
    maxWidth: screenwidth/1.050,
    flushbarPosition: FlushbarPosition.TOP,
    messageText: Container(
      padding: EdgeInsets.only(left: 5),
      child: Container(
        width: screenwidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sender.toString(),style: TextStyle(color: Colors.white,fontSize: screenwidth < 700 ? screenwidth/35: screenwidth/50,fontFamily: 'Google-Bold'),),
            Text(msg.toString(),style: TextStyle(color: Colors.white,fontSize: screenwidth < 700 ? screenwidth/40: screenwidth/50),),
          ],
        ),
      ),
    ),
    icon: Container(
      margin: EdgeInsets.only(left: 5),
      width: 70,
      height: 50,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage(('assets/logo.png'))
          )
      ),
    ),
    duration: Duration(seconds: 7),
    backgroundColor: Color.fromRGBO(5, 93, 157, 0.9),
    // leftBarIndicatorColor: Colors.black,
    borderRadius: 5,
    dismissDirection: FlushbarDismissDirection.VERTICAL,
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    // leftBarIndicatorColor: Colors.black,
    // borderRadius: 10,
    // aroundPadding: EdgeInsets.only(bottom:10.0,top: 10.0),
  )..show(context);
}
class NotificationDisplayer {
  showNotification(String body, String title, context) => Flushbar(
    maxWidth: screenwidth/1.050,
    flushbarPosition: FlushbarPosition.TOP,
    messageText: Container(
      padding: EdgeInsets.only(left: 5),
      child: Container(
        width: screenwidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title.toString(),style: TextStyle(color: Colors.white,fontSize: screenwidth < 700 ? screenwidth/35: screenwidth/50,fontFamily: 'Google-Bold'),),
            Text(body.toString(),style: TextStyle(color: Colors.white,fontSize: screenwidth < 700 ? screenwidth/40: screenwidth/50),),
          ],
        ),
      ),
    ),
    icon: Container(
      margin: EdgeInsets.only(left: 5),
      width: 70,
      height: 50,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.contain,
              image: AssetImage(('assets/logo.png'))
          )
      ),
    ),
    duration: Duration(seconds: 7),
    backgroundColor: Color.fromRGBO(5, 93, 157, 0.9),
    // leftBarIndicatorColor: Colors.black,
    borderRadius: 5,
    dismissDirection: FlushbarDismissDirection.VERTICAL,
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    // leftBarIndicatorColor: Colors.black,
    // borderRadius: 10,
    // aroundPadding: EdgeInsets.only(bottom:10.0,top: 10.0),
  )..show(context);
}
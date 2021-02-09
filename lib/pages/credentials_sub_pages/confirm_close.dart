import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ujap/globals/variables/other_variables.dart';

bool show_confirm = false;

class Confirm_close extends StatefulWidget {
  @override
  _Confirm_closeState createState() => _Confirm_closeState();
}

class _Confirm_closeState extends State<Confirm_close> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: screenwidth/35),
              width: screenwidth/1.5,
              height: screenwidth/2.5,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Text("Cela fermera l'application. Es-tu sur de vouloir continuer?",style: TextStyle(fontFamily: 'Google-Regular',color: Colors.black.withOpacity(0.7),fontSize: screenwidth < 700 ? screenheight/45 : 20,decoration: TextDecoration.none,),textAlign: TextAlign.center,),
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                  ),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: screenwidth/1.5,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text('Continuer',style: TextStyle(fontFamily: 'Google-Medium',color: Colors.white,fontSize: screenwidth < 700 ? screenheight/45 : 20,decoration: TextDecoration.none,),textAlign: TextAlign.center,),
                    ),
                    onTap: (){
                      setState(() {
                        print('asdasdasdasd');
                        exit(0);
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
              width: screenwidth/1.4,
              height: screenwidth/2.3,
              alignment: Alignment.topRight,
              child: GestureDetector(
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(1000.0)
                  ),
                  child: Icon(Icons.close,size: screenwidth < 700? 30 : 35,color: kPrimaryColor,),
                ),
                onTap: (){
                  setState(() {
                    print('asdasdasd');
                    show_confirm = false;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

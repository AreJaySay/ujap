import 'package:flutter/material.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/shemmering_loader.dart';

class Message_no_data extends StatefulWidget {
  @override
  _Message_no_dataState createState() => _Message_no_dataState();
}

class _Message_no_dataState extends State<Message_no_data> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          for (var x = 0; x < 5; x++)
          Container(
            width: screenwidth,
            padding: const EdgeInsets.symmetric(horizontal: 20,),
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000.0),
                  ),
                  child: loadingShimmering(),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.white,
                        ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 15,
                                width: screenwidth/2.5,
                                child: loadingShimmering(),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 20,
                                width: screenwidth < 700 ? screenwidth/1.5 : screenwidth,
                                child: loadingShimmering(),
                              )
                            ],
                          )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

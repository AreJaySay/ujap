import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/variables/other_variables.dart';

class No_data_middle extends StatefulWidget {
  @override
  _No_data_middleState createState() => _No_data_middleState();
}

class _No_data_middleState extends State<No_data_middle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, int index){

          return Row(
            children: [
              Container(
                height: screenheight,
                width: screenwidth < 700 ? screenwidth/3.9 : screenwidth/5.5,
                margin: EdgeInsets.only(left: screenwidth < 700 ? 15 : 25),
                child: Column(
                  children: [
                    Container(
                      height: 10,
                      child: _loadingShimmering(),
                    ),
                    SizedBox(
                      height: screenheight/110,
                    ),
                    Expanded(
                      child:Container(
                        child: _loadingShimmering(),
                      ),

                    ),
                    SizedBox(
                      height: screenheight/80,
                    ),
                    Expanded(
                      child:Container(
                        child: _loadingShimmering(),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: screenheight,
                width: screenwidth < 700 ? screenwidth/3.8 : screenwidth/5.5,
                margin: EdgeInsets.only(left: screenwidth < 700 ? 15 : 25),
                child: _loadingShimmering(),
              ),
            ],
          );
        },
      ),
    );
  }
}


Widget _loadingShimmering(){
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
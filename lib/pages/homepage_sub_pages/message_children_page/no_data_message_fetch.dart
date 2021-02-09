import 'package:shimmer/shimmer.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:flutter/material.dart';

class NoDataFetchMessage extends StatefulWidget {
  @override
  _NoDataFetchMessageState createState() => _NoDataFetchMessageState();
}

class _NoDataFetchMessageState extends State<NoDataFetchMessage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        reverse: true,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, int index) {
          return AnimatedContainer(
            duration: Duration(seconds: 2),
            width: screenwidth,
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Container(
                        child: _loadingShimmering(),
                        width: screenwidth/2,
                        height: 50,
                        margin: EdgeInsets.only(left: screenheight/4,bottom: screenwidth/20),
                    ),
                Container(
                  child: _loadingShimmering(),
                  width: screenwidth/2,
                  height: 50,
                  margin: EdgeInsets.only(right: screenheight/5,bottom: screenwidth/20),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _loadingShimmering() {
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
}

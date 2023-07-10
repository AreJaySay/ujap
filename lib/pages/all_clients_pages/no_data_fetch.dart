import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/curve_containers.dart';

class NoDateFetchClients extends StatefulWidget {
  @override
  _NoDateFetchClientsState createState() => _NoDateFetchClientsState();
}

class _NoDateFetchClientsState extends State<NoDateFetchClients> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, dynamic element){
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 120,
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey,
                      highlightColor: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(1000),
                            color: Colors.white
                        ),
                      )
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 230,
                      height: 25,
                      child: Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white
                            ),
                          )
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 250,
                      height: 15,
                      child: Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white
                            ),
                          )
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 250,
                      height: 15,
                      child: Shimmer.fromColors(
                          baseColor: Colors.grey,
                          highlightColor: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white
                            ),
                          )
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
        );
      },
    );
  }
}

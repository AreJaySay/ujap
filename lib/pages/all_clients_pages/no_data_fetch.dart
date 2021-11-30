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
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
                width: screenwidth,
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: ClipPath(
                      clipper: CurvedBottom(),
                      child: Container(
                        margin: EdgeInsets.all(80),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/new_app_icon.png"),
                            )),
                      ),
                    ))),
            Container(
              width: double.infinity,
              height: double.infinity,
              color: kPrimaryColor,
              child:Column(
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
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
                        Text("Nos partenaires".toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w600,fontFamily: 'Google-Bold')),
                        GestureDetector(
                          child: Container(
                              padding: EdgeInsets.all(3),
                              child: Icon(Icons.search, color: Colors.white,size: 26,)),
                          onTap: (){

                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 9,
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
                                  ],
                                ),
                              ],
                            ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
    );
  }
}

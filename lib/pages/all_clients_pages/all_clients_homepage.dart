import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/variables/video.dart';
import 'package:ujap/globals/widgets/curve_containers.dart';
import 'package:http/http.dart' as http;
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/pages/all_clients_pages/no_data_fetch.dart';
import 'package:ujap/pages/all_clients_pages/view_current_details_information.dart';
import 'package:ujap/pages/drawer_page.dart';
import 'dart:math' as math;

import 'package:ujap/pages/homepage.dart';
import 'package:ujap/services/ad_listener.dart';
import 'package:ujap/services/notifications.dart';

class AllClientsHomePage extends StatefulWidget {
  @override
  _AllClientsHomePageState createState() => _AllClientsHomePageState();
}

class _AllClientsHomePageState extends State<AllClientsHomePage> {
  List _allClients;
  List _allclientsLocal;
  List _categories;

  Future _getClients()async{
    var response = await http.get(Uri.parse('https://ujap.checkmy.dev/api/client/clients'),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $accesstoken",
          "Accept": "application/json"
        },
    );
    var _json = json.decode(response.body);
    if (response.statusCode == 200){
      setState(() {
        _allClients = _json;
        _allclientsLocal = _allClients;
      });
    }else{
      showSnackBar(context, "Une erreur s'est produite, veuillez réessayer.");
    }
  }

  Future _getCategories()async{
    var response = await http.get(Uri.parse('https://ujap.checkmy.dev/api/company_categories'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $accesstoken",
        "Accept": "application/json"
      },
    );
    var _json = json.decode(response.body);
    if (response.statusCode == 200){
      setState(() {
        _categories = _json;
      });
      print(_categories.toString());
    }else{
      showSnackBar(context, "Une erreur s'est produite, veuillez réessayer.");
    }
  }

  String _categoryVal = "";
  TextEditingController _search = TextEditingController();
  TextEditingController _searchname = TextEditingController();
  bool _searchbox = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getClients().whenComplete((){
      _getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        leading:  IconButton(
              onPressed: (){
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
                Navigator.pushReplacement(context,PageTransition(child: MainScreen(true),type: PageTransitionType.fade));
              },
              icon: Icon(Icons.home, color: Colors.white,size: 26,),
            ),
            actions: [
              Row(
                children: [
                  IconButton(
                      icon: !_searchbox ? IconButton(
                        icon: Icon(Icons.search, color: Colors.white,size: 26,),
                      ) :  IconButton(
                        icon: Icon(Icons.search_off_rounded, color: Colors.white,size: 26,),
                      ),
                      onPressed: () {
                        setState(() {
                          _searchbox = !_searchbox;
                          _searchname.text = "";
                          _allClients = _allclientsLocal;
                        });
                      }),
                  IconButton(
                    icon: Stack(
                      children: [
                        IconButton(icon: Icon(Icons.notifications_none,color: Colors.white,size: 26),onPressed: (){},),
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
      body: _allClients == null ?
        NoDateFetchClients() :  Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              alignment: Alignment.topCenter,
              width: double.infinity,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/new_app_icon.png",),
                    )),
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              color: kPrimaryColor,
              child: Column(
                children: [
                  _searchbox ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: TextField(
                      controller: _searchname,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Nom de la recherche',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              _searchname.text = "";
                              _allClients = _allclientsLocal;
                            });
                          },
                          icon: Icon(Icons.close,color: Colors.grey[700],),
                        )
                      ),
                      onChanged: (val){
                        setState(() {
                          _allClients = _allclientsLocal.where((s){
                            return s['name'].toString().toLowerCase().contains(val.toString().toLowerCase());
                          }).toList();
                        });
                      },
                    ),
                  ) :
                  Container(
                    height: 50,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 15),
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
                        Text("Nos partenaires".toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600,fontFamily: 'Google-Bold')),
                        GestureDetector(
                          child: Container(
                              width: 22,
                              height: 22,
                              child: Image(
                                color: Colors.white,
                                image: AssetImage('assets/home_icons/filter.png'),
                              ),
                          ),
                          onTap: (){
                            showMaterialModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                context: context,
                                builder: (context) => _filter(_search.text)
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: _allClients.length == 0 ?
                    Container(
                      width: screenwidth,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight:  Radius.circular(10))
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              child: Image(
                                color: Colors.grey[600],
                                image: AssetImage('assets/noclient.png'),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                                width: screenwidth,
                                child: Center(child: Text("AUCUN CLIENT TROUVÉ",style: TextStyle(color: Colors.black87.withOpacity(0.5),fontFamily: 'Google-Bold',fontSize: screenheight/55 )))),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: screenwidth/8),
                                width: screenwidth,
                                child: Text("Vous verrez ici tous les clients et les informations de leur entreprise."
                                  ,style: TextStyle(color: Colors.grey[350],fontFamily: 'Google-Bold',fontSize: screenheight/70 ,
                                  ),textAlign: TextAlign.center,
                                )
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: MaterialButton(
                                color: kPrimaryColor,
                                onPressed: (){
                                  setState(() {
                                    _allClients = _allclientsLocal;
                                    _searchname.text = "";
                                  });
                                },
                                height: 50,
                                child: Center(
                                  child: Text("Rafraîchir la page",style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ) :
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight:  Radius.circular(10))
                      ),
                      child: GroupedListView<dynamic, String>(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        elements: _allClients,
                        groupBy: (element) => element['name'][0],
                        groupSeparatorBuilder: (String groupByValue){
                          return Container(
                              // alignment: Alignment.topLeft,
                              // padding: EdgeInsets.all(5),
                              // child: Container(
                              //   width: 27,
                              //   height: 27,
                              //   decoration: BoxDecoration(
                              //     color: Colors.black,
                              //     borderRadius: BorderRadius.circular(1000),
                              //   ),
                              //   child: Center(child: Text(groupByValue,textAlign: TextAlign.start,style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),)),
                              // )
                          );
                        },
                        itemBuilder: (context, dynamic element){
                          return GestureDetector(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Container(
                                    width: 65,
                                    height: 65,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius
                                            .circular(1000.0),
                                        image: DecorationImage(
                                            image: element['filename'].toString() == "null" ||  element['filename'].toString() == "" ? AssetImage("assets/new_app_icon.png",) : NetworkImage("${Uri.parse('https://ujap.checkmy.dev/storage/clients/${element['filename']}')}")
                                        ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(0, 2), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        element['company'] == null ? Container() :
                                        Text(element['company'].toString(),style: TextStyle(fontSize:  15, color: Colors.black, fontFamily: 'Google-Bold'),),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(element['name'].toString()+" "+element['lastname'].toString(),style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            element['company_category'] == null ? Text('Aucune catégorie annoncée',style: TextStyle(color: Colors.grey),) :
                                            Text(element['company_category'].toString(),style: TextStyle(fontSize:  13, color: Colors.blueAccent, ),),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            element['telephone'] == null ? Container() :
                                            Text(element['telephone'].toString()+" | "+element['email'].toString(),style: TextStyle(fontSize:  13, color: Colors.grey[800], ),),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios_outlined)
                                ],
                              ),
                            ),
                            onTap: (){
                              print(element.toString());
                              Navigator.push(context, PageTransition(child: ViewClientDetails(element), type: PageTransitionType.rightToLeftWithFade));
                            },
                          );
                        },
                        itemComparator: (item1, item2) => item1['name'].toString().toLowerCase().compareTo(item2['name'].toString().toLowerCase()), // optional
                        useStickyGroupSeparators: true, // optional
                        floatingHeader: true,
                        // optional
                        order: GroupedListOrder.ASC, // optional
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _filter(String searchData){

    _search.text = searchData;

   return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      width: double.infinity,
      height: 460,
     decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight:  Radius.circular(10))
     ),
     child: Column(
       mainAxisAlignment: MainAxisAlignment.start,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         Container(
           width: 35,
           height: 8,
           decoration: BoxDecoration(
             color: Colors.grey[400],
             borderRadius: BorderRadius.circular(1000)
           ),
         ),
         SizedBox(
           height: 5,
         ),
         Container(
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               FlatButton(
                 onPressed: (){
                   setState(() {
                     _search.text = "";
                     _categoryVal = "";
                     _allClients = _allclientsLocal;
                     Navigator.of(context).pop(null);
                     showMaterialModalBottomSheet(
                         backgroundColor: Colors.transparent,
                         context: context,
                         builder: (context) => _filter(_search.text)
                     );
                   });
                 },
                 child: Text('Réinitia\nliser',style: TextStyle(fontSize:  15, color: Colors.grey[500]),),
               ),
               Text("RECHERCHE",style: TextStyle(fontSize:  16, color: Colors.black,fontFamily: 'Google-medium' ),),
               FlatButton(
                 onPressed: (){
                   Navigator.of(context).pop(null);
                 },
                 child: Text('Valider',style: TextStyle(fontSize:  15, color: Colors.grey[500]),),
               )
             ],
           ),
         ),
         SizedBox(
           height: 7,
         ),
         Container(
           margin: EdgeInsets.symmetric(horizontal: 20),
           height: 50,
           width: double.infinity,
           decoration: BoxDecoration(
               border: Border.all(color: Colors.grey),
               borderRadius: BorderRadius.circular(10)
           ),
           child: TextField(
             controller: _search,
             textAlignVertical: TextAlignVertical.center,
             decoration: InputDecoration(
               border: InputBorder.none,
               prefixIcon: Icon(Icons.search,color: Colors.black.withOpacity(0.7),),
               hintText: "Rechercher une entreprise",
               hintStyle: TextStyle(color: Colors.grey[400],fontFamily: 'Google-regular')
             ),
             onChanged: (val){
               setState(() {
                 _allClients = _allclientsLocal.where((s){
                   return s['company'].toString().toLowerCase().contains(_search.text.toString().toLowerCase());
                 }).toList().where((s){
                   return s['company_category'].toString().toLowerCase().contains(_categoryVal.toString().toLowerCase());
                 }).toList();
               });
             },
           ),
         ),
         Container(
           margin: EdgeInsets.only(left: 20,right: 20,bottom: 15,top: 30),
           alignment: Alignment.centerLeft,
           child: Text("Catégories",style: TextStyle(fontWeight: FontWeight.w500),),
         ),
         Expanded(
           child: Container(
             margin: EdgeInsets.symmetric(horizontal: 20),
             child: _categories.length == 0 ?
             Center(
               child: Text("AUCUNE CATÉGORIE TROUVÉE",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.grey),),
             ) :
             GridView.builder(
                 padding: EdgeInsets.all(0),
                 gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                     maxCrossAxisExtent: 150,
                     childAspectRatio: 2.7,
                     crossAxisSpacing: 10,
                     mainAxisSpacing: 10,
                 ),
                 itemCount: _categories.length,
                 itemBuilder: (BuildContext ctx, index) {
                   return GestureDetector(
                     child: Container(
                       alignment: Alignment.center,
                       child: Text(_categories[index]["name"],style: TextStyle(color: _categoryVal == _categories[index]["name"] ? Colors.white : Colors.grey[500],fontFamily: 'Google-regular' ),textAlign: TextAlign.center,),
                       decoration: BoxDecoration(
                           color: _categoryVal == _categories[index]["name"] ? kPrimaryColor : Colors.white,
                           borderRadius: BorderRadius.circular(5),
                           border: Border.all(color: _categoryVal == _categories[index]["name"] ? Colors.transparent : Colors.grey[400]),
                       ),
                     ),
                     onTap: (){
                       setState(() {
                         _categoryVal = _categories[index]["name"];
                         Navigator.of(context).pop(null);
                         showMaterialModalBottomSheet(
                             backgroundColor: Colors.transparent,
                             context: context,
                             builder: (context) => _filter(_search.text)
                         );
                         _allClients = _allclientsLocal.where((s){
                           return s['company'].toString().toLowerCase().contains(_search.text.toString().toLowerCase());
                         }).toList().where((s){
                           return s['company_category'].toString().toLowerCase().contains(_categoryVal.toString().toLowerCase());
                         }).toList();
                       });
                     },
                   );
                 }),
               ),
         ),
       ],
     ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/events_sub_pages_variables.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/pages/homepage_sub_pages/event_children/no_data_yet.dart';
import 'dart:math' as math;
import 'package:ujap/services/searches/search_service.dart';

var myEvents = "";
var fromDate = "";
var toDate = "";
var view_data_filter = "";
var status_data_filter = "";

int toDateInt = 0;
int fromDateInt = 99999999999;

class Events_filter extends StatefulWidget {
  @override
  _Events_filterState createState() => _Events_filterState();
}

class _Events_filterState extends State<Events_filter> {
  List status = ['Récents',' En cours','Tout'];
  List searchStatus = ['Newest','Ongoing','View all'];
  List view = ['Évènements','Matchs',' Tout'];
  List searchView = ['Event','Match','View all'];
//  bool date_textfields = true;
  DateTime selectedDate = DateTime.now();
  var _searchType = "";
  var _localStatus = "";
  var viewSearch = "";

  Future<int> _selectDate(bool date_textfields) async {
    final DateTime picked = await showDatePicker(
      context: context,
      locale : const Locale("fr","FR"),
      initialDate: selectedDate,
      firstDate: DateTime(1901, 1),
      lastDate: DateTime(2100),
    );
    print("PICKED $picked ");
    print("Selected Data : $selectedDate");
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        var parsedDate = DateTime.parse(picked.toString());
        String convertedDate = new DateFormat("dd-MM-yyyy").format(parsedDate);

        var _dateYearConverted = convertedDate.substring(6,10);
        var _dateDayConverted = convertedDate.substring(3,5);
        var _dateMonthConverted = convertedDate.substring(0,2);

        if (date_textfields == true){
          setState(() {
            fromDate = convertedDate.toString();
            convertedDate_filter = int.parse(_dateYearConverted+_dateMonthConverted+_dateDayConverted);
          });
        }
        else{
          setState(() {
            toDate = convertedDate.toString();
            convertedDate_filter_to = int.parse(_dateYearConverted+_dateMonthConverted+_dateDayConverted);
            print('DATE: '+convertedDate_filter_to.toString());
          });
        }

      });
      filterSearchService.filter(searchBox: searchfilter.text.toString(), viewData: _searchType,convertedDateFilter: convertedDate_filter,convertDateFilterTo: convertedDate_filter_to,statusData: _localStatus,);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenwidth,
      height: screenheight,
      alignment: Alignment.bottomCenter,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        width: screenwidth,
        height: screenwidth < 700 ? !events_filter_open ? 0.0 : screenheight/1.7 :  !events_filter_open ? 0.0 : screenheight/1.8,
        color: Colors.white,
        child:  ListView(
          padding: EdgeInsets.all(0),
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              height: 40,
              margin: EdgeInsets.only(top: screenwidth < 700 ? 0 : 10),
              width: screenwidth,
              padding: EdgeInsets.symmetric(horizontal: screenwidth/2.2,vertical: screenwidth < 700 ? 15 : 13),
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10000),
                  ),
                ),
                onHorizontalDragEnd: (text){
                  setState(() {
                    events_filter_open = false;
                  });
                },
              ),
            ),
            SizedBox(
              height: screenwidth < 700 ? screenheight/100 : 30,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: Container(
                        child: Text('Réinitialiser',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/60 : 22,fontFamily: 'Google-Bold',color: Colors.grey[400]),)
                    ),
                    onTap: (){
                      setState(() {
                        searchfilter.text = "";
                        _searchType = "";
                        convertedDate_filter = 0;
                        convertedDate_filter_to = 99999999999;
                        _localStatus = "";
                        fromDate = "";
                        toDate = "";
                        view_data_filter = "";
                        view_data = "";
                        fromDateInt = 0;
                        toDateInt = 99999999999;
                        status_data_filter = "";
                        viewSearch = "";
                        filterSearchService.filter();
                      });
                    },
                  ),
                  Text('Filtres',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/60 : 22,fontFamily: 'Google-Bold'),),
                  GestureDetector(
                    child: Container(
                        child: Text('Appliquer',style: TextStyle(fontSize: screenwidth < 700 ? screenheight/60 : 22,fontFamily: 'Google-Bold',color: Colors.grey[400]),)),
                    onTap: (){
                      setState(() {
                        searchfilter.text = "";
                        _searchType = "";
                        convertedDate_filter = 0;
                        convertedDate_filter_to = 99999999999;
                        _localStatus = "";
                        fromDate = "";
                        toDate = "";
                        view_data_filter = "";
                        view_data = "";
                        fromDateInt = 0;
                        toDateInt = 99999999999;
                        status_data_filter = "";
                        viewSearch = "";
                        filterSearchService.filter();
                        events_filter_open = false;
                        SystemChannels.textInput.invokeMethod('TextInput.hide');
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenwidth < 700 ? screenheight/80 : 20,
            ),
            Container(
              width: screenwidth,
              height: screenwidth < 700 ? screenheight/15 : 60,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: searchfilter,
                style: TextStyle(fontFamily: 'Google-Regular',fontSize: screenwidth < 700 ? screenheight/60 : 22),
                decoration: InputDecoration(
                    hintText: 'Rechercher',
                    hintStyle: TextStyle(color: Colors.grey[300],fontFamily: 'Google-Regular',fontSize: screenwidth < 700 ? screenheight/60 : 22),
                    prefixIcon: IconButton(
                      icon: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: Icon(Icons.search,color: Colors.black54,size: screenwidth < 700 ? 20 : 35,),
                      ),
                    ),
                    suffixIcon: searchfilter.text.isEmpty ? null : IconButton(
                      icon: Icon(Icons.close,color: Colors.black54,size: screenwidth < 700 ? 22 : 35,),
                      onPressed: (){
                        setState(() {
                          searchbox_filter = "";
                          searchfilter.text = "";
                          filterSearchService.filter(searchBox: "");
                        });
                      },
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: screenwidth < 700 ? 20 : 40,vertical: screenwidth < 700 ? 0 : 20),
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue[200]),

                    )
                ),
                onChanged: (text){
                  myEvents = text;
                  filterSearchService.filter(searchBox: searchfilter.text.toString(), viewData: _searchType,convertedDateFilter: convertedDate_filter,convertDateFilterTo: convertedDate_filter_to,statusData: _localStatus,);
                  showCloseButton = true;
                },
              ),
            ),
            SizedBox(
              height:  screenheight/30 ,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: screenwidth,
              child: Text('Date',textAlign: TextAlign.left,style: TextStyle(fontSize: screenwidth < 700 ? screenheight/65 : 21,fontFamily: 'Google-Bold'),),),
            SizedBox(
              height: screenwidth < 700 ? screenheight/90 : 20,
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: FlatButton(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: screenwidth/2,
                        height: screenwidth < 700 ? screenheight/20 : 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            fromDate == "" ?
                            Text('Du'.toString(),style: TextStyle(fontFamily: 'Google-Medium',fontSize: screenwidth < 700 ? screenheight/70 : 20,color: Colors.grey[300]),) :
                            Text(fromDate.toString(),style: TextStyle(fontFamily: 'Google-Medium',fontSize: screenwidth < 700 ? screenheight/70 : 20),),
                            Icon(Icons.calendar_today,size: screenwidth < 700 ? screenheight/45 : 25,color: Colors.grey[600],),
                          ],
                        ),
                      ),
                      onPressed: ()async{
                        setState(() {
                        });
                        _selectDate(true);
                        showCloseButton = true;
                      },
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        width: screenwidth/2,
                        height: screenwidth < 700 ? screenheight/20 : 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            toDate == "" ?
                            Text('Au'.toString(),style: TextStyle(fontFamily: 'Google-Medium',fontSize: screenwidth < 700 ? screenheight/70 : 20,color: Colors.grey[300]),) : Text(toDate.toString(),style: TextStyle(fontFamily: 'Google-Medium',fontSize: screenwidth < 700 ? screenheight/70 : 20),),
                            Icon(Icons.calendar_today,size: screenwidth < 700 ? screenheight/45 : 25,color: Colors.grey[600],),
                          ],
                        ),
                      ),
                      onPressed: (){
                         _selectDate(false);
                         showCloseButton = true;
                      },
                    ),
//
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenheight/30 ,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: screenwidth,
              child: Text('Statut',textAlign: TextAlign.left,style: TextStyle(fontSize: screenwidth < 700 ?  screenheight/65 : 21,fontFamily: 'Google-Bold'),),),
            SizedBox(
              height: screenwidth < 700 ? 10 : 20,
            ),
            Container(
              height: screenwidth < 700 ? screenheight/20 : 60,
              alignment: Alignment.center,
              width: screenwidth,
              margin: EdgeInsets.symmetric(horizontal: screenwidth/80),
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: status.length,
                itemBuilder: (context, int index){
                  return  GestureDetector(
                    child: Container(
                      width: screenwidth < 700 ? screenwidth/3.7 : screenwidth/3.5,
                      height: screenwidth < 700 ? 40 : 60,
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal:  screenwidth/50),
                      decoration: BoxDecoration(
                          color: status[index].toString() == status_data_filter.toString() ? Color.fromRGBO(5, 93, 157, 0.9) : Colors.white,
                          border: Border.all(color: Colors.grey[300]),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(status[index].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70 : 20,color: status[index].toString() == status_data_filter.toString() ? Colors.white : Colors.grey[300],fontFamily: 'Google-Medium'),),

                    ),
                    onTap: (){
                      status_data_filter = searchStatus[index].toString();
                      setState(() {
                        status_data_filter = status[index].toString();
                        _localStatus = searchStatus[index].toString();
                        print(status_data_filter.toString());
                      });
                      showCloseButton = true;
                      filterSearchService.filter(searchBox: searchfilter.text.toString(), viewData: _searchType,convertedDateFilter: convertedDate_filter,convertDateFilterTo: convertedDate_filter_to,statusData: _localStatus,);
                      print(_localStatus);
                    },

                  );
                },
              ),
            ),
            SizedBox(
              height: screenheight/30 ,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: screenwidth,
              child: Text('Affichage',textAlign: TextAlign.left,style: TextStyle(fontSize: screenwidth < 700 ?  screenheight/65 : 21,fontFamily: 'Google-Bold'),),),
            SizedBox(
              height: screenwidth < 700 ? 10 : 20,
            ),
            Container(
              height: screenwidth < 700 ? screenheight/20 : 60,
              alignment: Alignment.center,
              width: screenwidth,
              margin: EdgeInsets.symmetric(horizontal: screenwidth/80),
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: view.length,
                itemBuilder: (context, int index){
                  return  GestureDetector(
                    child: Container(
                      width: screenwidth < 700 ? screenwidth/3.7 : screenwidth/3.5,
                      height: screenwidth < 700 ? 40 : 60,
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: screenwidth/50),
                      decoration: BoxDecoration(
                          color: searchView[index].toString() == viewSearch.toString() ? Color.fromRGBO(5, 93, 157, 0.9) : Colors.white,
                          border: Border.all(color: Colors.grey[300]),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(view[index].toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: screenwidth < 700 ? screenheight/70 : 20,color: searchView[index].toString() == viewSearch.toString() ? Colors.white : Colors.grey[300],fontFamily: 'Google-Medium'),),

                    ),
                    onTap: (){
                      setState(() {
                        view_data_filter = searchView[index].toString();
                        viewSearch = searchView[index].toString();
                        if (viewSearch.toString() == "View all"){
                          _searchType = "";
                        }
                        else{
                         _searchType = searchView[index].toString();
                        }
                        showCloseButton = true;
                        // String searchBox = "", String viewData ="", int convertedDateFilter = 0, int convertDateFilterTo = 99999999999, String statusData = "", String tabbar = "", bool past = false
                        filterSearchService.filter(searchBox: searchfilter.text.toString(), viewData: _searchType,convertedDateFilter: convertedDate_filter,convertDateFilterTo: convertedDate_filter_to,statusData: _localStatus,);
                      });
                    },

                  );
                },
              ),
            ),
            SizedBox(
              height: screenwidth < 700 ? 10 : 50,
            ),
          ],
        ),
      ),
    );
  }
}
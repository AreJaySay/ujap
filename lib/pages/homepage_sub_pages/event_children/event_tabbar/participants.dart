import 'package:flutter/material.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/variables/other_variables.dart';

class Participants extends StatelessWidget {
  final List participants;
  final String type;
  Participants({this.participants,this.type});
  @override
  Widget build(BuildContext context) {
    return this.participants.length > 0 ?
    ListView.builder(
      padding: const EdgeInsets.all(0),
      itemCount: participants.length,
      itemBuilder: (context, index){
        List clientDetail;
        if (this.type.toString() == 'event'){
          clientDetail = events_clients.where((s){
            return s['id'].toString() == participants[index]['client_id'].toString();
          }).toList();
        }
        return clientDetail.toString() == "[]" ? Container() : Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                spreadRadius: -10,
                blurRadius: 5,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Container(
            width: screenwidth,
            margin: EdgeInsets.symmetric(vertical: screenwidth/90,horizontal: screenwidth/40),
            padding: EdgeInsets.symmetric(vertical: screenwidth/40,horizontal: screenwidth/30),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]),
              borderRadius: BorderRadius.circular(screenwidth/80),
            ),
            child: Container(
              width: screenwidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(1000),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[400],
                              blurRadius: 2,
                              offset: Offset(3,2)
                          )
                        ],
                        image: this.type.toString() == 'event' ?
                        DecorationImage(
                            fit:  clientDetail[0]['filename'].toString() == "null" ||  clientDetail[0]['filename'].toString() == "" ? BoxFit.contain : BoxFit.cover,
                            image:  clientDetail[0]['filename'].toString() == "null" ||  clientDetail[0]['filename'].toString() == "" ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${ clientDetail[0]['filename']}")
                        ) :
                        DecorationImage(
                            fit: participants[index]['clients']['filename'].toString() == "null" || participants[index]['clients']['filename'].toString() == "" ? BoxFit.contain : BoxFit.cover,
                            image: participants[index]['clients']['filename'].toString() == "null" || participants[index]['clients']['filename'].toString() == "" ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${participants[index]['clients']['filename']}")
                        )
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          child: Text("${ this.type.toString() == 'event' ? clientDetail[0]['name'].toString() : participants[index]['clients']['name']}",style: TextStyle(
                              fontSize: screenwidth < 700 ? screenwidth/30 : screenwidth/37,
                              fontFamily: 'Google-Bold',
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold
                          ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Container(
                          width: double.infinity,
                          child: Text("${this.type.toString() == 'event' ? clientDetail[0]['email'].toString() : participants[index]['clients']['email']}",style: TextStyle(
                              fontSize: screenwidth < 700 ? screenwidth/30 : screenwidth/40,
//                            fontFamily: 'Google-Bold',
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w400
                          ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    ) : Container(
      height: screenheight,
      child: Center(
        child: ListView(
          padding: EdgeInsets.only(top: screenwidth/6),
          children: [
            Container(
              width: screenwidth/4,
              height: screenwidth/4,
              child: Image(
                color: Colors.grey[600],
                image: AssetImage('assets/no_clients_attended.png'),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                width: screenwidth,
                alignment: Alignment.center,
                child: Text('Aucun participant'.toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? screenwidth/30 : screenwidth/40,fontFamily: 'Google-Bold', color: Colors.grey[700],fontWeight: FontWeight.bold),)),
          ],
        ),
      ),
    );
  }
}

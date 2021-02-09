import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/view_message_images.dart';
import 'package:ujap/services/conversation_chats_listener.dart';
import 'package:ujap/services/conversation_listener.dart';

class ViewChannelPhotos extends StatefulWidget {
  final int channelId;
  ViewChannelPhotos(this.channelId);
  @override
  _ViewChannelPhotosState createState() => _ViewChannelPhotosState();
}

class _ViewChannelPhotosState extends State<ViewChannelPhotos> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: kPrimaryColor
        ),
        title: Text("Photos",style: TextStyle(
          color: kPrimaryColor
        ),),
      ),
      body: StreamBuilder<List>(
        stream: conversationService.convo,
        builder: (context, snapshot) {
          try{
            if(snapshot.hasData){
              List data = snapshot.data.where((element) => int.parse(element['id'].toString()) == widget.channelId).toList()[0]['messages'].where((element) => element['filename'] != null).toList();
              if(data != null && data.length > 0){
                return GridView.count(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: List.generate(data.length, (index) =>
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: data[index]['filename'].toString().contains('pdf') ? Colors.white : Colors.grey[300],
                              image: DecorationImage(
                                fit:  data[index]['filename'].toString().contains('pdf') ? BoxFit.contain : BoxFit.fill,
                                image: data[index]['filename'].toString().contains('pdf') ? AssetImage('assets/messages_icon/pdf_icon.png') : NetworkImage("https://ujap.checkmy.dev${data[index]['filename']}"),
                              )
                            ),
                        ),
                          onTap: (){
                            Navigator.push(context, PageTransition(child:  ViewMessageImages(
                                "https://ujap.checkmy.dev${data[index]['filename']}"
                            ),type: PageTransitionType.leftToRightWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
                          },
                        )
                    )
                );
              }
              return Center(
                child: Text("Aucune image trouvée sur cette chaîne"),
              );
            }
            return Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(kPrimaryColor),),
            );
          }catch(e){
            return Center(
              child: Text("Oops! Something went wrong"),
            );
          }
        },
      ),
    );
  }
}

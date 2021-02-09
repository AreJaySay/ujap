import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/new_group_page.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/search_conversation_page.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/view_channel_photos.dart';

class ConvoSettingsPage extends StatefulWidget {
  final Map data;
  final int channelId;
  ConvoSettingsPage(this.data, this.channelId);
  @override
  _ConvoSettingsPageState createState() => _ConvoSettingsPageState();
}

class _ConvoSettingsPageState extends State<ConvoSettingsPage> {
  bool _showMembers = false;
  Widget avatarCircle(Map data){
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400],
            blurRadius: 1,
            offset: Offset(2,3)
          )
        ],
        image: DecorationImage(
          fit: data['detail']['filename'] == null ? BoxFit.contain : BoxFit.cover,
          image: data['detail']['filename'] == null || data['detail']['filename'] == "" ? AssetImage('assets/messages_icon/no_profile.png') : NetworkImage('https://ujap.checkmy.dev/storage/clients/${data['detail']['filename']}')
        ),
        borderRadius: BorderRadius.circular(10000)
      ),
    );
  }
  int calculateRemainingMember(){
    List members = widget.data['members'];
    return members.length - 2;
  }
  Widget getMembers(){
    if(widget.data['members'].length > 2){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 50,
            child: Stack(
              children: [
                Positioned(
                  right: 0,
                  child: avatarCircle(widget.data['members'][0])
                ),
                Positioned(
                  left: 0,
                  child: avatarCircle(widget.data['members'][1])
                )
              ],
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(1000)
            ),
            child: Center(
              child: Text("+${calculateRemainingMember()}",style: TextStyle(
                color: Colors.white,
                fontFamily: "Google-Bold"
              ),),
            ),
          )
        ],
      );
    }else if(widget.data['members'].length == 1 || widget.data['members'].length == 0){
      return Container(
        width: double.infinity,
        alignment: AlignmentDirectional.center,
        child: avatarCircle(widget.data['members'][0]),
      );
    }else{
      if(widget.data['members'][1] == null){
        return Container(
          width: double.infinity,
          alignment: AlignmentDirectional.center,
          child: avatarCircle(widget.data['members'][0]),
        );
      }
      if(widget.data['members'][0]['client_id'] == userdetails['id']){
        return Container(
          width: double.infinity,
          alignment: AlignmentDirectional.center,
          child: avatarCircle(widget.data['members'][1]),
        );
      }
      return Container(
        width: double.infinity,
        alignment: AlignmentDirectional.center,
        child: avatarCircle(widget.data['members'][0]),
      );
    }
  }
  channelName(){
    if(widget.data['members'].length > 2){
      if(widget.data['name'] == "ec0fc0100c4fc1ce4eea230c3dc10360"){
        List names = [];
        for(var member in widget.data['members']){
          names.add(member['detail']['name']);
        }
        return names.join(',');
      }
      return widget.data['name'];
    }else if(widget.data['members'].length == 1 || widget.data['members'].length == 0){
      return "Juste toi";
    }else{
      if(widget.data['members'][1] == null){
        return "Juste toi";
      }
      if(widget.data['members'][0]['client_id'] == userdetails['id']){
        return widget.data['members'][1]['detail']['name'];
      }
      return widget.data['members'][0]['detail']['name'];
    }
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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: getMembers()
                ),
                Container(
                  child: Text("${channelName()}",textAlign: TextAlign.center,maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(
                    fontFamily: "Google-Bold",
                    fontSize: 18
                  ),),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: double.infinity,
                  alignment: AlignmentDirectional.center,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(1000),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2
                        )
                      ]
                    ),
                    child: FlatButton(
                      onPressed: (){
                        List members = [];
                        for(var m in widget.data['members']){
                          for(var x in events_clients){
                            if(int.parse(m['client_id'].toString()) == int.parse(x['id'].toString())){
                              members.add(x);
                            }
                          }
                        }
                        members.removeWhere((element) => element['id'] == userdetails['id']);
                        Navigator.push(context, PageTransition(child: NewGroupPage(participateWith: members,toAdd: true,channelId: widget.channelId,), type: PageTransitionType.bottomToTop));
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1000)
                      ),
                      padding: const EdgeInsets.all(5),
                      child: FittedBox(
                        child: Icon(Icons.person_add,color: Colors.black54,),
                      ),
                    ),
                  ),
                ),
                widget.data['members'].length > 2 ? Container(
                  margin: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: Text("Informations sur le groupe",style: TextStyle(
                      color: Colors.black54
                  ),),
                ) : Container(),
                // widget.data['members'].length > 2 ? Container(
                //     width: double.infinity,
                //     child: FlatButton(
                //       onPressed: (){
                //
                //       },
                //       child: Row(
                //         children: [
                //           Expanded(
                //             child: Text("Changer le nom du groupe"),
                //           ),
                //           Icon(Icons.edit)
                //         ],
                //       ),
                //     )
                // ) : Container(),
                widget.data['members'].length > 2 ? Container(
                    width: double.infinity,
                    child: FlatButton(
//              padding: const EdgeInsets.symmetric(horizontal: 0),
                      onPressed: (){
                        setState(() {
                          _showMembers = !_showMembers;
                        });
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text("${_showMembers ? "Cacher" : "Voir"} les membres du groupe"),
                          ),
                          Icon(!_showMembers ? Icons.visibility : Icons.visibility_off)
                        ],
                      ),
                    )
                ) : Container(),
                // Container(
                //   width: double.infinity,
                //   child: Text("Actions",style: TextStyle(
                //     color: Colors.black54
                //   ),),
                // ),
                Container(
                  width: double.infinity,
                  child: FlatButton(
//              padding: const EdgeInsets.symmetric(horizontal: 0),
                    onPressed: (){
                      Navigator.push(context, PageTransition(child: ViewChannelPhotos(widget.channelId), type: PageTransitionType.bottomToTop));
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text("Voir les photos"),
                        ),
                        Icon(Icons.photo_size_select_actual)
                      ],
                    ),
                  )
                ),
                Container(
                    width: double.infinity,
                    child: FlatButton(
//              padding: const EdgeInsets.symmetric(horizontal: 0),
                      onPressed: (){
                        Navigator.push(context, PageTransition(child: SearchConversationPage(channelId: widget.channelId), type: PageTransitionType.bottomToTop));
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text("Rechercher dans la conversation"),
                          ),
                          Icon(Icons.search)
                        ],
                      ),
                    )
                ),
                widget.data['members'].length == 2 ? Container(
                    width: double.infinity,
                    child: FlatButton(
//              padding: const EdgeInsets.symmetric(horizontal: 0),
                      onPressed: (){
                        List participant = events_clients.where((element) => element['name'] == channelName()).toList();
                        Navigator.push(context, PageTransition(child: NewGroupPage(participateWith: participant,toAdd: false,), type: PageTransitionType.bottomToTop));
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text("Créer une discussion de groupe avec ${channelName()}"),
                          ),
                          Container(
                            width: 25,
                            height: 25,
                            alignment: AlignmentDirectional.center,
                            child: Image.asset("assets/messages_icon/add_group.png"),
                          )
                        ],
                      ),
                    )
                ) : Container()
              ],
            ),
          ),
          AnimatedContainer(
            width: double.infinity,
            duration: Duration(milliseconds: 400),
            height: _showMembers ? screenheight/4 : 0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
              color: Colors.grey[300]
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                              child: Text("Membres : ",style: TextStyle(
                                fontSize: screenheight/55,
                                fontWeight: FontWeight.w600
                              ),)
                          ),
                        ),
                        IconButton(icon: Icon(Icons.close), onPressed: ()=>setState(()=> _showMembers = false))
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: ListView.builder(
                    itemCount: widget.data['members'].length,
                    itemBuilder: (context, index) => Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          avatarCircle(widget.data['members'][index]),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text("${widget.data['members'][index]['detail']['name']}",style: TextStyle(
                              fontFamily: "Google-Bold"
                            ),),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

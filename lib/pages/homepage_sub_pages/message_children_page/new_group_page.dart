import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/new_compose_message.dart';
import 'package:ujap/services/conversation_chats_listener.dart';
import 'package:ujap/services/conversation_listener.dart';
import 'package:ujap/services/member_traversal.dart';
import 'package:ujap/services/message_controller.dart';

class NewGroupPage extends StatefulWidget {
  final List participateWith;
  bool toAdd = false;
  final int channelId;
  NewGroupPage({Key key, this.participateWith, this.toAdd, this.channelId}) : super(key : key);
  @override
  _NewGroupPageState createState() => _NewGroupPageState();

}

class _NewGroupPageState extends State<NewGroupPage> {
  List _selectedParticipants = [];
  List _clients = [];
  List _toAdd = [];

  TextEditingController _search = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _clients = events_clients;
      _clients.removeWhere((element) => element['id'] == userdetails['id']);
    });
    if(widget.participateWith != null){
      setState(() {
        _selectedParticipants = widget.participateWith;
      });
    }
  }
  bool checkifExist(int id) {
    for(var selected in _selectedParticipants){
      if(int.parse(selected['id'].toString()) == id){
        return true;
      }
    }
    return false;
  }
  bool checkifExistToAdd(int id) {
    for(var add in _toAdd){
      if(int.parse(add['id'].toString()) == id){
        return true;
      }
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: Text("Ajouter des participants"),
          actions: [
            FlatButton(
              onPressed: widget.toAdd ? _toAdd.length > 0 ? () async {
                print("ADD");

                for(var add in _toAdd){
                  conversationService.addMember(widget.channelId, add['id']);
                  Messagecontroller().sendmessage("", "Vous avez été ajouté à un groupe", add['id'], true, "add as member");
                  for(var member in _selectedParticipants){
                    Messagecontroller().updateMembers(int.parse(member['id'].toString()), add);
                  }
                }
                Navigator.of(context).pop(null);
                Navigator.of(context).pop(null);
              } : null : _selectedParticipants.length >= 2 ? () async {
                chatListener.updateChannelID(id: 0);
                chatListener.updateAll(data: []);
                Navigator.of(context).pop(null);
                Navigator.of(context).pop(null);
                if(widget.participateWith != null){
                  Navigator.of(context).pop(null);
                }
                List dd = MemberTraverser().getIdsRaw(from: _selectedParticipants);
                dd.add(userdetails['id']);
                dd.sort();
                await conversationService.checkConvoMembersExist(memberIds: dd).then((value) {
                  Navigator.push(context, PageTransition(child: NewComposeMessage(value), type: PageTransitionType.leftToRightWithFade));
                });

                for(var selected in _selectedParticipants){
                  Messagecontroller().sendmessage("", "Vous avez été ajouté à un groupe", selected['id'], true, "add as member");
                }
              } : null,
              child: Text(widget.toAdd ? "Ajouter" : "Créer",style: TextStyle(
                color: widget.toAdd ? _toAdd.length > 0 ? Colors.white : Colors.white54  : _selectedParticipants.length >= 2 ? Colors.white : Colors.white54
                ),
              )
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
//              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(),
              child: Theme(
                data: ThemeData(
                  primaryColor: kPrimaryColor
                ),
                child: TextField(
                  controller: _search,
                  onChanged: (text)=> setState((){
                    _clients=events_clients.where((element) => element['name'].toString().toLowerCase().contains(text.toLowerCase())).toList();
                    _clients.removeWhere((element) => element['id'] == userdetails['id']);
                  }),
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
//                contentPadding: EdgeInsets.all(0),
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    hintText: "Chercher"
                  ),
                ),
              )
            ),
            _selectedParticipants.length == 0 ? Container() : Container(
              width: double.infinity,
              height: screenheight/13,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for(var selected in _selectedParticipants)...{
                    Container(
                      width: 50,
                      height: double.infinity,
                      margin: const EdgeInsets.only(left: 20),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey[300],
                                            blurRadius: 2,
                                            offset: Offset(2,3)
                                        )
                                      ],
                                    borderRadius: BorderRadius.circular(1000),
                                    image: DecorationImage(
                                      fit: selected['filename'] == null ? BoxFit.contain : BoxFit.cover,
                                      image: selected['filename'] == null ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${selected['filename']}")
                                    )
                                  ),
                                ),
                                Text("${selected['name']}",
                                  style: TextStyle(),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                          ),
                          widget.toAdd ? Container() : Container(
                            width: double.infinity,
                            alignment: AlignmentDirectional.topEnd,
                            child: GestureDetector(
                              onTap: ()=> setState(()=> _selectedParticipants.removeWhere((element) => element['id'] == selected['id'])),
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(1000),
                                  color: Colors.white
                                ),
                                child: Center(
                                  child: Icon(Icons.close,color: Colors.black54,size: 13,),
                                ),
                              ),
                            )
                          )
                        ],
                      )
                    )
                  },

                  for(var add in _toAdd)...{
                    Container(
                        width: 50,
                        height: double.infinity,
                        margin: const EdgeInsets.only(left: 20),
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey[300],
                                              blurRadius: 2,
                                              offset: Offset(2,3)
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(1000),
                                        image: DecorationImage(
                                            fit: add['filename'] == null ? BoxFit.contain : BoxFit.cover,
                                            image: add['filename'] == null ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${add['filename']}")
                                        )
                                    ),
                                  ),
                                  Text("${add['name']}",
                                    style: TextStyle(),
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                  )
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            ),
                            Container(
                                width: double.infinity,
                                alignment: AlignmentDirectional.topEnd,
                                child: GestureDetector(
                                  onTap: ()=> setState(()=> _toAdd.removeWhere((element) => element['id'] == add['id'])),
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(1000),
                                        color: Colors.white
                                    ),
                                    child: Center(
                                      child: Icon(Icons.close,color: Colors.black54,size: 13,),
                                    ),
                                  ),
                                )
                            )
                          ],
                        )
                    )
                  }
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              child: Text("Suggéré",style: TextStyle(
                  color: Colors.black54,
                  fontSize: screenwidth/33
              ),),
            ),
            Expanded(
              child: ListView(
                children: [
                  for(var client in _clients)...{
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: FlatButton(
                        onPressed: (){
                          setState(() {
//                      selected = contacts;
//                      _search.text = contacts['name'];
                            if(checkifExist(int.parse(client['id'].toString()))){
                              if(widget.toAdd){
                                _toAdd.removeWhere((element) => element['id'] == client['id']);
                              }else{
                                _selectedParticipants.removeWhere((element) => element['id'] == client['id']);
                              }
                            }else {
                              if(widget.toAdd){
                                _toAdd.add(client);
                              }else{
                                _selectedParticipants.add(client);
                              }
                            }
                          });
                        },
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey[300],
                                      blurRadius: 2,
                                      offset: Offset(2,3)
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(1000),
                                  image: DecorationImage(
                                    fit: client['filename'] == null ? BoxFit.contain : BoxFit.cover,
                                      image: client['filename'] == null ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${client['filename']}")
                                  )
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text("${client['name']}",style: TextStyle(
                                  fontFamily: "Google-Bold",
                                  fontSize: screenwidth/30
                              ),),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(checkifExist(int.parse(client['id'].toString())) || checkifExistToAdd(int.parse(client['id'].toString())) ? Icons.check_circle : Icons.check_circle_outline, color: checkifExist(int.parse(client['id'].toString())) ||checkifExistToAdd(int.parse(client['id'].toString())) ? Colors.green : Colors.black54,)
                          ],
                        ),
                      ),
                    )
                  }
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}

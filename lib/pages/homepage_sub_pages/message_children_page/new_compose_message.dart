import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:ujap/controllers/home.dart';
import 'package:ujap/globals/container_data.dart';
import 'package:ujap/globals/user_data.dart';
import 'package:ujap/globals/variables/home_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/pages/credentials_sub_pages/loginpage.dart';
import 'package:ujap/pages/drawer_page.dart';
import 'package:ujap/pages/homepage.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/download_pdf%202.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/matches.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/convo_settings_page.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/message_children/image_to_send.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/slider.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/view_message_images.dart';
import 'package:ujap/services/api.dart';
import 'package:ujap/services/conversation_chats_listener.dart';
import 'package:ujap/services/conversation_listener.dart';
import 'package:ujap/services/member_traversal.dart';
import 'package:ujap/services/message_controller.dart';
import 'package:ujap/services/string_formatter.dart';
import 'package:http/http.dart' as http;

bool hasData = false;

class NewComposeMessage extends StatefulWidget {
  Map channelDetail, senderDetail;
  NewComposeMessage(this.channelDetail,this.senderDetail);
  @override
  _NewComposeMessageState createState() => _NewComposeMessageState();
}

class _NewComposeMessageState extends State<NewComposeMessage> {
  bool _isKeyboardActive = false;
  bool _imagetoSend = false;
  bool _filetoSend = false;

  List<int> memberIds = [];
  List _imageExtensions = ['jpg','png','jpeg','gif','tiff','eps',];
  String b64;
  String b64ImagetoSend = "";
  String b64FiletoSend = "";
  String extension;
  Map channelDetail;
  int dateBetween;
  ScrollController _scrollController = new ScrollController();
  KeyboardVisibilityController _keyboardVisibilityController = KeyboardVisibilityController();
  TextEditingController _message = new TextEditingController();
  bool toShow = false;
  getDetails() async {
    setState(() {
      channelDetail = widget.channelDetail;
      for(var member in channelDetail['members']){
        memberIds.add(int.parse(member['client_id'].toString()));
      }
    });
  }

  Future send({int channelID, String message = "", String b64, String ext, List<int> receiverIds, String reason = "", Map channelDetails, context}) async {
    try{
      Map body;
      if(b64 == null){
        body = {
          "channel_id" : "${channelID.toString()}",
          "sender_id" : "${userdetails['id'].toString()}",
          "message" : "$message",
          "date_sent" : "${DateTime.now()}"
        };
      }else{
        body = {
          "channel_id" : "${channelID.toString()}",
          "sender_id" : "${userdetails['id'].toString()}",
          "message" : "$message",
          "date_sent" : "${DateTime.now()}",
          "file" : "data:file/$ext;base64,$b64"
        };
      }
      await http.post("${conversationService.urlString}/channel/send",headers: {
        HttpHeaders.authorizationHeader : "Bearer $accesstoken",
        "accept" : "application/json"
      }, body: body).then((respo) {
        var data = json.decode(respo.body);
        if(respo.statusCode == 200){
          setState(() {
            conversationService.updateLastConvo(onId: channelID,data: data['result']);
            chatListener.append(data: data['result']);
            chatListener.updateChannelID(id: channelID);
            print('DIDI NASULOD'+receiverIds.toString());
            for(var id in receiverIds){
              if(id != int.parse(userdetails['id'].toString())){
                messagecontroller.sendmessage(data['result'],message, id,false, reason,receiverIds);
              }
            }
            b64ImagetoSend = "";
            _imagetoSend = false;
            b64FiletoSend = "";
            _filetoSend = false;
          });
        }else{
          print('ERROR sss :'+respo.body.toString());
        }
      });
    }catch(e){
      print("ERROR : $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initStatess
      super.initState();
    if (pdfFile != null){
      b64 = base64.encode(pdfFile.readAsBytesSync());
      b64ImagetoSend = b64;
      extension = pdfFile.toString().split('/')[pdfFile.toString().split('/').length - 1].split('.')[1];
    }
    _keyboardVisibilityController.onChange.listen((event) {
      if(this.mounted){
        setState(() {
          _isKeyboardActive = event;
        });
      }
    }).onError((e){
      print("ERROR : $e");
    });
    getDetails();
  }
  @override
  void dispose() {
    super.dispose();
    chatListener.updateChannelID(id: 0);
    chatListener.updateAll(data: null);
  }
  getFromGallery() async {
    try{
      await ImagePicker().getImage(source: ImageSource.gallery).then((value) {
        if(value != null){
          setState(() {
            b64 = base64.encode(new File(value.path).readAsBytesSync());
            b64ImagetoSend = b64;
            extension = value.path.split('/')[value.path.split('/').length - 1].split('.')[1];
          });
          print("EXTENSION : $extension");
        }
      });
    }catch(e){
      print('IMAGE PICKER ERROR :'+e.toString());
    }
  }
  getFromCamera() async {
    try{
      await ImagePicker().getImage(source: ImageSource.camera).then((value) {
        if(value != null){
          setState(() {
            b64 = base64.encode(new File(value.path).readAsBytesSync());
            b64ImagetoSend = b64;
            extension = value.path.split('/')[value.path.split('/').length - 1].split('.')[1];
          });
          print("EXTENSION : $extension");
        }
      });
    }catch(e){
      print('IMAGE PICKER ERROR :'+e.toString());
    }
  }
  getFromFile() async {
    await FilePicker.platform.pickFiles(type: FileType.custom,allowMultiple: false,allowedExtensions: ['jpg', 'pdf', 'doc'],).then((value) {
      if(value != null){
        setState(() {
          b64 = base64.encode(new File(value.paths[0]).readAsBytesSync());
          b64FiletoSend = b64;
          extension = value.paths[0].split('/')[value.paths[0].split('/').length - 1].split('.')[1];
        });
        print('PDF '+b64FiletoSend.toString());
      }
    });
  }
  String getChannelName(){
    if(channelDetail['members'].length == 1 || channelDetail['members'].length == 0 ){
      return "Juste toi";
    }else if(memberIds.length > 2){
      if(channelDetail['name'] == "ec0fc0100c4fc1ce4eea230c3dc10360"){
        List names = [];
        for(var mem in channelDetail['members']){
          names.add(mem['detail']['name']);
        }
        return names.join(',');
      }
      return channelDetail['name'];
    }else{
      if(channelDetail['members'][1] == null || channelDetail['members'][0]['client_id'] == channelDetail['members'][1]['client_id']){
        return "Juste toi";
      }else{
        if(channelDetail['members'][0]['client_id'] == userdetails['id']){
          return channelDetail['members'][1]['detail']['name'];
        }
        return channelDetail['members'][0]['detail']['name'];
      }
    }
  }
  Widget getImage(){
    if(memberIds.length == 1 || memberIds.length == 0){
      if(userdetails['filename'].toString() == "null" || userdetails['filename'].toString() == ""){
        return Image.asset("assets/messages_icon/no_profile.png",fit: BoxFit.contain,);
      }
      return Image.network("https://ujap.checkmy.dev/storage/clients/${userdetails['filename']}",fit: BoxFit.cover,);
    }else if(memberIds.length > 2){
      return Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: channelDetail['members'][0]['detail']['filename'] == null ? BoxFit.contain : BoxFit.cover,
                      image: channelDetail['members'][0]['detail']['filename'] == null ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${channelDetail['members'][0]['detail']['filename']}")
                  )
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: channelDetail['members'][1]['detail']['filename'] == null ? BoxFit.contain : BoxFit.cover,
                            image: channelDetail['members'][1]['detail']['filename'] == null ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${channelDetail['members'][1]['detail']['filename']}")
                        )
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: channelDetail['members'][2]['detail']['filename'] == null ? BoxFit.contain : BoxFit.cover,
                            image: channelDetail['members'][2]['detail']['filename'] == null ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${channelDetail['members'][2]['detail']['filename']}")
                        )
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      );
    }else{
      if(channelDetail['members'][0]['client_id'] == userdetails['id']){
        if(channelDetail['members'][1]['detail']['filename'].toString() == "null" || channelDetail['members'][1]['detail']['filename'].toString() == ""){
          return Image.asset("assets/messages_icon/no_profile.png");
        }
        return Image.network("https://ujap.checkmy.dev/storage/clients/${channelDetail['members'][1]['detail']['filename']}",fit: BoxFit.cover,);
      }
      if(channelDetail['members'][0]['detail']['filename'].toString() == "null"  || channelDetail['members'][1]['detail']['filename'].toString() == ""){
        return Image.asset("assets/messages_icon/no_profile.png");
      }
      return Image.network("https://ujap.checkmy.dev/storage/clients/${channelDetail['members'][0]['detail']['filename']}",fit: BoxFit.cover,);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.channelDetail['last_convo'] != null){
      final birthday = DateTime.parse(widget.channelDetail['last_convo']['date_sent']);
      final date2 = DateTime.now();
      dateBetween  = date2.difference(birthday).inDays;
    }
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
            onPressed: (){
              if (widget.channelDetail['last_convo'] == null && widget.channelDetail['members'].length == 2){
              // conversationService.deleteChannelLoc(widget.channelDetail['id']);
              }
              setState(() {
                currentindex = 2;
                indexListener.update(data: 2);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen(false)));
              });
        },
          ),
          backgroundColor: kPrimaryColor,
          titleSpacing: 0,
          centerTitle: true,
          title: Container(
            width: double.infinity,
            height: 60,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(1000),

                  ),
                  child: channelDetail == null ? Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),),
                    ),
                  ) : ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: getImage(),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    child: Text("${channelDetail == null ? "" : "${StringFormatter().titlize(data: getChannelName())}"}",style: TextStyle(fontSize: screenwidth < 700 ? screenwidth/23 : screenwidth/40),),
                  ),
                )
              ],
            ),
          ),
          actions: [
             IconButton(icon: Icon(Icons.settings), onPressed: ()=>Navigator.push(context, PageTransition(child: ConvoSettingsPage(channelDetail,channelDetail['id']), type: PageTransitionType.rightToLeftWithFade)))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List>(
                stream: chatListener.stream$,
                builder: (context, snapshot) {
                  try{
                    if(snapshot.hasData){
                      return ListView(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shrinkWrap: true,
                        reverse: true,
                        children: [
                          Container(child: !_filetoSend ? Container() : ImageToSend(b64FiletoSend.toString(),_message.text.toString(),'File',_filetoSend)),
                          Container(child: !_imagetoSend ? Container() : ImageToSend(b64ImagetoSend.toString(),_message.text.toString(),'Image',_imagetoSend)),
                          for(var x =snapshot.data.length -1;x>=0;x--)...{
                              messageContainer(snapshot.data[x]),
                          },
                          Container(
                            child: Text("${channelDetail == null ? "" : "${StringFormatter().titlize(data: getChannelName())}"}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: screenwidth < 700 ? screenwidth/25 : screenwidth/40,
                                fontFamily: "Google-Medium",
                                color: Colors.grey[800]
                              ),
                            ),
                            margin: EdgeInsets.only(bottom: 20),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            alignment: Alignment.center,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(1000),

                              ),
                              child: channelDetail == null ? Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),),
                                ),
                              ) : ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child: getImage(),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                      ),
                    );
                  }catch(e){
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: screenwidth/4,
                            height: screenwidth/4,
                            child: Image(
                              color: Colors.grey[700],
                              image: NetworkImage('https://static.thenounproject.com/png/1106407-200.png'),
                            ),
                          ),
                          Text("Une erreur s'est produite".toString(),style: TextStyle(fontSize: screenwidth < 700 ? screenwidth/25  : 20,fontFamily: 'Google-Medium',color: Colors.grey[600]),),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              child: Text("Veuillez d'abord essayer de le fermer et de l'ouvrir à nouveau pour résoudre ce problème.",style: TextStyle(fontSize: screenwidth < 700 ? screenwidth/30  : 15,fontFamily: 'Google-Regular',color: Colors.grey[500]),textAlign: TextAlign.center,)),
                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 40),
                              height: screenwidth/8,
                              width: screenwidth,
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: BorderRadius.circular(5)
                              ),
                              child: Center(
                                  child: Text('FERMER LA PAGE',style: TextStyle(fontSize: screenwidth < 700 ? screenwidth/25  : 20,fontFamily: 'Google-Medium',color: Colors.white),),
                              ),
                            ),
                            onTap: (){
                                  Navigator.push(context, PageTransition(child: MainScreen(false), type: PageTransitionType.topToBottom));
                              //   });
                              // }
                            },
                          )
                        ],
                      )
                    );
                  }
                },
              ),
            ),
            b64 == null ? Container() : Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
              height: 60,
              color: Colors.grey[200],
              child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          alignment: AlignmentDirectional.centerStart,
                          child: _imageExtensions.contains(extension) ?
                          GestureDetector(
                              child: Image.memory(base64.decode(b64)),
                            onTap: (){

                            },
                          ) :
                          GestureDetector(
                            onTap: (){
                            },
                            child: Row(
                              children: [
                                Icon(Icons.attach_file,color: Colors.blue,),
                                Expanded(
                                  child: Text( pdfFile != null ? "Ujap ticket.pdf" : "Ujap.pdf",style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    fontStyle: FontStyle.italic
                                  ),),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel,color: Colors.grey,),
                        onPressed: ()=> setState((){
                          b64 = null;
                          extension = null;
                        }),
                      ),
                    ],
                  )
              ),
            ),
            SafeArea(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Row(
                  children: [
                    AnimatedContainer(
                      width: _isKeyboardActive ? 0 : screenwidth/3,
                      duration: Duration(
                        milliseconds: 300,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: IconButton(
                                icon: Icon(Icons.camera_alt),
                                onPressed: getFromCamera,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: IconButton(
                                icon: Icon(Icons.image),
                                onPressed: getFromGallery,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: IconButton(
                                icon: Icon(Icons.attach_file),
                                onPressed: getFromFile,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: AnimatedContainer(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15)
                        ),
                        duration: Duration(milliseconds: 300),
                        child: TextField(
                          controller: _message,
                          cursorColor: kPrimaryColor,
                          maxLines: 4,
                          minLines: 1,
                          onChanged: (text){
                            if (b64 != null){
                              toShow = text.isNotEmpty;
                            }else{
                              setState(() {
                                toShow = text.isNotEmpty;
                              });
                            }
                          },
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                            border: InputBorder.none,
                            hintText: _isKeyboardActive ? "Tapez un message" : "Aa"
                          ),
                        ),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 400),
                      child: _message.text.isNotEmpty || b64 != null ? IconButton(
                        icon: Icon(Icons.send,color: kPrimaryColor,),
                        onPressed: (){
                          List _clientDetails = channelDetail['messages'].where((s){
                            return s.toString().contains("a quitté le groupe.");
                          }).toList();

                          if (_clientDetails.toString() != "null" && _clientDetails.toString() != "[]" && channelDetail['members'].length > 2){
                            print(_clientDetails.toString());
                            List _localresult = _clientDetails.where((s){
                              return s['message'].toString().contains("a quitté le groupe.");
                            }).toList();

                            print('RESULT OF LOCAL :'+_localresult.toString());

                            for (var x = 0; x < _localresult.length; x ++){
                              memberIds.removeWhere((s){
                                return s == _localresult[x]['sender_id'];
                              });
                            }
                          }

                          if (_message.text.isNotEmpty || b64 != null){
                            setState(() {
                              if (b64ImagetoSend != ""){
                                _imagetoSend = true;
                              }
                              if (b64FiletoSend != ""){
                                _filetoSend = true;
                              }
                              send(
                                channelID: channelDetail['id'],
                                message: _message.text,
                                b64: b64,
                                ext: extension,
                                receiverIds: memberIds,
                                context: context,
                                channelDetails: widget.channelDetail,
                              );
                              _message.clear();
                              _message.text = "";
                              b64 =null;
                              extension = null;
                              _message.text = null;
                              pdfFile = null;
                            });
                          }

                        },
                      ) : Container(),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  messageContainer(Map data){
   return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child:  data['message'].toString().contains('a quitté le groupe.')  ?
        Container(
          width: screenwidth,
          child: Text(data['message'].toString(),style: TextStyle(fontSize: screenwidth < 700 ? screenwidth/35 : screenwidth/40,color: Colors.grey[600]),textAlign: TextAlign.center,),
        ) :
        Row(
          mainAxisAlignment: data['sender_id'].toString() == userdetails['id'].toString() ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            data['sender_id'] == userdetails['id'] ? Container() : Container(
              margin: const EdgeInsets.only(right: 10),
              child: senderImage(data),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                data['sender_id'].toString() == userdetails['id'].toString() ? Container() : Text(channelDetail['members'].where((s)=> s['client_id'] == data['sender_id']).toList()[0]['detail']['name'].toString(),style: TextStyle(fontSize: screenwidth < 700 ? screenwidth/35 : screenwidth/40,color: Colors.grey[600]),),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: data['sender_id'] == userdetails['id'] ? kPrimaryColor : Colors.grey[300],
                      borderRadius: BorderRadius.circular(5)
                  ),
                  constraints: BoxConstraints(
                      maxWidth: screenwidth/1.6
                  ),
                  child: Column(
                    crossAxisAlignment: data['sender_id'] == userdetails['id'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      if(data['message'] != null)...{
                        Text("${data['message']}",style: TextStyle(
                            color: data['sender_id'] == userdetails['id'] ? Colors.white : Colors.black,
                            fontSize: screenwidth < 700 ? screenwidth/30 : screenwidth/47
                        ),),
                      },
                      if(data['filename'] != null)...{
                        Builder(
                          builder: (context) {
                            try{
                              if(!_imageExtensions.contains(data['filename'].toString().split('/')[data['filename'].toString().split('/').length - 1].split('.')[1]))
                              {
                                return GestureDetector(
                                  onTap: () async {
                                    WidgetsFlutterBinding.ensureInitialized();
                                    print(data['filename'].toString());
                                    Navigator.push(context, PageTransition(child:  ViewMessageImages(
                                        "https://ujap.checkmy.dev${data['filename']}"
                                    ),type: PageTransitionType.leftToRightWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
                                  },
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxHeight: screenheight/5,
                                    ),
                                    child: Text("UJAP.pdf",style: TextStyle(
                                        color: data['sender_id'] == userdetails['id'] ? Colors.white : Colors.blue,
                                        fontStyle: FontStyle.italic,
                                        decoration: TextDecoration.underline
                                    ),),
                                  ),
                                );
                              }
                              return Container(
                                constraints: BoxConstraints(
                                    maxHeight: screenheight/5
                                ),
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, PageTransition(child:  ViewMessageImages(
                                        "https://ujap.checkmy.dev${data['filename']}"
                                    ),type: PageTransitionType.leftToRightWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
                                  },
                                  onLongPress: ()async{
                                    print("LONG PRESS");
                                    print(await FirebaseMessaging().getToken());
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: "https://ujap.checkmy.dev${data['filename']}",
                                    placeholder: (context, url) => CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                  // child: Image(
                                  //   image:  NetworkImage("https://ujap.checkmy.dev${data['filename']}"),
                                  // ),
                                ),
                              );
                            }catch(e){
                              return Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: screenwidth/4,
                                        height: screenwidth/4,
                                        child: Image(
                                          color: Colors.grey[700],
                                          image: NetworkImage('https://static.thenounproject.com/png/1106407-200.png'),
                                        ),
                                      ),
                                      Text("Une erreur s'est produite".toString(),style: TextStyle(fontSize: screenwidth < 700 ? screenwidth/25  : 20,fontFamily: 'Google-Medium',color: Colors.grey[600]),),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                          padding: EdgeInsets.symmetric(horizontal: 50),
                                          child: Text("Veuillez d'abord essayer de le fermer et de l'ouvrir à nouveau pour résoudre ce problème.",style: TextStyle(fontSize: screenwidth < 700 ? screenwidth/30  : 15,fontFamily: 'Google-Regular',color: Colors.grey[500]),textAlign: TextAlign.center,)),
                                      GestureDetector(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 40),
                                          height: screenwidth/8,
                                          width: screenwidth,
                                          decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: Center(
                                            child: Text('FERMER LA PAGE',style: TextStyle(fontSize: screenwidth < 700 ? screenwidth/25  : 20,fontFamily: 'Google-Medium',color: Colors.white),),
                                          ),
                                        ),
                                        onTap: (){
                                          Navigator.push(context, PageTransition(child: MainScreen(false), type: PageTransitionType.topToBottom));
                                        },
                                      )
                                    ],
                                  )
                              );
                            }
                          },
                        )
                      }
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: dateBetween == 0 ? Text(DateFormat('kk:mm').format(DateTime.parse(widget.channelDetail['last_convo']['date_sent'])),style: TextStyle(fontSize: screenwidth < 700 ? 11 : 16,color: Colors.grey, fontFamily: "Google-medium"),textAlign: TextAlign.end,) :
                  dateBetween == 1 ? Text('Yesterday',style: TextStyle(fontSize: screenwidth < 700 ? 11 : 16,color: Colors.grey, fontFamily: "Google-medium"),) :
                  dateBetween > 1 ? Text('${dateBetween.toString()} days ago',style: TextStyle(fontSize: screenwidth < 700 ? 11 : 16,color: Colors.grey, fontFamily: "Google-medium"),) :
                  dateBetween > 7 ? Text('A week ago',style: TextStyle(fontSize: screenwidth < 700 ? 11 : 16,color: Colors.grey, fontFamily: "Google-medium"),) :
                  Text(DateFormat("d").format(DateTime.parse(widget.channelDetail['last_convo']['date_sent'])).toString().toUpperCase()+' '+monthDate[int.parse(DateFormat("MM").format(DateTime.parse(widget.channelDetail['last_convo']['date_sent'])).toString())].toString()+'.'+' '+DateFormat("yyyy").format(DateTime.parse(widget.channelDetail['last_convo']['date_sent'])).toString().toUpperCase(),style: TextStyle(fontSize: screenwidth < 700 ? 13 : 16,color: Colors.grey, fontFamily: "Google-medium"),),
                )
              ],
            ),
            data['sender_id'] == userdetails['id'] ? Container(
              margin: const EdgeInsets.only(left: 10),
              child: senderImage(data,),
            ) : Container(),
          ],
        )
    );
  }
  Widget senderImage(Map senderData) {
    return senderData['sender_id'].toString() == userdetails['id'].toString() ? Container() : Container(
      width: screenwidth < 700 ? 40 : 60,
      height: screenwidth < 700 ? 40 : 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: Colors.white,
        image: DecorationImage(
          fit: BoxFit.cover,
          image:  channelDetail['members'].where((s)=> s['client_id'] == senderData['sender_id']).toList()[0]['detail']['filename'].toString() == "null" ||  channelDetail['members'].where((s)=> s['client_id'] == senderData['sender_id']).toList()[0]['detail']['filename'].toString() == ""  ? AssetImage("assets/messages_icon/no_profile.png") : NetworkImage("https://ujap.checkmy.dev/storage/clients/${channelDetail['members'].where((s)=> s['client_id'] == senderData['sender_id']).toList()[0]['detail']['filename'].toString()}")
        )
      ),
    );
  }
}

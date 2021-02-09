import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:ujap/globals/variables/messages_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/show_snackbar.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/download_pdf%202.dart';
import 'package:ujap/pages/homepage_sub_pages/home_children_page/view_download_pdf.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/list_of_clients.dart';
import 'package:url_launcher/url_launcher.dart';

List<String> attachmentsFile = [];
var opponentTeam = "";

class SendGmail extends StatefulWidget {
  @override
  _SendGmailState createState() => _SendGmailState();
}

class _SendGmailState extends State<SendGmail> {
  bool isHTML = false;
  List<String> _receipents = [];
  var _reciepent = "";
  String platformResponse;

  TextEditingController _recipientController = new TextEditingController();
  final _subjectController = TextEditingController(text: 'Billet UJAP Match');
  final _bodyController = TextEditingController(
    text: "Bonjour, c'est le ticket pour le match entre l'équipe UJAP et $opponentTeam équipe.",
  );

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients:_receipents,
      attachmentPaths: attachmentsFile,
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
        print('here dapat');
        platformResponse = "L'e-mail a bien été envoyé.".toString();
      Future.delayed(Duration(seconds: 2)).then((_) {
        // this code is executed after the future ends.
        Navigator.of(context).pop(null);
        _scaffoldKey.currentState.showSnackBar( SnackBar(content: Text("SNACKBAR") ) );
      } );
    } catch (error) {
       platformResponse = "Connectez-vous d'abord à votre compte Gmail pour continuer.".toString();
       print(error.toString());
    }

    if (!mounted) return;
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(platformResponse),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            centerTitle: true,
            title: Container(
                child: Text('Envoyer un ticket par e-mail',style: TextStyle(fontFamily: 'Google-Bold',color: Colors.white,fontSize: screenwidth < 700 ? screenheight/40 : 20 ),textAlign: TextAlign.center,)),
            actions: <Widget>[
              Builder(
                builder:(context)=> IconButton(
                  onPressed: (){
                    setState(() {
                      if (_receipents.length != 0 || _recipientController.text.isNotEmpty){
                        send();
                        print('DAPAT SUMOLOD DIDI :'+attachmentsFile.toString());
                      }else{
                        showSnackBar(context, "Veuillez saisir le destinataire de l'e-mail");
                      }
                    });
                  },
                  icon: Icon(Icons.send),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Builder(
                      builder:(context)=> TextField(
                        controller: _recipientController,
                        style: TextStyle(fontFamily: 'Google-Medium',color: Colors.grey[800],fontSize: screenwidth < 700 ? screenheight/48 : 20 ),textAlign: TextAlign.left,
                        // controller: _recipientController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Recipient',
                          suffixIcon: !_reciepent.toString().contains("com") ? null : IconButton(
                            icon: Icon(Icons.person_add,size: screenwidth < 700 ? 25 : 30,color: Colors.grey[600],),
                            onPressed: (){
                             setState(() {
                               _receipents.add(_reciepent.toString());
                               _reciepent = "";
                               _recipientController.text = "";
                             });
                            },
                          )
                        ),
                        onChanged: (text){
                          setState(() {
                            _reciepent = text;
                            if (_recipientController.text.toString().contains('.com')){
                              attachmentsFile.add(pdfFile.path);
                              if (_receipents.toString().toLowerCase().contains(_reciepent.toString().toLowerCase())){
                                showSnackBar(context, 'Cet e-mail est déjà sélectionné.');
                              }else{
                                _receipents.add(_reciepent.toString());
                              }
                              _reciepent = "";
                              _recipientController.text = "";
                            }
                          });
                        },
                      ),
                    ),
                  ),
                   for (var x = 0; x < _receipents.length; x++)
                   Container(
                     margin: EdgeInsets.symmetric(vertical: 5),
                     padding: EdgeInsets.symmetric(horizontal: 8),
                     width: screenwidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_receipents[x].toString(), style: TextStyle(fontFamily: 'Google-Medium',color: Colors.grey[700],fontSize: screenwidth < 700 ? screenheight/55 : 20 )),
                        GestureDetector(
                          child:  Icon(Icons.remove_circle_outline,color: Colors.grey[800],size: screenwidth < 700 ? 25 : 30,),
                          onTap: (){
                            setState(() {
                              _receipents.remove(_receipents[x].toString());
                            });
                          },
                        )
                      ],
                    ),
                    ),
                _receipents.length == 0 ? Container() : SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      style: TextStyle(fontFamily: 'Google-Medium',color: Colors.grey[800],fontSize: screenwidth < 700 ? screenheight/48 : 20 ),textAlign: TextAlign.left,
                      controller: _subjectController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Subject',
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      style: TextStyle(fontFamily: 'Google-Medium',color: Colors.grey[800],fontSize: screenwidth < 700 ? screenheight/50 : 20 ),textAlign: TextAlign.left,
                      controller: _bodyController,
                      maxLines: 10,
                      decoration: InputDecoration(
                          labelText: 'Body', border: OutlineInputBorder()),
                    ),
                  ),
                  CheckboxListTile(
                    title: Container(
                        width: double.infinity,
                        child: Text('HTML',style: TextStyle(color: Colors.black45.withOpacity(0.7),fontFamily: 'Google-Bold',fontSize: screenheight/50 ))),
                    onChanged: (bool value) {
                      setState(() {
                        isHTML = value;
                      });
                    },
                    value: isHTML,
                  ),
                  Container(
                    width: double.infinity,
                    height: screenwidth/4.5,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        GestureDetector(
                          child: Container(
                            width: screenwidth/4.5,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.contain,
                                  image: AssetImage("assets/messages_icon/pdf_icon.png"),
                                )
                            ),
                        ),
                          onTap: (){
                            setState(() {
                              uploadPDF();
                              Navigator.push(context, PageTransition(child: ViewDownloadPdf(
                              ),type: PageTransitionType.leftToRightWithFade,alignment: Alignment.center, curve: Curves.easeIn,duration: Duration(milliseconds: 500)));
                            });
                          },
                        ),
                        Container(
                          height: screenheight,
                          alignment: Alignment.centerLeft,
                          child: Text('BILLET DE MATCH PDF',style: TextStyle(color: Colors.black45.withOpacity(0.5),fontFamily: 'Google-Bold',fontSize: screenheight/60 )),
                        )
                      ],
                    ),
                  ),
                SizedBox(
                  height: screenwidth/7,
                ),
                platformResponse != "Connectez-vous d'abord à votre compte Gmail pour continuer.".toString() ? Container() :  GestureDetector(
                  child: Container(
                    height: screenwidth/10,
                    width: screenwidth,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Téléchargez plutôt l'application Gmail",style: TextStyle(color: Colors.white,fontFamily: 'Google-Bold',fontSize: screenheight/60 )),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage('https://assets.stickpng.com/images/5847fafdcef1014c0b5e48ce.png')
                            )
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap: ()async{
                    print('CLICK');
                    const url = 'https://apps.apple.com/us/app/gmail-email-by-google/id422689480';
                    if (await canLaunch(url)) {
                    await launch(url);
                    } else {
                    throw 'Could not launch $url';
                    }
                  },
                ),
                ],
              ),
            ),
          ),
          // floatingActionButton: FloatingActionButton.extended(
          //   icon: Icon(Icons.camera),
          //   label: Text('Add Image'),
          //   onPressed: _openImagePicker,
          // ),
      ),
      onTap: (){
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
    );
  }

  // void _openImagePicker() async {
  //   File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     attachments.add(pick.path);
  //   });
  // }
}
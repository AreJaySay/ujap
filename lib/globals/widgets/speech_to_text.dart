import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:ujap/globals/variables/messages_sub_pages_variables.dart';
import 'package:ujap/globals/variables/other_variables.dart';
import 'package:ujap/globals/widgets/show_snackbar.dart';
//import 'package:ujap/pages/homepage_sub_pages/message_children_page/compose_message.dart';
import 'package:ujap/pages/homepage_sub_pages/message_children_page/list_of_clients.dart';


const languages = const [
  const Language('Francais', 'fr_FR'),
  const Language('English', 'en_US'),
  const Language('Pусский', 'ru_RU'),
  const Language('Italiano', 'it_IT'),
  const Language('Español', 'es_ES'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class SpeechToText extends StatefulWidget {
  @override
  _SpeechToTextState createState() => new _SpeechToTextState();
}

class _SpeechToTextState extends State<SpeechToText> {
  TextEditingController _speechSearch = new TextEditingController();
  SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  bool _enableTextfield = false;
  FocusNode myFocusNode;
  String transcription = '';

  //String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
    myFocusNode = FocusNode();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_SpeechToTextState.activateSpeechRecognizer... ');
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);
    _speech.activate('fr_FR').then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        child: new Scaffold(
          appBar: new AppBar(
            backgroundColor: kPrimaryColor,
            actions: [
              new IconButton(
                icon: Icon(Icons.arrow_back_ios,size: 30,),
                onPressed: (){
                  Navigator.of(context).pop(null);
                },
              ),
              Expanded(
                child: new Container(
                  width: screenwidth,
                  height: screenheight,
                  alignment: Alignment.center,
                  child: Text('Reconnaissance vocale',style: TextStyle(fontFamily: 'Google-Bold',color: Colors.white,fontSize: screenwidth < 700 ? screenheight/40 : 23 ),textAlign: TextAlign.center,),
                ),
              ),
              new PopupMenuButton<Language>(
                icon: Icon(Icons.language,size: 30,),
                onSelected: _selectLangHandler,
                itemBuilder: (BuildContext context) => _buildLanguagesWidgets,
              )
            ],
          ),
          body: new Padding(
              padding: new EdgeInsets.all(8.0),
              child: new Center(
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    new Expanded(
                        child: new Container(
                            padding: const EdgeInsets.all(8.0),
                            color: Colors.grey.shade200,
                            child: TextField(
                              style: TextStyle(fontFamily: 'Google-Medium',color: Colors.grey[800],fontSize: screenwidth < 700 ? screenheight/45 : 20 ),
                              focusNode: myFocusNode,
                              enabled: _enableTextfield,
                              controller: _speechSearch,
                              maxLines: null,
                              decoration: InputDecoration(
                                border: InputBorder.none
                              ),
                            )
                        )),
                        Container(
                          height: screenheight/4,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                    child: Container(
                                      width: screenwidth/3,
                                      height: screenheight,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.keyboard,size: screenwidth/11,color:  _speechSearch.text.isEmpty ? Colors.grey[400] : Colors.grey[800],),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            child: Image(
                                              color:  _speechSearch.text.isEmpty ? Colors.grey[400] : Colors.grey[800],
                                              image: AssetImage('assets/double_tap.png'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        if (_speechSearch.text.isNotEmpty){
                                          myFocusNode.requestFocus();
                                          _enableTextfield = true;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              Expanded(
                                child: Container(
                                  width: screenwidth/3,
                                  height: screenheight,
                                  alignment: Alignment.center,
                                  child: _isListening ?
                                  Container(
                                    margin: EdgeInsets.all(20),
                                    width: screenwidth/3,
                                    height: screenheight,
                                    child: Image(
                                      fit: BoxFit.fitHeight,
                                      image: AssetImage('assets/mic_listen.gif'),
                                    ),
                                  ) : GestureDetector(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.mic,size: screenwidth/5,color: Colors.greenAccent,),
                                          Text('Appuyez pour parler',style: TextStyle(fontFamily: 'Google-Bold',color: Colors.black87.withOpacity(0.5),fontSize: screenwidth < 700 ? screenheight/40 : 20 ),textAlign: TextAlign.center,),
                                        ],
                                      ),
                                    ),
                                    onTap: (){
                                     setState(() {
                                       _isListening = true;
                                       start();
                                     });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: screenwidth/3,
                                  height: screenheight,
                                  child: GestureDetector(
                                    child: Center(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: screenwidth < 700 ? 10 : 15,horizontal:  screenwidth < 700 ? 12 : 25),
                                        decoration: BoxDecoration(
                                          color: _speechSearch.text.isEmpty ? kPrimaryColor.withOpacity(0.4) : kPrimaryColor,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text('Terminé',style: TextStyle(fontFamily: 'Google-Bold',color: Colors.white,fontSize: screenwidth < 700 ? screenheight/45 : 25 ),textAlign: TextAlign.center,),
                                      ),
//                                    child: Icon(Icons.check_circle,size: screenwidth/10,color: kPrimaryColor,),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        if (_speechSearch.text.isNotEmpty){
                                          Navigator.of(context).pop(null);
//                                          composeMessage.text = transcription.toString();
                                          messageToclient_public = transcription.toString();
                                          searchboxEvents.text = transcription.toString();
                                          tosearch_clients = transcription.toString();
                                        }
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
//                  _buildButton(
//                    onPressed: _speechRecognitionAvailable && !_isListening
//                        ? () => start()
//                        : null,
//                    label: _isListening
//                        ? 'Listening...'
//                        : 'Listen (${selectedLang.code})',
//                  ),
//                  _buildButton(
//                    onPressed: _isListening ? () => cancel() : null,
//                    label: 'Cancel',
//                  ),
//                  _buildButton(
//                    onPressed: _isListening ? () => stop() : null,
//                    label: 'Stop',
//                  ),
                  ],
                ),
              )),
        ),
        onTap: (){
         setState(() {
           SystemChannels.textInput.invokeMethod('TextInput.hide');
         });
        },
      ),
    );
  }

  List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets => languages
      .map((l) => new CheckedPopupMenuItem<Language>(
    value: l,
    checked: selectedLang == l,
    child: new Text(l.name),
  ))
      .toList();

  void _selectLangHandler(Language lang) {
    setState(() => selectedLang = lang);
  }

  Widget _buildButton({String label, VoidCallback onPressed}) => new Padding(
      padding: new EdgeInsets.all(12.0),
      child: new RaisedButton(
        color: Colors.cyan.shade600,
        onPressed: onPressed,
        child: new Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ));

  void start() => _speech.activate(selectedLang.code).then((_) {
    return _speech.listen().then((result) {
      print('_SpeechToTextState.start => result $result');
      setState(() {
        _isListening = result;
      });
    });
  });

  void cancel() =>
      _speech.cancel().then((_) => setState(() => _isListening = false));

  void stop() => _speech.stop().then((_) {
    setState(() => _isListening = false);
  });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    print('_SpeechToTextState.onCurrentLocale... $locale');
    setState(
            () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) {
    print('_SpeechToTextState.onRecognitionResult... $text');
    setState(() {
      transcription = text;
      _speechSearch.text = transcription;
    });
  }

  void onRecognitionComplete(String text) {
    print('_SpeechToTextState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
  }

  void errorHandler() => activateSpeechRecognizer();
}
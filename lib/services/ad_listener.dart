import 'dart:core';
import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ujap/pages/homepage.dart';
import 'package:ujap/services/conversation_chats_listener.dart';
import 'package:ujap/services/conversation_listener.dart';
import 'package:ujap/services/pushnotification.dart';
import 'package:ujap/services/string_formatter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class AdListener{
  BehaviorSubject<bool> _ad = new BehaviorSubject.seeded(false);
  Stream get stream$ => _ad.stream;
  bool get current => _ad.value;

  update(bool adState){
    print("ADSTATE : $adState");
    _ad.add(adState);
  }

  showAd(context,Map data) async {
    VideoPlayerController _videoController;
    ChewieController _chewieController;
    print('DATA ADS'+data['content'].toString());
    if(data['type'] != 'image' && data['ad_type'] != 1 && data['content'] != "null"){
      _videoController = VideoPlayerController.network('${StringFormatter().cleaner(StringFormatter().strToObj(data['content'])['location'])}');
      await _videoController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: true,
        looping: false,
        showControls: false,
        showControlsOnInitialize: false,
      );
    }
    print('showing');
    if(chatListener.getChannelID() == 0 && data['ad_type'] != 1 && data['content'] != "null"){
      return showGeneralDialog(
          barrierColor: Colors.black.withOpacity(0.5),
          transitionBuilder: (context, a1, a2, widget) {
            return Transform.scale(
              scale: a1.value,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 4,sigmaX: 4),
                child: Opacity(
                  opacity: a1.value,
                  child: AlertDialog(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    contentPadding: const EdgeInsets.all(0),
                    content: data['type'] == 'image' ? Container(
                      width: double.infinity,
//                    height: MediaQuery.of(context).size.height/1.5,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                            child: Text("${data['name']}"),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16)
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                String url = '${StringFormatter().cleaner(StringFormatter().strToObj(data['content'])['location'])}';
                                if (await canLaunch(url)) {
                                await launch(url);
                                } else {
                                throw 'Could not launch $url';
                                }
                              },
                                child: Image.network('${StringFormatter().cleaner(StringFormatter().strToObj(data['content'])['location'])}',fit: BoxFit.cover,)
                            ),
                          ),
                        ],
                      ),
                    ) : Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height/2,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              String url = '${StringFormatter().cleaner(StringFormatter().strToObj(data['content'])['location'])}';
                              if (await canLaunch(url)) {
                              await launch(url);
                              } else {
                              throw 'Could not launch $url';
                              }
                            },
                            child: Chewie(
                              controller: _chewieController,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(1000)
                              ),
                              child: FlatButton(
                                onPressed: (){
                                  Navigator.of(context).pop(null);
                                  if(_videoController != null && _chewieController != null && _chewieController.isPlaying){
                                    try{
                                      _videoController?.pause();
                                      _chewieController?.dispose();
                                    }catch(e){
                                      print("asda");
                                    }
                                  }
                                },
                                padding: const EdgeInsets.all(0),
                                child: Center(
                                  child: Icon(Icons.close,size: 15,color: Colors.grey[700],),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ),
                  ),
                ),
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 200),
          barrierDismissible: data['type'] == 'image',
          barrierLabel: '',
          context: context,

          pageBuilder: (context, animation1, animation2) {});
    } else{
      print("SHOW AD");
      adListener.update(true);
    }
  }


}
AdListener adListener = AdListener();
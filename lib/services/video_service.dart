import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class VideoService{
  final VideoPlayerController videoPlayerController;
  final ChewieController chewieController;
  VideoService({this.chewieController, this.videoPlayerController}){
    __init();
  }
  void __init() async {
    await this.videoPlayerController.initialize();
  }
  void dispose(){
    if(this.chewieController != null && this.videoPlayerController != null && this.chewieController.isPlaying){
      chewieController.pause();
      videoPlayerController.pause();
    }
  }
  Widget showVideo() {
    if(this.videoPlayerController != null && this.chewieController != null) {
      return Chewie(
        controller: this.chewieController,
      );
    }
    return Container();
  }
}
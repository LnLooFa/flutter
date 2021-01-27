
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDetailsWidget extends StatefulWidget {
  final StreamController streamController;
  VideoDetailsWidget({this.streamController});

  @override
  _VideoDetailsWidgetState createState() => _VideoDetailsWidgetState();
}

class _VideoDetailsWidgetState extends State<VideoDetailsWidget> {
  VideoPlayerController _controller;
  bool _isPlay = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/welcome_video.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    _controller.addListener(() {
      if(_isPlay&&!_controller.value.isPlaying){
        setState(() {
          _isPlay=false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //第一层视频
        Positioned.fill(
          child: GestureDetector(
            onTap: (){
              setState(() {
                _controller.pause();
                _isPlay=false;
              });
            },
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
        //第二层控制按钮
        buildControllerWidget(),
      ],
    );
  }

  Widget buildControllerWidget() {
    if (_isPlay) {
      return Container();
    }
    return Positioned.fill(
      child: Container(
        color: Colors.blueGrey.withOpacity(0.5),
        child: GestureDetector(
          onTap: () {
            setState(() {
              //发送通知先停止到播放,
              if(widget.streamController!=null){
                widget.streamController.add(_controller);
              }
              //总时长
              Duration duration = _controller.value.duration;
              //视频播放到当前位置
              Duration position = _controller.value.position;
              if(position == duration){
                _controller.seekTo(Duration.zero);
              }
              //通过上面的代码停止了播放,通过play再播放当前视频
              _controller.play();
              _isPlay=true;
            });
          },
          child: Icon(
            Icons.play_circle_fill,
            size: 45,
          ),
        ),
      ),
    );
  }

}

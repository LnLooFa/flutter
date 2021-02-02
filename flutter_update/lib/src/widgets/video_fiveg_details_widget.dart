import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoFiveGDetailsWidget extends StatefulWidget {
  final StreamController streamController;

  VideoFiveGDetailsWidget({this.streamController});

  @override
  _VideoFiveGDetailsWidgetState createState() =>
      _VideoFiveGDetailsWidgetState();
}

class _VideoFiveGDetailsWidgetState extends State<VideoFiveGDetailsWidget> {
  VideoPlayerController _controller;
  bool _isPlay = false;
  double _currentSlider = 0.0;
  bool _isFirst = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/welcome_video.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    _controller.addListener(() {
      if (_isPlay && !_controller.value.isPlaying) {
        setState(() {
          _isPlay = false;
        });
      }
      Duration currentDuration = _controller.value.position;
      Duration totalDuration = _controller.value.duration;
      _currentSlider =
          currentDuration.inMilliseconds / totalDuration.inMilliseconds;
      if (_opacity == 1.0) {
        _streamController.add(0);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _streamController.close();
    if(_timer!=null&&_timer.isActive){
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //第一层视频
        buildVideoWidget(),
        //第二层控制按钮
        buildControllerWidget(),
      ],
    );
  }

  ///视频列表
  Widget buildVideoWidget() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _controller.pause();
            _isPlay = false;
          });
        },
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }

  ///视频控制层
  Widget buildControllerWidget() {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 1200),
      opacity: _opacity,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _opacity = 1.0;
          });
          _timer = Timer(Duration(seconds: 3), () {
            setState(() {
              _opacity = 0.0;
            });
          });
        },
        child: Stack(
          children: [
            videoCoverWidget(),
            //标题
            buildVideoTitle(),
            //进度条
            buildBottomProgress(),
          ],
        ),
      ),
    );
  }

  Timer _timer;
  double _opacity = 1.0;

  ///封面视图
  Widget videoCoverWidget() {
    return Positioned.fill(
      child: Container(
        color: Colors.blueGrey.withOpacity(0.5),
        child: GestureDetector(
          onTap: () {
            if (_controller.value.isPlaying) {
              stopVideo();
              if (_timer.isActive) {
                setState(() {
                  _timer.cancel();
                });
              }
            } else {
              startVideoPlayer();
              _timer = Timer(Duration(seconds: 3), () {
                setState(() {
                  _opacity = 0.0;
                });
              });
            }
            setState(() {});
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipOval(
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                      gradient: RadialGradient(colors: [
                    Colors.black,
                    Colors.black.withOpacity(0.3),
                  ])),
                  child: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow_sharp,
                    size: 34,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///开始播放视频
  void startVideoPlayer() {
    _isFirst = false;
    //发送通知先停止到播放,
    if (widget.streamController != null) {
      widget.streamController.add(_controller);
    }
    //总时长
    Duration duration = _controller.value.duration;
    //视频播放到当前位置
    Duration position = _controller.value.position;
    if (position == duration) {
      _controller.seekTo(Duration.zero);
    }
    //通过上面的代码停止了播放,通过play再播放当前视频
    _controller.play();
    _isPlay = true;
  }

  ///视频标题
  Widget buildVideoTitle() {
    return Positioned(
      left: 10,
      top: 10,
      right: 10,
      height: 50,
      child: Text(
        "早起的年轻人",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }
  StreamController<int> _streamController =new StreamController();

  Widget buildBottomProgress() {
    if (_isFirst) {
      return Container();
    }
    return Positioned(
      bottom: 0,
      left: 10,
      right: 10,
      height: 30,
      child: StreamBuilder(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Row(
            children: [
              Text(
                buildTimeText(_controller.value.position),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Expanded(
                child: Slider(
                  value: _currentSlider,
                  onChanged: (value) {
                    setState(() {
                      _currentSlider = value;
                      _controller.seekTo(_controller.value.duration * value);
                    });
                  },
                  min: 0.0,
                  max: 1.0,
                  //进度条底色
                  inactiveColor: Colors.red,
                  //进度条颜色
                  activeColor: Colors.yellow,
                ),
              ),
              Text(
                buildTimeText(_controller.value.duration),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  ///开始时间
  String buildTimeText(Duration duration) {
    if (duration != null) {
      int m = duration.inMinutes;
      int s = duration.inSeconds;

      String mStr = "$m";
      if (m < 10) {
        mStr = "0$m";
      }
      String sStr = "$s";
      if (s < 10) {
        sStr = "0$s";
      }
      return "$mStr:$sStr";
    }
    return "00:00";
  }

  void stopVideo() {
    _controller.pause();
    _isPlay = false;
  }
}

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HomeListItemWidget extends StatefulWidget {
  @override
  _HomeListItemWidgetState createState() => _HomeListItemWidgetState();
}

class _HomeListItemWidgetState extends State<HomeListItemWidget> {
  VideoPlayerController _controller;
  bool isPlay = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/video/welcome_video.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2),
      padding: EdgeInsets.all(8),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.one_k),
              Text("早起的年轻人"),
            ],
          ),
          SizedBox(height: 8),
          Container(
            height: 160,
            child: Stack(
              children: [
                //第一层视频
                Positioned.fill(
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        _controller.pause();
                        isPlay=false;
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
            ),
          )
        ],
      ),
    );
  }

  Widget buildControllerWidget() {
    if (isPlay) {
      return Container();
    }
    return Positioned.fill(
      child: Container(
        color: Colors.blueGrey.withOpacity(0.5),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _controller.play();
              isPlay=true;
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

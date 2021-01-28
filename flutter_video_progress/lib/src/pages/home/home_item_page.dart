import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ho/src/pages/fiveg/five_g_list_item_widget.dart';
import 'package:flutter_ho/src/utils/log_util.dart';
import 'package:video_player/video_player.dart';

import 'home_list_item_widget.dart';

class HomeItemPage extends StatefulWidget {
  final int pageIndex;
  HomeItemPage(this.pageIndex);

  @override
  _HomeItemPageState createState() => _HomeItemPageState();
}

class _HomeItemPageState extends State<HomeItemPage> {
  StreamController<VideoPlayerController> _streamController =
      StreamController.broadcast();

  VideoPlayerController _videoPlayerController;
  bool _isScroll=false;

  @override
  void initState() {
    super.initState();
    _streamController.stream.listen((event) {
      LogUtil.e("收到消息");
      if (_videoPlayerController != null &&
          _videoPlayerController.textureId != event.textureId) {
        _videoPlayerController.pause();
      }
      _videoPlayerController = event;
    });
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("首页"),
      ),
      backgroundColor: Colors.grey[200],
      body: NotificationListener(
        onNotification: (ScrollNotification notification){
          Type runTimeType = notification.runtimeType;
          if(runTimeType == ScrollStartNotification){
            LogUtil.e("开始滑动");
            _isScroll=true;
          }
          if(runTimeType == ScrollEndNotification){
            LogUtil.e("滑动结束");
            setState(() {
              _isScroll=false;
            });
          }
          return false;
        },
        child: ListView.builder(
          //缓存设置为0
          cacheExtent: 0,
          itemCount: 100,
          itemBuilder: (BuildContext context, int index) {
            return buildPageViewWidget();
          },
        ),
      ),
    );
  }

  Widget buildPageViewWidget(){
    if(widget.pageIndex==0){
      return HomeListItemWidget(streamController: _streamController,isScroll: _isScroll,);
    }else if(widget.pageIndex==1){
      return FiveGListItemWidget(streamController: _streamController,isScroll: _isScroll,);
    }
  }
}

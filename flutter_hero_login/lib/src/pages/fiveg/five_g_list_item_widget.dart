import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ho/src/widgets/video_details_widget.dart';
import 'package:flutter_ho/src/widgets/video_fiveg_details_widget.dart';
import 'package:video_player/video_player.dart';

class FiveGListItemWidget extends StatefulWidget {
  final StreamController streamController;
  final isScroll;

  FiveGListItemWidget({this.streamController, this.isScroll = false});

  @override
  _FiveGListItemWidgetState createState() => _FiveGListItemWidgetState();
}

class _FiveGListItemWidgetState extends State<FiveGListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2),
      padding: EdgeInsets.all(8),
      color: Colors.white,
      child: Container(
        height: 160,
        child: buildVideoWidget(),
      ),
    );
  }

  Widget buildVideoWidget() {
    if (widget.isScroll) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          "assets/images/cover.png",
          fit: BoxFit.fitWidth,
        ),
      );
    }else{
      return VideoFiveGDetailsWidget(
        streamController: widget.streamController,
      );
    }
  }
}

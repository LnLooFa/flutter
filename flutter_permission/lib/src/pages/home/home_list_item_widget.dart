import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ho/src/widgets/video_details_widget.dart';
import 'package:video_player/video_player.dart';

class HomeListItemWidget extends StatefulWidget {
  final StreamController streamController;
  final isScroll;

  HomeListItemWidget({this.streamController, this.isScroll = false});

  @override
  _HomeListItemWidgetState createState() => _HomeListItemWidgetState();
}

class _HomeListItemWidgetState extends State<HomeListItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2),
      padding: EdgeInsets.all(8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            child: buildVideoWidget(),
          )
        ],
      ),
    );
  }

  Widget buildVideoWidget() {
    if (widget.isScroll) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          "assets/images/app_logo.png",
          fit: BoxFit.fitWidth,
        ),
      );
    }
    return VideoDetailsWidget(
      streamController: widget.streamController,
    );
  }
}

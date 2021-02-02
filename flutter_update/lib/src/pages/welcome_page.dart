import 'package:flutter/material.dart';
import 'package:flutter_ho/src/widgets/welcome_time_widget.dart';
import 'package:flutter_ho/src/widgets/welcome_video_widget.dart';

class WelComePage extends StatefulWidget {
  @override
  _WelComePageState createState() => _WelComePageState();
}

class _WelComePageState extends State<WelComePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: WelComeVideoWidget(),
            ),
            Positioned(
              child: WelcomeTimeWidget(),
              right: 20,
              bottom: 66,
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'file:///E:/flutter/flutter_ho/flutter_permission/lib/src/pages/home/home_page.dart';
import 'package:flutter_ho/src/utils/log_util.dart';
import 'package:flutter_ho/src/utils/navigator_util.dart';

class WelcomeTimeWidget extends StatefulWidget {
  @override
  _WelcomeTimeWidgetState createState() => _WelcomeTimeWidgetState();
}

class _WelcomeTimeWidgetState extends State<WelcomeTimeWidget> {
  int currentTime = 5;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (currentTime == 0) {
        _timer.cancel();
        goHome();
        return;
      }
      setState(() {
        currentTime--;
      });
      LogUtil.e("倒计时");
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        goHome();
      },
      child: buildContainer(),
    );
  }

  Widget buildContainer() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      alignment: Alignment.center,
      width: 100,
      height: 33,
      child: Text(
        "${currentTime}S",
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  void goHome() {
    LogUtil.e("去首页");
    NavigatorUtil.pushPageByFade(
      context: context,
      targPage: HomePage(),
      isReplace: true,
    );
  }
}

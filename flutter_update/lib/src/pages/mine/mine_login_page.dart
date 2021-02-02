import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ho/src/pages/setting/setting_page.dart';
import 'package:flutter_ho/src/utils/navigator_util.dart';

class MineLoginPage extends StatefulWidget {
  @override
  _MineLoginPageState createState() => _MineLoginPageState();
}

class _MineLoginPageState extends State<MineLoginPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Color(0XffCDDEEC),
      ),
      child: Scaffold(
        //填充布局
        body: Container(
            width: double.infinity,
            height: double.infinity,
            child: buildStack(context)),
      ),
    );
  }

  Stack buildStack(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: buildBackgroundWidget()),
        Positioned(
          top: 44,
          right: 10,
          child: bulidSettingButton(context),
        )
      ],
    );
  }

  Container buildBackgroundWidget() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Colors.lightBlueAccent.withOpacity(0.3),
            Colors.blue.withOpacity(0.3),
          ])),
    );
  }

  Widget bulidSettingButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings_applications_outlined),
      onPressed: () {
        NavigatorUtil.pushPage(
            context: context,
            targPage: SettingPage(),
            dismissCallBack: (value) {
              if (value != null) {
                setState(() {});
              }
            });
      },
    );
  }
}

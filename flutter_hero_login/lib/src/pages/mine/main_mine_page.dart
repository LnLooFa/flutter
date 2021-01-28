import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ho/src/pages/mine/mine_login_page.dart';
import 'package:flutter_ho/src/pages/mine/mine_not_login_page.dart';
import 'package:flutter_ho/src/utils/user_manager.dart';

class MainMinePage extends StatefulWidget {
  @override
  _MainMinePageState createState() => _MainMinePageState();
}

class _MainMinePageState extends State<MainMinePage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      child: buildMineBody(),
      value: SystemUiOverlayStyle(
        //NavigationBar 颜色
        systemNavigationBarColor: Colors.grey,
        //状态栏 风格
        statusBarBrightness: Brightness.light,
        //状态栏 颜色
        statusBarColor: Color(0Xffcddeec),
      ),
    );
  }

  Widget buildMineBody() {
    if (UserManage.getInstance.isLogin) {
      //用户已经登录
      return MineLoginPage();
    } else {
      //用户未登录
      return MineNotLoginPage();
    }
  }
}

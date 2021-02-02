import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ho/src/common/app_updata.dart';
import 'package:flutter_ho/src/common/controller.dart';
import 'package:flutter_ho/src/pages/login/login_page.dart';
import 'package:flutter_ho/src/utils/log_util.dart';
import 'package:flutter_ho/src/utils/navigator_util.dart';
import 'package:flutter_ho/src/utils/user_manager.dart';
import 'package:package_info/package_info.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("设置"),
      ),
      body: ListView(
        children: [
          //检测版本更新
          buildCheckVersion(),
          //退出当前用户登录
          buildLoginOut(),
        ],
      ),
    );
  }

  Widget buildCheckVersion() {
    if(Platform.isAndroid){
      return ListTile(
        title: Text("检测版本更新"),
        trailing: Icon(Icons.arrow_forward_ios),
        leading: Icon(Icons.cancel_presentation_rounded),
        onTap: () {
          check();
        },
      );
    }else{
      return Container();
    }
  }

  Widget buildLoginOut() {
    bool isLogin = UserManage.getInstance.isLogin;
    return ListTile(
      title: Text(isLogin ? "退出登录" : "去登录"),
      trailing: Icon(Icons.arrow_forward_ios),
      leading: Icon(Icons.cancel_presentation_rounded),
      onTap: () {
        if (isLogin) {
          exitFunction();
        } else {
          NavigatorUtil.pushPage(
              context: context, targPage: LoginPage(), isReplace: true);
        }
      },
    );
  }

  void exitFunction() async {
    bool isExit = await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("温馨提示"),
            content: Container(
              padding: EdgeInsets.all(16),
              child: Text("确定退出吗?"),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text("取消"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              CupertinoDialogAction(
                child: Text("确定"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
    if(isExit){
      loginStreamController.add(0);
      UserManage.getInstance.clear();
      Navigator.of(context).pop(true);
    }
  }

  void check() async {
    //获取当前App的版本信息
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    LogUtil.e("appName $appName");
    LogUtil.e("packageName $packageName");
    LogUtil.e("version $version");
    LogUtil.e("buildNumber $buildNumber");

    checkAppVersion(context, showToast: true);
  }

}

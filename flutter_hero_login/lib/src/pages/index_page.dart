import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ho/src/pages/welcome_page.dart';
import 'package:flutter_ho/src/utils/log_util.dart';
import 'package:flutter_ho/src/utils/navigator_util.dart';
import 'package:flutter_ho/src/utils/sp_util.dart';
import 'package:flutter_ho/src/widgets/permission_widget.dart';
import 'package:flutter_ho/src/widgets/protocol_model.dart';

import 'package:permission_handler/permission_handler.dart';

import 'guild/first_guild_page.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with ProtocolModel {
  List<String> _list = [
    "为你更好的用户体验,所以需要获取你的手机文件存储权限,以保存你的一些偏好设置",
    "你已决绝权限,所以无法保存你的一些偏好设置,将无法使用APP",
    "你已拒绝权限,请在设置中心同意APP的权限申请",
    "其他错误"
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/images/app_logo.png",
          width: 100,
          height: 100,
        ),
        // child: Text("权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请" +
        //     "权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请" +
        //     "权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请"),
      ),
    );
  }

  void initData() {
    //当前应用的运行环境
    //当前APP运行在release环境时为true
    bool isLog = !bool.fromEnvironment("dart.vm.product");
    LogUtil.init(isLog: isLog);
    NavigatorUtil.pushPageByFade(
        context: context,
        targPage: PermissionWidget(
          permission: Permission.storage,
          isCloseApp: true,
          permissionList: _list,
        ),
        //权限申请结果
        dismissCallBack: (value) {
          if (value == null || !value) {
            //权限请求不通过
          } else {
            initDataNext();
          }
        });
  }

  void initDataNext() async {
    await SPUtil.init();
    bool isAgreement = await SPUtil.getBool("isAgreement");

    //是否同意协议
    if (isAgreement == null || !isAgreement) {
      isAgreement = await showProtocolFunction(context);
    }
    if (isAgreement) {
      LogUtil.e("同意协议");
      SPUtil.save("isAgreement", true);
      toNextPage();
    } else {
      LogUtil.e("不同意协议");
      closeApp();
    }
  }

  void closeApp() {
    SystemChannels.platform.invokeMethod("SystemNavigator.pop");
  }

  void toNextPage() async{
    bool isFirstPage=await SPUtil.getBool("is_first_page");
    if(isFirstPage==null || !isFirstPage){
      NavigatorUtil.pushPageByFade(
        context: context,
        targPage: FirstGuildPage(),
        isReplace: true,
      );
    }else{
      NavigatorUtil.pushPageByFade(
        context: context,
        targPage: WelComePage(),
        isReplace: true,
      );
    }
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionWidget extends StatefulWidget {
  final Permission permission;
  final List<String> permissionList;
  final bool isCloseApp;
  final String leftBtnText;

  PermissionWidget({@required this.permission,@required this.permissionList,
    this.isCloseApp=false,this.leftBtnText="再考虑一下"});

  @override
  _PermissionWidgetState createState() => _PermissionWidgetState();
}

class _PermissionWidgetState extends State<PermissionWidget> with WidgetsBindingObserver{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.transparent,
      ),
    );
  }

  bool _isToSetting=false;
  @override
  void initState() {
    super.initState();
    checkPermission();
    //注册观察者
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed &&_isToSetting){
      checkPermission();
    }
  }

  @override
  void dispose() {
    //注销观察者
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void checkPermission({PermissionStatus status}) async {
    Permission permission=widget.permission;
    if(status == null){
      status = await permission.status;
    }
    if(status.isUndetermined){ //第一次申请
      showPermissionAlert(widget.permissionList[0],"同意",permission);
    }else if(status.isDenied){ //第一次申请被拒绝
      if(Platform.isIOS){
        showPermissionAlert(widget.permissionList[2],"去设置中心",permission);
        return;
      }
      showPermissionAlert(widget.permissionList[1],"重试",permission);
    }else if(status.isPermanentlyDenied){ // 第二次申请被拒绝
      showPermissionAlert(widget.permissionList[2],"去设置中心",permission,isSetting:true);
    }else{ // 通过
      Navigator.of(context).pop(true);
    }
  }

  List<String> _list= [
    "为你更好的用户体验,所以需要获取你的手机文件存储权限,以保存你的一些偏好设置",
    "你已决绝权限,所以无法保存你的一些偏好设置,将无法使用APP",
    "你已拒绝权限,请在设置中心同意APP的权限申请",
    "其他错误"
  ];

  void showPermissionAlert(String message,String rightText,Permission permission,{bool isSetting = false}){
    showCupertinoDialog(builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text("温馨提示"),
        content: Container(
          padding: EdgeInsets.all(12),
          child: Text(message),
        ),
        actions: [
          CupertinoDialogAction(child: Text("${widget.leftBtnText}"),onPressed: (){
            widget.isCloseApp?closeApp():Navigator.of(context).pop(false);
          },),
          CupertinoDialogAction(child: Text("$rightText"),onPressed: (){
            //是否是
            if(isSetting){
              _isToSetting=true;
              //跳转到设置中心
              openAppSettings();
            }else{
              requestPermission(permission);
            }
            Navigator.of(context).pop(true);
          },)
        ],
      );
    }, context: context);
  }

  void requestPermission(Permission permission) async{
    PermissionStatus status = await permission.request();
    checkPermission(status: status);
  }

  void closeApp() {
    SystemChannels.platform.invokeMethod("SystemNavigator.pop");
  }
}

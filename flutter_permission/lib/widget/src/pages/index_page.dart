import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ho/widget/src/widgets/permission_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List<String> _list= [
    "为你更好的用户体验,所以需要获取你的手机文件存储权限,以保存你的一些偏好设置",
    "你已决绝权限,所以无法保存你的一些偏好设置,将无法使用APP",
    "你已拒绝权限,请在设置中心同意APP的权限申请",
    "其他错误"
  ];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Navigator.of(context).push(PageRouteBuilder(opaque:false,pageBuilder:
          (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
        return PermissionWidget(
          permission: Permission.storage,
          permissionList:_list,
        );
      }));
    }).then((value) => {
      if(value == null || !value){
        //权限请求不通过
      }else{
        //权限请求通过
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text("权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请"
            +"权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请"
            +"权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请权限申请"),
      ),
    );
  }
}

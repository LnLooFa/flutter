import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ho/src/utils/log_util.dart';
import 'package:install_plugin_custom/install_plugin_custom.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';

import 'install_status.dart';

class AppUpgradePage extends StatefulWidget {
  final bool isForce;
  final bool isBackDismiss;
  final String upgradeText;
  final String apkUrl;

  AppUpgradePage({
    @required this.apkUrl,
    this.isForce = false,
    this.isBackDismiss = false,
    this.upgradeText = "",
  });

  @override
  _AppUpgradePageState createState() => _AppUpgradePageState();
}

class _AppUpgradePageState extends State<AppUpgradePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: new Material(
        type: MaterialType.transparency,
        //监听Android设备上的返回键盘物理按钮
        child: WillPopScope(
          onWillPop: () async {
            closeApp(context);
            return Future.value(true);
          },
          child: GestureDetector(
            //点击背景是否消失
            onTap: () {
              //非强制升级下起作用
              //并且用户设置了点击背景升级弹框消失
              if (!widget.isForce && widget.isBackDismiss) {
                closeApp(context);
              }
            },
            //升级内容区域
            child: buildBodyContainer(context),
          ),
        ),
      ),
    );
  }

  void closeApp(BuildContext context) {
    //最好是有一个再次点击时间控制
    //笔者这里省略
    //如果正在下载中 取消网络请求
    if (_cancelToken != null && !_cancelToken.isCancelled) {
      //取消下载
      _cancelToken.cancel();
    }
    //如果是强制升级 点击物理返回键退出应用程序
    if (widget.isForce) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else {
      Navigator.of(context).pop();
    }
  }

  Container buildBodyContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildUpgradeDialog(),
        ],
      ),
    );
  }

  ///白色弹框Dialog
  Widget buildUpgradeDialog() {
    //圆角裁剪
    return ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(12),
      ),
      child: Container(
        width: 280,
        height: 320,
        color: Colors.white,
        child: buildUpgradeChild(),
      ),
    );
  }

  Widget buildUpgradeChild() {
    return Column(
      //垂直方向居中
      mainAxisAlignment: MainAxisAlignment.center,
      //包裹子Widget
      mainAxisSize: MainAxisSize.min,
      children: [
        //标题栏&取消按钮
        buildHeaderWidget(context),
        //内容区域
        buildUpdateContent(),
        //升级进度条
        buildUpdateProgress(),
      ],
    );
  }

  Expanded buildUpdateContent() {
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 14,
          ),
          child: Text(
            "${widget.upgradeText}",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeaderWidget(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 28,
            child: Text(
              "升级提醒",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
          ),
          //取消按钮
          Positioned(
            right: 5,
            child: CloseButton(
              onPressed: () {
                closeApp(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  StreamController<double> _streamController = new StreamController();

  StreamBuilder<double> buildUpdateProgress() {
    return StreamBuilder<double>(
      stream: _streamController.stream,
      initialData: 0.0,
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        return Container(
          child: Stack(
            children: [
              buildUpdateButton(context, snapshot),
              //结合Align实现裁剪动画
              ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: snapshot.data,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Material buildUpdateButton(
      BuildContext context, AsyncSnapshot<double> snapshot) {
    return Material(
      color: Colors.redAccent,
      child: Ink(
        child: InkWell(
          onTap: onTapFunction,
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Text(
              buildBottomText(snapshot.data),
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //当前状态
  InstallStatus _installStatus = InstallStatus.none;

  String buildBottomText(double progress) {
    String buttonText = "";
    switch (_installStatus) {
      case InstallStatus.none:
        buttonText = "升级";
        break;
      case InstallStatus.downing:
        buttonText = "下载中" + (progress * 100).toStringAsFixed(0) + "%";
        break;
      case InstallStatus.downFinish:
        buttonText = '点击安装';
        break;
      case InstallStatus.downFaile:
        buttonText = '重新下载';
        break;
      case InstallStatus.installFaile:
        buttonText = '重新安装';
        break;
    }
    return buttonText;
  }

  void onTapFunction() {
    //如果是iOS手机就跳转APPStore
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      InstallPluginCustom.gotoAppStore(
          "https://apps.apple.com/cn/app/id1453826566");
      return;
    }
    //第一次下载
    //下载失败点击重试
    if (_installStatus == InstallStatus.none ||
        _installStatus == InstallStatus.downFaile) {
      _installStatus = InstallStatus.downing;
      downApkFunction();
    } else if (_installStatus == InstallStatus.downFinish ||
        _installStatus == InstallStatus.installFaile) {
      //安装失败时
      //下载完成时 点击触发安装
      installApkFunction();
    }
  }

  String appLocalPath;
  CancelToken _cancelToken;

  ///使用dio 下载文件
  void downApkFunction() async {
    // 申请写文件权限 一般在应用第一次打开里就申请
    // 这里可以省略
    ///手机储存目录
    String savePath = await getPhoneLocalPath();
    String appName = "/rk.apk";

    //创建DIO
    Dio dio = new Dio();
    //取消网络请求标识
    _cancelToken = new CancelToken();

    //Apk下载保存本地路径
    appLocalPath = "$savePath$appName";

    try {
      //参数一 文件的网络储存URL
      //参数二 下载的本地目录文件
      //参数三 取消标识
      //参数四 下载监听
      Response response = await dio.download(widget.apkUrl, appLocalPath,
          cancelToken: _cancelToken, onReceiveProgress: (received, total) {
            if (total != -1) {
              ///当前下载的百分比例
              print((received / total * 100).toStringAsFixed(0) + "%");
              // CircularProgressIndicator(value: currentProgress,) 进度 0-1
              _streamController.add(received / total);
              setState(() {});
            }
          });
      print("下载完成");
      setState(() {
        _streamController.add(0.0);
      });
      _installStatus = InstallStatus.downFinish;
      installApkFunction();
    } catch (e) {
      print('${e.toString()}');
      //取消网络请求
      //下载失败都会在这回调
      //可自行处理
      _installStatus = InstallStatus.downFaile;
      setState(() {});
    }
  }

  ///获取手机的存储目录路径
  ///getExternalStorageDirectory() 获取的是
  ///     android 的外部存储 （External Storage）
  /// getApplicationDocumentsDirectory 获取的是
  ///     ios 的Documents` or `Downloads` 目录
  Future<String> getPhoneLocalPath() async {
    final directory = Theme.of(context).platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  ///安装apk
  void installApkFunction() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    InstallPluginCustom.installApk(appLocalPath, packageName).then((value) {
      LogUtil.e("install apk $value");
    }).catchError((error) {
      _installStatus = InstallStatus.installFaile;
      setState(() {});
    });
  }
}

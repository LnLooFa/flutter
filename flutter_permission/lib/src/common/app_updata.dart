import 'package:flutter/material.dart';
import 'package:flutter_ho/src/bean/app_version_bean.dart';
import 'package:flutter_ho/src/pages/net/response_info.dart';
import 'package:flutter_ho/src/pages/update/app_upgrade_page.dart';
import 'package:flutter_ho/src/utils/navigator_util.dart';

Future<bool> checkAppVersion(BuildContext context,
    {bool showToast = false}) async {
  Map<String, dynamic> map = {};
  // ResponseInfo responseInfo = await DioUtil.instance.getRequest(
  //   url: HttpHelper.appVersion,
  //   queryParameters: map,
  // );
  ResponseInfo responseInfo =
      await Future.delayed(Duration(milliseconds: 1000), () {
    return ResponseInfo(data: {
      "isNeed": true,
      "updateContent": "优化了一些Bug,程序员们正在努力修复中",
      "packageUrl":
          "http://pic.studyyoun.com/96b282d9-f82c-46fb-8767-754bd6288775.apk"
    });
  });
  if (responseInfo.success) {
    Map element = responseInfo.data;

    AppVersionBean appVersionBean = AppVersionBean.fromJson(element);
    if (appVersionBean != null) {
      if (appVersionBean.isNeed) {
        showAppUpgradeDialog(
          context: context,
          upgradeText: appVersionBean.updateContent,
          apkUrl: appVersionBean.packageUrl,
        );
      }
    }
  }
  return Future.value(true);
}

///便捷显示升级弹框
void showAppUpgradeDialog({
  @required BuildContext context,
  //是否强制更新
  bool isForce = false,
  //点击背景是否消失
  bool isBackDismiss = false,
  //更新内容
  String upgradeText = "",
  String apkUrl = "",
}) {
  NavigatorUtil.pushPageByFade(
      opaque: false,
      context: context,
      targPage: AppUpgradePage(
        apkUrl: apkUrl,
        isBackDismiss: isBackDismiss,
        isForce: isForce,
        upgradeText: upgradeText,
      ));
}

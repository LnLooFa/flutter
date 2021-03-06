import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ho/src/utils/log_util.dart';
import 'package:flutter_ho/src/utils/navigator_util.dart';
import 'package:flutter_ho/src/widgets/webview_widget.dart';


class ProtocolModel {
  TapGestureRecognizer _userProtocolRecognizer;
  TapGestureRecognizer _privacyProtocolRecognizer;

  ///显示用户协议的对话框
  Future<bool> showProtocolFunction(BuildContext context) async {
    //点击用户协议手势
    _userProtocolRecognizer = TapGestureRecognizer();
    //点击隐私协议手势
    _privacyProtocolRecognizer = TapGestureRecognizer();
    bool isShow = await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return cupertinoDialogAction(context);
        });
    //销毁用户协议手势
    _userProtocolRecognizer.dispose();
    //销毁隐私协议手势
    _privacyProtocolRecognizer.dispose();
    return Future.value(isShow);
  }

  CupertinoAlertDialog cupertinoDialogAction(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("温馨提示"),
      content: Container(
          height: 250,
          padding: EdgeInsets.only(top: 12),
          child: SingleChildScrollView(
            child: buildContent(context),
          )),
      actions: [
        CupertinoDialogAction(
          child: Text("不同意"),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        CupertinoDialogAction(
          child: Text("同意"),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        )
      ],
    );
  }

  //协议说明文案
  String userPrivateProtocol =
      "我们一向尊重并会严格保护用户在使用本产品时的合法权益（包括用户隐私、用户数据等）不受到任何侵犯。本协议（包括本文最后部分的隐私政策）是用户（包括通过各种合法途径获取到本产品的自然人、法人或其他组织机构，以下简称“用户”或“您”）与我们之间针对本产品相关事项最终的、完整的且排他的协议，并取代、合并之前的当事人之间关于上述事项的讨论和协议。本协议将对用户使用本产品的行为产生法律约束力，您已承诺和保证有权利和能力订立本协议。用户开始使用本产品将视为已经接受本协议，请认真阅读并理解本协议中各种条款，包括免除和限制我们的免责条款和对用户的权利限制（未成年人审阅时应由法定监护人陪同），如果您不能接受本协议中的全部条款，请勿开始使用本产品";

  Widget buildContent(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: "请你在使用本产品前仔细阅读",
          style: TextStyle(color: Colors.grey[600]),
          children: [
            TextSpan(
                text: "《用户协议》",
                style: TextStyle(color: Colors.blue),
                recognizer: _userProtocolRecognizer
                  ..onTap = () {
                    openUserProtocol(context);
                  }),
            TextSpan(
              text: "与",
              style: TextStyle(color: Colors.grey[600]),
            ),
            TextSpan(
                text: "《隐私协议》",
                style: TextStyle(color: Colors.blue),
                recognizer: _privacyProtocolRecognizer
                  ..onTap = () {
                    openPrivacyProtocol(context);
                  }),
            TextSpan(
              text: userPrivateProtocol,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ]),
    );
  }

  void openUserProtocol(BuildContext context) {
    LogUtil.e("查看用户协议");
    NavigatorUtil.pushPageByFade(
      context: context,
      targPage: WebViewWidget(
        htmlUrl: 'https://github.com/LnLooFa/ProgressBarView',
        pageTitle: "用户协议",
      ),
    );
  }

  void openPrivacyProtocol(BuildContext context) {
    LogUtil.e("查看隐私协议");
    NavigatorUtil.pushPageByFade(
        context: context,
        targPage: WebViewWidget(
          htmlUrl: 'https://github.com/LnLooFa/ProgressBarView',
          pageTitle: "隐私协议",
        ));
  }
}

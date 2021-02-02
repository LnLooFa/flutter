import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorUtil {
  ///普通打开页面的路由
  ///[context] 上下文参数
  ///[targPage] 目标页面
  ///[isReplace] 是否替换当前页面
  static void pushPage(
      {@required BuildContext context,
      @required Widget targPage,
      bool isReplace = false,
      Function(dynamic value) dismissCallBack}) {
    PageRoute pageRoute;
    if (Platform.isAndroid) {
      pageRoute = MaterialPageRoute(builder: (BuildContext context) {
        return targPage;
      });
    } else {
      pageRoute = CupertinoPageRoute(builder: (BuildContext context) {
        return targPage;
      });
    }

    if (isReplace) {
      Navigator.of(context).pushReplacement(pageRoute).then((value) {
        if (dismissCallBack != null) {
          dismissCallBack(value);
        }
      });
    } else {
      Navigator.of(context).push(pageRoute).then((value) {
        if (dismissCallBack != null) {
          dismissCallBack(value);
        }
      });
    }
  }

  ///普通打开页面的路由
  ///[context] 上下文参数
  ///[targPage] 目标页面
  ///[isReplace] 是否替换当前页面
  ///[opaque] 是否以背景透明打开
  static void pushPageByFade(
      {@required BuildContext context,
      @required Widget targPage,
      bool isReplace = false,
      int startMills=400,
      bool opaque = false,
      Function(dynamic value) dismissCallBack}) {
    PageRoute pageRoute = PageRouteBuilder(
        opaque: opaque,
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return targPage;
        },
        transitionDuration: Duration(milliseconds: startMills),
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        });

    if (isReplace) {
      Navigator.of(context).pushReplacement(pageRoute).then((value) {
        if (dismissCallBack != null) {
          dismissCallBack(value);
        }
      });
    } else {
      Navigator.of(context).push(pageRoute).then((value) {
        if (dismissCallBack != null) {
          dismissCallBack(value);
        }
      });
    }
  }
}

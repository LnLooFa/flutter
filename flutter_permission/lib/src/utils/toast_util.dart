import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
///Toast工具类
class ToastUtil {
  static void showToast(String message) {
    // 根据消息长度决定自动消失时间
    double multiplier = 0.5;
    double flag = message.length * 0.06 + 0.5;
    //计算显示时间
    int timeInSecForIos = (multiplier * flag).round();
    //如果已经有显示的,先取消已有显示
    Fluttertoast.cancel();
    //显示toast
    Fluttertoast.showToast(msg: message,
      backgroundColor: Colors.black54,
      gravity: ToastGravity.CENTER,
      //只针对iOS生效的消失时间
      timeInSecForIosWeb: timeInSecForIos,
    );
  }
}
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ho/src/widgets/bubble/bubble_bean.dart';

///绘制气泡的画笔
class BubblePainter extends CustomPainter {
  //创建画笔
  Paint _paint = new Paint();

  //保存气泡的集合
  final List<BubbleBean> list;

  //随机数
  final Random random;

  BubblePainter({this.list, this.random});

  //计算坐标
  Offset calculateXY(double speed, double theta) {
    return Offset(speed * cos(theta), speed * sin(theta));
  }

  @override
  void paint(Canvas canvas, Size size) {
    //每次绘制都重新计算位置
    list.forEach((element) {
      //计算偏移量
      var velocity = calculateXY(element.speed, element.theta);
      //新的坐标, 位偏移
      var dx = element.position.dx + velocity.dx;
      var dy = element.position.dy + velocity.dy;
      //X轴边界计算
      if(element.position.dx<0 || element.position.dx > size.width){
        dx = random.nextDouble()*size.width;
      }
      //y轴边界计算
      if (element.position.dy < 0 || element.position.dy > size.height) {
        dy = random.nextDouble() * size.height;
      }
      //新的位置
      element.position = Offset(dx, dy);
    });

    //循环绘制所有的气泡
    list.forEach((element) {
      //画笔颜色
      _paint.color = element.color;
      //绘制圆
      canvas.drawCircle(element.position, element.radius, _paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

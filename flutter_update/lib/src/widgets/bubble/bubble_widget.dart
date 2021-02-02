import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ho/src/utils/colors_util.dart';
import 'package:flutter_ho/src/widgets/bubble/bubble_bean.dart';

import 'bubble_painter.dart';

///气泡动画背景
class BubbleWidget extends StatefulWidget {
  @override
  _BubbleWidgetState createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget>
    with SingleTickerProviderStateMixin {
  //创建的气泡合计
  List<BubbleBean> _list = [];

  //随机数据 毫秒时间戳
  Random _random = new Random(DateTime.now().microsecondsSinceEpoch);

  //气泡的最大半径
  double maxRadius = 100;

  //气泡运动的最快速度
  double maxSpeed = 0.7;

  //气泡计算使用的最大弧度(360度)
  double maxTheta = 2.0 * pi;

  //动画控制器
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 12; i++) {
      BubbleBean particle = new BubbleBean();
      //获取随机透明度的白色颜色
      particle.color = ColorsUtil.getRandomWhiteColor(_random);
      //指定一个位置,每次绘制时还会修改
      particle.position = Offset(-1, -1);
      //气泡运动的速度
      particle.speed = _random.nextDouble() * maxSpeed;
      //随机角度
      particle.theta = _random.nextDouble() * maxTheta;
      //随机半径
      particle.radius = _random.nextDouble() * maxRadius;
      //添加集合
      _list.add(particle);
    }

    //动画控制器
    _animationController = new AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    //刷新监听
    _animationController.addListener(() {
      //刷新是更新流
      setState(() {});
    });

    Future.delayed(Duration(milliseconds: 200),(){
      //开始正向运行此动画，然后
      //完成后重新启动动画。
      _animationController.repeat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubblePainter(
        list: _list,
        random: _random,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

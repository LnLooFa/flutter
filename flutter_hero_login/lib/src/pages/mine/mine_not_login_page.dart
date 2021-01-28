import 'package:flutter/material.dart';
import 'package:flutter_ho/src/pages/mine/mine_login_page.dart';
import 'package:flutter_ho/src/utils/navigator_util.dart';

class MineNotLoginPage extends StatefulWidget {
  @override
  _MineNotLoginPageState createState() => _MineNotLoginPageState();
}

class _MineNotLoginPageState extends State<MineNotLoginPage> {
  bool _isDown = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0Xffcddeec),
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTapDown: (TapDownDetails details) {
              //手势按下的时候执行
              setState(() {
                _isDown = true;
              });
            },
            onTap: () {
              //手势松开的时候执行
              setState(() {
                _isDown = false;
              });
              NavigatorUtil.pushPageByFade(
                startMills:1200,
                  context: context, targPage: MineLoginPage(), isReplace: false);
            },
            onTapCancel: () {
              //手势取消的时候执行
              setState(() {
                _isDown = false;
              });
            },
            child: buildHero(),
          )
        ],
      ),
    );
  }

  Hero buildHero() {
    return Hero(
            tag: "login",
            child: Container(
              width: 66,
              height: 66,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(
                  Radius.circular(43),
                ),
                //投影
                boxShadow: _isDown ? [
                  BoxShadow(
                    //X,Y轴方向的偏移量
                    offset: Offset(3, 4),
                    //阴影颜色
                    color: Colors.black,
                    //阴影圆角
                    blurRadius: 13,
                  ),
                ] : null,
              ),
              child: Text(
                "登录",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          );
  }
}

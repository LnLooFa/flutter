import 'package:flutter/material.dart';
import 'package:flutter_ho/src/pages/home/home_page.dart';
import 'package:flutter_ho/src/utils/navigator_util.dart';

class FirstGuildPage extends StatefulWidget {
  @override
  _FirstGuildPageState createState() => _FirstGuildPageState();
}

class _FirstGuildPageState extends State<FirstGuildPage> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        //第一层图片视图
        buildGuildView(_width, _height),
        //第二层小圆点视图
        buildIndicator(),
        //第三层去首页按钮
        buildToHome(),
      ],
    );
  }

  Widget buildGuildView(double width, double height) {
    return Positioned.fill(
      child: PageView(
        onPageChanged: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        children: [
          Image.asset(
            "assets/images/sp01.png",
            width: width,
            height: height,
            fit: BoxFit.fill,
          ),
          Image.asset(
            "assets/images/sp02.png",
            width: width,
            height: height,
            fit: BoxFit.fill,
          ),
          Image.asset(
            "assets/images/sp03.png",
            width: width,
            height: height,
            fit: BoxFit.fill,
          ),
          Image.asset(
            "assets/images/sp05.png",
            width: width,
            height: height,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }

  int _currentIndex = 0;

  Widget buildIndicator() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildIndefot(_currentIndex == 0),
          buildIndefot(_currentIndex == 1),
          buildIndefot(_currentIndex == 2),
          buildIndefot(_currentIndex == 3),
        ],
      ),
    );
  }

  Widget buildIndefot(bool isSelect) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: 10,
      width: isSelect ? 20 : 10,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.deepOrangeAccent,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }

  Widget buildToHome() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: _currentIndex == 3 ? 120 : 0,
            height: _currentIndex == 3 ? 40 : 0,
            alignment: Alignment.center,
            child: ElevatedButton(
              child: Text(
                "去首页",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                NavigatorUtil.pushPageByFade(
                  context: context,
                  targPage: HomePage(),
                  isReplace: true,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

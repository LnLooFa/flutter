import 'package:flutter/material.dart';
import 'package:flutter_ho/src/pages/home/home_item_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _controller=PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: PageView(
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          children: [
            HomeItemPage(0),
            HomeItemPage(1),
            HomeItemPage(2),
            HomeItemPage(4),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int value){
          setState(() {
            _currentIndex=value;
            _controller.jumpToPage(value);
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "首页",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.five_g),
            label: "5G",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "消息",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "我的",
          ),
        ],
      ),
    );
  }
}

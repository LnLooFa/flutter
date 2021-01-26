
import 'package:flutter/material.dart';

import 'home_list_item_widget.dart';

class HomeItemPage extends StatefulWidget {
  @override
  _HomeItemPageState createState() => _HomeItemPageState();
}

class _HomeItemPageState extends State<HomeItemPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("首页"),
      ),
      backgroundColor: Colors.grey[200],
      body: Container(
        child: ListView.builder(
          itemCount:100,
          itemBuilder: (BuildContext context, int index) {
            return HomeListItemWidget();
        },),
      ),
    );
  }
}

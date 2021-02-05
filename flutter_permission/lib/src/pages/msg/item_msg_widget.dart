import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ho/src/bean/msg_bean.dart';

class ItemMsgWidget extends StatefulWidget {
  final MsgBean msgBean;

  ItemMsgWidget({this.msgBean});

  @override
  _ItemMsgWidgetState createState() => _ItemMsgWidgetState();
}

class _ItemMsgWidgetState extends State<ItemMsgWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orangeAccent.withOpacity(0.5),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        //包裹
        mainAxisSize: MainAxisSize.min,
        //子widget左对齐
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              "${widget.msgBean.artTitle}",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          Container(
            child: Row(
              children: [
                //权重
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Icon(Icons.forward_10),
                            SizedBox(width: 10),
                            Text("早起的年轻人"),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 9),
                        child: Text(
                          "${widget.msgBean.artInfo}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //右侧图片
                Container(
                  margin: EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                    child: Image.asset(
                      "assets/images/cover2.png",
                      width: 70,
                      height: 80,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 2),
            child: Row(
              children: [
                Text("520喜欢"),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  width: 3,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                ),
                Text("17个评论"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

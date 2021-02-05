import 'package:flutter/material.dart';
import 'package:flutter_ho/src/bean/msg_bean.dart';
import 'package:flutter_ho/src/pages/net/response_info.dart';
import 'package:flutter_ho/src/utils/toast_util.dart';

import 'item_msg_widget.dart';

class MainMsgPage extends StatefulWidget {
  @override
  _MainMsgPageState createState() => _MainMsgPageState();
}

class _MainMsgPageState extends State<MainMsgPage> {
  List<MsgBean> _msgList = [];
  int _pageIndex = 1;
  int _pageSize = 10;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initMsgList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message'),
      ),

      //每一个滑动组件 在滑动时都会发出相应的通知
      //在这里只监听了滑动结束 的通知
      //滑动监听
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (ScrollNotification notification){
          //在滑动结束的时候 判断下如果滑动了 2/3数据
          //就自动加载下一页数据
          //获取滑动的距离
          //ScrollMetrics 是保存就滑动相关的信息
          ScrollMetrics scrollMetrics=notification.metrics;
          //获取滑动的距离
          double pixels=scrollMetrics.pixels;
          //获取最大滑动的距离
          double maxPixels = scrollMetrics.maxScrollExtent;
          //获取滑动的方向
          AxisDirection axisDirection=scrollMetrics.axisDirection;
          if(pixels>= maxPixels/3*2 && axisDirection==AxisDirection.down){
            loadmore();
          }
          return true;
        },
        //下拉刷新
        child: RefreshIndicator(
          onRefresh: (){
            return onRefresh();
          },
          child: ListView.builder(
            itemCount: _msgList.length,
            itemBuilder: (BuildContext context, int index) {
              MsgBean msgBean = _msgList[index];
              return ItemMsgWidget(
                msgBean: msgBean,
              );
            },
          ),
        ),
      ),
    );
  }

  ///异步加载
  void initMsgList() async {
    /*
    {
    "code": 200,
    "data": [
        {
            "id": 3,
            "title": "JS 雪花飘落效果 玩转 canvas 绘图 码农的每日积累 -匠心之作",
            "url": "https://zhuanlan.zhihu.com/p/327699543",
            "image": "https://img-blog.csdnimg.cn/20201128105150457.gif#pic_center",
            "readCount": 232,
            "pariseCount": 111,
            "createTime": "2020-01-09T21:17:49.000+0000"
        },
      ],
    }
     */

    //添加一下分页请求信息
    Map<String, dynamic> map = new Map();
    //当前页数
    map["pageIndex"] = _pageIndex;
    //每页大小
    map["pageSize"] = _pageSize;

    //发起一个get 请求
    // ResponseInfo responseInfo = await DioUtils.instance.getRequest(
    //   url: HttpHelper.artList,
    //   queryParameters: map,
    // );
    //使用模拟数据
    ResponseInfo responseInfo =
        await Future.delayed(Duration(milliseconds: 1000), () {
      List list = [];

      for (int i = 0; i < 10; i++) {
        list.add({
          "title": "测试数据$i",
          "artInfo": "这里是测试数据的简介",
          "readCount": 100,
          "pariseCount": 120,
        });
      }

      return ResponseInfo(data: list);
    });
    //加载结束标识
    _isLoading = false;
    if (responseInfo.success) {
      List list = responseInfo.data;
      //无数据时 更新索引
      if (list.length == 0 && _pageIndex != 1) {
        _pageIndex--;
      }
      if (_pageIndex == 1) {
        //清空一下数据
        _msgList = [];
      }
      list.forEach((element) {
        _msgList.add(MsgBean.fromMap(element));
      });
      setState(() {});
    } else {
      ToastUtil.showToast("请求失败");
    }
  }

  int _preLoadingTime = 0;

  //下拉刷新
  Future<bool> onRefresh() async {
    //重置页数
    _pageIndex = 1;
    //记录开始加载的时间
    _preLoadingTime = DateTime.now().microsecond;
    //加载数据
    await initMsgList();
    //加载完的时间
    int current = DateTime.now().microsecond;
    //时间差
    int flagTime = current - _preLoadingTime;
    //最少显示1秒
    if (flagTime < 1000) {
      await Future.delayed(Duration(milliseconds: 1000 - flagTime));
    }
    ToastUtil.showToast("已刷新");
    return true;
  }

  //加载更多
  void loadmore() {
    if (!_isLoading) {
      _isLoading = true;
      _pageIndex++;
      initMsgList();
    }
  }
  
}

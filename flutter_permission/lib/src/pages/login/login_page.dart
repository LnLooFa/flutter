import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ho/src/bean/user_bean.dart';
import 'package:flutter_ho/src/common/controller.dart';
import 'package:flutter_ho/src/pages/net/dio_util.dart';
import 'package:flutter_ho/src/pages/net/http_helper.dart';
import 'package:flutter_ho/src/pages/net/response_info.dart';
import 'package:flutter_ho/src/utils/log_util.dart';
import 'package:flutter_ho/src/utils/toast_util.dart';
import 'package:flutter_ho/src/utils/user_manager.dart';
import 'package:flutter_ho/src/widgets/bubble/bubble_widget.dart';
import 'package:flutter_ho/src/widgets/custom_textfield_widget.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            //设置背景
            buildBackgroundWidget(),
            //气泡
            buildBubbleWidget(),
            //高斯模糊
            buildFilterWidget(),
            //设置头像
            buildAvatarWidget(),
            //中间区域输入框和按钮
            buildFiledWidget(context),
            //关闭
            buildClosePage(context),
          ],
        ),
      ),
    );
  }

  Positioned buildBackgroundWidget() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.lightBlueAccent.withOpacity(0.3),
                Colors.blue.withOpacity(0.3),
              ]),
        ),
      ),
    );
  }

  Positioned buildBubbleWidget() {
    return Positioned.fill(
      child: BubbleWidget(),
    );
  }

  Positioned buildFilterWidget() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 0.3,
          sigmaY: 0.3,
        ),
        child: Container(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
    );
  }

  Positioned buildAvatarWidget() {
    return Positioned(
      top: 50,
      left: 0,
      right: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: "login",
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: Image.asset(
                    "assets/images/cover.png",
                    width: 80,
                    height: 80,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "欢迎登录",
            style: TextStyle(
              decoration: TextDecoration.none,
              color: Colors.blueGrey,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildClosePage(BuildContext context) {
    return Positioned(
      left: 10,
      top: 40,
      child: CloseButton(
        color: Colors.blueGrey,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  TextEditingController _userTextEditingController =
      new TextEditingController();
  TextEditingController _pwdTextEditingController = new TextEditingController();
  FocusNode _userFocusNode = new FocusNode();
  FocusNode _pwdFocusNode = new FocusNode();
  bool _pwdShow = true;

  Widget buildFiledWidget(BuildContext context) {
    return Positioned(
      left: 40,
      right: 40,
      bottom: 60,
      child: Column(
        children: [
          //手机号
          TextFieldWidget(
            hintText: "手机号",
            focusNode: _userFocusNode,
            submit: (value) {
              LogUtil.e("$value");
              if (value.length != 11) {
                ToastUtil.showToast("请输入11位的手机号码");
                FocusScope.of(context).requestFocus(_userFocusNode);
                return;
              }
              //提交完之后让输入框失去焦点
              _userFocusNode.unfocus();
              //然后让密码输入框获取焦点
              FocusScope.of(context).requestFocus(_pwdFocusNode);
            },
            prefixIconData: Icons.phone,
            obscureText: false,
            controller: _userTextEditingController,
          ),
          SizedBox(
            height: 40,
          ),
          //密码
          TextFieldWidget(
            hintText: "密码",
            focusNode: _pwdFocusNode,
            submit: (value) {
              LogUtil.e("$value");
              if (value.length < 6) {
                ToastUtil.showToast("请输入6位以上的密码");
                FocusScope.of(context).requestFocus(_pwdFocusNode);
                return;
              }
              //手机号输入框失去焦点
              _userFocusNode.unfocus();
              //密码输入框失去焦点
              _pwdFocusNode.unfocus();
              submitFunction(context);
            },
            prefixIconData: Icons.lock_open_outlined,
            suffixIconData: _pwdShow ? Icons.visibility : Icons.visibility_off,
            obscureText: _pwdShow,
            controller: _pwdTextEditingController,
            onTap: () {
              setState(() {
                _pwdShow = !_pwdShow;
              });
            },
          ),
          SizedBox(
            height: 40,
          ),
          //登录
          buildLoginWidget(context),
          SizedBox(
            height: 20,
          ),
          //注册
          buildRegisterWidget(),
        ],
      ),
    );
  }

  Container buildLoginWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
          onPressed: () {
            LogUtil.e("点击登录按钮");
            submitFunction(context);
          },
          child: Text(
            "登录",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(1.0),
          )),
    );
  }

  Container buildRegisterWidget() {
    return Container(
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: () {
          LogUtil.e("点击注册按钮");
        },
        child: Text(
          "注册",
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 14,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          side: MaterialStateProperty.all(
              BorderSide(color: Colors.blueGrey, width: 2)),
          elevation: MaterialStateProperty.all(1.0),
        ),
      ),
    );
  }

  ///登录请求接口
  void submitFunction(BuildContext context) async {
    //用户名
    String userName = _userTextEditingController.text;
    //密码
    String password = _pwdTextEditingController.text;
    if (userName.trim().length != 11) {
      ToastUtil.showToast("请输入11位手机号");
      return;
    }
    if (password.trim().length < 6) {
      ToastUtil.showToast("请输入11位手机号");
      return;
    }

    Map<String, dynamic> map = {
      "mobile": userName,
      "password": password,
    };

    //发起网络请求
    // ResponseInfo responseInfo = await DioUtil.instance.postRequest(
    //   url: HttpHelper.login,
    //   formDataMap: map,
    // );

    //模拟登录成功
    ResponseInfo responseInfo = await Future.delayed(Duration(milliseconds: 1000),(){
      return ResponseInfo(data: {
        "userName":"测试数据",
        "age":22,
      });
    });

    if(responseInfo.success){
      UserBean userBean=UserBean.formMap(responseInfo.data);
      UserManage.getInstance.setUserBean = userBean;
      ToastUtil.showToast("登录成功");
      Navigator.of(context).pop(true);
      loginStreamController.add(0);
    }else{
      ToastUtil.showToast("${responseInfo.message}");
    }
  }
}

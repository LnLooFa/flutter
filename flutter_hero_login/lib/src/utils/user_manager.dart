
import 'package:flutter_ho/src/bean/user_bean.dart';

class  UserManage{
  UserManage._();

  static UserManage getInstance  =  UserManage._();

  UserBean _userBean;

  bool get isLogin => _userBean!=null;
}
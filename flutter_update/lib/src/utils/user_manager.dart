import 'package:flutter_ho/src/bean/user_bean.dart';
import 'package:flutter_ho/src/utils/sp_util.dart';

class UserManage {
  UserManage._();

  static UserManage getInstance = UserManage._();

  UserBean _userBean;

  set setUserBean(UserBean bean) {
    _userBean = bean;
    SPUtil.saveObject("user_bean", _userBean);
  }

  get getUserBean => _userBean;

  bool get isLogin => _userBean != null;

  void initUserInfo() async{
    Map<String,dynamic> map=await SPUtil.getObject("user_bean");
    if(map!=null){
      _userBean=UserBean.formMap(map);
    }
  }

  void clear(){
    _userBean=null;
    SPUtil.remove("user_bean");
  }
}

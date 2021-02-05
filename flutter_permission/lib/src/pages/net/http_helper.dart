
//请求接口清单
class HttpHelper{
  static const String BASE_HOST="http://192.168.40.50:8080/";
  //用户密码登录
  static const String login = BASE_HOST + "user/login";
  //检查更新
  static const String appVersion = BASE_HOST + "app/version";
  //获取文章列表
  static const String artList = BASE_HOST + "article/list";
  //获取信息列表
  static const String msgList = BASE_HOST + "msg/list";
}
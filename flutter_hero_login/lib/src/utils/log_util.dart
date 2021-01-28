
class LogUtil{
  static bool _isLog = true;
  static String _logFlag = "Flutter-Brook";

  static void init({bool isLog = false,String logFlag = "Flutter-Brook"}){
    _isLog = isLog;
    _logFlag=logFlag;
  }

  static void e(String message){
    if(_isLog){
      print("$_logFlag | $message");
    }
  }
}


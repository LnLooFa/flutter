
import 'package:dio/dio.dart';

class LogsInterceptors extends InterceptorsWrapper{
  @override
  Future onRequest(RequestOptions options) {
    print("\n================== 请求数据 ==========================");
    print("|请求url：${options.path}");
    print('|请求头: ' + options.headers.toString());
    print('|请求参数: ' + options.queryParameters.toString());
    print('|请求方法: ' + options.method);
    print("|contentType = ${options.contentType}");
    print('|请求时间: ' + DateTime.now().toString());
    if (options.data != null) {
      print('|请求数据: ' + options.data.toString());
    }

    return Future.value(options);
  }

  @override
  Future onResponse(Response response) {
    print("\n|================== 响应数据 ==========================");
    if (response != null) {
      print("|url = ${response.request.path}");
      print("|code = ${response.statusCode}");
      print("|data = ${response.data}");
      print('|返回时间: ' + DateTime.now().toString());
      print("\n");
    } else {
      print("|data = 请求错误 E409");
      print('|返回时间: ' + DateTime.now().toString());
      print("\n");
    }

    return Future.value(response);
  }

  @override
  Future onError(DioError err) {
    print("\n================== 错误响应数据 ======================");
    print("|url = ${err.request.path}");
    print("|type = ${err.type}");
    print("|message = ${err.message}");

    print('|response = ${err.response}');
    print("\n");

    return Future.value(err);
  }
}
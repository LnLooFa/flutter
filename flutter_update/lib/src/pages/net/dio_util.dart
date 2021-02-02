import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ho/src/pages/net/response_info.dart';
import 'package:package_info/package_info.dart';

import 'logs_interceptors.dart';

///网络请求工具类,使用Dio库
class DioUtil {
  Dio _dio;
  static DioUtil _instance;

  static DioUtil get instance => _getInstance();

  factory DioUtil() => _getInstance();

  //配置代理标识 false 不配置
  bool isProxy = false;

  //网络代理地址
  String proxyIp = "192.168.0.107";

  //网络代理端口
  String proxyPort = "8888";

  static DioUtil _getInstance() {
    if (_instance == null) {
      _instance = new DioUtil._instanal();
    }
    return _instance;
  }

  DioUtil._instanal() {
    BaseOptions options = new BaseOptions();
    options.connectTimeout = 20000;
    options.receiveTimeout = 2 * 60 * 1000;
    options.sendTimeout = 2 * 60 * 1000;
    _dio = new Dio(options);
    bool inProduction = bool.fromEnvironment("dart.vm.product");
    if (!inProduction) {
      debugFunction();
    }
  }

  void debugFunction() {
    _dio.interceptors.add(LogsInterceptors());
    if (isProxy) {
      _setUpPROXY();
    }
  }

  ///配置代理
  void _setUpPROXY() {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.findProxy = (uri) {
        //proxyIp 地址  proxyPort 端口
        return 'PROXY $proxyIp : $proxyPort';
      };
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        //忽略证书
        return true;
      };
    };
  }

  ///get请求
  ///[url] 请求地址
  ///[queryParameters] 请求参数
  ///[cancelTag] 取消请求
  Future getRequest(
      {@required String url,
      Map<String, dynamic> queryParameters,
      CancelToken cancelTag}) async {
    try {
      _dio.options = await buildOptions(_dio.options);
      //配置header的请求类型
      _dio.options.headers["content-type"] = "application/json";
      Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        cancelToken: cancelTag,
      );
      //响应数据
      dynamic responseData = response.data;
      //数据解析
      if (responseData is Map<String, dynamic>) {
        //转换
        Map<String, dynamic> responseMap = responseData;
        int code = responseMap["code"];
        if (code == 200) {
          dynamic data = responseMap["data"];
          return ResponseInfo(data: data);
        } else {
          return ResponseInfo.error(
            code: responseMap["code"],
            message: responseMap["message"],
          );
        }
      }
    } catch (e, s) {
      return errorController(e, s);
    }
  }

  ///post请求
  ///[url] 请求地址
  ///[formDataMap] formData 请求参数
  ///[jsonMap] JSON 格式
  ///[cancelTag] 取消请求
  Future<ResponseInfo> postRequest({
    @required String url,
    Map<String, dynamic> formDataMap,
    Map<String, dynamic> jsonMap,
    CancelToken cancelTag,
  }) async {
    FormData form;
    _dio.options = await buildOptions(_dio.options);
    if (formDataMap != null) {
      form = FormData.fromMap(formDataMap);
      _dio.options.headers["content-type"] = "multipart/form-data";
    }

    try {
      Response response = await _dio.post(
        url,
        data: form == null ? jsonMap : form,
        cancelToken: cancelTag,
      );
      dynamic responseData=response.data;
      if(responseData is Map<String,dynamic>){
        Map<String,dynamic> responseMap=responseData;
        int code=responseMap["code"];
        if (code == 200) {
          //业务代码处理正常
          //获取数据
          dynamic data = responseMap["data"];
          return ResponseInfo(data: data);
        } else {
          //业务代码异常
          return ResponseInfo.error(
              code: responseMap["code"],
              message:responseMap["message"]);
        }
      }
    } catch (e, s) {
      return errorController(e, s);
    }
  }

  Future<ResponseInfo> errorController(e, StackTrace s) {
    ResponseInfo responseInfo = ResponseInfo();
    responseInfo.success = false;
    if (e is DioError) {
      DioError dioError = e;
      switch (dioError.type) {
        case DioErrorType.CONNECT_TIMEOUT:
          responseInfo.message = "连接超时";
          break;
        case DioErrorType.SEND_TIMEOUT:
          responseInfo.message = "请求超时";
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          responseInfo.message = "响应超时";
          break;
        case DioErrorType.RESPONSE:
          // 响应错误
          responseInfo.message = "响应错误";
          break;
        case DioErrorType.CANCEL:
          // 取消操作
          responseInfo.message = "已取消";
          break;
        case DioErrorType.DEFAULT:
          // 默认自定义其他异常
          responseInfo.message = "网络请求异常";
          break;
      }
    } else {
      responseInfo.message = "未知错误";
    }
    responseInfo.success = false;
    return Future.value(responseInfo);
  }

  ///配置Options
  Future<BaseOptions> buildOptions(BaseOptions options) async {
    //配置header
    options.headers["productId"] = Platform.isAndroid ? "Android" : "iOS";
    options.headers["application"] = "coalx";

    //获取当前APP版本信息
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    options.headers["appVersion"] = "$version";
    return Future.value(options);
  }
}


///请求数据返回Info
class ResponseInfo {
  bool success;
  int code;
  String message;
  dynamic data;

  ResponseInfo({
    this.success = true,
    this.code = 200,
    this.message = "请求成功",
    this.data,
  });

  ResponseInfo.error({
    this.success = false,
    this.code = 201,
    this.message = "请求异常",
  });
}

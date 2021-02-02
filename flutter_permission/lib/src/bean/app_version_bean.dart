
class AppVersionBean {
  bool isNeed;
  String isForce;
  String updateContent;
  String packageUrl;

  AppVersionBean.fromJson(Map<String, dynamic> map) {
    this.isNeed = map["isNeed"];
    this.isForce = map["isForce"];
    this.updateContent = map["updateContent"];
    this.packageUrl = map["packageUrl"];
  }
}
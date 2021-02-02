
class UserBean{
  String userName;
  int userAge;

  UserBean.formMap(Map<String,dynamic> map){
    this.userName=map["userName"];
    this.userAge=map["age"];
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> map = new Map();
    map["userName"]=this.userName;
    map["age"]=this.userAge;
    return map;
  }
}
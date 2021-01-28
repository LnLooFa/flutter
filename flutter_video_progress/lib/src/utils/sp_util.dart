
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SPUtil{
  ///静态实例
  static SharedPreferences _sharedPreferences;

  ///初始化
  static Future<bool> init() async{
    _sharedPreferences = await SharedPreferences.getInstance();
    return true;
  }

  ///删除指定key的数据
  static void remove(String key) async{
    if(_sharedPreferences.containsKey(key)){
      _sharedPreferences.remove(key);
    }
  }

  ///保存数据
  static Future save(String key,dynamic value) async{
    if(value is String){
      _sharedPreferences.setString(key, value);
    }else if(value is bool){
      _sharedPreferences.setBool(key, value);
    }else if(value is double){
      _sharedPreferences.setDouble(key, value);
    }else if(value is int){
      _sharedPreferences.setInt(key, value);
    }else if(value is List<String>){
      _sharedPreferences.setStringList(key, value);
    }
  }

  ///读取数据
  static Future<String> getString(String key) async{
    return _sharedPreferences.getString(key);
  }

  static Future<bool> getBool(String key) async{
    return _sharedPreferences.getBool(key);
  }

  static Future<double> getDouble(String key) async{
    return _sharedPreferences.getDouble(key);
  }

  static Future<int> getInt(String key) async{
    return _sharedPreferences.getInt(key);
  }

  static Future<List<String>> getStringList(String key) async{
    return _sharedPreferences.getStringList(key);
  }

  ///保存自定义对象类型
  static Future saveObject(String key,dynamic value) async{
    _sharedPreferences.setString(key, json.encode(value));
  }

  ///读取自定义对象类型
  static dynamic getObject(String key) async{
    String _data = _sharedPreferences.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  ///保存列表数据
  static Future<bool> setObjectList(String key,List<Object> list) async{
    List<String> _dataList = list?.map((value) {
      return json.encode(value);
    })?.toList();
    return _sharedPreferences.setStringList(key, _dataList);
  }

  ///返回的是List<Map<String,dynamic>>类型
  static List<Map> getObjectList(String key) {
    if (_sharedPreferences == null) return null;
    List<String> dataLis = _sharedPreferences.getStringList(key);
    return dataLis?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    })?.toList();
  }
}
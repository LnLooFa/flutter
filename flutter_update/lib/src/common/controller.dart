import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//用于登录的通信
StreamController<int> loginStreamController = StreamController.broadcast();


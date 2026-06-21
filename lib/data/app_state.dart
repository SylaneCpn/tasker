import 'package:flutter/material.dart';
import 'package:tasker/meta/serializable.dart';
import 'package:tasker/utils/json_serializable.dart';

@serializable
class AppState  with ChangeNotifier , JsonSerializable{
  final String? name = "SylaneCpn";
  
  @override
  Map<String, Object?> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
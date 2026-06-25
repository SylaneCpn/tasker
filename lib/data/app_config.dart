import 'package:flutter/material.dart';
import 'package:tasker/meta/deserializable.dart';
import 'package:tasker/utils/json_serializable.dart';

@deserializable
class AppConfig with ChangeNotifier, JsonSerializable {
  final String? name = "SylaneCpn";

  @override
  Map<String, Object?> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

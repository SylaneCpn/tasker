import 'package:flutter/material.dart';

extension SerializeTimeOfDay on TimeOfDay {
  String serialize() => "$hour:$minute";
}

TimeOfDay parseTimeOfDay(String str) {
  try {
    final [hour , minute] = str.split(":").map(int.parse).toList();
    return TimeOfDay(hour: hour, minute: minute);
  }

  on Exception {
    throw FormatException("Could not parse TimeOfDay from $str");
  }
}
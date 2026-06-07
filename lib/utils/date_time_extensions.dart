import 'package:flutter/material.dart';

extension IsSameDay on DateTime {
  bool isSameDay(DateTime other) =>
      year == other.year && day == other.day && month == other.month;
}

extension CopyWithTimeOfDay on DateTime {
  DateTime copyWithTimeOfDay(TimeOfDay timeOfDay) =>
      copyWith(hour: timeOfDay.hour, minute: timeOfDay.minute);
}

extension TimeOfDayFromDateTime on DateTime {
  TimeOfDay asTimeOfDay() => TimeOfDay(hour: hour, minute: minute);
}
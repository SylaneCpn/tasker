import 'package:flutter/material.dart';
import 'package:tasker/data/month.dart';
import 'package:tasker/data/year_date.dart';

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

extension AsYearDate on DateTime {
  YearDate asYearDate() => YearDate(day: day, month: Month.fromMonthOfYear(month) , year:  year);
}

extension IsToday on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return isSameDay(now); 
  }
}
import 'package:flutter/material.dart';
import 'package:tasker/utils/date_time_extensions.dart';
import 'package:tasker/utils/serialize_time_of_day.dart';

class TimeOfDayRange {
  TimeOfDay _start;
  TimeOfDay get start => _start;
  TimeOfDay _end;
  TimeOfDay get end => _end;
  Duration get duration => _end.asDateTime().difference(_start.asDateTime());
  bool _isAllDay;
  bool get isAllDay => _isAllDay;

  TimeOfDayRange({TimeOfDay? start, required TimeOfDay end})
    : _end = end,
      _start = start ?? TimeOfDay.now(),
      _isAllDay = false {
    assert(!_start.isAfter(_end));
  }

  TimeOfDayRange._unchecked({
    required TimeOfDay start,
    required TimeOfDay end,
    required bool isAllDay,
  }) : _start = start,
       _end = end,
       _isAllDay = isAllDay;

  factory TimeOfDayRange.allDay() {
    final start = TimeOfDay(hour: 0, minute: 0);
    final end = TimeOfDay(hour: 23, minute: 59);
    return TimeOfDayRange._unchecked(start: start, end: end, isAllDay: true);
  }

  factory TimeOfDayRange.parse(String str) {
    try {
      final [start, end] = str.split("-").map(parseTimeOfDay).toList();
      if (end.asDateTime().difference(start.asDateTime()) ==
          Duration(hours: 23, minutes: 59)) {
        return TimeOfDayRange.allDay();
      }

      return TimeOfDayRange(start: start, end: end);
    } on Exception catch (e) {
      throw FormatException(
        "Could not parse TimeOfDayRangeFrom $str because $e",
      );
    }
  }

  bool contains(TimeOfDay timeOfDay) =>
      _isAllDay || (!timeOfDay.isBefore(start) && !timeOfDay.isAfter(end));

  bool isBefore(TimeOfDay timeOfDay) => !_isAllDay && _end.isBefore(timeOfDay);

  bool isAfter(TimeOfDay timeOfDay) => !_isAllDay && _start.isAfter(timeOfDay);

  String serialize() => "${_start.serialize()}-${_end.serialize()}";
}

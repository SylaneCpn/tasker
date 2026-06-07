import 'package:flutter/material.dart';

class TimeOfDayRange {
  TimeOfDay _start;
  TimeOfDay get start => _start;
  TimeOfDay _end;
  TimeOfDay get end => _end;
  bool _isAllDay;
  bool get isAllDay => _isAllDay;

  TimeOfDayRange({TimeOfDay? start, required TimeOfDay end})
    : _end = end,
      _start = start ?? TimeOfDay.now(),
      _isAllDay = false {
    assert(!this.start.isAfter(end));
  }

  TimeOfDayRange._({
    required TimeOfDay start,
    required TimeOfDay end,
    required bool isAllDay,
  }) : _start = start,
       _end = end,
       _isAllDay = isAllDay;

  factory TimeOfDayRange.allDay() {
    final start = TimeOfDay(hour: 0, minute: 0);
    final end = TimeOfDay(hour: 23, minute: 59);
    return TimeOfDayRange._(start: start, end: end , isAllDay: true);
  }

  bool contains(TimeOfDay timeOfDay) =>
       _isAllDay || (!timeOfDay.isBefore(start) && !timeOfDay.isAfter(end));
}

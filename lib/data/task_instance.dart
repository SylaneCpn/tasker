// ignore_for_file: prefer_final_fields

import 'package:result/result.dart';
import 'package:tasker/utils/duration_parse.dart';
import 'package:tasker/utils/unwrap_or_throw_extension.dart';

/// An instance of a task
/// With an DateTime as start time and a Duration
class TaskInstance {
  DateTime _start;
  Duration _duration;

  DateTime get start => _start;
  Duration get duration => _duration;
  DateTime get end => _start.add(duration);

  TaskInstance({required DateTime start, required Duration duration})
    : _start = start,
      _duration = duration {
    final endTimeOfDay = _start.add(_duration);
    final endDurationSinceStartOfTheDay = Duration(
      hours: endTimeOfDay.hour,
      minutes: endTimeOfDay.minute,
    );
    assert(endDurationSinceStartOfTheDay < Duration(hours: 24));
  }

  factory TaskInstance.tillEndOfDay({required DateTime start}) {
    final deadLine = start.copyWith(hour: 23, minute: 59);
    final duration = deadLine.difference(start);
    return TaskInstance(start: start, duration: duration);
  }

  static Result<TaskInstance, FormatException> parse(String str) {
    try {
      final [startDateAsString, durationAsString] = str.split("+");
      final start = DateTime.parse(startDateAsString);
      final duration = parseDuration(durationAsString).unwrapOrThrow();
      return Ok(TaskInstance(start: start, duration: duration));
    } on Exception catch (e) {
      return Err(
        FormatException("Could not parse TaskInstance from $str because $e"),
      );
    }
  }

  @override
  bool operator ==(Object other) =>
      other is TaskInstance &&
      other._start == _start &&
      other._duration == _duration;

  @override
  int get hashCode => Object.hash(_start, _duration);

  bool contains(DateTime dateTime) =>
      !dateTime.isBefore(start) && !dateTime.isAfter(end);

  String serialize() => "$_start+$_duration";
}

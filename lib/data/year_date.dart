import 'package:flutter/material.dart';
import 'package:result/result.dart';
import 'package:tasker/data/month.dart';
import 'package:tasker/utils/leap_year.dart';

/// A class that represents a date from a day and a month
class YearDate implements Comparable<YearDate> {
  final Month month;
  final int day;
  // ignore: unused_field
  final bool _isLeap;

  static Result<YearDate , FormatException> parse(String str) {
    try {
      final [day , monthAsInt ] = str.split(":").map(int.parse).toList();
      return Ok(YearDate(day: day, month: Month.fromMonthOfYear(monthAsInt) , year:  garranteedLeapYear));

    }

    on Exception catch (e) {
      throw Err(FormatException("Could not parse YearDate from $str because $e"));
    }
  }

  // ignore: unused_element
  const YearDate._unchecked({
    required this.month,
    required this.day,
    required bool isLeap,
  }) : _isLeap = isLeap;

  YearDate({required this.day, required this.month, int? year})
    : _isLeap = isLeapYear(year ?? DateTime.now().year) {
    assert(month.numberOfDays(year ?? DateTime.now().year) >= day && day > 0);
  }

  YearDate copyWith({Month? month, int? day, int? year}) =>
      YearDate(month: month ?? this.month, day: day ?? this.day, year: year);

  @override
  bool operator ==(Object other) =>
      other is YearDate && other.day == day && other.month == month;

  @override
  int get hashCode => Object.hash(month, day);

  @override
  int compareTo(YearDate other) {
    if (this == other) return 0;
    if (month != other.month) {
      return month.monthOfYear() - other.month.monthOfYear();
    }
    return day - other.day;
  }

  bool isBefore(YearDate candidate) => compareTo(candidate) < 0;
  bool isAfter(YearDate candidate) => compareTo(candidate) > 0;

  bool isSameDayAs(DateTime dateTime) {
    final toCompAsYearDate = YearDate(day: dateTime.day, month: Month.fromMonthOfYear(dateTime.month));
    return toCompAsYearDate == this;
  }

  bool isToday() => isSameDayAs(DateTime.now());

  String serialize() => "$day:${month.monthOfYear()}";
}

extension NextAfterDate on Iterable<YearDate> {
  YearDate? nextAfter(YearDate yearDate, {bool Function(YearDate)? predicate}) {
    final after = where((yd) => yd.compareTo(yearDate) >= 0 && (predicate?.call(yd) ?? true)).toList()..sort();
    final before = where((yd) => yd.compareTo(yearDate) < 0 && (predicate?.call(yd) ?? true)).toList()..sort();
    if (after.isNotEmpty) {
      return after.first;
    }
    return before.firstOrNull;
  }
}

extension PrevBeforeDate on Iterable<YearDate> {
  YearDate? prevBefore(YearDate yearDate, {bool Function(YearDate)? predicate}) {
    final after = where((yd) => yd.compareTo(yearDate) > 0 && (predicate?.call(yd) ?? true)).toList()..sort()..reversed;
    final before = where((yd) => yd.compareTo(yearDate) <= 0 && (predicate?.call(yd) ?? true)).toList()..sort()..reversed;
    if (before.isNotEmpty) {
      return before.first;
    }
    return after.firstOrNull;
  }
}

import 'package:result/result.dart';
import 'package:tasker/data/date.dart';
import 'package:tasker/extensions/date_time_extensions.dart';

class DateRange {
  final Date? start;
  final Date? end;

  Duration? get duration => (start != null && end != null) ? end!.toDateTime().difference(start!.toDateTime()) : null;

  DateRange({this.start, this.end});
  static Result<DateRange, FormatException> parse(String str) {
    try {
      final [start, end] = str.split("/");
      final parsedStart = DateTime.tryParse(start)?.toDate();
      final parsedEnd = DateTime.tryParse(end)?.toDate();
      return Ok(
        DateRange(start: parsedStart, end:parsedEnd),
      );
    } on Exception catch (e) {
      return Err(
        FormatException("Could not parse DateRange from $str  because $e"),
      );
    }
  }

  String serialize() {
    return "${start?.toDateTime() ?? "_"}/${end?.toDateTime() ?? "_"}";
  }

  // bool contains(DateTime dateTime) =>
  //     !dateTime.isBefore(start.toDateTime()) && !dateTime.isAfter(end.toDateTime());

  bool contains(DateTime dateTime) =>
    switch ((start,end)) {
      (Date s , Date e) => !dateTime.isBefore(s.toDateTime()) && !dateTime.isAfter(e.toDateTime()),
      (Date s , null) =>!dateTime.isBefore(s.toDateTime()),
      (null, Date e) =>!dateTime.isAfter(e.toDateTime()),
      // No limit, full range
      (null, null) => true,
    };
}

import 'package:result/result.dart';
import 'package:tasker/data/date.dart';

class DateRange {
  final Date start;
  Duration get duration => end.toDateTime().difference(start.toDateTime());
  final Date end;

  DateRange({Date? start, required this.end})
    : start = start ?? Date.now();

  static Result<DateRange, FormatException> parse(String str) {
    try {
      final [start, end] = str.split("/");
      return Ok(
        DateRange(start: Date.fromDateTime( DateTime.parse(start)), end:Date.fromDateTime(DateTime.parse(end)) ),
      );
    } on Exception catch (e) {
      throw Err(
        FormatException("Could not parse DateRange from $str  because $e"),
      );
    }
  }

  String serialize() {
    return "${start.toDateTime()}/${end.toDateTime()}";
  }

  bool contains(DateTime dateTime) =>
      !dateTime.isBefore(start.toDateTime()) && !dateTime.isAfter(end.toDateTime());
}

import 'package:result/result.dart';

class DateRange {
  final DateTime start;
  Duration get duration => end.difference(start);
  final DateTime end;

  DateRange({DateTime? start, required this.end})
    : start = start ?? DateTime.now();

  static Result<DateRange, FormatException> parse(String str) {
    try {
      final [start, end] = str.split("/");
      return Ok(
        DateRange(start: DateTime.parse(start), end: DateTime.parse(end)),
      );
    } on Exception catch (e) {
      throw Err(
        FormatException("Could not parse DateRange from $str  because $e"),
      );
    }
  }

  String serialize() {
    return "$start/$end";
  }

  bool contains(DateTime dateTime) =>
      !dateTime.isBefore(start) && !dateTime.isAfter(end);
}

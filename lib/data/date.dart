import 'package:tasker/data/month.dart';

class Date {
  final int day;
  final Month month;
  final int year;

  const Date._unchecked({
    required this.day,
    required this.month,
    required this.year,
  });
  factory Date({required int day, required Month month, required int year}) {
    assert(Date.isValid(day: day, month: month, year: year));
    return Date._unchecked(day: day, month: month, year: year);
  }

  static bool hasPassedOrInvalid({required int day, required Month month, required int year}) {
    if (!Date.isValid(day: day, month: month, year: year)) {
      return true;
    }
    return Date(day: day,month: month,year: year).hasPassed();
  }

  static bool isValid({required int day, required Month month, required int year}) => day <= month.numberOfDays(year);

  Date copyWith({int? day, Month? month, int? year}) => Date(
    day: day ?? this.day,
    month: month ?? this.month,
    year: year ?? this.year,
  );

  bool hasPassed() {
    final today = Date.now().toDateTime();
    return toDateTime().isBefore(today);
  }

  factory Date.fromDateTime(DateTime dateTime) => Date(
    day: dateTime.day,
    month: Month.fromMonthOfYear(dateTime.month),
    year: dateTime.year,
  );



  factory Date.now() => Date.fromDateTime(DateTime.now());

  DateTime toDateTime() => DateTime(year, month.monthOfYear(), day);
}

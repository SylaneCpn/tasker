import 'package:tasker/data/month.dart';

class Date {
  final int day;
  final Month month;
  final int year;

  const Date._unchecked({required this.day , required this.month , required this.year});
  factory Date({required int day, required Month month , required int year}) {
    assert(day <= month.numberOfDays(year));
    return Date._unchecked(day: day, month: month, year: year);
  }

  factory Date.fromDateTime(DateTime dateTime) => Date(day: dateTime.day, month: Month.fromMonthOfYear(dateTime.month), year: dateTime.year);


  factory Date.now() => Date.fromDateTime(DateTime.now());
  

  DateTime toDateTime() => DateTime(year, month.monthOfYear(),day);
}
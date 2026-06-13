import 'package:tasker/utils/leap_year.dart';

///Enum for the months of the year.
enum Month {
  january,
  febuary,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december;

  /// Get the month of the week ranging from 1 to 12 included.
  /// 
  /// `Month.january` maps to 1 while `Month.july` maps to 7.
  int monthOfYear() => index + 1;

  /// Get the `Month` from the month number of the yrat.
  /// 
  /// 1 maps to `Month.january` while 7 maps to `Month.july`.
  /// 
  /// All operation are mod 12 so putting 15 as an input while be equivalent to 3
  /// giving `Month.march`.   
  factory Month.fromMonthOfYear(int monthOfYear) => Month.values[(monthOfYear - 1) % 12];

  /// Number of days in the month for a given year.
  int numberOfDays(int year) => switch(this) {
    Month.january => 31,
    Month.febuary => isLeapYear(year) ? 29 : 28 ,
    Month.march => 31,
    Month.april => 30,
    Month.may => 31,
    Month.june => 30,
    Month.july => 31,
    Month.august => 31,
    Month.september => 30,
    Month.october => 31,
    Month.november => 30,
    Month.december => 31,
    
  };
}


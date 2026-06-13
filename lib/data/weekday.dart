///Enum for the days of the week.
enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  /// Get the day of the week ranging from 1 to 7 included.
  /// 
  /// `Weekday.monday` maps to 1 while `Weekday.sunday` maps to 7.
  int dayOfWeek() => index + 1;

  /// Get the `WeekDay` from the day number of the week.
  /// 
  /// 1 maps to `Weekday.monday` while 7 maps to `Weekday.sunday`.
  /// 
  /// All operation are mod 7 so putting 10 as an input while be equivalent to 3
  /// giving `Weekday.wednesday`.   
  factory Weekday.fromDayOfWeek(int dayOfWeek) => Weekday.values[(dayOfWeek - 1) % 7];
}
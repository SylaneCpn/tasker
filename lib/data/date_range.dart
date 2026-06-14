class DateRange {
  DateTime start;
  Duration duration;
  DateTime get end => start.add(duration);

  DateRange({DateTime? start, required this.duration})
    : start = start ?? DateTime.now();




  bool contains(DateTime dateTime) => !dateTime.isBefore(start) && !dateTime.isAfter(end);
  
}

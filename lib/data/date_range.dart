class DateRange {
  DateTime start;
  DateTime end;

  DateRange({DateTime? start, required this.end})
    : start = start ?? DateTime.now() {
      assert(!this.start.isAfter(end));
    }




  bool contains(DateTime dateTime) => !dateTime.isBefore(start) && !dateTime.isAfter(end);
  
}

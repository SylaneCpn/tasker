import 'package:tasker/utils/duration_parse.dart';

class DateRange {
  DateTime start;
  Duration duration;
  DateTime get end => start.add(duration);

  DateRange({DateTime? start, required this.duration})
    : start = start ?? DateTime.now();


  factory DateRange.parse(String str)  {
    try {
      final [start , duration] = str.split("+");
      return DateRange(start : DateTime.parse(start) , duration: parseDuration(duration) );
    }

    on Exception catch (e) {
      throw FormatException("Could not parse DateRange from $str  because $e");
    }
    
  }



  String serialize() {
    return "$start+$duration";
  }



  bool contains(DateTime dateTime) => !dateTime.isBefore(start) && !dateTime.isAfter(end);
  
}

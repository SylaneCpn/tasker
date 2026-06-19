import 'package:result/result.dart';
import 'package:tasker/utils/duration_parse.dart';

class DateRange {
  DateTime start;
  Duration duration;
  DateTime get end => start.add(duration);

  DateRange({DateTime? start, required this.duration})
    : start = start ?? DateTime.now();


  static Result<DateRange , FormatException> parse(String str)  {
    try {
      final [start , duration] = str.split("+");
      return Ok(DateRange(start : DateTime.parse(start) , duration: parseDuration(duration).unwrap() ));
    }

    on Exception catch (e) {
      throw Err(FormatException("Could not parse DateRange from $str  because $e"));
    }
    
  }



  String serialize() {
    return "$start+$duration";
  }



  bool contains(DateTime dateTime) => !dateTime.isBefore(start) && !dateTime.isAfter(end);
  
}

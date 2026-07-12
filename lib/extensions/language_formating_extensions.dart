import 'package:tasker/data/month.dart';
import 'package:tasker/data/task_instance.dart';
import 'package:tasker/extensions/capitalize_string.dart';
import 'package:tasker/extensions/pad_for_clock.dart';
import 'package:tasker/languages/language_text_provider.dart';

extension AsLangName on Month {
  String asLangName(LanguageTextProvider langTextProv) {
    return langTextProv.rawTextes[name.toLowerCase()] ?? name.capitalize();
  }
}

extension FormatedDate on TaskInstance {
  ({String timeRangeFormat, String dateFormat}) formatedDate(
    LanguageTextProvider langTextProv,
  ) {
    final DateTime(:day, month: monthAsInt, :year) = start;
    final month = Month.fromMonthOfYear(monthAsInt);

    final dateFormat = "$day ${month.asLangName(langTextProv)} $year";

    if (isAllDay) {
      return (dateFormat: dateFormat, timeRangeFormat: langTextProv.allDay);
    }

    final endProxy = end;
    final beginHour = start.hour;
    final beginMinute = start.minute;

    final endHour = endProxy.hour;
    final endMinute = endProxy.minute;

    final timeRangeFormat = "${beginHour.padForClock()}:${beginMinute.padForClock()} - ${endHour.padForClock()}:${endMinute.padForClock()}";
    return (dateFormat: dateFormat, timeRangeFormat: timeRangeFormat);
  }
}

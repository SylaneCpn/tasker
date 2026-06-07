import 'package:tasker/data/date_range.dart';
import 'package:tasker/data/time_of_day_range.dart';
import 'package:tasker/data/weekday.dart';
import 'package:tasker/utils/date_time_extensions.dart';

sealed class Schedule {
  /// Next time the schedule meets
  DateTime? next();

  /// Last time the schedule was met
  DateTime? last();
  bool isToday();
  bool occuringNow();

  Duration? sinceLast() {
    final lastTime = last();
    if (lastTime != null) {
      return DateTime.now().difference(lastTime);
    }
    return null;
  }

  Duration? tillNext() {
    final nextTime = next();
    if (nextTime != null) {
      return nextTime.difference(DateTime.now());
    }

    return null;
  }
}

class OneTime extends Schedule {
  DateTime time;
  TimeOfDayRange range;

  OneTime({
    required int year,
    int month = 1,
    int day = 1,
    TimeOfDayRange? range,
  }) : time = DateTime(year, month, day),
       range = range ?? TimeOfDayRange.allDay();

  @override
  DateTime? next() {
    final now = DateTime.now();
    final deadLine = time.copyWithTimeOfDay(range.end);
    return deadLine.isAfter(now) ? deadLine : null;
  }

  @override
  bool isToday() {
    final now = DateTime.now();
    return now.isSameDay(time);
  }

  @override
  DateTime? last() {
    final now = DateTime.now();
    final deadLine = time.copyWithTimeOfDay(range.end);
    return deadLine.isAfter(now) ? deadLine : null;
  }

  @override
  bool occuringNow() {
    final now = DateTime.now();
    return now.isSameDay(time) && range.contains(now.asTimeOfDay());
  }
}

class Weekly extends Schedule {
  final Map<Weekday, List<TimeOfDayRange>> occurences;
  final DateRange range;

  Weekly._unchecked({required this.occurences, required this.range});

  factory Weekly({
    required Map<Weekday, List<TimeOfDayRange>> occurences,
    required DateRange range,
  }) {
    assert(occurences.isNotEmpty);
    assert(occurences.values.every((tod) => tod.isNotEmpty));
    return Weekly._unchecked(occurences: occurences, range: range);
  }

  @override
  DateTime? next() {
    final now = DateTime.now();
    DateTime candidateDay = now.copyWith();
    MapEntry<Weekday, List<TimeOfDayRange>>? targetOccurence = occurences
        .entries
        .where((e) => e.key.dayOfWeek() == candidateDay.weekday)
        .firstOrNull;

    // No occurence for the day
    while (targetOccurence == null) {
      candidateDay = candidateDay.add(Duration(days: 1));
      targetOccurence = occurences.entries
          .where((e) => e.key.dayOfWeek() == candidateDay.weekday)
          .firstOrNull;
    }

    final foundOccurence = targetOccurence;
    final timeOfDaysForOccurence = foundOccurence.value;
    timeOfDaysForOccurence.sort((a, b) => a.start.compareTo(b.start));

    final nextTimeOfDay = timeOfDaysForOccurence.where((timeOfDay) {
      final checkIfAfter = candidateDay.copyWith(
        hour: timeOfDay.start.hour,
        minute: timeOfDay.start.minute,
      );
      return checkIfAfter.isAfter(now);
    }).firstOrNull;

    if (nextTimeOfDay != null) {
      final targetDate = candidateDay.copyWith(
        hour: nextTimeOfDay.start.hour,
        minute: nextTimeOfDay.start.minute,
      );
      return range.contains(targetDate) ? targetDate : null;
    }
    // Case the targetOcurence is today but was earlier that day
    // we have to find the next one
    else {
      // start with next day...
      // ...and continue as previously
      targetOccurence = null;
      while (targetOccurence == null) {
        candidateDay = candidateDay.add(Duration(days: 1));
        // filter empty schedule this time
        targetOccurence = occurences.entries
            .where(
              (e) =>
                  e.key.dayOfWeek() == candidateDay.weekday &&
                  e.value.isNotEmpty,
            )
            .firstOrNull;
      }

      final nextOccurenceDay = targetOccurence;
      final occurencesInDay = nextOccurenceDay.value;
      occurencesInDay.sort((a, b) => a.start.compareTo(b.start));
      // Garanted to be not empty
      final firstTimeInDay = occurencesInDay.first;

      // Check if in range
      final targetDate = candidateDay.copyWith(
        hour: firstTimeInDay.start.hour,
        minute: firstTimeInDay.start.minute,
      );
      return range.contains(targetDate) ? targetDate : null;
    }
  }

  @override
  bool isToday() {
    final now = DateTime.now();
    return range.contains(now) &&
        occurences.entries.any((occ) => occ.key.dayOfWeek() == now.weekday);
  }

  @override
  DateTime? last() {
    final now = DateTime.now();
    DateTime candidateDay = now.copyWith();
    MapEntry<Weekday, List<TimeOfDayRange>>? targetOccurence = occurences
        .entries
        .where((e) => e.key.dayOfWeek() == candidateDay.weekday)
        .firstOrNull;

    // No occurence for the day
    while (targetOccurence == null) {
      candidateDay = candidateDay.subtract(Duration(days: 1));
      targetOccurence = occurences.entries
          .where((e) => e.key.dayOfWeek() == candidateDay.weekday)
          .firstOrNull;
    }

    final foundOccurence = targetOccurence;
    final timeOfDaysForOccurence = foundOccurence.value;
    timeOfDaysForOccurence.sort((a, b) => b.start.compareTo(a.start));

    final lastTimeOfDay = timeOfDaysForOccurence.where((timeOfDay) {
      final checkIfBefore = candidateDay.copyWith(
        hour: timeOfDay.start.hour,
        minute: timeOfDay.start.minute,
      );
      return checkIfBefore.isBefore(now);
    }).firstOrNull;

    if (lastTimeOfDay != null) {
      final targetDate = candidateDay.copyWith(
        hour: lastTimeOfDay.start.hour,
        minute: lastTimeOfDay.start.minute,
      );
      return range.contains(targetDate) ? targetDate : null;
    }
    // Case the targetOcurence is today but was later that day
    // we have to find the next one
    else {
      // start with next day...
      // ...and continue as previously
      targetOccurence = null;
      while (targetOccurence == null) {
        candidateDay = candidateDay.subtract(Duration(days: 1));
        // filter empty schedule this time
        targetOccurence = occurences.entries
            .where(
              (e) =>
                  e.key.dayOfWeek() == candidateDay.weekday &&
                  e.value.isNotEmpty,
            )
            .firstOrNull;
      }

      final nextOccurenceDay = targetOccurence;
      final occurencesInDay = nextOccurenceDay.value;
      occurencesInDay.sort((a, b) => b.start.compareTo(a.start));
      // Garanted to be not empty
      final lastTimeInDay = occurencesInDay.first;

      // Check if in range
      final targetDate = candidateDay.copyWith(
        hour: lastTimeInDay.start.hour,
        minute: lastTimeInDay.start.minute,
      );
      return range.contains(targetDate) ? targetDate : null;
    }
  }

  @override
  bool occuringNow() {
    final now = DateTime.now();
    final isTdy = isToday();
    if (!isTdy) {
      return false;
    }

    final weekdayToday = Weekday.fromDayOfWeek(now.weekday);
    return occurences[weekdayToday]?.any(
          (r) => r.contains(now.asTimeOfDay()),
        ) ??
        false;
  }
}

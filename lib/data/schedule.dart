import 'package:tasker/data/date_range.dart';
import 'package:tasker/data/month.dart';
import 'package:tasker/data/time_of_day_range.dart';
import 'package:tasker/data/weekday.dart';
import 'package:tasker/data/year_date.dart';
import 'package:tasker/utils/date_time_extensions.dart';
import "package:tasker/utils/duration_parse.dart";

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

  static Schedule fromJson(Map<String, Object?> json) {
    final type = json["type"] as String?;
    final data = json["data"] as Map<String, Object?>?;
    return switch (type) {
      "discrete_occurences" => DiscreteOccurences.fromJson(data ?? {}),
      _ => throw FormatException(
        "Could not parse Schedule : Invalid type : $type",
      ),
    };
  }
}

class DiscreteOccurences extends Schedule {
  final Map<DateTime, Duration> occurences;
  DiscreteOccurences._unchecked({required this.occurences});

  DiscreteOccurences({required this.occurences}) {
    assert(occurences.isNotEmpty);
  }

  factory DiscreteOccurences.fromJson(Map<String, Object?> json) {
    final occurences = <DateTime, Duration>{};
    try {
      for (final MapEntry(:key, :value) in json.entries) {
        final date = DateTime.parse(key);
        final duration = parseDuration(value as String);
        occurences[date] = duration;
      }

      return DiscreteOccurences(occurences: occurences);
    } on Exception catch (e) {
      throw FormatException(
        "Could not parse DiscreteOccurences from $json because : $e",
      );
    }
  }

  DiscreteOccurences.once({
    required int year,
    int month = 1,
    int day = 1,
    Duration? range,
  }) : this._unchecked(
         occurences: {DateTime(year, month, day): range ?? Duration(hours: 24)},
       );

  @override
  DateTime? next() {
    final now = DateTime.now();
    final afterNow =
        occurences.entries.where((e) => e.key.isAfter(now)).toList()
          ..sort((a, b) => a.key.compareTo(b.key));
    return afterNow.firstOrNull?.key;
  }

  @override
  bool isToday() {
    final now = DateTime.now();
    return occurences.entries.any((e) => now.isSameDay(e.key));
  }

  @override
  DateTime? last() {
    final now = DateTime.now();
    final beforeNow =
        occurences.entries.where((e) => e.key.isBefore(now)).toList()
          ..sort((a, b) => b.key.compareTo(a.key));
    return beforeNow.firstOrNull?.key;
  }

  @override
  bool occuringNow() {
    final now = DateTime.now();
    return occurences.entries.any((e) {
      final range = DateRange(start: e.key, duration: e.value);
      return range.contains(now);
    });
  }
}

class Weekly extends Schedule {
  final Map<Weekday, List<TimeOfDayRange>> occurences;
  final DateRange range;

  Weekly._unchecked({required this.occurences, required this.range});

  factory Weekly.fromJson(Map<String , Object?> map) {
    //Todo
    throw ArgumentError();
  }

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

class Monthly extends Schedule {
  final Map<int, List<TimeOfDayRange>> occurences;
  final DateRange range;

  Monthly._unchecked({required this.occurences, required this.range});

  factory Monthly({
    required Map<int, List<TimeOfDayRange>> occurences,
    required DateRange range,
  }) {
    assert(occurences.isNotEmpty);
    assert(occurences.values.every((tod) => tod.isNotEmpty));
    return Monthly._unchecked(occurences: occurences, range: range);
  }

  @override
  bool isToday() {
    final now = DateTime.now();
    return occurences.keys.contains(now.day) && range.contains(now);
  }

  @override
  DateTime? last() {
    final now = DateTime.now();
    DateTime candidateDay = DateTime(now.year, now.month, now.day);
    MapEntry<int, List<TimeOfDayRange>>? targetOccurence = occurences.entries
        .where(
          (e) =>
              e.key == candidateDay.day &&
                  // If today then only get the occurences that have passed
                  candidateDay.isToday()
              ? e.value.any((r) => r.isBefore(now.asTimeOfDay()))
              : true,
        )
        .firstOrNull;
    while (targetOccurence == null) {
      candidateDay = candidateDay.subtract(Duration(days: 1));
      targetOccurence = occurences.entries
          .where(
            (e) => e.key == candidateDay.day && candidateDay.isToday()
                ? e.value.any((r) => r.isBefore(now.asTimeOfDay()))
                : true,
          )
          .firstOrNull;
    }
    final sortedRanges = targetOccurence.value
      ..sort((a, b) => b.start.compareTo(a.start));
    final firstRange = sortedRanges.firstWhere(
      (sr) => candidateDay.isToday() ? sr.isBefore(now.asTimeOfDay()) : true,
    );
    final targetTime = candidateDay.copyWith(
      hour: firstRange.start.hour,
      minute: firstRange.start.minute,
    );
    return range.contains(targetTime) ? targetTime : null;
  }

  @override
  DateTime? next() {
    final now = DateTime.now();
    DateTime candidateDay = DateTime(now.year, now.month, now.day);
    MapEntry<int, List<TimeOfDayRange>>? targetOccurence = occurences.entries
        .where(
          (e) =>
              e.key == candidateDay.day &&
                  // If today then only get the occurences that haven't passed yet
                  candidateDay.isToday()
              ? e.value.any((r) => r.isAfter(now.asTimeOfDay()))
              : true,
        )
        .firstOrNull;
    while (targetOccurence == null) {
      candidateDay = candidateDay.add(Duration(days: 1));
      targetOccurence = occurences.entries
          .where(
            (e) => e.key == candidateDay.day && candidateDay.isToday()
                ? e.value.any((r) => r.isAfter(now.asTimeOfDay()))
                : true,
          )
          .firstOrNull;
    }
    final sortedRanges = targetOccurence.value
      ..sort((a, b) => a.start.compareTo(b.start));
    final firstRange = sortedRanges.firstWhere(
      (sr) => candidateDay.isToday() ? sr.isAfter(now.asTimeOfDay()) : true,
    );
    final targetTime = candidateDay.copyWith(
      hour: firstRange.start.hour,
      minute: firstRange.start.minute,
    );
    return range.contains(targetTime) ? targetTime : null;
  }

  @override
  bool occuringNow() {
    if (!isToday()) {
      return false;
    }
    final now = DateTime.now();
    // Safe because check with isToday()
    final ranges = occurences[now.day]!;
    return ranges.any((r) => r.contains(now.asTimeOfDay()));
  }
}

class Yearly extends Schedule {
  final Map<YearDate, List<TimeOfDayRange>> occurences;
  final DateRange range;

  Yearly._unchecked({required this.occurences, required this.range});

  factory Yearly({
    required Map<YearDate, List<TimeOfDayRange>> occurences,
    required DateRange range,
  }) {
    assert(occurences.isNotEmpty);
    assert(occurences.values.every((tod) => tod.isNotEmpty));
    return Yearly._unchecked(occurences: occurences, range: range);
  }

  @override
  bool isToday() {
    final now = DateTime.now();
    final todayYearDate = now.asYearDate();
    return occurences.entries.any((e) => e.key == todayYearDate) &&
        range.contains(now);
  }

  @override
  DateTime? last() {
    final now = DateTime.now();
    final nowYearDate = YearDate(
      day: now.day,
      month: Month.fromMonthOfYear(now.month),
    );
    final prevYearDate = occurences.keys.prevBefore(
      nowYearDate,
      predicate: (yd) => yd.isToday()
          // if year date is today then only take the occurences that already have happened
          ? occurences[yd]?.any((occ) => occ.isBefore(now.asTimeOfDay())) ??
                false
          : true,
    );
    if (prevYearDate == null) return null;
    final ranges = occurences[prevYearDate]!;
    ranges.sort((a, b) => b.start.compareTo(a.start));
    final prevRange = ranges
        .where(
          (r) => prevYearDate.isToday() ? r.isBefore(now.asTimeOfDay()) : true,
        )
        .firstOrNull;
    if (prevRange == null) return null;
    final prevDateTime = DateTime(
      !prevYearDate.isBefore(nowYearDate) ? now.year : now.year - 1,
      prevYearDate.month.monthOfYear(),
      prevYearDate.day,
      prevRange.start.hour,
      prevRange.start.minute,
    );
    return prevDateTime;
  }

  @override
  DateTime? next() {
    final now = DateTime.now();
    final nowYearDate = YearDate(
      day: now.day,
      month: Month.fromMonthOfYear(now.month),
    );
    final nextYearDate = occurences.keys.nextAfter(
      nowYearDate,
      predicate: (yd) => yd.isToday()
          // if year date is today then only take the occurences that haven't happened yet
          ? occurences[yd]?.any((occ) => occ.isAfter(now.asTimeOfDay())) ??
                false
          : true,
    );
    if (nextYearDate == null) return null;
    final ranges = occurences[nextYearDate]!;
    ranges.sort((a, b) => a.start.compareTo(b.start));
    final nextRange = ranges
        .where(
          (r) => nextYearDate.isToday() ? r.isAfter(now.asTimeOfDay()) : true,
        )
        .firstOrNull;
    if (nextRange == null) return null;
    final nextDateTime = DateTime(
      !nextYearDate.isBefore(nowYearDate) ? now.year : now.year + 1,
      nextYearDate.month.monthOfYear(),
      nextYearDate.day,
      nextRange.start.hour,
      nextRange.start.minute,
    );
    return nextDateTime;
  }

  @override
  bool occuringNow() {
    final now = DateTime.now();
    if (!isToday()) {
      return false;
    }
    return occurences[now.asYearDate()]!.any(
      (r) => r.contains(now.asTimeOfDay()),
    );
  }
}

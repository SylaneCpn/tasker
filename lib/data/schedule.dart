import 'package:result/result.dart';
import 'package:tasker/data/date_range.dart';
import 'package:tasker/data/month.dart';
import 'package:tasker/data/task_instance.dart';
import 'package:tasker/data/time_of_day_range.dart';
import 'package:tasker/data/weekday.dart';
import 'package:tasker/data/year_date.dart';
import 'package:tasker/meta/serializable.dart';
import 'package:tasker/utils/date_time_extensions.dart';
import 'package:tasker/utils/json_serializable.dart';
import 'package:tasker/utils/unwrap_or_throw_extension.dart';

@serializable
sealed class Schedule with JsonSerializable {
  /// Next time the schedule meets
  DateTime? next();

  /// Last time the schedule was met
  DateTime? last();
  bool isToday();
  bool occuringNow();

  Iterable<TaskInstance> instancesForDay({
    required int year,
    required Month month,
    required int day,
  });

  Iterable<TaskInstance> instancesToday() {
    final now = DateTime.now();
    return instancesForDay(
      year: now.year,
      month: Month.fromMonthOfYear(now.year),
      day: now.day,
    );
  }

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

  static Result<Schedule, FormatException> fromJson(Map<String, Object?> json) {
    final type = json["type"] as String?;
    return switch (type) {
      DiscreteOccurences.typeIdentifier => DiscreteOccurences.fromJson(json),
      Weekly.typeIdentifier => Weekly.fromJson(json),
      Monthly.typeIdentifier => Monthly.fromJson(json),
      Yearly.typeIdentifier => Yearly.fromJson(json),
      _ => Err(
        FormatException("Could not parse Schedule : Invalid type : $type"),
      ),
    };
  }

}

@serializable
class DiscreteOccurences extends Schedule {
  static const typeIdentifier = "discrete_occurences";

  final Set<TaskInstance> occurences;
  DiscreteOccurences._unchecked({required this.occurences});

  DiscreteOccurences({required this.occurences}) {
    assert(occurences.isNotEmpty);
  }

  static Result<DiscreteOccurences, FormatException> fromJson(
    Map<String, Object?> json,
  ) {
    final occurences = <TaskInstance>{};
    try {
      for (final occurence in json["data"] as List) {
        final taskInstanceAsString = occurence as String;
        occurences.add(TaskInstance.parse(taskInstanceAsString).unwrapOrThrow());
      }

      return Ok(DiscreteOccurences(occurences: occurences));
    } on Exception catch (e) {
      return Err(
        FormatException(
          "Could not parse DiscreteOccurences from $json because : $e",
        ),
      );
    }
  }

  @override
  Map<String, Object?> toJson() {
    final asJson = <String, Object?>{"type": typeIdentifier};
    final dataList = <String>[];
    for (final occurence in occurences) {
      dataList.add(occurence.serialize());
    }
    asJson["data"] = dataList;
    return asJson;
  }

  DiscreteOccurences.once({
    required int year,
    int month = 1,
    int day = 1,
    Duration? duration,
  }) : this._unchecked(
         occurences: {
           duration != null
               ? TaskInstance(
                   start: DateTime(year, month, day),
                   duration: duration,
                 )
               : TaskInstance.tillEndOfDay(start: DateTime(year, month, day)),
         },
       );

  @override
  DateTime? next() {
    final now = DateTime.now();
    final afterNow = occurences.where((e) => e.start.isAfter(now)).toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    return afterNow.firstOrNull?.start;
  }

  @override
  bool isToday() {
    final now = DateTime.now();
    return occurences.any((e) => now.isSameDay(e.start));
  }

  @override
  DateTime? last() {
    final now = DateTime.now();
    final beforeNow = occurences.where((e) => e.end.isBefore(now)).toList()
      ..sort((a, b) => b.start.compareTo(a.start));
    return beforeNow.firstOrNull?.start;
  }

  @override
  bool occuringNow() {
    final now = DateTime.now();
    return occurences.any((e) {
      final range = DateRange(start: e.start, end: e.end);
      return range.contains(now);
    });
  }

  @override
  Iterable<TaskInstance> instancesForDay({
    required int year,
    required Month month,
    required int day,
  }) => occurences.where(
    (occ) => occ.start.isSameDay(DateTime(year, month.monthOfYear(), day)),
  );
}

@serializable
class Weekly extends Schedule {
  static const typeIdentifier = "weekly";

  final Map<Weekday, List<TimeOfDayRange>> occurences;
  final DateRange range;

  Weekly._unchecked({required this.occurences, required this.range});

  static Result<Weekly, FormatException> fromJson(Map<String, Object?> json) {
    try {
      final data = json["data"] as Map<String, Object?>;
      final range = data["range"] as String;
      final occurences = data["occurences"] as Map<String, Object?>;

      final weekdayMap = <Weekday, List<TimeOfDayRange>>{};
      for (final occurence in occurences.entries) {
        final weekday = Weekday.fromDayOfWeek(int.parse(occurence.key));
        final timeOfDayRanges = (occurence.value as List)
            .map((elem) => TimeOfDayRange.parse(elem).unwrapOrThrow())
            .toList();
        weekdayMap[weekday] = timeOfDayRanges;
      }

      return Ok(
        Weekly(occurences: weekdayMap, range: DateRange.parse(range).unwrapOrThrow()),
      );
    } on Exception catch (e) {
      return Err(
        FormatException("Could not parse Weekly from $json because $e"),
      );
    }
  }

  @override
  Map<String, Object?> toJson() {
    final asJson = <String, Object?>{"type": typeIdentifier};
    final data = <String, Object?>{};
    data["range"] = range.serialize();
    final occurencesMap = <String, Object?>{};
    for (final occurence in occurences.entries) {
      final weekdayAsString = occurence.key.dayOfWeek().toString();
      final timeOfDayRanges = occurence.value
          .map((r) => r.serialize())
          .toList();
      occurencesMap[weekdayAsString] = timeOfDayRanges;
    }

    data["occurences"] = occurencesMap;
    asJson["data"] = data;
    return asJson;
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

  @override
  Iterable<TaskInstance> instancesForDay({
    required int year,
    required Month month,
    required int day,
  }) {
    final dateTime = DateTime(year, month.monthOfYear(), day);
    return occurences.entries
        .where(
          (e) =>
              e.key.dayOfWeek() == dateTime.weekday && range.contains(dateTime),
        )
        .expand(
          (e) => e.value.map(
            (r) => TaskInstance(
              start: dateTime.copyWith(
                hour: r.start.hour,
                minute: r.start.minute,
              ),
              duration: r.duration,
            ),
          ),
        );
  }
}

@serializable
class Monthly extends Schedule {
  static const typeIdentifier = "monthly";

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

  static Result<Monthly, FormatException> fromJson(Map<String, Object?> json) {
    try {
      final data = json["data"] as Map<String, Object?>;
      final rangeAsString = data["range"] as String;
      final rawOccurencesMap = data["occurences"] as Map<String, Object?>;
      final occurences = <int, List<TimeOfDayRange>>{};
      for (final occurence in rawOccurencesMap.entries) {
        final dayOfMonth = int.parse(occurence.key);
        final timeOfDayRanges = (occurence.value as List)
            .map((r) => TimeOfDayRange.parse(r).unwrapOrThrow())
            .toList();
        occurences[dayOfMonth] = timeOfDayRanges;
      }
      return Ok(
        Monthly(
          occurences: occurences,
          range: DateRange.parse(rangeAsString).unwrapOrThrow(),
        ),
      );
    } on Exception catch (e) {
      return Err(
        FormatException("Could not parse Monthly from $json because $e"),
      );
    }
  }

  @override
  Map<String, Object?> toJson() {
    final asJson = <String, Object?>{"type": typeIdentifier};
    final data = <String, Object?>{};
    data["range"] = range.serialize();
    final occurencesMap = <String, Object?>{};
    for (final occurence in occurences.entries) {
      final dayOfMonth = occurence.key.toString();
      final timeOfDayRanges = occurence.value
          .map((r) => r.serialize())
          .toList();
      occurencesMap[dayOfMonth] = timeOfDayRanges;
    }

    data["occurences"] = occurencesMap;
    asJson["data"] = data;
    return asJson;
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

  @override
  Iterable<TaskInstance> instancesForDay({
    required int year,
    required Month month,
    required int day,
  }) {
    final dateTime = DateTime(year, month.monthOfYear(), day);
    return occurences.entries
        .where((e) => e.key == dateTime.day && range.contains(dateTime))
        .expand(
          (e) => e.value.map(
            (r) => TaskInstance(
              start: dateTime.copyWith(
                hour: r.start.hour,
                minute: r.start.minute,
              ),
              duration: r.duration,
            ),
          ),
        );
  }
}

@serializable
class Yearly extends Schedule {
  static const typeIdentifier = "yearly";

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

  static Result<Yearly, FormatException> fromJson(Map<String, Object?> json) {
    try {
      final data = json["data"] as Map<String, Object?>;
      final rangeAsString = data["range"] as String;
      final rawOccurencesMap = data["occurences"] as Map<String, Object?>;
      final occurences = <YearDate, List<TimeOfDayRange>>{};
      for (final occurence in rawOccurencesMap.entries) {
        final yearDate = YearDate.parse(occurence.key).unwrapOrThrow();
        final timeOfDayRanges = (occurence.value as List)
            .map((r) => TimeOfDayRange.parse(r).unwrapOrThrow())
            .toList();
        occurences[yearDate] = timeOfDayRanges;
      }
      return Ok(
        Yearly(
          occurences: occurences,
          range: DateRange.parse(rangeAsString).unwrapOrThrow(),
        ),
      );
    } on Exception catch (e) {
      return Err(
        FormatException("Could not parse Monthly from $json because $e"),
      );
    }
  }

  @override
  Map<String, Object?> toJson() {
    final asJson = <String, Object?>{"type": typeIdentifier};
    final data = <String, Object?>{};
    data["range"] = range.serialize();
    final occurencesMap = <String, Object?>{};
    for (final occurence in occurences.entries) {
      final dayOfYear = occurence.key.serialize();
      final timeOfDayRanges = occurence.value
          .map((r) => r.serialize())
          .toList();
      occurencesMap[dayOfYear] = timeOfDayRanges;
    }

    data["occurences"] = occurencesMap;
    asJson["data"] = data;
    return asJson;
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

  @override
  Iterable<TaskInstance> instancesForDay({
    required int year,
    required Month month,
    required int day,
  }) {
    final dateTime = DateTime(year, month.monthOfYear(), day);
    return occurences.entries
        .where((e) => e.key.isSameDayAs(dateTime) && range.contains(dateTime))
        .expand(
          (e) => e.value.map(
            (r) => TaskInstance(
              start: dateTime.copyWith(
                hour: r.start.hour,
                minute: r.start.minute,
              ),
              duration: r.duration,
            ),
          ),
        );
  }
  
  
}

import 'package:flutter/material.dart';
import 'package:tasker/data/daily_tasks_status.dart';
import 'package:tasker/data/date_range.dart';
import 'package:tasker/data/month.dart';
import 'package:tasker/data/schedule.dart';
import 'package:tasker/data/task_context.dart';
import 'package:tasker/data/task_instance.dart';
import 'package:tasker/data/tasks_wrapper.dart';
import 'package:tasker/data/time_of_day_range.dart';
import 'package:tasker/data/weekday.dart';
import 'package:tasker/data/year_date.dart';

DiscreteOccurences mockDiscreteOccurences() {
  final DateTime(year: nowYear, month: nowMonth, day: nowDay) = DateTime.now();
  final occurences = Iterable.generate(
    15,
    (i) => TaskInstance(
      start: DateTime(2020 + 1, i % 12 + 1, (i * 5) % 28 + 1),
      duration: Duration(hours: i + 1),
    ),
  ).toSet();
  occurences.add(
    TaskInstance(
      start: DateTime(nowYear, nowMonth, nowDay),
      duration: Duration(hours: 23, minutes: 59),
    ),
  );
  final disOcc = DiscreteOccurences(occurences: occurences);
  return disOcc;
}

Weekly mockWeekly() {
  final occurences = <Weekday, List<TimeOfDayRange>>{};
  for (final i in Iterable<int>.generate(3)) {
    final weekday = Weekday.fromDayOfWeek(i + 1);
    final range = List.generate(
      5,
      (index) => TimeOfDayRange(
        start: TimeOfDay(hour: index, minute: 0),
        end: TimeOfDay(hour: index, minute: 59),
      ),
    );
    occurences[weekday] = range;
  }
  final weekly = Weekly(
    occurences: occurences,
    range: DateRange(end: DateTime.now().copyWith(year: 2027)),
  );

  return weekly;
}

Monthly mockMonthly() {
  final occurences = <int, List<TimeOfDayRange>>{};
  for (final i in Iterable<int>.generate(15)) {
    final monthday = i + 2;
    final range = List.generate(
      5,
      (index) => TimeOfDayRange(
        start: TimeOfDay(hour: index, minute: 0),
        end: TimeOfDay(hour: index, minute: 59),
      ),
    );
    occurences[monthday] = range;
  }
  final monthly = Monthly(
    occurences: occurences,
    range: DateRange(end: DateTime.now().copyWith(year: 2027)),
  );
  return monthly;
}

Yearly mockYearly() {
  final occurences = <YearDate, List<TimeOfDayRange>>{};
  for (final i in Iterable<int>.generate(15)) {
    final yearDate = YearDate(day: i + 1, month: Month.fromMonthOfYear(i + 1));
    final range = List.generate(
      5,
      (index) => TimeOfDayRange(
        start: TimeOfDay(hour: index, minute: 0),
        end: TimeOfDay(hour: index, minute: 59),
      ),
    );
    occurences[yearDate] = range;
  }
  final yearly = Yearly(
    occurences: occurences,
    range: DateRange(end: DateTime.now().copyWith(year: 2027)),
  );

  return yearly;
}

TasksWrapper mockTaskWrapper() {
  final wrapper = TasksWrapper.empty();
  wrapper
    ..add(
      description: "Some Task",
      notifies: true,
      label: "Task 1",
      schedule: mockDiscreteOccurences(),
    )
    ..add(
      description: "Some Task",
      notifies: true,
      label: "Task 2",
      schedule: mockWeekly(),
    )
    ..add(
      description: "Some Task",
      notifies: true,
      label: "Task 3",
      schedule: mockMonthly(),
    )
    ..add(
      description: "Some Task",
      notifies: true,
      label: "Task 4",
      schedule: mockYearly(),
    );
  return wrapper;
}

TaskContext mockContext() {
  final wrapper = mockTaskWrapper();
  final status = DailyTasksStatus.newToday();

  final context = TaskContext(dailyStatus: status, tasksWrapper: wrapper);
  return context;
}

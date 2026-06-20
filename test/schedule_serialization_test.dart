import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tasker/data/date_range.dart';
import 'package:tasker/data/month.dart';
import 'package:tasker/data/task_instance.dart';
import 'package:tasker/data/time_of_day_range.dart';
import 'package:tasker/data/weekday.dart';
import 'package:tasker/data/year_date.dart';
import 'package:test/test.dart';
import 'package:tasker/data/schedule.dart';

void main() {
  const pathPrefix = "test_ressources/schedule";
  const discretePath ="$pathPrefix/discrete_serialized.json";
  const weeklyPath = "$pathPrefix/weekly_serialized.json";
  const monthlyPath = "$pathPrefix/monthly_serialized.json";
  const yearlyPath  = "$pathPrefix/yearly_serialized.json";

  group("Serialize Schedules", () {
    test("Serialize then Deserialize DistinctOccurences", () async {
      final occurences = Iterable.generate(
        15,
        (i) => TaskInstance(
          start: DateTime(2020 + 1, i % 12 + 1, (i * 5) % 28 + 1),
          duration: Duration(hours: i + 1),
        ),
      ).toSet();
      final disOcc = DiscreteOccurences(occurences: occurences);
      final asJson = disOcc.toJson();
      final asJsonString = json.encode(asJson);
      final outputFile = await File(
       discretePath,
      ).create(recursive: true);
      await outputFile.writeAsString(asJsonString);
      final deserialized = DiscreteOccurences.fromJson(
        json.decode(await outputFile.readAsString()),
      ).unwrapOrElse((e) => throw e);
      expect(disOcc.occurences, deserialized.occurences);
    });

    test("Serialize then Deserialize Weekly", () async {
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
      final asJson = weekly.toJson();
      final asJsonString = json.encode(asJson);
      final outputFile = await File(
        weeklyPath,
      ).create(recursive: true);
      await outputFile.writeAsString(asJsonString);
      final _ = Weekly.fromJson(
        json.decode(await outputFile.readAsString()),
      ).unwrapOrElse((e) => throw e);


    });

    test("Serialize then Deserialize Monthly", () async {
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
      final asJson = monthly.toJson();
      final asJsonString = json.encode(asJson);
      final outputFile = await File(
        monthlyPath,
      ).create(recursive: true);
      await outputFile.writeAsString(asJsonString);
      final _ = Monthly.fromJson(
        json.decode(await outputFile.readAsString()),
      ).unwrapOrElse((e) => throw e);
    });

    test("Serialize then Deserialize Yearly", () async {
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
      final asJson = yearly.toJson();
      final asJsonString = json.encode(asJson);
      final outputFile = await File(
        yearlyPath,
      ).create(recursive: true);
      await outputFile.writeAsString(asJsonString);
      final _ = Yearly.fromJson(
        json.decode(await outputFile.readAsString()),
      ).unwrapOrElse((e) => throw e);
    });

    test("Deserialize w/ factory Schedule constructor", () async {
        final discreteJson = json.decode(await File(discretePath).readAsString());
        final weeklyJson = json.decode(await File(weeklyPath).readAsString());
        final monthlyJson = json.decode(await File(monthlyPath).readAsString());
        final yearlyJson = json.decode(await File(yearlyPath).readAsString());

        expect(Schedule.fromJson(discreteJson).unwrap().runtimeType, DiscreteOccurences);
        expect(Schedule.fromJson(weeklyJson).unwrap().runtimeType, Weekly);
        expect(Schedule.fromJson(monthlyJson).unwrap().runtimeType , Monthly);
        expect(Schedule.fromJson(yearlyJson).unwrap().runtimeType, Yearly);
    });
  });
}

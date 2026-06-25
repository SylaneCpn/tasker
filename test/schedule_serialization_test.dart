import 'dart:convert';
import 'dart:io';

import 'package:tasker/mock/mock_schedule.dart';
import 'package:tasker/utils/unwrap_or_throw_extension.dart';
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
      final disOcc = mockDiscreteOccurences();
      final asJson = disOcc.toJson();
      final asJsonString = json.encode(asJson);
      final outputFile = await File(
       discretePath,
      ).create(recursive: true);
      await outputFile.writeAsString(asJsonString);
      final deserialized = DiscreteOccurences.fromJson(
        json.decode(await outputFile.readAsString()),
      ).unwrapOrThrow();
      expect(disOcc.occurences, deserialized.occurences);
    });

    test("Serialize then Deserialize Weekly", () async {
      final weekly = mockWeekly();
      final asJson = weekly.toJson();
      final asJsonString = json.encode(asJson);
      final outputFile = await File(
        weeklyPath,
      ).create(recursive: true);
      await outputFile.writeAsString(asJsonString);
      final _ = Weekly.fromJson(
        json.decode(await outputFile.readAsString()),
      ).unwrapOrThrow();


    });

    test("Serialize then Deserialize Monthly", () async {
      final monthly = mockMonthly();
      final asJson = monthly.toJson();
      final asJsonString = json.encode(asJson);
      final outputFile = await File(
        monthlyPath,
      ).create(recursive: true);
      await outputFile.writeAsString(asJsonString);
      final _ = Monthly.fromJson(
        json.decode(await outputFile.readAsString()),
      ).unwrapOrThrow();
    });

    test("Serialize then Deserialize Yearly", () async {
      final yearly = mockYearly();
      final asJson = yearly.toJson();
      final asJsonString = json.encode(asJson);
      final outputFile = await File(
        yearlyPath,
      ).create(recursive: true);
      await outputFile.writeAsString(asJsonString);
      final _ = Yearly.fromJson(
        json.decode(await outputFile.readAsString()),
      ).unwrapOrThrow();
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

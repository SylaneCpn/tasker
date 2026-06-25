import 'package:result/result.dart';
import 'package:tasker/data/task_instance.dart';
import 'package:tasker/meta/deserializable.dart';

import 'package:tasker/utils/json_serializable.dart';
import 'package:tasker/utils/unwrap_or_throw_extension.dart';


@deserializable
class DailyTasksStatus with JsonSerializable {
  

  final DateTime date;
  final Map<int, List<TaskInstance>> done;

  

  DailyTasksStatus({required this.date, required this.done});
  DailyTasksStatus.newDay(this.date) : done = {};
  factory DailyTasksStatus.newToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DailyTasksStatus.newDay(today);
  }

  static Result<DailyTasksStatus, FormatException> fromJson(
    Map<String, Object?> json,
  ) {
    try {
      final date = DateTime.parse(json["date"] as String);
      final rawDoneMap = json["done"] as Map<String, Object?>;
      final done = <int, List<TaskInstance>>{};
      for (final doneEntry in rawDoneMap.entries) {
        final taskId = int.parse(doneEntry.key);
        final instances = (doneEntry.value as List)
            .map(
              (inst) => TaskInstance.parse(inst).unwrapOrThrow(),
            )
            .toList();
        done[taskId] = instances;
      }
      return Ok(DailyTasksStatus(date: date, done: done));
    } on Exception catch (e) {
      return Err(
        FormatException(
          "Could not parse DailyTasksStatus from $json because $e",
        ),
      );
    }
  }

  @override
  Map<String, Object?> toJson() {
    final asJson = <String, Object?>{};
    asJson["date"] = date.toString();
    final doneStringMap = <String, Object?>{};
    for (final doneEntry in done.entries) {
      final taskId = doneEntry.key.toString();
      final instancesAsString = doneEntry.value
          .map((ins) => ins.serialize())
          .toList();
      doneStringMap[taskId] = instancesAsString;
    }

    asJson["done"] = doneStringMap;
    return asJson;
  }
}

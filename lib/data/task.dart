import 'package:result/result.dart';
import 'package:tasker/data/schedule.dart';
import 'package:tasker/meta/serializable.dart';
import 'package:tasker/utils/json_serializable.dart';
import 'package:tasker/utils/unwrap_or_throw_extension.dart';

@serializable
class Task with JsonSerializable {
  String label;
  String description;
  Schedule schedule;

  Task({
    required this.label,
    required this.description,
    required this.schedule,
  });

  static Result<Task, FormatException> fromJson(Map<String, Object?> json) {
    try {
      final label = json["label"] as String;
      final description = json["description"] as String;
      final schedule = Schedule.fromJson(
        json["schedule"] as Map<String, Object?>,
      ).unwrapOrThrow();
      return Ok(
        Task(label: label, description: description, schedule: schedule),
      );
    } on Exception catch (e) {
      return Err(FormatException("Could not parse Task from $json because $e"));
    }
  }

  @override
  Map<String, Object?> toJson() {
    final asJson = <String, Object?>{};
    asJson["label"] = label;
    asJson["description"] = description;
    asJson["schedule"] = schedule.toJson();
    return asJson;
  }
}

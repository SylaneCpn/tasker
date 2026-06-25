import 'package:result/result.dart';
import 'package:tasker/data/schedule.dart';
import 'package:tasker/meta/deserializable.dart';
import 'package:tasker/utils/json_serializable.dart';
import 'package:tasker/utils/unwrap_or_throw_extension.dart';

@deserializable
class Task with JsonSerializable {
  final int id;
  bool notifies;
  String label;
  String description;
  Schedule schedule;

  Task({
    required this.id,
    required this.notifies,
    required this.label,
    required this.description,
    required this.schedule,
  });

  static Result<Task, FormatException> fromJson(Map<String, Object?> json) {
    try {
      final label = json["label"] as String;
      final description = json["description"] as String;
      final id = json["id"] as int;
      final notifies = json["notifies"] as bool;
      final schedule = Schedule.fromJson(
        json["schedule"] as Map<String, Object?>,
      ).unwrapOrThrow();
      return Ok(
        Task(id : id, notifies: notifies, label: label, description: description, schedule: schedule),
      );
    } on Exception catch (e) {
      return Err(FormatException("Could not parse Task from $json because $e"));
    }
  }

  @override
  bool operator ==(Object other) => other is Task && id == other.id;
    

  @override
  Map<String, Object?> toJson() {
    final asJson = <String, Object?>{};
    asJson["id"] = id;
    asJson["notifies"] = notifies;
    asJson["label"] = label;
    asJson["description"] = description;
    asJson["schedule"] = schedule.toJson();
    return asJson;
  }
  
  @override
  int get hashCode => id;
  
}

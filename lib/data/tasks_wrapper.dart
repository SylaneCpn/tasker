import 'package:result/result.dart';
import 'package:tasker/data/task.dart';
import 'package:tasker/meta/serializable.dart';
import 'package:tasker/utils/json_serializable.dart';
import 'package:tasker/utils/unwrap_or_throw_extension.dart';

@serializable
class TasksWrapper with JsonSerializable {
  final List<Task> tasks;

  TasksWrapper(this.tasks);
  TasksWrapper.empty() : this(List.empty());

  static Result<TasksWrapper, FormatException> fromJson(
    Map<String, Object?> json,
  ) {
    try {
      final rawTasks = json["tasks"] as List;
      final tasks = rawTasks
          .map((t) => Task.fromJson(t).unwrapOrThrow())
          .toList();
      return Ok(TasksWrapper(tasks));
    } on Exception catch (e) {
      return Err(
        FormatException("Could not parse TasksWrapper from $json because $e"),
      );
    }
  }

  @override
  Map<String, Object?> toJson() {
    final asJson = <String, Object?>{};
    final parsedTasks = tasks.map((t) => t.toJson()).toList();

    asJson["tasks"] = parsedTasks;
    return asJson;
  }
}

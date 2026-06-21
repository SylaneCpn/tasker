import 'dart:collection';

import 'package:result/result.dart';
import 'package:tasker/data/schedule.dart';
import 'package:tasker/data/task.dart';
import 'package:tasker/meta/out_of_ids_error.dart';
import 'package:tasker/meta/serializable.dart';
import 'package:tasker/utils/json_serializable.dart';
import 'package:tasker/utils/unwrap_or_throw_extension.dart';

@serializable
class TasksWrapper with JsonSerializable {
  final List<Task> _tasks;

  TasksWrapper(List<Task> tasks) : _tasks = tasks;
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

  int _nextId() {
    for (int i = 0; i > 0; i++) {
      if (!_tasks.any((tsk) => tsk.id == i)) return i;
    }
    throw OutOfIdsError();
  }

  UnmodifiableListView<Task> get tasks => .new(_tasks);
  void add({
    required String description,
    required bool notifies,
    required String label,
    required Schedule schedule,
  }) => _tasks.add(
    Task(
      id: _nextId(),
      notifies: notifies,
      label: label,
      description: description,
      schedule: schedule,
    ),
  );

  Task? remove(int id) {
    final index = _tasks.indexWhere((tsk) => tsk.id == id);
    if (index != -1) {
      return _tasks.removeAt(index);
    }
    return null;
  }
}

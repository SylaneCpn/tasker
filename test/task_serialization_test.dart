import 'dart:convert';
import 'dart:io';

import 'package:tasker/data/daily_tasks_status.dart';
import 'package:tasker/data/task.dart';
import 'package:tasker/data/tasks_wrapper.dart';
import 'package:tasker/extensions/unwrap_or_throw_extension.dart';
import 'package:tasker/mock/mock_schedule.dart';
import 'package:test/test.dart';

const pathPrefix = "test_ressources/task";
const prettyJsonEncoder = JsonEncoder.withIndent(" ");

void main() {
  group("Serialize Task", () {
    test("Serialize simple Task", () async {
      final task = mockTaskWrapper().tasks.first;
      final asJson = task.toJson();
      final asJsonString = prettyJsonEncoder.convert(asJson);
      final outputFile = await File("$pathPrefix/task.json").create(recursive: true);
      await outputFile.writeAsString(asJsonString);

      final deserialized = Task.fromJson(json.decode(await outputFile.readAsString())).unwrapOrThrow();
      expect(task.id, deserialized.id);
    });
  });

  group("Serialize Task wrapper", (){
    test("Serialize Wrapper", () async {
      final wrapper = mockTaskWrapper();
      final asJson = wrapper.toJson();
      final asJsonString = prettyJsonEncoder.convert(asJson);
      final outputFile = await File("$pathPrefix/task_wrapper.json").create(recursive: true);
      await outputFile.writeAsString(asJsonString);

      final _ = TasksWrapper.fromJson(json.decode(await outputFile.readAsString())).unwrapOrThrow();
    });
  });

  group("Serialize Task status", (){
    test("Serialize status", () async {
      final dailyStatus = mockContext().dailyStatus;
      final asJson = dailyStatus.toJson();
      final asJsonString = prettyJsonEncoder.convert(asJson);
      final outputFile = await File("$pathPrefix/task_context.json").create(recursive: true);
      await outputFile.writeAsString(asJsonString);

      final _ = DailyTasksStatus.fromJson(json.decode(await outputFile.readAsString())).unwrapOrThrow();
    });
  });
}
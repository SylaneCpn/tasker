import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart' as path_prov;
import 'package:result/result.dart';
import 'package:tasker/data/tasks_wrapper.dart';
import 'package:tasker/utils/unwrap_or_throw_extension.dart';

const appTaskWrapperPath = "data/persistance/tasks.json";

Future<Result<TasksWrapper, Exception>> getTasksfromAppDirectory() async {
  try {
    final appRessourceDirectory = await path_prov
        .getApplicationSupportDirectory();
    final filePath = "${appRessourceDirectory.path}/$appTaskWrapperPath";
    final dailyTasksStatusFile = await File(filePath).create(recursive: true);
    final content = await dailyTasksStatusFile.readAsString();
    // File was just created, no data
    if (content.isEmpty) {
      return Ok(TasksWrapper.empty());
    }
    final jsonContent = json.decode(content);
    final fileTasksContent = TasksWrapper.fromJson(jsonContent).unwrapOrThrow();

    return Ok(fileTasksContent);
  } on Exception catch (e) {
    return Err(
      Exception("Could not get DailyTasksStatus from app directory because $e"),
    );
  }
}

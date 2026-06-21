import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart' as path_prov;
import 'package:result/result.dart';
import 'package:tasker/data/daily_tasks_status.dart';
import 'package:tasker/utils/date_time_extensions.dart';
import 'package:tasker/utils/unwrap_or_throw_extension.dart';


const appDailyStatusPath = "data/persistance/daily_status.json";

Future<Result<DailyTasksStatus, Exception>>
  getDailyTaskStatusfromAppDirectory() async {
    try {
      final appRessourceDirectory = await path_prov
          .getApplicationSupportDirectory();
      final filePath = "${appRessourceDirectory.path}/$appDailyStatusPath";
      final dailyTasksStatusFile = await File(filePath).create(recursive: true);
      final content = await dailyTasksStatusFile.readAsString();
      // File was just created, no data
      if (content.isEmpty) {
        return Ok(DailyTasksStatus.newToday());
      }
      final jsonContent = json.decode(content);
      final fileDailyContent = DailyTasksStatus.fromJson(
        jsonContent,
      ).unwrapOrThrow();

      // It's the same day, provide it to the user
      if (fileDailyContent.date.isToday()) {
        return Ok(fileDailyContent);
      }
      //Otherwise it's no longer relevant
      return Ok(DailyTasksStatus.newToday());
    } on Exception catch (e) {
      return Err(
        Exception(
          "Could not get DailyTasksStatus from app directory because $e",
        ),
      );
    }
  }

  Future<Result<(), Exception>> storeDailyTaskStatusToAppDirectory(DailyTasksStatus status) async {

    try {
      final appRessourceDirectory = await path_prov
          .getApplicationSupportDirectory();
      final filePath = "${appRessourceDirectory.path}/$appDailyStatusPath";
      final statusAsJson = status.toJson();
      final statusAsString = json.encode(statusAsJson);
      // Prevent error when called just before closing the app
      File(filePath).writeAsStringSync(statusAsString);
      return Ok(());
    }

    on Exception catch(e) {
      return Err(Exception("Could not store DailyTaskStatus to app directory because $e"));
    }

  }
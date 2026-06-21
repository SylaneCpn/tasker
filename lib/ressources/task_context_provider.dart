import 'package:result/result.dart';
import 'package:tasker/data/daily_tasks_status.dart';
import 'package:tasker/data/task_context.dart';
import 'package:tasker/data/tasks_wrapper.dart';
import 'package:tasker/ressources/daily_task_status_provider.dart';
import 'package:tasker/ressources/tasks_provider.dart';
import 'package:tasker/utils/unwrap_or_throw_extension.dart';

Future<Result<TaskContext, Exception>> getTaskContextFromAppDirectory() async {
  try {
    final tasksWrapper = (await getTasksfromAppDirectory()).unwrapOr(
      TasksWrapper.empty(),
    );
    final dailyStatus = (await getDailyTaskStatusfromAppDirectory()).unwrapOr(
      DailyTasksStatus.newToday(),
    );
    return Ok(
      TaskContext(dailyStatus: dailyStatus, tasksWrapper: tasksWrapper),
    );
  } on Exception catch (e) {
    return Err(
      Exception("Could not get TaskContext from app directory because $e"),
    );
  }
}

Future<Result<(), Exception>> storeTaskContextToAppDirectory(
  TaskContext context,
) async {
  try {
    final dailyTaskStatus = context.dailyStatus;
    final tasksWrapper = context.tasksWrapper;

    (await storeDailyTaskStatusToAppDirectory(dailyTaskStatus)).unwrapOrThrow();
    (await storeTaskWrapperToAppDirectory(tasksWrapper)).unwrapOrThrow();
    return Ok(());

    
  } on Exception catch (e) {
    return Err(
      Exception("Could not store TaskContext to app directory because $e"),
    );
  }
}

import 'package:result/result.dart';
import 'package:tasker/data/daily_tasks_status.dart';
import 'package:tasker/data/task_context.dart';
import 'package:tasker/data/tasks_wrapper.dart';
import 'package:tasker/ressources/daily_task_status_provider.dart';
import 'package:tasker/ressources/tasks_provider.dart';

Future<Result<TaskContext, Exception>> getTaskContextFromAppDirectory() async {
  try {
    final tasksWrapper = (await getTasksfromAppDirectory()).unwrapOr(TasksWrapper.empty());
    final dailyStatus = (await getDailyTaskStatusfromAppDirectory()).unwrapOr(DailyTasksStatus.newToday());
    return Ok(
      TaskContext(dailyStatus: dailyStatus, tasksWrapper: tasksWrapper),
    );
  } on Exception catch (e) {
    return Err(
      Exception("Could not get TaskContext from app directory because $e"),
    );
  }
}


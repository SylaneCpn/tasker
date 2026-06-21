import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/data/daily_tasks_status.dart';
import 'package:tasker/data/task.dart';
import 'package:tasker/data/task_context.dart';
import 'package:tasker/languages/langage_text_provider.dart';

class DailyTasksWidget extends StatelessWidget {
  const DailyTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final langTextProv = context.watch<LangageTextProvider>();
    final taskContext = context.watch<TaskContext>();
    return Column(
      children: [
        Align(
          alignment: .centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              langTextProv.taskLabel,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
        DailyTasksWidgetsView(taskContext: taskContext),
      ],
    );
  }
}

class DailyTasksWidgetsView extends StatelessWidget {
  final TaskContext taskContext;
  const DailyTasksWidgetsView({super.key, required this.taskContext});

  @override
  Widget build(BuildContext context) {
    final dailyStatus = taskContext.dailyStatus;
    final taskWrapper = taskContext.tasksWrapper;
    final dailyTasks = taskWrapper.tasks.where((tsk) => tsk.schedule.isToday());

    if (dailyTasks.isNotEmpty) {
      return Column(
        children: dailyTasks
            .map((dt) => DailyTaskView(task: dt, status: dailyStatus))
            .toList(),
      );
    } else {
      return const EmptyDailyTasksWidget();
    }
  }
}

class DailyTaskView extends StatelessWidget {
  final Task task;
  final DailyTasksStatus status;
  const DailyTaskView({super.key, required this.task, required this.status});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class EmptyDailyTasksWidget extends StatelessWidget {
  const EmptyDailyTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final langTextProv = context.watch<LangageTextProvider>();
    final Size( height : viewH , width : viewW ) = MediaQuery.sizeOf(context);
    return SizedBox(
      height: viewH * 0.65,
      width: viewW * 0.75,
      child: Center(
        child: Text(
          langTextProv.emptyDailyTask,
          textAlign: .center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

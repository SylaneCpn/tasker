import 'package:flutter/material.dart';
import 'package:tasker/data/task_context.dart';
import 'package:tasker/widgets/views/main_page/daily_tasks_widget/daily_tasks_list_layout_mode.dart';
import 'package:tasker/widgets/views/main_page/daily_tasks_widget/daily_tasks_content/daily_tasks_list.dart';
import 'package:tasker/widgets/views/main_page/daily_tasks_widget/daily_tasks_content/empty_daily_tasks_widget.dart';

class DailyTasksContent extends StatelessWidget {
  final DailyTasksListLayoutMode layout;
  final TaskContext taskContext;
  const DailyTasksContent({
    super.key,
    required this.taskContext,
    required this.layout,
  });

  @override
  Widget build(BuildContext context) {
    final dailyStatus = taskContext.dailyStatus;
    final taskWrapper = taskContext.tasksWrapper;

    final sortedDailyTasks = taskWrapper.tasks
        .where((tsk) => tsk.schedule.isToday())
        .toList()..sort(
      (a, b) => a.schedule.firstInstanceToday()!.start.compareTo(
        b.schedule.firstInstanceToday()!.start,
      ),
    );

    if (sortedDailyTasks.isNotEmpty) {
      return DailyTasksList(
        dailyTasks: sortedDailyTasks,
        status: dailyStatus,
        layout: layout,
      );
    } else {
      return const EmptyDailyTasksWidget();
    }
  }
}

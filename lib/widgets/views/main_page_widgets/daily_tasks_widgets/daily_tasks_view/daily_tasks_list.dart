import 'package:flutter/material.dart';
import 'package:tasker/data/daily_tasks_status.dart';
import 'package:tasker/data/task.dart';
import 'package:tasker/style/theme.dart';
import 'package:tasker/widgets/views/main_page_widgets/daily_tasks_widgets/daily_task_list_layout_mode.dart';
import 'package:tasker/widgets/views/main_page_widgets/daily_tasks_widgets/daily_tasks_view/daily_tasks_list/daily_task_card.dart';
import 'package:tasker/widgets/views/main_page_widgets/daily_tasks_widgets/daily_tasks_view/daily_tasks_list/done_last_tasks_list.dart';

class DailyTasksList extends StatelessWidget {
  final List<Task> dailyTasks;
  final DailyTasksStatus status;
  final DailyTaskListLayoutMode layout;

  const DailyTasksList({
    super.key,
    required this.dailyTasks,
    required this.status,
    required this.layout,
  });

  

  @override
  Widget build(BuildContext context) {

    return switch (layout) {
      .chronologicalOrder => Padding(
        padding: sectionPadding,
        child: Column(
          children: dailyTasks
              .map((dt) => DailyTaskCard(task: dt, status: status))
              .toList(),
        ),
      ),
      .doneLast => DoneLastTasksList(
        dailyTasks: dailyTasks,
        status: status,
      ),
    };
  }
}
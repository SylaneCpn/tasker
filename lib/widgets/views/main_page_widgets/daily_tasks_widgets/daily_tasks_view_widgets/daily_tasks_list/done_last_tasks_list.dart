import 'package:flutter/material.dart';
import 'package:tasker/data/daily_tasks_status.dart';
import 'package:tasker/data/task.dart';
import 'package:tasker/style/theme.dart';
import 'package:tasker/utils/date_time_extensions.dart';
import 'package:tasker/widgets/views/main_page_widgets/daily_tasks_widgets/daily_tasks_view_widgets/daily_tasks_list/daily_tasks_list_section.dart';

class DoneLastTasksList  extends StatelessWidget{
  final DailyTasksStatus status;
  final List<Task> dailyTasks;
  const DoneLastTasksList({super.key, required this.dailyTasks, required this.status});

  @override
  Widget build(BuildContext context) {
    final occuringNowTasks = dailyTasks.where((t) => t.schedule.occuringNow());

    final incommingTasks = dailyTasks.where(
      (t) => t.schedule.next()?.start.isToday() ?? false,
    );

    final otherTasks = dailyTasks.where(
      (t) => !(t.schedule.next()?.start.isToday() ?? true),
    );
    return Column(
      children: [
        if (occuringNowTasks.isNotEmpty)
          Padding(
            padding: sectionPadding,
            child: DailyTasksListSection(taskList: occuringNowTasks, status: status),
          ),

        if (incommingTasks.isNotEmpty)
          Padding(
            padding: sectionPadding,
            child: DailyTasksListSection(taskList: incommingTasks, status: status),
          ),

        if (otherTasks.isNotEmpty)
          Padding(
            padding: sectionPadding,
            child: DailyTasksListSection(taskList: otherTasks, status: status),
          ),
      ],
    );
  }
}
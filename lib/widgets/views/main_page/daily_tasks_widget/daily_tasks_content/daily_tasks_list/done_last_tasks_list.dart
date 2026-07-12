import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/data/daily_tasks_status.dart';
import 'package:tasker/data/task.dart';
import 'package:tasker/extensions/date_time_extensions.dart';
import 'package:tasker/languages/language_text_provider.dart';
import 'package:tasker/style/theme.dart';
import 'package:tasker/widgets/views/main_page/daily_tasks_widget/daily_tasks_content/daily_tasks_list/daily_tasks_list_section.dart';

class DoneLastTasksList  extends StatelessWidget{
  final DailyTasksStatus status;
  final List<Task> dailyTasks;
  const DoneLastTasksList({super.key, required this.dailyTasks, required this.status});

  @override
  Widget build(BuildContext context) {
    final LanguageTextProvider langTextProv = context.watch();
    final occuringNowTasks = dailyTasks.where((t) => t.schedule.occuringNow());

    final incommingTasks = dailyTasks.where(
      (t) => (t.schedule.next()?.start.isToday() ?? false) && !t.schedule.occuringNow(),
    );

    final otherTasks = dailyTasks.where(
      (t) => !(t.schedule.next()?.start.isToday() ?? true) && !t.schedule.occuringNow(),
    );
    return Column(
      children: [
        if (occuringNowTasks.isNotEmpty)
          Padding(
            padding: sectionPadding,
            child: DailyTasksListSection(label: langTextProv.occuring, taskList: occuringNowTasks, status: status),
          ),

        if (incommingTasks.isNotEmpty)
          Padding(
            padding: sectionPadding,
            child: DailyTasksListSection(label : langTextProv.incomming , taskList: incommingTasks, status: status),
          ),

        if (otherTasks.isNotEmpty)
          Padding(
            padding: sectionPadding,
            child: DailyTasksListSection( label :langTextProv.done ,taskList: otherTasks, status: status),
          ),
      ],
    );
  }
}
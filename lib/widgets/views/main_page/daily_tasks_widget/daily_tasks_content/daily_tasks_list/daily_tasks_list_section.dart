import 'package:flutter/material.dart';

import 'package:tasker/data/daily_tasks_status.dart';
import 'package:tasker/data/task.dart';
import 'package:tasker/style/theme.dart';
import 'package:tasker/widgets/views/main_page/daily_tasks_widget/daily_tasks_content/daily_tasks_list/daily_task_card.dart';

class DailyTasksListSection extends StatelessWidget {
  final DailyTasksStatus status;
  final Iterable<Task> taskList;
  final String label;

  const DailyTasksListSection({super.key, required this.taskList, required this.status, required this.label});

  @override
  Widget build(BuildContext context) {
    final sectionStyle = Theme.of(context).textTheme.headlineSmall;
    return Column(
          spacing: mediumSpacing ,
              crossAxisAlignment: .stretch,
              children: [
                Align(
                  alignment: .centerLeft,
                  child: Padding(
                    padding: isolatePadding,
                    child: Text(label, style: sectionStyle),
                  ),
                ),
                ...taskList.map(
                  (t) => DailyTaskCard(task: t, status: status),
                ),
              ],
            );
  }

}
import 'package:flutter/material.dart';

import 'package:tasker/data/daily_tasks_status.dart';
import 'package:tasker/data/task.dart';
import 'package:tasker/style/theme.dart';
import 'package:tasker/widgets/views/main_page/daily_tasks_widget/daily_tasks_content/daily_tasks_list/daily_task_card.dart';

class DailyTasksListSection extends StatefulWidget {
  final DailyTasksStatus status;
  final Iterable<Task> taskList;
  final String label;

  const DailyTasksListSection({
    super.key,
    required this.taskList,
    required this.status,
    required this.label,
  });

  @override
  State<DailyTasksListSection> createState() => _DailyTasksListSectionState();
}

class _DailyTasksListSectionState extends State<DailyTasksListSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = .new(vsync: this, duration: Duration(milliseconds: 100));

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sectionStyle = Theme.of(context).textTheme.headlineSmall;
    return Column(
      spacing: cardSpacing,
      crossAxisAlignment: .stretch,
      children: [
        Align(
          alignment: .centerLeft,
          child: SizeTransition(
            sizeFactor: _controller ,
            child: Padding(
              padding: isolatePadding,
              child: Text(widget.label, style: sectionStyle),
            ),
          ),
        ),
        ...widget.taskList.map(
          (t) => DailyTaskCard(
            key: ValueKey(t.id),
            task: t,
            status: widget.status,
          ),
        ),
      ],
    );
  }
}

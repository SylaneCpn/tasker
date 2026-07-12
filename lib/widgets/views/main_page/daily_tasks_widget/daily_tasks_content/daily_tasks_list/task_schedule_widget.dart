import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/data/daily_tasks_status.dart';
import 'package:tasker/data/task.dart';
import 'package:tasker/data/task_context.dart';
import 'package:tasker/data/task_instance.dart';
import 'package:tasker/extensions/language_formating_extensions.dart';
import 'package:tasker/languages/language_text_provider.dart';
import 'package:tasker/style/theme.dart';
import 'package:tasker/widgets/common/accordion.dart';

class TaskScheduleWidget extends StatefulWidget {
  final DailyTasksStatus status;
  final Task task;
  const TaskScheduleWidget({
    super.key,
    required this.status,
    required this.task,
  });

  @override
  State<TaskScheduleWidget> createState() => _TaskScheduleWidgetState();
}

class _TaskScheduleWidgetState extends State<TaskScheduleWidget> {
  @override
  Widget build(BuildContext context) {
    final langTextProv = context.watch<LanguageTextProvider>();
    return Accordion(
        header: Text(
          langTextProv.instancesToday,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      bodyBuilder: (context, animation) {
        final sortedTodayInstances =
            widget.task.schedule.instancesToday().toList()
              ..sort((a, b) => a.start.compareTo(b.start));

        return Column(
          children: sortedTodayInstances
              .map(
                (instance) => _InstanceLabel(
                  instance: instance,
                  status: widget.status,
                  taskId: widget.task.id,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _InstanceLabel extends StatelessWidget {
  final TaskInstance instance;
  final DailyTasksStatus status;
  final int taskId;

  const _InstanceLabel({
    required this.instance,
    required this.status,
    required this.taskId,
  });

  void toggleDone(TaskContext context) {
    if (status.done[taskId]?.contains(instance) ?? false) {
      status.done[taskId]!.remove(instance);
    } else {
      //Create for id if doesn't exists
      status.done[taskId] ??= [];
      status.done[taskId]!.add(instance);
    }

    context.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    final LanguageTextProvider langTextProv = context.watch();
    final TaskContext taskContext = context.watch();

    final (dateFormat: _, :timeRangeFormat) = instance.formatedDate(
      langTextProv,
    );
    const padding = EdgeInsets.symmetric(horizontal: 35.0);
    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: lightSeparatorColor.withAlpha((255 * 0.8).toInt()),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              timeRangeFormat,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Padding(
              padding: isolatePadding,
              child: IconButton(
                onPressed: () => toggleDone(taskContext),
                color: (status.done[taskId]?.contains(instance) ?? false)
                    ? Colors.blue
                    : null,
                icon: Icon(Icons.check),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

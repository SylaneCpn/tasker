import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/data/daily_tasks_status.dart';
import 'package:tasker/data/task.dart';
import 'package:tasker/data/task_context.dart';
import 'package:tasker/data/task_instance.dart';
import 'package:tasker/languages/language_text_provider.dart';
import 'package:tasker/style/theme.dart';
import 'package:tasker/widgets/common/icon_toggle_button.dart';

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
  final ExpansibleController _controller = .new();

  @override
  Widget build(BuildContext context) {
    final langTextProv = context.watch<LanguageTextProvider>();
    return Expansible(
      controller: _controller,
      headerBuilder: (context, animation) => GestureDetector(
        behavior: .opaque,
        onTap: () => _controller.isExpanded
            ? _controller.collapse()
            : _controller.expand(),
        child: Padding(
          padding: sectionPadding,
          child: Row(
            children: [
              RotationTransition(
                turns: animation,
                child: Icon(Icons.expand_less),
              ),
              Text(
                langTextProv.instances,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
      bodyBuilder: (context, animation) => Column(
        children: widget.task.schedule
            .instancesToday()
            .map(
              (instance) => _InstanceLabel(
                instance: instance,
                status: widget.status,
                taskId: widget.task.id,
              ),
            )
            .toList(),
      ),
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
    }

    else {
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
    return Padding(
      padding: isolatePadding,
      child: Row(
        mainAxisAlignment: .spaceAround,
        children: [
          Text(timeRangeFormat, style: Theme.of(context).textTheme.titleSmall),
          Padding(
            padding: isolatePadding,
            child: IconToggleButton(
              toggleCallback: () => toggleDone(taskContext),
              borderRadius: defBorderRadius,
              activated: status.done[taskId]?.contains(instance) ?? false,
              size: Size.square(32.0),
              iconData: Icons.check,
            ),
          ),
        ],
      ),
    );
  }
}

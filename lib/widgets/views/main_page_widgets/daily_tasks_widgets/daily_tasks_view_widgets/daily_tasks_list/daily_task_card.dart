import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/data/daily_tasks_status.dart';
import 'package:tasker/data/instance_type.dart';
import 'package:tasker/data/task.dart';
import 'package:tasker/data/task_context.dart';
import 'package:tasker/languages/language_text_provider.dart';
import 'package:tasker/style/theme.dart';
import 'package:tasker/widgets/commons/elevated_container.dart';
import 'package:tasker/widgets/commons/icon_toggle_button.dart';

class DailyTaskCard extends StatelessWidget {
  final Task task;
  final DailyTasksStatus status;
  const DailyTaskCard({super.key, required this.task, required this.status});

  Color borderColor() => task.schedule.occuringNow()
      ? Color.fromRGBO(0, 255, 0, 1.0)
      : Colors.black;
  Color cardBackGroundColor() => task.schedule.occuringNow()
      ? Color.fromRGBO(0, 255, 0, 0.15)
      : Colors.white;

  bool get actiavated => task.notifies;

  void toggleTaskNotification(
    TaskContext taskContext,
    BuildContext buildContext,
    LanguageTextProvider langTextProv,
    Task task,
  ) {
    task.notifies = !task.notifies;
    taskContext.notifyListeners();
    ScaffoldMessenger.of(buildContext).showSnackBar(
      SnackBar(
        content: Text(
          "${task.notifies ? langTextProv.notificationActivated : langTextProv.notificationDeactivated} ${task.label}.",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskContext = context.watch<TaskContext>();
    final langTextProv = context.watch<LanguageTextProvider>();
    return ElevatedContainer(
      innerPadding: isolatePadding,
      borderRadius: defBorderRadius,
      decoration: BoxDecoration(
        color: cardBackGroundColor(),
        border: Border.all(color: borderColor(), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: mediumSpacing,
        children: [
          Text(
            task.label,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: .start,
          ),
          Text(
            task.description,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: .start,
          ),

          _InstanceTypeLabel(
            instanceType: InstanceType.fromSchedule(task.schedule),
          ),
          Align(
            alignment: .centerRight,
            child: IconToggleButton(
              toggleCallback: () => toggleTaskNotification(taskContext, context, langTextProv, task),
              activated: actiavated,
              borderRadius: defBorderRadius,
              size: Size.square(42.0),
              iconData: actiavated ? Icons.alarm_on : Icons.alarm_off,
            ),
          ),
        ],
      ),
    );
  }
}

class _InstanceTypeLabel extends StatelessWidget {
  final InstanceType instanceType;

  const _InstanceTypeLabel({required this.instanceType});

  @override
  Widget build(BuildContext context) {
    final langTextProv = context.watch<LanguageTextProvider>();
    final txtStyle = Theme.of(context).textTheme.bodyMedium;
    switch (instanceType) {
      case NowInstance(:final instance):
        final (:timeRangeFormat, :dateFormat) = instance.formatedDate(
          langTextProv,
        );
        return Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(langTextProv.nowInstance, style: txtStyle),
            Column(
              children: [
                Text(dateFormat, style: txtStyle),
                Text(timeRangeFormat, style: txtStyle),
              ],
            ),
          ],
        );

      case NextInstance(:final instance):
        final (:timeRangeFormat, :dateFormat) = instance.formatedDate(
          langTextProv,
        );
        return Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(langTextProv.nextInstance, style: txtStyle),
            Column(
              children: [
                Text(dateFormat, style: txtStyle),
                Text(timeRangeFormat, style: txtStyle),
              ],
            ),
          ],
        );
      case PrevInstance(:final instance):
        final (:timeRangeFormat, :dateFormat) = instance.formatedDate(
          langTextProv,
        );
        return Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(langTextProv.prevInstance, style: txtStyle),
            Column(
              children: [
                Text(dateFormat, style: txtStyle),
                Text(timeRangeFormat, style: txtStyle),
              ],
            ),
          ],
        );
      case NeverInstance():
        return Text(langTextProv.nowInstance, style: txtStyle);
    }
  }
}

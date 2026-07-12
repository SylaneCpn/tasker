import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/data/daily_tasks_status.dart';
import 'package:tasker/data/instance_type.dart';
import 'package:tasker/data/task.dart';
import 'package:tasker/data/task_context.dart';
import 'package:tasker/extensions/language_formating_extensions.dart';
import 'package:tasker/languages/language_text_provider.dart';
import 'package:tasker/style/theme.dart';
import 'package:tasker/widgets/common/elevated_container.dart';
import 'package:tasker/widgets/common/icon_toggle_button.dart';
import 'package:tasker/widgets/common/light_separator.dart';
import 'package:tasker/widgets/views/main_page/daily_tasks_widget/daily_tasks_content/daily_tasks_list/task_schedule_widget.dart';

class DailyTaskCard extends StatefulWidget {
  final Task task;
  final DailyTasksStatus status;
  const DailyTaskCard({super.key, required this.task, required this.status});

  @override
  State<DailyTaskCard> createState() => _DailyTaskCardState();
}

class _DailyTaskCardState extends State<DailyTaskCard> with SingleTickerProviderStateMixin {

  late final AnimationController _controller = .new(vsync: this , duration:  Duration(milliseconds: 400)) ;

  double _animationValue = 0.0;


  // For box color animation
  Color? lastColorBorder;
  Color? lastColorBackgroud;
  late Color currentColorBorder;
  late Color currentColorBackground;
  

  @override
  void initState() {
    super.initState();
    final (:borderColor, :cardBackGroundColor) = cardColors();

    currentColorBackground = cardBackGroundColor;
    currentColorBorder = borderColor;
    _controller.addListener(() {
      setState(() {
        _animationValue = _controller.value;
      });
      
    });
    _controller.forward();
    
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  void didUpdateWidget(covariant DailyTaskCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.reset();
    lastColorBackgroud = currentColorBackground;
    lastColorBorder = currentColorBorder;
    final (:borderColor, :cardBackGroundColor) = cardColors();

    currentColorBackground = cardBackGroundColor;
    currentColorBorder = borderColor;
    

    _controller.forward();
  }


  ({Color borderColor, Color cardBackGroundColor}) cardColors() {
    if (widget.status.allDoneForToday(widget.task)) {
      final color = Color.fromRGBO(66, 169, 111, 1);
      return (
        borderColor: color,
        cardBackGroundColor: color.withValues(alpha: 0.15),
      );
    }

    if (widget.task.schedule.occuringNow()) {
      final color = Color.fromRGBO(45, 45, 226, 1);
      return (
        borderColor: color,
        cardBackGroundColor: color.withValues(alpha: 0.15),
      );
    }
    //If there is still a task to be done and the last instance today has passed
    if (!(widget.task.schedule.next()?.isToday() ?? true)) {
      final color = Color.fromRGBO(221, 49, 49, 1);
      return (
        borderColor: color,
        cardBackGroundColor: color.withValues(alpha: 0.15),
      );
    }
    return (borderColor: Colors.black, cardBackGroundColor: shadedContainer);
  }

  bool get activated => widget.task.notifies;

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

    final borderColorTween = ColorTween(begin: lastColorBorder ?? currentColorBorder , end: currentColorBorder );
    final backgroundColorTween = ColorTween(begin: lastColorBackgroud ?? currentColorBackground , end : currentColorBackground);

    return ElevatedContainer(
      innerPadding: isolatePadding,
      borderRadius: defBorderRadius,
      decoration: BoxDecoration(
        color: backgroundColorTween.lerp(_animationValue) ?? currentColorBackground,
        border: Border.all(color: borderColorTween.lerp(_animationValue) ?? currentColorBorder, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: .start,
        spacing: mediumSpacing,
        children: [
          Text(
            widget.task.label,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: .start,
          ),

          Text(
            widget.task.description,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: .start,
          ),

          Text(
            langTextProv.scheduleType(widget.task.schedule),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: lightText),
            textAlign: .start,
          ),

          const LightSeparator(),

          _InstanceTypeLabel(
            instanceType: InstanceType.fromSchedule(widget.task.schedule),
          ),

          const LightSeparator(),

          TaskScheduleWidget(status: widget.status, task: widget.task,),
          Row(
            spacing: smallSpacing,
            mainAxisAlignment: .end,
            children: [
              IconToggleButton(
                toggleCallback: () => toggleTaskNotification(
                  taskContext,
                  context,
                  langTextProv,
                  widget.task,
                ),
                activated: activated,
                borderRadius: defBorderRadius,
                size: Size.square(42.0),
                iconData: activated ? Icons.alarm_on : Icons.alarm_off,
              ),
            ],
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
    final txtStyle = Theme.of(context).textTheme.titleSmall;
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

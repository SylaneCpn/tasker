import 'package:flutter/material.dart';
import 'package:tasker/data/schedule.dart';
import 'package:tasker/data/schedule_type.dart';
import 'package:tasker/data/task.dart';
import 'package:tasker/data/task_context.dart';
import 'package:tasker/languages/language_text_provider.dart';
import 'package:tasker/style/theme.dart';
import 'package:tasker/widgets/common/date_picker.dart';
import 'package:tasker/widgets/common/selectable_chip.dart';
import 'package:tasker/widgets/common/with_title.dart';

class AddTaskDialog extends StatefulWidget {
  final Task? baseTask;
  final LanguageTextProvider langTextProv;
  final TaskContext taskContext;

  const AddTaskDialog({
    super.key,
    this.baseTask,
    required this.langTextProv,
    required this.taskContext,
  });


  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final GlobalKey<FormState> _formKey = .new();
  final GlobalKey<_ScheduleBuilder> _scheduleBuilderKey = .new();

  late final TextEditingController _labelController = .new(
    text: widget.baseTask?.label,
  );
  late final TextEditingController _descriptionController = .new(
    text: widget.baseTask?.description,
  );

  ScheduleType scheduleType = .discreteOccurences;

  late bool beNotified = widget.baseTask?.notifies ?? true;

  void setScheduleType(ScheduleType type) {
    setState(() {
      scheduleType = type;
    });
  }

  void setBeNotified(bool notified) {
    setState(() {
      beNotified = notified;
    });
  }

  String? baseInputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return widget.langTextProv.emptyInputText;
    }
    return null;
  }

  void updateTaskContext(BuildContext context) {
    final schedule = _scheduleBuilderKey.currentState!.buildSchedule();
    if (_formKey.currentState!.validate() && schedule != null) {
      final wrapper = widget.taskContext.tasksWrapper;
      
      //Update the task
      if (widget.baseTask != null) {
        wrapper.update(
          widget.baseTask!.id,
          description: _descriptionController.text,
          notifies: beNotified,
          label: _labelController.text,
          schedule: schedule,
        );
      }
      // Create a new one
      else {
        wrapper.add(
          description: _descriptionController.text,
          notifies: beNotified,
          label: _labelController.text,
          schedule: schedule,
        );
      }

      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(widget.langTextProv.taskUpdated)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(8.0),
      scrollable: false,
      actions: [
        TextButton(
          onPressed: () => updateTaskContext(context),
          child: Text(widget.langTextProv.confirm),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.langTextProv.back),
        ),
      ],
      title: Text(widget.langTextProv.addTask),
      content: SizedBox(
        height: MediaQuery.heightOf(context) * 0.75,
        width: MediaQuery.widthOf(context) * 0.9,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              spacing: defaultSpacing,
              mainAxisSize: .min,
              children: [
                WithTitle(
                  title: widget.langTextProv.label,
                  child: TextFormField(
                    validator: baseInputValidator,
                    controller: _labelController,
                    decoration: InputDecoration(
                      focusColor: mainColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor),
                      ),
                    ),
                  ),
                ),
          
                WithTitle(
                  title: widget.langTextProv.description,
                  child: TextFormField(
                    controller: _descriptionController,
                    validator: baseInputValidator,
                    decoration: InputDecoration(
                      focusColor: mainColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: mainColor),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(widget.langTextProv.beNotified),
                    Switch(value: beNotified, onChanged: setBeNotified),
                  ],
                ),
          
                WithTitle(
                  title: widget.langTextProv.schedule,
                  child: Wrap(
                    runSpacing: smallSpacing,
                    spacing: smallSpacing,
                    children: ScheduleType.values
                        .map(
                          (type) => SelectableChip(
                            label: widget.langTextProv.scheduleTypeName(type),
                            isSelected: scheduleType == type,
                            onSelectCallback: () => setScheduleType(type),
                          ),
                        )
                        .toList(),
                  ),
                ),
          
                
          
                _ScheduleBuilderWidget(
                  langTextProv: widget.langTextProv,
                  scheduleBuilderKey: _scheduleBuilderKey,
                  scheduleType: scheduleType,
                  baseSchedule: widget.baseTask?.schedule,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

mixin _ScheduleBuilder<T extends StatefulWidget> on State<T> {
  Schedule? buildSchedule();
}

class _ScheduleBuilderWidget extends StatelessWidget {
  final LanguageTextProvider langTextProv;
  final GlobalKey<_ScheduleBuilder> scheduleBuilderKey;
  final ScheduleType scheduleType;
  final Schedule? baseSchedule;

  const _ScheduleBuilderWidget({
    required this.scheduleBuilderKey,
    required this.scheduleType, this.baseSchedule, required this.langTextProv,
  });

  @override
  Widget build(BuildContext context) {

    return switch (scheduleType) {
      ScheduleType.discreteOccurences => _DiscreteOccurencesBuilderWidget(
        key: scheduleBuilderKey,
        baseSchedule: baseSchedule is DiscreteOccurences ? baseSchedule as DiscreteOccurences : null, langTextProv: langTextProv,
      ),
      ScheduleType.weekly => _WeeklyBuilderWidget(key: scheduleBuilderKey, baseSchedule: baseSchedule is Weekly ? baseSchedule as Weekly : null,),
      ScheduleType.monthly => _MonthlyBuilderWidget(key: scheduleBuilderKey , baseSchedule: baseSchedule is Monthly ? baseSchedule as Monthly : null,),
      ScheduleType.yearly => _YearlyBuilderWidget(key: scheduleBuilderKey, baseSchedule: baseSchedule is Yearly ? baseSchedule as Yearly : null,),
    };
  }
}

class _DiscreteOccurencesBuilderWidget extends StatefulWidget {

  final DiscreteOccurences? baseSchedule;
  final LanguageTextProvider langTextProv;

  const _DiscreteOccurencesBuilderWidget({super.key, this.baseSchedule, required this.langTextProv});
  @override
  State<_DiscreteOccurencesBuilderWidget> createState() =>
      _DiscreteOccurencesBuilderWidgetState();
}

class _DiscreteOccurencesBuilderWidgetState
    extends State<_DiscreteOccurencesBuilderWidget>
    with _ScheduleBuilder {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Column(
      children: [
        DatePicker(langTextProv: widget.langTextProv,onDateSelected: (_) {})
      ],
    );
  }

  @override
  Schedule? buildSchedule() {
    // TODO: implement buildSchedule
    throw UnimplementedError();
  }
}

class _WeeklyBuilderWidget extends StatefulWidget {
  final Weekly? baseSchedule;
  const _WeeklyBuilderWidget({super.key, this.baseSchedule});

  @override
  State<_WeeklyBuilderWidget> createState() => _WeeklyBuilderWidgetState();
}

class _WeeklyBuilderWidgetState extends State<_WeeklyBuilderWidget>
    with _ScheduleBuilder {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }

  @override
  Schedule? buildSchedule() {
    // TODO: implement buildSchedule
    throw UnimplementedError();
  }
}

class _MonthlyBuilderWidget extends StatefulWidget {

  final Monthly? baseSchedule;
  const _MonthlyBuilderWidget({super.key, this.baseSchedule});

  @override
  State<_MonthlyBuilderWidget> createState() => _MonthlyBuilderWidgetState();
}

class _MonthlyBuilderWidgetState extends State<_MonthlyBuilderWidget>
    with _ScheduleBuilder {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }

  @override
  Schedule? buildSchedule() {
    // TODO: implement buildSchedule
    throw UnimplementedError();
  }
}

class _YearlyBuilderWidget extends StatefulWidget {

  final Yearly? baseSchedule;
  const _YearlyBuilderWidget({super.key, this.baseSchedule});

  @override
  State<_YearlyBuilderWidget> createState() => _YearlyBuilderWidgetState();
}

class _YearlyBuilderWidgetState extends State<_YearlyBuilderWidget>
    with _ScheduleBuilder {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }

  @override
  Schedule? buildSchedule() {
    // TODO: implement buildSchedule
    throw UnimplementedError();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/data/schedule.dart';
import 'package:tasker/data/schedule_type.dart';
import 'package:tasker/data/task.dart';
import 'package:tasker/data/task_context.dart';
import 'package:tasker/data/task_instance.dart';
import 'package:tasker/languages/language_text_provider.dart';
import 'package:tasker/style/theme.dart';
import 'package:tasker/widgets/common/date_picker.dart';
import 'package:tasker/widgets/common/selectable_chip.dart';
import 'package:tasker/widgets/common/time_of_day_range_picker.dart';
import 'package:tasker/widgets/common/with_title.dart';

class AddTaskDialog extends StatefulWidget {
  final Task? baseTask;
  final TaskContext taskContext;

  const AddTaskDialog({super.key, this.baseTask, required this.taskContext});

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

  String? baseInputValidator(String? value, LanguageTextProvider langTextProv) {
    if (value == null || value.isEmpty) {
      return langTextProv.emptyInputText;
    }
    return null;
  }

  void updateTaskContext(
    BuildContext context,
    LanguageTextProvider langTextProv,
  ) {
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
      ).showSnackBar(SnackBar(content: Text(langTextProv.taskUpdated)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final langTextProv = context.watch<LanguageTextProvider>();
    final sectionTitleStyle = Theme.of(context).textTheme.headlineSmall;
    return AlertDialog(
      insetPadding: EdgeInsets.all(8.0),
      scrollable: false,
      actions: [
        TextButton(
          onPressed: () => updateTaskContext(context, langTextProv),
          child: Text(langTextProv.confirm),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(langTextProv.back),
        ),
      ],
      title: Text(langTextProv.addTask),
      content: SizedBox(
        height: MediaQuery.heightOf(context) * 0.75,
        width: MediaQuery.widthOf(context) * 0.9,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              spacing: defaultSpacing,
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,

              children: [
                WithTitle(
                  title: langTextProv.label,
                  titleStyle: sectionTitleStyle,
                  child: TextFormField(
                    validator: (inp) => baseInputValidator(inp, langTextProv),
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
                  title: langTextProv.description,
                  titleStyle: sectionTitleStyle,
                  child: TextFormField(
                    controller: _descriptionController,
                    validator: (inp) => baseInputValidator(inp, langTextProv),
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
                    Text(
                      langTextProv.beNotified,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Switch(value: beNotified, onChanged: setBeNotified),
                  ],
                ),

                WithTitle(
                  title: langTextProv.schedule,
                  titleStyle: sectionTitleStyle,
                  child: Wrap(
                    runSpacing: smallSpacing,
                    spacing: smallSpacing,
                    children: ScheduleType.values
                        .map(
                          (type) => SelectableChip(
                            label: langTextProv.scheduleTypeName(type),
                            isSelected: scheduleType == type,
                            onSelectCallback: () => setScheduleType(type),
                          ),
                        )
                        .toList(),
                  ),
                ),

                Padding(
                  padding: smallPadding,
                  child: _ScheduleBuilderWidget(
                    scheduleBuilderKey: _scheduleBuilderKey,
                    scheduleType: scheduleType,
                    baseSchedule: widget.baseTask?.schedule,
                  ),
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
  final GlobalKey<_ScheduleBuilder> scheduleBuilderKey;
  final ScheduleType scheduleType;
  final Schedule? baseSchedule;

  const _ScheduleBuilderWidget({
    required this.scheduleBuilderKey,
    required this.scheduleType,
    this.baseSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return switch (scheduleType) {
      ScheduleType.discreteOccurences => _DiscreteOccurencesBuilderWidget(
        key: scheduleBuilderKey,
        baseSchedule: baseSchedule is DiscreteOccurences
            ? baseSchedule as DiscreteOccurences
            : null,
      ),
      ScheduleType.weekly => _WeeklyBuilderWidget(
        key: scheduleBuilderKey,
        baseSchedule: baseSchedule is Weekly ? baseSchedule as Weekly : null,
      ),
      ScheduleType.monthly => _MonthlyBuilderWidget(
        key: scheduleBuilderKey,
        baseSchedule: baseSchedule is Monthly ? baseSchedule as Monthly : null,
      ),
      ScheduleType.yearly => _YearlyBuilderWidget(
        key: scheduleBuilderKey,
        baseSchedule: baseSchedule is Yearly ? baseSchedule as Yearly : null,
      ),
    };
  }
}

class _DiscreteOccurencesBuilderWidget extends StatefulWidget {
  final DiscreteOccurences? baseSchedule;

  const _DiscreteOccurencesBuilderWidget({super.key, this.baseSchedule});
  @override
  State<_DiscreteOccurencesBuilderWidget> createState() =>
      _DiscreteOccurencesBuilderWidgetState();
}

class _DiscreteOccurencesBuilderWidgetState
    extends State<_DiscreteOccurencesBuilderWidget>
    with _ScheduleBuilder {
  final GlobalKey<TimeOfDayRangePickerState> _timeOfDayPickerKey = .new();
  final GlobalKey<DatePickerState> _datePickerKey = .new();
  final Set<TaskInstance> _occurences = {};

  // TODO : Fix it to make it more robust.
  void addOccurence() {
    final date = _datePickerKey.currentState!.getDate();
    final range = _timeOfDayPickerKey.currentState!.getRange();

    // TODO : Add a visual indicator on the app saying it failed
    if (range == null) {
      print("Could not add occurence");
    } else {
      final duration = range.duration;
      final startDate = DateTime(
        date.year,
        date.month.monthOfYear(),
        date.day,
        range.start.hour,
        range.start.minute,
      );
      setState(() {
        _occurences.add(TaskInstance(start: startDate, duration: duration));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final now = DateTime.now();
    final langTextProv = context.watch<LanguageTextProvider>();
    final sectionTitleTheme = Theme.of(context).textTheme.titleLarge;
    return Column(
      crossAxisAlignment: .stretch,
      spacing: defaultSpacing,
      children: [
        // TODO : REMOVE FOR DEBUG PURPOSES
        ..._occurences.map((occ) => Text(occ.toString())),

        WithTitle(
          title: langTextProv.day,
          titleStyle: sectionTitleTheme,
          child: DatePicker(key: _datePickerKey),
        ),

        WithTitle(
          title: langTextProv.timeOfDay,
          child: TimeOfDayRangePicker(key: _timeOfDayPickerKey),
        ),
        // TODO : Fix label
        TextButton(onPressed: addOccurence, child: Text("Add")),
      ],
    );
  }

  @override
  Schedule? buildSchedule() {
    if (_occurences.isNotEmpty) {
      return DiscreteOccurences(occurences: _occurences.toSet());
    } else {
      return null;
    }
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

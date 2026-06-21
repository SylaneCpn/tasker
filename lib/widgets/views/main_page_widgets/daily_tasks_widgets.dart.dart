import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/data/task_context.dart';
import 'package:tasker/languages/langage_text_provider.dart';

class DailyTasksWidget extends StatelessWidget {
  const DailyTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final langTextProv = context.watch<LangageTextProvider>();
    final taskContext = context.watch<TaskContext>();
    return Column(
      children: [
        Align(
          alignment: .centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left : 12.0),
            child: Text(
              langTextProv.taskLabel,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
      ],
    );
  }
}

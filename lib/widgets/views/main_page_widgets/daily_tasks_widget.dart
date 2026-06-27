import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/data/task_context.dart';
import 'package:tasker/languages/langage_text_provider.dart';
import 'package:tasker/style/theme.dart';
import 'package:tasker/widgets/commons/elevated_container.dart';
import 'package:tasker/widgets/commons/toggle_button.dart';
import 'package:tasker/widgets/views/main_page_widgets/daily_tasks_widgets/daily_task_list_layout_mode.dart';
import 'package:tasker/widgets/views/main_page_widgets/daily_tasks_widgets/daily_tasks_view.dart';

class DailyTasksWidget extends StatefulWidget {
  const DailyTasksWidget({super.key});

  @override
  State<DailyTasksWidget> createState() => _DailyTasksWidgetState();
}

class _DailyTasksWidgetState extends State<DailyTasksWidget> {
  DailyTaskListLayoutMode layout = .chronologicalOrder;

  void toggleLayoutMode() => setState(
    () => layout = switch (layout) {
      .chronologicalOrder => .doneLast,
      .doneLast => .chronologicalOrder,
    },
  );

  @override
  Widget build(BuildContext context) {
    final langTextProv = context.watch<LangageTextProvider>();
    final taskContext = context.watch<TaskContext>();
    return Column(
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Padding(
              padding: isolatePadding,
              child: Text(
                langTextProv.taskLabel,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),

            Padding(
              padding: isolatePadding,
              child: ElevatedContainer(
                borderRadius: BorderRadius.circular(12.0),
                child: SizedBox(
                  width: 42.0,
                  height: 42.0,
                  child: ToggleButton(
                    toggleCallback: toggleLayoutMode,
                    activated: layout == .doneLast,
                    borderRadius: BorderRadius.circular(12.0),
                    child: Icon(Icons.sort),
                  ),
                ),
              ),
            ),
          ],
        ),
        DailyTasksView(taskContext: taskContext, layout: layout),
      ],
    );
  }
}


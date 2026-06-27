import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/data/task_context.dart';
import 'package:tasker/languages/language_text_provider.dart';
import 'package:tasker/style/theme.dart';
import 'package:tasker/widgets/common/icon_toggle_button.dart';
import 'package:tasker/widgets/views/main_page_widgets/daily_tasks_widgets/daily_tasks_list_layout_mode.dart';
import 'package:tasker/widgets/views/main_page_widgets/daily_tasks_widgets/daily_tasks_view.dart';

class DailyTasksWidget extends StatefulWidget {
  const DailyTasksWidget({super.key});

  @override
  State<DailyTasksWidget> createState() => _DailyTasksWidgetState();
}

class _DailyTasksWidgetState extends State<DailyTasksWidget> {
  DailyTasksListLayoutMode layout = .chronologicalOrder;

  void toggleLayoutMode() => setState(
    () => layout = switch (layout) {
      .chronologicalOrder => .doneLast,
      .doneLast => .chronologicalOrder,
    },
  );

  @override
  Widget build(BuildContext context) {
    final langTextProv = context.watch<LanguageTextProvider>();
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
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),

            Padding(
              padding: isolatePadding,
              child: IconToggleButton(
                size: Size.square(42.0),
                toggleCallback: toggleLayoutMode,
                activated: layout == .doneLast,
                borderRadius: defBorderRadius,
                iconData: Icons.sort,
              ),
            ),
          ],
        ),
        DailyTasksView(taskContext: taskContext, layout: layout),
      ],
    );
  }
}


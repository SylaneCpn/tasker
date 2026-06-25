import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/data/daily_tasks_status.dart';
import 'package:tasker/data/task.dart';
import 'package:tasker/data/task_context.dart';
import 'package:tasker/data/tasks_wrapper.dart';
import 'package:tasker/languages/langage_text_provider.dart';
import 'package:tasker/utils/date_time_extensions.dart';
import 'package:tasker/widgets/views/main_page_widgets/daily_task_list_layout_mode.dart';

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
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              langTextProv.taskLabel,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
        DailyTasksView(taskContext: taskContext),
      ],
    );
  }
}

class DailyTasksView extends StatelessWidget {
  final TaskContext taskContext;
  const DailyTasksView({super.key, required this.taskContext});

  @override
  Widget build(BuildContext context) {
    final dailyStatus = taskContext.dailyStatus;
    final taskWrapper = taskContext.tasksWrapper;
    final dailyTasks = taskWrapper.tasks.where((tsk) => tsk.schedule.isToday());

    if (dailyTasks.isNotEmpty) {
      return DailyTasksList(dailyTasks: dailyTasks, status: dailyStatus);
    } else {
      return const EmptyDailyTasksWidget();
    }
  }
}

class DailyTasksList extends StatefulWidget {
  final Iterable<Task> dailyTasks;
  final DailyTasksStatus status;

  const DailyTasksList({
    super.key,
    required this.dailyTasks,
    required this.status,
  });

  @override
  State<DailyTasksList> createState() => _DailyTasksListState();
}

class _DailyTasksListState extends State<DailyTasksList> {
  DailyTaskListLayoutMode layout = .chronologicalOrder;

  void toggleLayoutMode() => setState(
    () => layout = switch (layout) {
      .chronologicalOrder => .doneLast,
      .doneLast => .chronologicalOrder,
    },
  );

  @override
  Widget build(BuildContext context) {
    // Garanted because it was filtered by parent
    final orderd = widget.dailyTasks.toList()
      ..sort(
        (a, b) => a.schedule.firstInstanceToday()!.start.compareTo(
          b.schedule.firstInstanceToday()!.start,
        ),
      );
      final langTextProv = context.watch<LangageTextProvider>();
      final sectionStyle = Theme.of(context).textTheme.headlineMedium;
    return Column(
      children: [
        Align(
          alignment: .centerRight,
          child: InkWell(
            onTap: toggleLayoutMode,
            child: Icon(
              Icons.sort,
              color: layout == .doneLast ? Colors.blue : Colors.grey,
            ),
          ),
        ),
        switch (layout) {
          .chronologicalOrder => Column(
            children: orderd
                .map((dt) => DailyTaskCard(task: dt, status: widget.status))
                .toList(),
          ),
          .doneLast => Column(
            children: [
              Column(
                children: [
                  Align(alignment: .centerLeft, child: Text(langTextProv.occuring, style: sectionStyle,)),
                  ...orderd.where((t) => t.schedule.occuringNow()).map((t) => DailyTaskCard(task: t, status: widget.status))
                ],
              ),

              Column(
                children: [
                  Align(alignment: .centerLeft, child: Text(langTextProv.incomming, style: sectionStyle,)),
                  ...orderd.where((t) => t.schedule.next()?.isToday() ?? false).map((t) => DailyTaskCard(task: t, status: widget.status))
                ],
              ),

              Column(
                children: [
                  Align(alignment: .centerLeft, child: Text(langTextProv.done, style: sectionStyle,)),
                  ...orderd.where((t) => !(t.schedule.next()?.isToday() ?? true)).map((t) => DailyTaskCard(task: t, status: widget.status))
                ],
              ),

            ],
          ),
        },
      ],
    );
  }
}

class DailyTaskCard extends StatelessWidget {
  final Task task;
  final DailyTasksStatus status;
  const DailyTaskCard({super.key, required this.task, required this.status});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class EmptyDailyTasksWidget extends StatelessWidget {
  const EmptyDailyTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final langTextProv = context.watch<LangageTextProvider>();
    final Size(height: viewH, width: viewW) = MediaQuery.sizeOf(context);
    return SizedBox(
      height: viewH * 0.65,
      width: viewW * 0.75,
      child: Center(
        child: Text(
          langTextProv.emptyDailyTask,
          textAlign: .center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tasker/data/daily_tasks_status.dart';
import 'package:tasker/data/task.dart';

class DailyTaskCard extends StatelessWidget {
  final Task task;
  final DailyTasksStatus status;
  const DailyTaskCard({super.key, required this.task, required this.status});

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
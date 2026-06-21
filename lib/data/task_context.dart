import 'package:flutter/material.dart';
import 'package:tasker/data/daily_tasks_status.dart';
import 'package:tasker/data/tasks_wrapper.dart';

class TaskContext with ChangeNotifier{
  final DailyTasksStatus dailyStatus;
  final TasksWrapper tasksWrapper;

  TaskContext({required this.dailyStatus , required this.tasksWrapper});
  TaskContext.newToday() : this(dailyStatus:  DailyTasksStatus.newToday() , tasksWrapper: TasksWrapper.empty());

  // Make the method public
  @override
  void notifyListeners() => super.notifyListeners();
}
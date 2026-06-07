import 'package:tasker/data/schedule.dart';

class Task {
  String label;
  String description;
  int iter;
  Schedule schedule;

  Task({required this.label , required this.description , required this.schedule, this.iter = 1});


}
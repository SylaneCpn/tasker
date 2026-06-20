import 'package:tasker/data/schedule.dart';
import 'package:tasker/meta/serializable.dart';

@serializable
class Task {
  String label;
  String description;
  Schedule schedule;

  Task({required this.label , required this.description , required this.schedule});


}
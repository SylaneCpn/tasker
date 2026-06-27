import 'package:tasker/data/schedule.dart';
import 'package:tasker/data/task_instance.dart';

sealed class InstanceType {

  const InstanceType();


  factory InstanceType.fromSchedule(Schedule schedule) {

    if (schedule.occuringNow()) {
      return NowInstance(schedule.nowInstance()!);
    }

    final next = schedule.next();
    if (next != null) return NextInstance(next);

    final prev = schedule.last();
    if (prev != null) return PrevInstance(prev);

    // Should not append but just in case
    return NeverInstance();

  }

}

class NowInstance extends InstanceType {
  final TaskInstance instance;

  NowInstance(this.instance);
}


class NextInstance extends InstanceType {
  final TaskInstance instance;

  NextInstance(this.instance);
}

class PrevInstance extends InstanceType {
  final TaskInstance instance;

  PrevInstance(this.instance);
}


class NeverInstance extends InstanceType {}

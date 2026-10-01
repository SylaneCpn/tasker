import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tasker/data/time_of_day_range.dart';
import 'package:tasker/style/theme.dart';
import 'package:tasker/widgets/common/time_of_day_picker.dart';

class TimeOfDayRangePicker extends StatefulWidget {
  const TimeOfDayRangePicker({super.key});

  @override
  State<TimeOfDayRangePicker> createState() => TimeOfDayRangePickerState();
}

class TimeOfDayRangePickerState extends State<TimeOfDayRangePicker> {
  final GlobalKey<TimeOfDayPickerState> _startKey = .new();
  final GlobalKey<TimeOfDayPickerState> _endKey = .new();

  TimeOfDayRange? getRange() {
    final start = _startKey.currentState!.getTimeOfDay();
    final end = _endKey.currentState!.getTimeOfDay();

    try {
      return TimeOfDayRange(start: start, end: end);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: smallSpacing,
      mainAxisAlignment: .center,
      children: [
        Expanded(
          child: SizedBox(
            height: MediaQuery.heightOf(context) * 0.4,
            child: TimeOfDayPicker(key: _startKey),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: MediaQuery.heightOf(context) * 0.4,
            child: TimeOfDayPicker(key: _endKey),
          ),
        ),
      ],
    );
  }
}

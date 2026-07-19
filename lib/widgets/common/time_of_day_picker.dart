import 'package:flutter/material.dart';
import 'package:tasker/style/theme.dart';

class TimeOfDayPicker extends StatefulWidget {
  final int? baseHour;
  final int? baseMinute;

  const TimeOfDayPicker({super.key, this.baseHour, this.baseMinute});

  @override
  State<TimeOfDayPicker> createState() => _TimeOfDayPickerState();
}

class _TimeOfDayPickerState extends State<TimeOfDayPicker> {
  late final _hourController = CarouselController(initialItem : widget.baseHour ?? 0);
  late final _minuteController = CarouselController(initialItem: widget.baseMinute ?? 0);




  @override
  Widget build(BuildContext context) {
    final itemsInView = 5;
    return LayoutBuilder(
      builder: (context , constraints) {
        final width = constraints.maxWidth * 0.4;
        final height = constraints.maxHeight;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(color: mainColor),
            color: backgroundColor
          ),
          child: Row(
            mainAxisAlignment: .center,
            children: [
              SizedBox(
                width: width,
                height: height,
                child: CarouselView(
                  controller: _hourController,
                  scrollDirection: .vertical,
                  itemExtent: height / itemsInView,
                  children: List.generate(
                    24,
                    (i) => FittedBox(child: Text(i.toString())),
                  ),
                ),
              ),
              SizedBox(
                width: width,
                height: height,
                child: CarouselView(
                  controller: _minuteController,
                  scrollDirection: .vertical,
                  itemExtent: height / itemsInView,
                  children: List.generate(
                    60,
                    (i) => FittedBox(child: Text(i.toString())),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

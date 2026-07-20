import 'package:flutter/material.dart';
import 'package:tasker/languages/language_text_provider.dart';
import 'package:tasker/style/theme.dart';

class TimeOfDayPicker extends StatefulWidget {
  final int? baseHour;
  final int? baseMinute;
  final LanguageTextProvider langTextProv;

  const TimeOfDayPicker({super.key, this.baseHour, this.baseMinute, required this.langTextProv});

  @override
  State<TimeOfDayPicker> createState() => _TimeOfDayPickerState();
}

class _TimeOfDayPickerState extends State<TimeOfDayPicker> {
  late final _hourController = CarouselController(
    initialItem: _leadingFromClicked(clickedElement: widget.baseHour ?? 0, itemCount: 24) ,
  );
  late final _minuteController = CarouselController(
    initialItem: _leadingFromClicked(clickedElement: widget.baseMinute ?? 0, itemCount: 60) ,
  );

  static const _itemsPerView = 5;

  late int _hourIndex = widget.baseHour ?? 0;
  late int _minuteIndex = widget.baseMinute ?? 0;

  static int _newIndexFromLeadingClicked({
    required int leadingElement,
    required int itemCount,
  }) => (leadingElement + _itemsPerView ~/ 2) % itemCount;

  static int _leadingFromClicked({
    required int clickedElement,
    required int itemCount,
  }) => (clickedElement - _itemsPerView ~/ 2) % itemCount;

  void _onMinuteChanged(int leadingElement) {
    setState(() {
      _minuteIndex = _newIndexFromLeadingClicked(
        leadingElement: leadingElement,
        itemCount: 60,
      );
    });
  }

  void _onHourChanged(int leadingElement) {
    setState(() {
      _hourIndex = _newIndexFromLeadingClicked(
        leadingElement: leadingElement,
        itemCount: 24,
      );
    });
  }

  // static void _animateToItem({
  //   required int itemClicked,
  //   required CarouselController controller,
  //   required int itemCount,
  // }) {
  //   controller.animateToItem(
  //     _leadingFromClicked(
  //       clickedElement: itemClicked,
  //       itemCount: itemCount,
  //     ),
  //   );
  // }

  // void _animateToMinute({required int itemClicked}) {
  //   _animateToItem(
  //     itemClicked: itemClicked,
  //     controller: _minuteController,
  //     itemCount: 60,
  //   );
  // }

  // void _animateToHour({required int itemClicked}) {
  //   _animateToItem(
  //     itemClicked: itemClicked,
  //     controller: _hourController,
  //     itemCount: 24,
  //   );
  // }

  TimeOfDay widgetTimeOfDay() =>
      TimeOfDay(hour: _hourIndex, minute: _minuteIndex);

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth * 0.4;
        final height = constraints.maxHeight;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(color: mainColor),
            color: backgroundColor,
          ),
          child: Row(
            mainAxisAlignment: .center,
            children: [
              Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: smallPadding,
                      child: FittedBox(child: Text(widget.langTextProv.hour)),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    height: height * 0.90,
                    child: CarouselView(
                      // Disabeled because animation can't go back 
                      // onTap: (value) => _animateToHour(
                      //   itemClicked: value,
                      // ),
                      itemSnapping: true,
                      onIndexChanged: (index) =>
                          _onHourChanged(index),
                      backgroundColor: backgroundColor,
                      infinite: true,
                      controller: _hourController,
                      scrollDirection: .vertical,
                      itemExtent: height / _itemsPerView,
                      children: List.generate(
                        24,
                        (i) => Padding(
                          padding: smallPadding,
                          child: FittedBox(
                            child: Text(
                              i.toString(),
                              style: TextStyle(
                                color: i != _hourIndex
                                    ? Colors.black.withAlpha(120)
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: smallPadding,
                      child: FittedBox(child: Text(widget.langTextProv.minute)),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    height: height * 0.90,
                    child: CarouselView(
                      // Disabeled because animation can't go back 
                      // onTap: (value) => _animateToMinute(
                      //   itemClicked: value,
                      // ),
                      itemSnapping: true,
                      onIndexChanged: (index) =>
                          _onMinuteChanged(index),
                      backgroundColor: backgroundColor,
                      infinite: true,
                      controller: _minuteController,
                      scrollDirection: .vertical,
                      itemExtent: height / _itemsPerView,
                      children: List.generate(
                        60,
                        (i) => Padding(
                          padding: smallPadding,
                          child: FittedBox(
                            child: Text(
                              i.toString(),
                              style: TextStyle(
                                color: i != _minuteIndex
                                    ? Colors.black.withAlpha(120)
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tasker/languages/language_text_provider.dart';
import 'package:tasker/widgets/common/time_of_day_picker.dart';

class TimeOfDayRangePicker extends StatelessWidget {
  final LanguageTextProvider langTextProv;
  const TimeOfDayRangePicker({super.key, required this.langTextProv});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      children: [
        Expanded(
          child: SizedBox(
            height: 400.0,
            // width: MediaQuery.widthOf(context) * 0.8,
            child: TimeOfDayPicker()),
        )
      ],
    );
  }
}

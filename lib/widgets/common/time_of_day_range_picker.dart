import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tasker/languages/language_text_provider.dart';
import 'package:tasker/style/theme.dart';
import 'package:tasker/widgets/common/time_of_day_picker.dart';

class TimeOfDayRangePicker extends StatelessWidget {
  final LanguageTextProvider langTextProv;
  const TimeOfDayRangePicker({super.key, required this.langTextProv});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: smallSpacing,
      mainAxisAlignment: .center,
      children: [
        Expanded(
          child: SizedBox(
            height: MediaQuery.heightOf(context) * 0.4,
            child: TimeOfDayPicker(langTextProv: langTextProv,)),
        ),
        Expanded(
          child: SizedBox(
            height: MediaQuery.heightOf(context) * 0.4,
            child: TimeOfDayPicker(langTextProv: langTextProv,)),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tasker/data/date.dart';
import 'package:tasker/data/month.dart';
import 'package:tasker/extensions/language_formating_extensions.dart';
import 'package:tasker/languages/language_text_provider.dart';
import 'package:tasker/style/theme.dart';
import 'package:tasker/widgets/common/labeled_box.dart';
import 'package:tasker/widgets/common/segmented_buttons.dart';

class DatePicker extends StatefulWidget {
  final LanguageTextProvider langTextProv;
  final Date? baseDate;
  final void Function(Date)? onDateSelected;

  const DatePicker({
    super.key,
    this.onDateSelected,
    this.baseDate,
    required this.langTextProv,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late Date currentDate = widget.baseDate ?? Date.now();
  _DateSelectorField selectorField = .day;

  static List<String> _labels(LanguageTextProvider langTextProv) => [
    langTextProv.day,
    langTextProv.month,
    langTextProv.year,
  ];

  void setIndex(int idx) => setState(() {
    selectorField = _DateSelectorField.values[idx];
  });

  void setDate({int? day, Month? month, int? year}) {
    setState(() {
      currentDate = currentDate.copyWith(day: day, month: month, year: year);
    });
    widget.onDateSelected?.call(currentDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultSpacing),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: mainColor),
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        mainAxisSize: .min,
        spacing: mediumSpacing,
        children: [
          Text(widget.langTextProv.formatedDate(currentDate)),

          Align(
            alignment: .center,
            child: SegmentedButtons(
              labels: _labels(widget.langTextProv),
              selectedIndex: selectorField.index,
              onIndexSelected: setIndex,
            ),
          ),
          Padding(
            padding: EdgeInsetsGeometry.zero,
            child: switch (selectorField) {
              _DateSelectorField.day => _DaySelector(
                selectedDay: currentDate.day,
                currentMonth: currentDate.month,
                currentYear: currentDate.year,
                onSelectedDay: (selectedDay) => setDate(day: selectedDay),
              ),
              _DateSelectorField.month => _MonthSelector(
                currentDay: currentDate.day,
                selectedMonth: currentDate.month,
                currentYear: currentDate.year,
                langTextProv: widget.langTextProv,
                onSelectedMonth: (selectedMonth) =>
                    setDate(month: selectedMonth),
              ),
              _DateSelectorField.year => _YearSelector(
                currentDay: currentDate.day,
                currentMonth: currentDate.month,
                selectedYear: currentDate.year,
                onSelectedYear: (selectedYear) => setDate(year: selectedYear),
              ),
            },
          ),
        ],
      ),
    );
  }
}

class _DaySelector extends StatelessWidget {
  final int selectedDay;
  final Month currentMonth;
  final int currentYear;

  final void Function(int)? onSelectedDay;

  const _DaySelector({
    required this.selectedDay,
    required this.currentMonth,
    required this.currentYear,
    this.onSelectedDay,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.heightOf(context) * 0.4,
      child: GridView.count(
        crossAxisCount: 5,
        shrinkWrap: true,
        mainAxisSpacing: smallSpacing,
        crossAxisSpacing: smallSpacing,
        children: List.generate(
          currentMonth.numberOfDays(currentYear),
          (i) => LabeledBox(
            isDeactivated: Date(
              day: i + 1,
              month: currentMonth,
              year: currentYear,
            ).hasPassed(),
            label: (i + 1).toString(),
            isSelected: selectedDay == (i + 1),
            onSelectCallback: () => onSelectedDay?.call(i + 1),
          ),
        ),
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  final int currentDay;
  final Month selectedMonth;
  final int currentYear;
  final LanguageTextProvider langTextProv;

  final void Function(Month)? onSelectedMonth;

  const _MonthSelector({
    required this.currentDay,
    required this.selectedMonth,
    required this.currentYear,
    this.onSelectedMonth,
    required this.langTextProv,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.heightOf(context) * 0.4,
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        mainAxisSpacing: smallSpacing,
        crossAxisSpacing: smallSpacing,
        children: Month.values
            .map(
              (m) => LabeledBox(
                isDeactivated: Date.hasPassedOrInvalid(
                  day: currentDay,
                  month: m,
                  year: currentYear,
                ),
                label: m.asLangName(langTextProv),
                isSelected: selectedMonth == m,
                onSelectCallback: () => onSelectedMonth?.call(m),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _YearSelector extends StatelessWidget {
  final int currentDay;
  final Month currentMonth;
  final int selectedYear;

  final void Function(int)? onSelectedYear;

  const _YearSelector({
    required this.currentDay,
    required this.currentMonth,
    required this.selectedYear,
    this.onSelectedYear,
  });

  @override
  Widget build(BuildContext context) {
    final nowYear = DateTime.now().year;
    return SizedBox(
      height: MediaQuery.heightOf(context) * 0.4,
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        mainAxisSpacing: smallSpacing,
        crossAxisSpacing: smallSpacing,
        children: List.generate(
          200,
          (i) => LabeledBox(
            isDeactivated: Date.hasPassedOrInvalid(
              day: currentDay,
              month: currentMonth,
              year: i + nowYear,
            ),
            label: (i + nowYear).toString(),
            isSelected: selectedYear == (i + nowYear),
            onSelectCallback: () => onSelectedYear?.call(i + nowYear),
          ),
        ),
      ),
    );
  }
}

enum _DateSelectorField { day, month, year }

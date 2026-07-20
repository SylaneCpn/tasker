import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tasker/data/date.dart';
import 'package:tasker/data/month.dart';
import 'package:tasker/data/schedule.dart';
import 'package:tasker/data/schedule_type.dart';
import 'package:tasker/extensions/language_formating_extensions.dart';
import 'package:tasker/extensions/pad_for_clock.dart';

class LanguageTextProvider with ChangeNotifier {
  static const defaultLocale = Locale("en");
  static const nameSpace = "lang";
  static const filePrefix = "textes";

  Locale _locale;
  Map<String, String?>? _textes;

  UnmodifiableMapView<String, String?> get rawTextes => .new(_textes ?? {});

  LanguageTextProvider._(this._locale);

  factory LanguageTextProvider({Locale? locale}) {
    final loc =
        locale ??
        Locale(
          Platform.localeName.split("_").firstOrNull?.toLowerCase() ??
              defaultLocale.languageCode,
        );
    final instance = LanguageTextProvider._(loc);

    _fetchLabelsFromDev(loc).then((map) {
      instance._textes = map;
      instance._notifyListeners();
    });

    return instance;
  }

  static String parseAssetPath(Locale locale) {
    final loc = locale.languageCode;
    return "assets/$nameSpace/${filePrefix}_$loc.json";
  }

  static Future<Map<String, String?>> _fetchLabelsFromDev(Locale locale) async {
    try {
      final bytes = await rootBundle.load(parseAssetPath(locale));
      final Map<String, Object?> asJson = json.decode(
        utf8.decode(Uint8List.sublistView(bytes)),
      );
      return asJson.cast();
    } on Exception {
      // print(e);
      return {};
    }
  }

  String? _txt(String key) => _textes?[key];

  void _notifyListeners() => notifyListeners();

  Locale get currentLocale => _locale;
  String get homeLabel => _txt("homeLabel") ?? "Home";
  String get taskLabel => _txt("taskLabel") ?? "Tasks";
  String get calendarLabel => _txt("calendarLabel") ?? "Calendar";
  String get optionsLabel => _txt("optionsLabel") ?? "Options";
  String get day => _txt("day") ?? "Day";
  String get month => _txt("month") ?? "Month";
  String get year => _txt("year") ?? "Year";
  String get hour => _txt("hour") ?? "Hour";
  String get minute => _txt("minute") ?? "Minute";
  String get timeOfDay => _txt("timeOfDay") ?? "Time of Day";
  String get begin => _txt("begin") ?? "Begin";
  String get end => _txt("end") ?? "End";
  String get couldNotFetch =>
      _txt("couldNotFetch") ??
      "An Error occured, the file could not be fetched";
  String get dataNotFetchedYet =>
      _txt("dataNotFetchedYet") ?? "Data is about to be fetched on the device";
  String get fetchingData => _txt("fetchingData") ?? "Waiting for data...";
  String get retry => _txt("retry") ?? "Retry";
  String get hello => _txt("hello") ?? "Hello,";
  String get emptyDailyTask => _txt("emptyDailyTask") ?? "No tasks for today !";
  String get done => _txt("done") ?? "Done";
  String get occuring => _txt("occuring") ?? "Occuring";
  String get incomming => _txt("incomming") ?? "Incomming";
  String get nowInstance => _txt("nowInstance") ?? "Right now :";
  String get nextInstance => _txt("nextInstance") ?? "Next";
  String get prevInstance => _txt("prevInstance") ?? "Previously";
  String get neverInstance => _txt("neverInstance") ?? "No more instance.";
  String get beNotified => _txt("beNotified") ?? "Be notified"; 
  String get back => _txt("back") ?? "Back";
  String get confirm => _txt("confirm") ?? "Confirm";
  String get emptyInputText => _txt("emptyInputText") ?? "The input cannot be empty." ;
  String get taskUpdated => _txt("taskUpdated") ?? "Tasks updated.";
  String get notificationActivated =>
      _txt("notificationActivated") ?? "You will be notified of :";
  String get notificationDeactivated =>
      _txt("notificationDeactivated") ?? "You will no longer be notified of :";
  String get allDay => _txt("allDay") ?? "All Day";
  String get instances => _txt("instances") ?? "Instances";
  String get instancesToday => _txt("instancesToday") ?? "Instances Today";
  String get discreteOccurences =>
      _txt("discreteOccurences") ?? "Discrete Occurences";
  String get addTask => _txt("addTask") ?? "Add Task";
  String get label => _txt("label") ?? "Label";
  String get description => _txt("description") ?? "Description";
  String get schedule => _txt("schedule") ?? "Schedule";
  String get weekly => _txt("weekly") ?? "Weekly";
  String get monthly => _txt("monthly") ?? "Monthly";
  String get yearly => _txt("yearly") ?? "Yearly";

  String formatedDateTime(DateTime date) {
    final DateTime(:year, month: monthAsInt, :day, :hour, :minute) = date;
    final month = Month.fromMonthOfYear(monthAsInt);
    return "$day ${month.asLangName(this)} $year @ ${hour.padForClock()}:${minute.padForClock()}";
  }

  String formatedDate(Date date) {
    final Date(:year, month: month, :day) = date;
    return "$day ${month.asLangName(this)} $year";
  }


  String scheduleType(Schedule schedule) => switch (schedule) {
    DiscreteOccurences _ => discreteOccurences,
    Weekly _ => weekly,
    Monthly() => monthly,
    Yearly() => yearly,
  };

  String scheduleTypeName(ScheduleType type) => switch(type) {
    .discreteOccurences => discreteOccurences,
    .weekly => weekly,
    .monthly => monthly,
    .yearly => yearly
  };
}

import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tasker/data/month.dart';

class LangageTextProvider with ChangeNotifier {
  static const defaultLocale = Locale("en");
  static const nameSpace = "lang";
  static const filePrefix = "textes";

  Locale _locale;
  Map<String, String?>? _textes;

  UnmodifiableMapView<String, String?> get rawTextes => .new(_textes ?? {});

  LangageTextProvider._(this._locale);

  factory LangageTextProvider({Locale? locale}) {
    final loc =
        locale ??
        Locale(
          Platform.localeName.split("_").firstOrNull?.toLowerCase() ??
              defaultLocale.languageCode,
        );
    final instance = LangageTextProvider._(loc);

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
  String formatedDate(DateTime date) {
    final DateTime(:year, month: monthAsInt , :day , :hour , :minute ) = date;
    final month = Month.fromMonthOfYear(monthAsInt);
    return "$day ${month.asLangName(this)} $year @ $hour:$minute";
  }
}

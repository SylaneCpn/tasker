import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class LangageTextProvider extends ChangeNotifier {
  static const defaultLocale = Locale("en");
  static const nameSpace = "lang";
  static const filePrefix = "textes";

  Locale _locale;
  Map<String, String?>? _textes;

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
    } on Exception{
      // print(e);
      return {};
    }
  }

  void _notifyListeners() {
    notifyListeners();
  }

  Locale get currentLocale => _locale;
  String get homeLabel => _textes?["homeLabel"] ?? "Home";
  String get taskLabel => _textes?["taskLabel"] ?? "Tasks";
}

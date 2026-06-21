export 'themes/bottom_nav_bar_theme.dart';
export 'themes/text_theme.dart';
export 'themes/colors.dart';
export 'themes/text_button_theme.dart';
export 'themes/floating_action_button_theme.dart';

import 'package:flutter/material.dart';
import 'package:tasker/style/theme.dart' as theme;
import 'package:tasker/style/themes/text_button_theme.dart';

final appThemeData = ThemeData(
  fontFamily: theme.fontFamily,
  textTheme: theme.textTheme,
  textButtonTheme: textButtonThemeData,
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff6200ee)).copyWith(
  primaryContainer: const Color(0xff6200ee),
  onPrimaryContainer: Colors.white,
  secondaryContainer: const Color(0xff03dac6),
  onSecondaryContainer: Colors.black,
  error: const Color(0xffb00020),
  onError: Colors.white,
),
  bottomNavigationBarTheme: theme.bottomNavBarTheme,
  floatingActionButtonTheme: theme.floatingActionButtonThemeData,
);

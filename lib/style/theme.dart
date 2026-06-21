export 'themes/bottom_nav_bar_theme.dart';
export 'themes/text_theme.dart';
export 'themes/colors.dart';
export 'themes/text_button_theme.dart';

import 'package:flutter/material.dart';
import 'package:tasker/style/theme.dart' as theme;
import 'package:tasker/style/themes/text_button_theme.dart';

final appThemeData = ThemeData(
  fontFamily: theme.fontFamily,
  textTheme: theme.textTheme,
  textButtonTheme: textButtonThemeData,
  colorScheme: ColorScheme.light(),
  bottomNavigationBarTheme: theme.bottomNavBarTheme,
);

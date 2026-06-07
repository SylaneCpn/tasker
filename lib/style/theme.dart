export 'themes/bottom_nav_bar_theme.dart';
export 'themes/text_theme.dart';

import 'package:flutter/material.dart';
import 'package:tasker/style/theme.dart' as theme;

final appThemeData = ThemeData(
  fontFamily: theme.fontFamily,
  textTheme: theme.textTheme,
  colorScheme: ColorScheme.light(),
  bottomNavigationBarTheme: theme.bottomNavBarTheme,
);

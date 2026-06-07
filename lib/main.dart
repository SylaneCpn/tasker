import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/languages/langage_text_provider.dart';
import 'package:tasker/style/theme.dart' as theme;
import 'package:tasker/widgets/page_switcher.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: theme.appThemeData ,
      home: ChangeNotifierProvider(
        create: (context) => LangageTextProvider(),
        child: const PageSwitcher(),
      ),
    );
  }
}

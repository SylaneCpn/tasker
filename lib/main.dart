import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/languages/langage_text_provider.dart';
import 'package:tasker/style/theme.dart' as theme;
import 'package:tasker/widgets/task_data_provider.dart';

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
        child: Scaffold(body: Center(child: const TaskDataProvider())),
      ),
    );
  }
}

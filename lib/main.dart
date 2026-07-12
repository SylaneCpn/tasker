import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/languages/language_text_provider.dart';
import 'package:tasker/style/theme.dart' as theme;
import 'package:tasker/style/themes/colors.dart';
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
      color: shadedContainer,
      home: ChangeNotifierProvider(
        create: (context) => LanguageTextProvider(),
        child: Scaffold(backgroundColor: shadedContainer, body: Center(child: const TaskDataProvider())),
      ),
    );
  }
}

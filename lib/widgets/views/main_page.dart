import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/data/task_context.dart';
import 'package:tasker/languages/language_text_provider.dart';
import 'package:tasker/style/theme.dart';
import 'package:tasker/widgets/add_task_dialog.dart';
import 'package:tasker/widgets/views/main_page/daily_tasks_widget.dart';
import 'package:tasker/widgets/views/main_page/greetings_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Configured to rebuild the widget every minute
  Timer? _rebuildTimer;

  @override
  void initState() {
    super.initState();
    final DateTime(:second, :millisecond) = DateTime.now();
    final millisUntilFullMinute = 60 * 1000 - (second * 1000 + millisecond);
    Future<void>.delayed(Duration(milliseconds: millisUntilFullMinute)).then((
      _,
    ) {
      _rebuildTimer = .periodic(Duration(minutes: 1), (_) => setState(() {}));
    });
  }

  @override
  void dispose() {
    _rebuildTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LanguageTextProvider langTextProv = context.watch();
    final TaskContext taskContext = context.watch();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          fullscreenDialog: true,
          context: context,
          builder: (_) => AddTaskDialog(
            langTextProv: langTextProv,
            taskContext: taskContext,
          ),
        ),
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: defaultSpacing,
          mainAxisAlignment: .center,
          children: [
            Align(alignment: .topLeft, child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: const GreetingsCard(),
            )),
            const DailyTasksWidget(),
            // Here so floating action button does't block some tasks
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}

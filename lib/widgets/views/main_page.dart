import 'package:flutter/material.dart';
import 'package:tasker/widgets/views/main_page_widgets/daily_tasks_widgets.dart.dart';
import 'package:tasker/widgets/views/main_page_widgets/greetings_card.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 32.0,
        mainAxisAlignment: .center,
        children: [
          Align(alignment: .topLeft, child: const GreetingsCard()),
          const DailyTasksWidget(),
        ],
      ),
    );
  }
}

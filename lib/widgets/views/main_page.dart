import 'package:flutter/material.dart';
import 'package:tasker/widgets/views/main_page_widgets/daily_tasks_widget.dart';
import 'package:tasker/widgets/views/main_page_widgets/greetings_card.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {} , child: Icon(Icons.add),),
      body: SingleChildScrollView(
        child: Column(
          spacing: 24.0,
          mainAxisAlignment: .center,
          children: [
            Align(alignment: .topLeft, child: const GreetingsCard()),
            const DailyTasksWidget(),
          ],
        ),
      ),
    );
  }
}

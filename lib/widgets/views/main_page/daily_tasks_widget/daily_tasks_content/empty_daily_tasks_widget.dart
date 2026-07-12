import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/languages/language_text_provider.dart';

class EmptyDailyTasksWidget extends StatelessWidget {
  const EmptyDailyTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final langTextProv = context.watch<LanguageTextProvider>();
    final Size(height: viewH, width: viewW) = MediaQuery.sizeOf(context);
    return SizedBox(
      height: viewH * 0.65,
      width: viewW * 0.75,
      child: Center(
        child: Text(
          langTextProv.emptyDailyTask,
          textAlign: .center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
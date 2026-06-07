import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/languages/langage_text_provider.dart';

class AppNavBar extends StatelessWidget {

  final void Function(int)? switchToIndexCallBack;
  final int currentIndex;
  const AppNavBar({super.key, this.switchToIndexCallBack, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LangageTextProvider>();
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: languageProvider.homeLabel),
        BottomNavigationBarItem(icon: Icon(Icons.task_alt), label: languageProvider.taskLabel),
      ],
      onTap:(value) => switchToIndexCallBack?.call(value),
      currentIndex: currentIndex,
    );
  }
}

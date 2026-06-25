import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/data/app_config.dart';
import 'package:tasker/widgets/app_nav_bar.dart';
import 'package:tasker/widgets/views/main_page.dart';

class PageSwitcher extends StatefulWidget {
  const PageSwitcher({super.key});

  @override
  State<PageSwitcher> createState() => _PageSwitcherState();
}

class _PageSwitcherState extends State<PageSwitcher> {
  int index = 0;

  void switchToIndex(int newIndex) => setState(() {
    index = newIndex;
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppConfig(),
      child: Scaffold(
        bottomNavigationBar: AppNavBar(
          currentIndex: index,
          switchToIndexCallBack: switchToIndex,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: [
              MainPage(),
              Text("Tasks"),
              Text("Calendar"),
              Text("Settings"),
            ][index],
          ),
        ),
      ),
    );
  }
}

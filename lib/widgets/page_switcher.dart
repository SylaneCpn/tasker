import 'package:flutter/material.dart';
import 'package:tasker/widgets/app_nav_bar.dart';

class PageSwitcher extends StatefulWidget{
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
    return Scaffold(
          bottomNavigationBar: AppNavBar(currentIndex: index, switchToIndexCallBack: switchToIndex,),
          body: Center(
            child: [
              Text("Home"),
              Text("Tasks")
            ][index],
          ),
        );
  }
}
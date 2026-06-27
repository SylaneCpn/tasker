import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tasker/data/task_context.dart';
import 'package:tasker/ressources/task_context_provider.dart';
import 'package:tasker/widgets/page_switcher.dart';

class LifecycleHandler  extends StatefulWidget{
  final TaskContext taskContext;
  const LifecycleHandler({super.key, required this.taskContext});

  @override
  State<LifecycleHandler> createState() => _LifecycleHandlerState();
}

class _LifecycleHandlerState extends State<LifecycleHandler> with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() async {
    await storeTaskContextToAppDirectory(widget.taskContext);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      await storeTaskContextToAppDirectory(widget.taskContext);
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Future<AppExitResponse> didRequestAppExit() async {
    await storeTaskContextToAppDirectory(widget.taskContext);
    return super.didRequestAppExit();
  }


  @override
  Widget build(BuildContext context) => const PageSwitcher();
}
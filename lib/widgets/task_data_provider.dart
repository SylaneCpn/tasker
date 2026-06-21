import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:result/result.dart';
import 'package:tasker/data/task_context.dart';
import 'package:tasker/ressources/task_context_provider.dart';
import 'package:tasker/utils/fetch_status.dart';
import 'package:tasker/widgets/page_switcher.dart';

class TaskDataProvider  extends StatefulWidget{
  const TaskDataProvider({super.key});

  @override
  State<TaskDataProvider> createState() => _TaskDataProviderState();
}

class _TaskDataProviderState extends State<TaskDataProvider> {

  FetchStatus<TaskContext, Exception> taskContext = const NotFetchedYet();

  @override
  void initState() {
    super.initState();
    fetchTaskContext();
  }

  
  void fetchTaskContext() {
    final pendingFuture = getTaskContextFromAppDirectory();
    setState(() {
      taskContext = Pending();
    });
    pendingFuture.then((res) {
      switch (res) {
        case Ok(:final value):
          setState(() {
            taskContext = Success(value);
          });
        case Err(:final error):
        setState(() {
          taskContext = Failure(error);
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return switch(taskContext) {
      NotFetchedYet() => DataNotFetchedYetWidget(),
      Pending() => DataPendingWidget(),
      Failure(:final error)  => FetchFailureWidget(error: error , refetchCallback: fetchTaskContext),
      Success(:final value) => ChangeNotifierProvider.value(value: value, child: PageSwitcher(),)
    };
  }
}

class DataNotFetchedYetWidget extends StatelessWidget {
  const DataNotFetchedYetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}

class DataPendingWidget extends StatelessWidget {
  const DataPendingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}

class FetchFailureWidget<E> extends StatelessWidget {
  final E error;
  final void Function() refetchCallback;

  const FetchFailureWidget({super.key, required this.error , required this.refetchCallback});
  
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }}
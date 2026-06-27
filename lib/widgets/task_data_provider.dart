import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/data/task_context.dart';
import 'package:tasker/languages/language_text_provider.dart';
import 'package:tasker/mock/mock_schedule.dart';
import 'package:tasker/style/themes/colors.dart';
import 'package:tasker/utils/fetch_status.dart';
import 'package:tasker/widgets/lifecycle_handler.dart';

class TaskDataProvider extends StatefulWidget {
  const TaskDataProvider({super.key});

  @override
  State<TaskDataProvider> createState() => _TaskDataProviderState();
}

class _TaskDataProviderState extends State<TaskDataProvider> {
  FetchStatus<TaskContext, Exception> taskContext = Failure(
    Exception("Place holder error"),
  );

  @override
  void initState() {
    super.initState();
    fetchTaskContext();
  }

  void fetchTaskContext() {
    // final pendingFuture = getTaskContextFromAppDirectory();
    // setState(() {
    //   taskContext = Pending();
    // });
    // pendingFuture.then((res) {
    //   setState(() {
    //     taskContext = switch (res) {
    //       Ok(:final value) => Success(value),
    //       Err(:final error) => Failure(error),
    //     };
    //   });
    // });

    setState(() {
      taskContext = Success(mockContext());
    });
  }

  @override
  Widget build(BuildContext context) {
    return switch (taskContext) {
      NotFetchedYet() => DataNotFetchedYetWidget(),
      Pending() => DataPendingWidget(),
      Failure(:final error) => FetchFailureWidget(
        error: error,
        refetchCallback: fetchTaskContext,
      ),
      Success(:final value) => ChangeNotifierProvider.value(
        value: value,
        child: LifecycleHandler(taskContext:value),
      ),
    };
  }
}

class DataNotFetchedYetWidget extends StatelessWidget {
  const DataNotFetchedYetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final langTextProv = context.watch<LanguageTextProvider>();
    return Center(
      child: Text(
        langTextProv.dataNotFetchedYet,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class DataPendingWidget extends StatelessWidget {
  const DataPendingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final langTextProv = context.watch<LanguageTextProvider>();
    return Column(
      spacing: 20.0,
      mainAxisAlignment: .center,
      children: [
        CircularProgressIndicator(color: onBackgroundColor),
        Text(
          langTextProv.fetchingData,
          textAlign: TextAlign.justify,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class FetchFailureWidget<E> extends StatelessWidget {
  final E error;
  final void Function() refetchCallback;

  const FetchFailureWidget({
    super.key,
    required this.error,
    required this.refetchCallback,
  });

  @override
  Widget build(BuildContext context) {
    final langTextProv = context.watch<LanguageTextProvider>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: .center,
        spacing: 60.0,
        children: [
          Column(
            spacing: 30.0,
            children: [
              Text(
                langTextProv.couldNotFetch,
                textAlign: .center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(error.toString()),
            ],
          ),
          TextButton(
            onPressed: refetchCallback,
            style: TextButton.styleFrom(backgroundColor: onBackgroundColor),
            child: Text(
              langTextProv.retry,
              style: TextStyle(color: backgroundColor),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/data/app_state.dart';
import 'package:tasker/languages/langage_text_provider.dart';
import 'package:tasker/widgets/commons/elevated_container.dart';

class GreetingsCard  extends StatelessWidget{
  const GreetingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final langTextProv = context.watch<LangageTextProvider>();
    return ElevatedContainer(
              borderRadius: BorderRadius.circular(20.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("${langTextProv.hello}\n${appState.name}", style: Theme.of(context).textTheme.headlineMedium,),
              ),
            );
  }

}
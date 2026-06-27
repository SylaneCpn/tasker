import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasker/data/app_config.dart';
import 'package:tasker/languages/language_text_provider.dart';
import 'package:tasker/style/theme.dart';
import 'package:tasker/widgets/commons/elevated_container.dart';

class GreetingsCard extends StatelessWidget {
  const GreetingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppConfig>();
    final langTextProv = context.watch<LanguageTextProvider>();
    return ElevatedContainer(
      borderRadius: defBorderRadius,
      child: Padding(
        padding: isolatePadding,
        child: Text(
          "${langTextProv.hello}\n${appState.name}",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

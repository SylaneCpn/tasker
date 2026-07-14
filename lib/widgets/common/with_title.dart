import 'package:flutter/material.dart';
import 'package:tasker/style/theme.dart';

class WithTitle extends StatelessWidget{
  final String title;
  final TextStyle? titleStyle;
  final Widget child;

  const WithTitle({super.key, required this.title, required this.child, this.titleStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: smallSpacing,
      crossAxisAlignment: .stretch,
      children: [
        Align(
          alignment: .centerLeft,
          child: Text(title, style: titleStyle ?? Theme.of(context).textTheme.titleMedium,),
        ),
        child
      ],
    );
  }
}
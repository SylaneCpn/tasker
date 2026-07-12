import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tasker/style/theme.dart';

class Accordion extends StatefulWidget{

  final Widget header;
  final Widget Function(BuildContext , Animation<double>) bodyBuilder;
  final double? spacing;

  const Accordion({super.key, required this.header, required this.bodyBuilder , this.spacing});

  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  final ExpansibleController _controller = .new();


  void toggleCallback() => _controller.isExpanded
            ? _controller.collapse()
            : _controller.expand();

  @override
  Widget build(BuildContext context) {
   return Expansible(
      controller: _controller,
      headerBuilder: (_, animation) => GestureDetector(
        behavior: .opaque,
        onTap: toggleCallback,
        child: Padding(
          padding: sectionPadding,
          child: Row(
            spacing: widget.spacing ?? 8.0,
            children: [
              Transform.rotate(
                angle: animation.value * pi,
                child: Icon(Icons.expand_less),
              ),
              widget.header,
            ],
          ),
        ),
      ),
      bodyBuilder: widget.bodyBuilder,
    );
  }
}
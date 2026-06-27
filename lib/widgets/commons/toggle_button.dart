import 'package:flutter/material.dart';

class ToggleButton extends StatelessWidget {

  final Widget child; 
  final VoidCallback? toggleCallback;
  final bool activated;
  final BorderRadius? borderRadius;
  const ToggleButton({super.key, required this.child, required this.toggleCallback, required this.activated, this.borderRadius});

  static const activatedColor = Colors.blue;
  static const deactivatedColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return InkWell(
              onTap: toggleCallback,
              focusColor: activatedColor ,
              hoverColor: activatedColor,
              // highlightColor: activatedColor,
              borderRadius: borderRadius,
              child: Icon(
                Icons.sort,
                color: activated ? activatedColor : deactivatedColor,
              ),
            );
  }

}
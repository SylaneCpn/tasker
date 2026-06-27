import 'package:flutter/material.dart';
import 'package:tasker/widgets/commons/elevated_container.dart';

class ToggleButton extends StatelessWidget {

  final Widget child; 
  final VoidCallback? toggleCallback;
  final bool activated;
  final BorderRadius? borderRadius;
  final Size size;
  const ToggleButton({super.key, required this.child, required this.toggleCallback, required this.activated, this.borderRadius, required this.size});

  static const activatedColor = Colors.blue;
  static const deactivatedColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return ElevatedContainer(
      borderRadius: borderRadius,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: InkWell(
                  onTap: toggleCallback,
                  focusColor: activatedColor ,
                  hoverColor: activatedColor,
                  // highlightColor: activatedColor,
                  borderRadius: borderRadius,
                  child: Icon(
                    Icons.sort,
                    color: activated ? activatedColor : deactivatedColor,
                  ),
                ),
      ),
    );
  }

}
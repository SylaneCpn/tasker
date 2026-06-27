import 'package:flutter/material.dart';
import 'package:tasker/widgets/common/elevated_container.dart';

class IconToggleButton extends StatelessWidget {

  final IconData iconData; 
  final VoidCallback? toggleCallback;
  final bool activated;
  final BorderRadius? borderRadius;
  final Size size;
  const IconToggleButton({super.key, required this.toggleCallback, required this.activated, this.borderRadius, required this.size, required this.iconData,});

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
                  child: Icon(iconData, color: activated ? activatedColor : deactivatedColor,),
                ),
      ),
    );
  }

}
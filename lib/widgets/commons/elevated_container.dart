import 'package:flutter/material.dart';

class ElevatedContainer extends StatelessWidget{
  final Widget child;
  final double elevation;
  final BoxDecoration? decoration;
  final BorderRadius? borderRadius;
  const ElevatedContainer({super.key, this.decoration , this.borderRadius, this.elevation = 8.0, required this.child});

  @override
  Widget build(BuildContext context) {
    final BoxDecoration? finalDecoration = decoration?.copyWith(borderRadius: borderRadius);
    return Material(
      elevation: elevation,
      borderRadius: borderRadius,
      child: Container(
        decoration: finalDecoration,
        child: child,
      ),
    );
  }
}
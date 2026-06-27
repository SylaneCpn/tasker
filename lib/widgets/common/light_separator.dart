import 'package:flutter/material.dart';

class LightSeparator extends StatelessWidget{
  const LightSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.0),
        color: Colors.grey[600]
      ),
    );
  }

}
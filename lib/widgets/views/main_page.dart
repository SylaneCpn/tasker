import 'package:flutter/material.dart';
import 'package:tasker/widgets/commons/elevated_container.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: .min,
        children: [
          ElevatedContainer(
            borderRadius: BorderRadius.circular(20.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Hello User !", textScaler: TextScaler.linear(4.0)),
            ),
          ),
        ],
      ),
    );
  }
}

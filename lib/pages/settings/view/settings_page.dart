import 'package:flutter/material.dart';
import 'package:listen_together_app/widgets/widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
            child: Column(
          children: [
            SettingsButton([
              (MediaQuery.of(context).size.width * 1).toDouble(),
              (MediaQuery.of(context).size.height * 0.062).toDouble()
            ], 'Settings Button', () => {})
          ],
        )));
  }
}

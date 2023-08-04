import 'package:flutter/material.dart';
import 'package:listen_together_app/widgets/widgets.dart';

class StartPartyPage extends StatelessWidget {
  const StartPartyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          Center(
            child: AccentButton(
              [
                (MediaQuery.of(context).size.width * 0.8).toDouble(),
                (MediaQuery.of(context).size.height * 0.062).toDouble()
              ],
              'Start your Party',
              () => {},
            ),
          ),
          Spacer(),
          Container(
              child: Text(
            'Version 0.1 Beta. Die App ist noch lange nicht fertig, dies ist eine Test Version die nur wenige Leute erhalten',
            style: TextStyle(
                color: Theme.of(context).primaryColorLight, fontSize: 15),
          )),
        ],
      )),
    );
  }
}

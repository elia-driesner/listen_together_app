import 'package:flutter/material.dart';
import 'package:listen_together_app/widgets/widgets.dart';

class StartListenTogether extends StatefulWidget {
  const StartListenTogether({super.key});

  @override
  State<StartListenTogether> createState() => _StartListenTogetherState();
}

class _StartListenTogetherState extends State<StartListenTogether> {
  TextEditingController nameController = TextEditingController();
  double name_margin = 0.15;
  List<double> name_size = [0.8, 0.1];

  void moveName() async {
    setState(() => {
          name_margin = 0.02,
          name_size = [0.6, 0.09]
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(width: MediaQuery.of(context).size.width),
            AnimatedContainer(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 120),
              margin: EdgeInsets.fromLTRB(
                  0, (MediaQuery.of(context).size.height * name_margin), 0, 0),
              child: AnimatedSize(
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 100),
                child: BigInput(
                  size: [
                    (MediaQuery.of(context).size.width * name_size[0])
                        .toDouble(),
                    (MediaQuery.of(context).size.height * name_size[1])
                        .toDouble()
                  ],
                  text: "Name",
                  controller: nameController,
                  obscureText: false,
                ),
              ),
            ),
            const Spacer(),
            Container(
                margin: EdgeInsets.fromLTRB(
                    0, 0, 0, MediaQuery.of(context).size.height * 0.035),
                child: AccentButton(
                  [
                    (MediaQuery.of(context).size.width * 0.8).toDouble(),
                    (MediaQuery.of(context).size.height * 0.062).toDouble()
                  ],
                  'Start Listen Together',
                  () => moveName(),
                )),
          ],
        )));
  }
}

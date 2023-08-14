import 'package:flutter/material.dart';
import 'package:listen_together_app/widgets/widgets.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map settings = {
    'Account': [
      ['Change Username', () => {}],
      ['Change Password', () => {}],
      ['Delete Account', () => {}],
      ['Logout', () => {}]
    ],
    'About': [
      ['About us', () => {}],
      ['Website', () => {}]
    ]
  };
  List<Widget> children = [];

  void create_widgets() async {
    settings.forEach((key, value) {
      children.add(
        Container(
          margin: EdgeInsets.fromLTRB(40, 20, 50, 0),
          alignment: Alignment.bottomLeft,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Text(
                  key,
                  style: TextStyle(
                      color: Theme.of(context).primaryColorLight, fontSize: 17),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey)),
            ],
          ),
        ),
      );
      var part = settings[key];
      part.forEach((value) {
        children.add(SettingsButton([
          (MediaQuery.of(context).size.width * 1).toDouble(),
          (MediaQuery.of(context).size.height * 0.062).toDouble()
        ], value[0], value[1]));
      });
    });
    setState(() {
      children = children;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => create_widgets());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
            child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 40, 0),
                    child: IconButton(
                        onPressed: () => {Navigator.pop(context)},
                        alignment: Alignment.centerLeft,
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.white,
                        )),
                  ),
                ),
                Text(
                  'Settings',
                  style: TextStyle(
                      color: Theme.of(context).primaryColorLight, fontSize: 23),
                ),
                const Spacer(),
              ]),
            ),
            Column(
              children: children,
            )
          ],
        )));
  }
}

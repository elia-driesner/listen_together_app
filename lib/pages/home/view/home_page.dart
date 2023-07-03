import 'package:flutter/material.dart';
import '/data/user_data.dart';
import '/pages/auth/auth.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  void checkLogin() {
    if (user_data == null) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => LoginPage(),
          transitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: const Text('homepage')));
  }
}

import 'package:flutter/material.dart';
import 'pages/home/home.dart';
import 'pages/splash_screen/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(child: SplashScreen());
  }
}

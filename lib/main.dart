import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        errorColor: Color.fromARGB(255, 255, 104, 104),
        indicatorColor: const Color.fromARGB(255, 36, 36, 36),
        primaryColorDark: const Color.fromARGB(255, 36, 36, 36),
        primaryColorLight: const Color.fromARGB(255, 240, 240, 240),
        primaryColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: const Color(0xff191414),
        focusColor: const Color(0xff1DB954),
        textSelectionTheme: const TextSelectionThemeData(
            selectionHandleColor: Color.fromARGB(80, 36, 36, 36),
            selectionColor: Color.fromARGB(80, 36, 36, 36)),
        useMaterial3: true,
      ),
      home: const App(),
    );
  }
}

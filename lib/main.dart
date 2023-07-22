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
        errorColor: const Color.fromARGB(255, 255, 104, 104),
        indicatorColor: const Color.fromARGB(255, 36, 36, 36),
        primaryColorDark: const Color(0xff080704),
        primaryColorLight: const Color(0xffE1E1E1),
        primaryColor: const Color(0xff131416),
        backgroundColor: const Color(0xff131416),
        focusColor: const Color(0xffF2C94C),
        textSelectionTheme: const TextSelectionThemeData(
            selectionHandleColor: Color.fromARGB(80, 36, 36, 36),
            selectionColor: Color.fromARGB(80, 36, 36, 36)),
        useMaterial3: true,
      ),
      home: const App(),
    );
  }
}

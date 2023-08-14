import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
        errorColor: const Color.fromARGB(255, 255, 104, 104),
        indicatorColor: Color.fromARGB(255, 202, 202, 202),
        primaryColorDark: Color.fromARGB(255, 0, 0, 0),
        primaryColorLight: const Color(0xffE1E1E1),
        primaryColor: Color.fromARGB(255, 0, 0, 0),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        focusColor: Color.fromARGB(255, 255, 255, 255),
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color.fromARGB(255, 255, 255, 255),
            selectionHandleColor: Color.fromARGB(80, 255, 255, 255),
            selectionColor: Color.fromARGB(80, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: const App(),
    );
  }
}

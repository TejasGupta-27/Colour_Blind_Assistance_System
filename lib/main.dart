import 'package:flutter/material.dart';
import 'welcome_screen.dart'; // Import your WelcomeScreen widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(), // Use the system's theme mode
      home: WelcomeScreen(),
    );
  }
}

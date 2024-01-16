import 'package:flutter/material.dart';
import 'welcome_screen.dart'; // Import your WelcomeScreen widget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

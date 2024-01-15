import 'dart:async';
import 'package:flutter/material.dart';
import 'home_page.dart'; // Import your HomePage widget

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Delayed navigation to the next screen after 3 seconds
    Future.delayed(Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), // Use your HomePage widget
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    Colors.red,
                    Colors.orange,
                    Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.indigo,
                    Colors.purple,
                    Colors.red, // Repeating red to complete the circle
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Welcome to the World of Colors!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

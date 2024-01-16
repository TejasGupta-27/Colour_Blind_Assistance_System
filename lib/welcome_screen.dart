import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_page.dart';

class WelcomeScreen extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _handleGoogleSignIn(BuildContext context) async {
    try {
      await _googleSignIn.signIn(); // Perform Google Sign-In

      // Navigate to the Home Page after successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (error) {
      print('Google Sign-In Error: $error');
      // Handle error or show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _handleGoogleSignIn(context),
              child: Text('Sign In with Google'),
            ),
          ],
        ),
      ),
    );
  }
}

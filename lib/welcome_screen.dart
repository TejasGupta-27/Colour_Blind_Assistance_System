import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_page.dart';

class WelcomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  WelcomeScreen({super.key});

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        // User signed in
        print('Google Sign-In Successful: ${user.displayName}');

        // Show a SnackBar for successful sign-in
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome, ${user.displayName}!'),
            duration: const Duration(seconds: 3),
            shape: const OvalBorder(),
          ),
        );

        // Navigate to the Home Page or perform other actions
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Handle the case where user authentication fails
        print('Google Sign-In Failed');
      }
    } catch (error) {
      // Handle other sign-in errors
      print('Google Sign-In Error: $error');
      // Show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the user is already signed in
    if (_auth.currentUser != null) {
      // User is already signed in, navigate to the Home Page
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 80.0,
              width: 80.0,
              decoration: const BoxDecoration(
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
            const SizedBox(height: 20.0),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Welcome to the World of Colors!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
            ),
            if (_auth.currentUser == null)
              ElevatedButton(
                onPressed: () {
                  print("Button Pressed");
                  _handleGoogleSignIn(context);
                },
                child: const Text('Sign In with Google'),
              ),
          ],
        ),
      ),
    );
  }
}

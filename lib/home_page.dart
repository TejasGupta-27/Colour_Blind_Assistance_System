import 'dart:io';
import 'package:colour_blindness/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'auth_service.dart';
import 'package:colour_blindness/profile_screen.dart';

class HomePage extends StatefulWidget {
  final AuthService authService = AuthService();

  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _pickedImage;

  void _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
      _showSnackBar(context, 'Image selected successfully', true);
    } else {
      _showSnackBar(context, 'No image selected', false);
    }
  }

  void _showSnackBar(BuildContext context, String message, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Blindness Simulator'),
      ),
      drawer: buildDrawer(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: const Text('Choose Photo'),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: const Text('Take Photo'),
            ),
            if (_pickedImage != null)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.file(
                  _pickedImage!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 99, 16, 114),
            ),
            child: FutureBuilder<User?>(
              future: widget.authService.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  User user = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(user.photoURL ?? ''),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.displayName ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Text('User not signed in');
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Edit Profile'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Sign Out'),
            onTap: () async {
              await widget.authService.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

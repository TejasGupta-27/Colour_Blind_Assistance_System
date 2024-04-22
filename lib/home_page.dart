import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:colour_blindness/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'package:colour_blindness/profile_screen.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final AuthService authService = AuthService();

  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _pickedImage;
  late ImageLabeler _imageLabeler;
  List<ImageLabel> _labels = [];
  PaletteGenerator? _paletteGenerator;

  @override
  void initState() {
    super.initState();
    _initializeImageLabeler();
  }

  Future<void> _initializeImageLabeler() async {
    _imageLabeler = GoogleMlKit.vision.imageLabeler();
  }

  void _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
        _labels = [];
        _paletteGenerator = null;
      });
      _runImageLabeling();
      _generatePalette();
    }
  }

  Future<void> _runImageLabeling() async {
    if (_pickedImage == null) return;

    try {
      final inputImage = InputImage.fromFilePath(_pickedImage!.path);
      final labels = await _imageLabeler.processImage(inputImage);
      setState(() {
        _labels = labels;
      });
    } catch (e) {
      print('Failed to run image labeling: $e');
    }
  }

  Future<void> _generatePalette() async {
    if (_pickedImage == null) return;

    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(FileImage(_pickedImage!),
            size: const Size(150, 150));

    setState(() {
      _paletteGenerator = paletteGenerator;
    });
  }

  String findClosestColor(Color dominantColor) {
    double minDistance = double.infinity;
    String closestColor = '';

    Map<String, String> colorNames = {
      'Red': '#FF0000',
      'Green': '#00FF00',
      'Blue': '#0000FF',
      'Yellow': '#FFFF00',
      'Cyan': '#00FFFF',
      'Magenta': '#FF00FF',
      'Purple': '#800080',
      'Pink': '#FFC0CB',
      'Orange': '#FFA500',
      'Teal': '#008080',
      'Brown': '#A52A2A',
      'Lime': '#00FF00',
      'Maroon': '#800000',
      'Navy': '#000080',
      'Olive': '#808000',
      'Indigo': '#4B0082',
      'Aquamarine': '#7FFFD4',
      'Turquoise': '#40E0D0',
      'Silver': '#C0C0C0',
      'Gray': '#808080',
      'Black': '#000000',
      'White': '#FFFFFF',
      // Add more color names as needed
    };

    colorNames.forEach((name, hex) {
      Color color = Color(int.parse(hex.replaceAll('#', ''), radix: 16));
      double distance = ((color.red - dominantColor.red).abs() +
              (color.green - dominantColor.green).abs() +
              (color.blue - dominantColor.blue).abs()) /
          3.0; // Calculate the average distance for RGB components

      if (distance < minDistance) {
        minDistance = distance;
        closestColor = name;
      }
    });

    return closestColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colour Blindness Aid'),
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
            if (_labels.isNotEmpty)
              Column(
                children: [
                  Text(
                    'Top Answer: ${_labels.first.label}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Confidence: ${(_labels.first.confidence * 100).toStringAsFixed(2)}%',
                  ),
                ],
              ),
            if (_paletteGenerator != null)
              Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Dominant Color:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Closest Color: ${findClosestColor(_paletteGenerator!.dominantColor!.color)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
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
          // ListTile(
          //   title: const Text('Edit Profile'),
          //   onTap: () {
          //     Navigator.of(context).push(un 
          //       MaterialPageRoute(builder: (context) => const ProfileScreen()),
          //     );
          //   },
          // ),
          ListTile(
            title: const Text('Mosaic Test'),
            onTap: () {
              launch('https://www.colorlitelens.com/mosaic-test.html');
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

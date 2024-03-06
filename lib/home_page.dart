import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _pickedImage;
  late ImageLabeler _imageLabeler;

  List<ImageLabel> _labels = [];
  List<Color> _dominantColors = [];

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
      });
      _runImageLabeling();
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
      _extractDominantColors(inputImage);
    } catch (e) {
      print('Failed to run image labeling: $e');
    }
  }

  void _extractDominantColors(InputImage inputImage) {
    // Code to extract dominant colors goes here
  }

  @override
 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Image Labeling & Color Detection'),
    ),
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
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Confidence: ${(_labels.first.confidence * 100).toStringAsFixed(2)}%',
                ),
              ],
            ),
          if (_dominantColors.isNotEmpty)
            Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  'Dominant Color:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Color: ${_dominantColors.first}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
        ],
      ),
    ),
  );
}

}

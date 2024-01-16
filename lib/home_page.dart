import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? _pickedImage;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Blindness Simulator'),
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
                  File(_pickedImage!.path),
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
}

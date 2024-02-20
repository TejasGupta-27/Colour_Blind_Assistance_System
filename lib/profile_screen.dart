import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Define the Gender enum at the top level of the file
enum Gender { male, female }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _name;
  late String _email;
  late String _age;
  late String _colourBlindnessType;
  late Gender _selectedGender;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load profile data on initialization
  }

  Future<void> _loadProfileData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userProfile =
            await _firestore.collection('users').doc(user.uid).get();
        Map<String, dynamic>? userData = userProfile.data() as Map<String, dynamic>?;
        setState(() {
          _name = user.displayName ?? '';
          _email = user.email ?? '';
          _age = userData?['age'] ?? '';
          _colourBlindnessType = userData?['colourBlindnessType'] ?? '';
          _selectedGender = userData?['gender'] == 'Male' ? Gender.male : Gender.female;
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error loading profile data: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: _buildProfileForm(),
      ),
    );
  }

  Widget _buildProfileForm() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              enabled: false,
            ),
            TextFormField(
              initialValue: _email,
              decoration: const InputDecoration(labelText: 'Email Address'),
              enabled: false,
            ),
            TextFormField(
              initialValue: _age,
              decoration: const InputDecoration(labelText: 'Age'),
              onChanged: (value) => _age = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                return null;
              },
            ),
            _buildGenderRadioList(),
            DropdownButtonFormField<String>(
              value: _colourBlindnessType.isNotEmpty ? _colourBlindnessType : null,
              onChanged: (value) {
                setState(() {
                  _colourBlindnessType = value!;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 'Normal',
                  child: Text('Normal'),
                ),
                DropdownMenuItem(
                  value: 'Protanomaly',
                  child: Text('Protanomaly'),
                ),
                DropdownMenuItem(
                  value: 'Deuteranomaly',
                  child: Text('Deuteranomaly'),
                ),
                DropdownMenuItem(
                  value: 'Tritanomaly',
                  child: Text('Tritanomaly'),
                ),
                DropdownMenuItem(
                  value: 'Protanopia',
                  child: Text('Protanopia'),
                ),
                DropdownMenuItem(
                  value: 'Deuteranopia',
                  child: Text('Deuteranopia'),
                ),
                DropdownMenuItem(
                  value: 'Tritanopia',
                  child: Text('Tritanopia'),
                ),
                DropdownMenuItem(
                  value: 'Achromatopsia',
                  child: Text('Achromatopsia'),
                ),
                DropdownMenuItem(
                  value: 'Achromatomaly',
                  child: Text('Achromatomaly'),
                ),
              ],
              decoration: const InputDecoration(labelText: 'Color Blindness Type'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderRadioList() {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: RadioListTile<Gender>(
              title: const Text('Male'),
              value: Gender.male,
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
          ),
          Expanded(
            child: RadioListTile<Gender>(
              title: const Text('Female'),
              value: Gender.female,
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = _auth.currentUser;
        if (user != null) {
          // Update Firebase database with the changes
          await _firestore.collection('users').doc(user.uid).update({
            'age': _age,
            'gender': _selectedGender == Gender.male ? 'Male' : 'Female',
            'colourBlindnessType': _colourBlindnessType,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (error) {
        print('Error updating profile: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

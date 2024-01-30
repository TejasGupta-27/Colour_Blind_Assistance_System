import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _age;
  late String _gender;
  late String _colourBlindnessType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: FutureBuilder(
        future: _loadProfileData(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading profile data: ${snapshot.error}'),
            );
          } else {
            return SingleChildScrollView(
              child: _buildProfileForm(snapshot.data),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _loadProfileData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userProfile =
            await _firestore.collection('users').doc(user.uid).get();
        return userProfile.data() as Map<String, dynamic>;
      }
    } catch (error) {
      throw error;
    }
    return {};
  }

  Widget _buildProfileForm(Map<String, dynamic>? userData) {
    String _name = _auth.currentUser?.displayName ?? '';
    String _email = _auth.currentUser?.email ?? '';

    _age = userData?['age'] ?? '';
    _gender = userData?['gender'] ?? '';
    _colourBlindnessType = userData?['colourBlindnessType'] ?? '';

    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: _name,
              decoration: InputDecoration(labelText: 'Name'),
              enabled: false,
            ),
            TextFormField(
              initialValue: _email,
              decoration: InputDecoration(labelText: 'Email Address'),
              enabled: false,
            ),
            TextFormField(
              initialValue: _age,
              decoration: InputDecoration(labelText: 'Age'),
              onChanged: (value) => _age = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: _gender,
              decoration: InputDecoration(labelText: 'Gender'),
              onChanged: (value) => _gender = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your gender';
                }
                return null;
              },
            ),
            TextFormField(
              initialValue: _colourBlindnessType,
              decoration:
                  InputDecoration(labelText: 'Colour Blindness Type'),
              onChanged: (value) => _colourBlindnessType = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your colour blindness type';
                }
                return null;
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = _auth.currentUser;
        if (user != null) {
          await _firestore.collection('users').doc(user.uid).update({
            'age': _age,
            'gender': _gender,
            'colourBlindnessType': _colourBlindnessType,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
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
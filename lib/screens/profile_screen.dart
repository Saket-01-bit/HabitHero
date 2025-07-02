import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/challenge.dart';
import '../widgets/custom_input_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _locationController = TextEditingController();

  List<Challenge> _challenges = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadChallenges();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) return;

      final data = doc.data();
      if (data == null) return;

      setState(() {
        _nameController.text = data['name'] ?? '';
        _emailController.text = data['email'] ?? '';
        _ageController.text = data['age']?.toString() ?? '';
        _locationController.text = data['location'] ?? '';
      });
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  Future<void> _loadChallenges() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final snapshot = await FirebaseFirestore.instance
          .collection('challenges')
          .where('userId', isEqualTo: user.uid)
          .get();

      setState(() {
        _challenges = snapshot.docs
            .map((doc) => Challenge.fromMap(doc.id as Map<String, dynamic>, doc.data()))
            .toList();
      });
    } catch (e) {
      print("Error loading challenges: $e");
    }
  }

  Future<void> _saveProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': _nameController.text.trim(),
        'age': _ageController.text.trim(),
        'location': _locationController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated")),
      );
    } catch (e) {
      print("Error saving profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int totalCompletedDays = _challenges
        .expand((c) => c.progress)
        .where((done) => done)
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: const Color(0xFF1E1E2C),
        foregroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            CustomInputField(controller: _nameController, label: 'Name'),
            const SizedBox(height: 16),
            CustomInputField(controller: _emailController, label: 'Email', readOnly: true),
            const SizedBox(height: 16),
            CustomInputField(controller: _ageController, label: 'Age', keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            CustomInputField(controller: _locationController, label: 'Location'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            Text(
              "Total Completed Days: $totalCompletedDays",
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to the login page after logout
      );
    } catch (e) {
      print("Error during logout: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error logging out. Please try again."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => _logout(context),
          child: Text("Logout"),
        ),
      ),
    );
  }
}

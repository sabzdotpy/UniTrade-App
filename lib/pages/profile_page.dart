import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import './choose_college_page.dart';
import '../utils/google_sign_in_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    GoogleSignInProvider  googleSignInProvider = GoogleSignInProvider();

    try {
      await FirebaseAuth.instance.signOut();
      googleSignInProvider.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChooseCollegePage()), // Navigate to the login page after logout
      );
    } catch (e) {
      print("Error during logout: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error logging out. Please try again."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async { 
                _logout(context);
                var box = await Hive.openBox("appPreferences");
                box.put('isLoggedIn', false);
              },
              child: const Text("Logout"),
            ),
            ElevatedButton(
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Logged in User: ${user.email}, UID: ${user.uid}"),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("No user is logged in."),
                    ),
                  );
                }
              },
              child: const Text("Print User")
            )
          ],
        ),
      ),
    );
  }
}

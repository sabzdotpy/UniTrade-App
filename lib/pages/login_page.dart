import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import "./home_page.dart";
import "../utils/google_sign_in_provider.dart";

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GoogleSignInProvider _googleSignInProvider = GoogleSignInProvider();
  final Logger print =  Logger(printer: PrettyPrinter());

  @override
  void initState() {
    super.initState();
    print.i("Login Page Initialized.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            var box = Hive.box('appPreferences');

            User? user = await _googleSignInProvider.signInWithGoogle(context);
            if (user != null) {
              // Proceed to the main page if the sign-in was successful
              print.i("Google Sign in successful. Proceeding to main page.");
              // ---
              box.put('isLoggedIn', true);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
              // ---
            }
            else {
              print.w("No user found after Google Login is closed.");
            }
            
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
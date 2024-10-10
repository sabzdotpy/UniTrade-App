import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import '../utils/app_images.dart';
import "./home_page.dart";
import "../utils/google_sign_in_provider.dart";
import 'choose_college_page.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {

//   // final GoogleSignInProvider _googleSignInProvider = GoogleSignInProvider();
//   // final Logger print =  Logger(printer: PrettyPrinter());

//   @override
//   void initState() {
//     super.initState();
//     // print.i("Login Page Initialized.");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: 
//       ),
//     );
//   }
// }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    bool isSigningIn = false; // To show loading indicator during sign-in

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
      appBar: AppBar(
        title: ElevatedButton.icon(
          onPressed: () {}, 
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0), // Control the border radius here
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Button padding
          ),
          icon: Icon(Icons.chevron_left),
          label: Text("Back"),

        ),
        elevation: 0, // Optional: remove AppBar shadow
        backgroundColor: Colors.transparent, // Optional: transparent background
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.get('unitrade.png'),
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 20),

            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 40,
              color: Colors.white,
            ),
            
            (isSigningIn)
                ? const CircularProgressIndicator() // Show loading indicator during sign-in
                : ElevatedButton(
                    onPressed: () async {
                      var box = Hive.box('appPreferences');

                      User? user = await _googleSignInProvider.signInWithGoogle(context);
                      if (user != null) {
                        print.i("Google Sign in successful. Proceeding to main page.");
                        box.put('isLoggedIn', true);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      }
                      else {
                        print.w("No user found after Google Login is closed.");
                      }
                    },
                    child: const Text('Sign in with Google'),
                  ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
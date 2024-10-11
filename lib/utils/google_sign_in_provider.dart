import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class GoogleSignInProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final Logger print = Logger(printer: PrettyPrinter());

  Future<User?> signInWithGoogle(BuildContext context, String endsWith) async {
    try {
      // Trigger the Google authentication process
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in, return null
        return null;
      }

      // Check if the user's email matches the allowed domain
      if (!googleUser.email.endsWith(endsWith)) {
        print.i("User email does not end with $endsWith");
        // Show an error message if the email doesn't match
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Only users with an $endsWith domain can log in.'),
          ),
        );
        // Sign out from GoogleSignIn
        await _googleSignIn.signOut();
        return null;
      }

      // Get the Google authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential for Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google user credential
      UserCredential userCredential = await _auth.signInWithCredential(credential);

      // Return the signed-in user
      return userCredential.user;
    } catch (e) {
      print.e('Error during Google Sign-In: $e');
      return null;
    }
  }

  // Sign out from Google and Firebase
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}

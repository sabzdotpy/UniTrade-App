import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import "./login_page.dart";
import "../utils/google_sign_in_provider.dart";

class ChooseCollegePage extends StatefulWidget {
  const ChooseCollegePage({super.key});

  @override
  State<ChooseCollegePage> createState() => _ChooseCollegePageState();
}

class _ChooseCollegePageState extends State<ChooseCollegePage> {

  final GoogleSignInProvider _googleSignInProvider = GoogleSignInProvider();
  final Logger print =  Logger(printer: PrettyPrinter());

  @override
  void initState() {
    super.initState();
    print.i("College Choosing Page Initialized.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }, 
        child: Text("Choose your college")),
      ),
    );
  }
}
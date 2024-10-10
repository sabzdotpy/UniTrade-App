import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import './login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to the App'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                var box = Hive.box('appPreferences');
                box.put('isFirstTime', false);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}
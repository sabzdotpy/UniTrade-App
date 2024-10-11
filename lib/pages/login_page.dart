import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;

import '../utils/app_images.dart';
import "./home_page.dart";
import "../utils/google_sign_in_provider.dart";
import 'choose_college_page.dart';


class LoginPage extends StatefulWidget {

  final String collegeName;
  final String mail;

  LoginPage({
    required this.collegeName,
    required this.mail
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    bool isSigningIn = false;
    late String collegeName;
    late String mail;

    final double _signInButtonHeight = 60;

    final GoogleSignInProvider _googleSignInProvider = GoogleSignInProvider();
    final Logger print =  Logger(printer: PrettyPrinter());

    @override
    void initState() {
      super.initState();
      collegeName = widget.collegeName;
      mail = widget.mail;

      print.i("Login Page Initialized.");
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ElevatedButton.icon(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ChooseCollegePage()));
          }, 
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
              width: MediaQuery.of(context).size.width * 0.82,
              // height: 70,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(77, 146, 202, 0.6),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                  color: const Color.fromARGB(126, 171, 215, 252),
                  width: 2,
                )
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon( Icons.info, size: 20, ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: Text(
                      "Since you have chosen $collegeName, only emails ending with '$mail' will be permitted.",
                      textAlign: TextAlign.left,
                      softWrap: true,
                    ),
                  ),
                ],
              )
              
              
            ),

            const SizedBox(height: 20,),
            
            (isSigningIn)
                ? const CircularProgressIndicator() // Show loading indicator during sign-in
                // : GoogleSignInButton(googleSignInProvider: _googleSignInProvider, print: print),
                : SignInButton(googleSignInProvider: _googleSignInProvider, print: print, mail: mail,),
                // Stack(
                //   alignment: Alignment.center,
                //   children: [
                //     // Background container with radial gradient (Google logo colors)
                //     Container(
                //       width: MediaQuery.of(context).size.width * 0.5,
                //       height: _signInButtonHeight,
                //       decoration: const BoxDecoration(
                //         shape: BoxShape.rectangle,
                //         borderRadius: BorderRadius.all(Radius.circular(38)),
                //         gradient: LinearGradient(
                //           begin: Alignment.centerLeft,
                //           end: Alignment.centerRight,
                //           colors: [
                //             Colors.blue,   
                //             Colors.green,  
                //             Colors.yellow, 
                //             Colors.red,    
                //           ],
                //           stops: [0.0, 0.33, 0.66, 1.0],
                //         ),
                //     ),),

                //     Container(
                //       height: (_signInButtonHeight - 5),
                //       width: MediaQuery.of(context).size.width * 0.489,
                //       child: ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: const Color.fromRGBO(20, 20, 20, 1),
                //           shape: const RoundedRectangleBorder(
                //             borderRadius: BorderRadius.all(Radius.circular(38)),
                //           )
                //         ),
                //         onPressed: () async {
                          // var box = Hive.box('appPreferences');
                          // User? user = await _googleSignInProvider.signInWithGoogle(context);
                          // if (user != null) {
                          //   print.i("Google Sign in successful. Proceeding to main page.");
                          //   box.put('isLoggedIn', true);
                          //   Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => const HomeScreen()),
                          //   );
                          // }
                          // else {
                          //   print.w("No user found after Google Login is closed.");
                          // }
                //         },
                //         child: const Text(
                //           'Sign in with Google',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 18,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),


            const SizedBox(height: 50),

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


class SignInButton extends StatefulWidget {


  final GoogleSignInProvider googleSignInProvider; // Define GoogleSignInProvider
  final dynamic print;
  final String mail;

  // Constructor to receive the parameters
  const SignInButton({
    Key? key,
    required this.googleSignInProvider,
    required this.print,
    required this.mail
  }) : super(key: key);


  @override
  _SignInButtonState createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> with SingleTickerProviderStateMixin {
  final double _signInButtonHeight = 50;

  late AnimationController _controller;
  late GoogleSignInProvider googleSignInProvider;
  late dynamic print;
  late String mail;

  @override
  void initState() {
    super.initState();
    googleSignInProvider = widget.googleSignInProvider;
    print = widget.print;
    mail = widget.mail;
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(); // Repeat the animation continuously
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Animated gradient container
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: _signInButtonHeight,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(38)),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.blue, // Blue
                    Colors.green, // Green
                    Colors.yellow, // Yellow
                    Colors.red, // Red
                  ],
                  // Rotate the gradient based on the animation
                  transform: GradientRotation(_controller.value * 2 * math.pi),
                ),
              ),
            );
          },
        ),

        // Elevated Button on top
        Container(
          height: (_signInButtonHeight - 5),
          width: MediaQuery.of(context).size.width * 0.489,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(20, 20, 20, 1),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(38)),
              ),
            ),
            onPressed: () async {
              var box = Hive.box('appPreferences');
                User? user = await googleSignInProvider.signInWithGoogle(context, mail);
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
            child: const Text(
              'Sign in with Google',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

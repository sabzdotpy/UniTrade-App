import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'dart:math' as math;
import 'package:hugeicons/hugeicons.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

import '../utils/app_images.dart';
import "./home_page.dart";
import "../utils/google_sign_in_provider.dart";
import 'choose_college_page.dart';


class LoginPage extends StatefulWidget {

  final String collegeName;
  final String mail;

  const LoginPage({super.key, 
    required this.collegeName,
    required this.mail
  });

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        automaticallyImplyLeading: false,
        title: ElevatedButton.icon(
          onPressed: () {
             Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const ChooseCollegePage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(-1.0, 0.0); // Start the animation from the left
                    const end = Offset.zero; // End at the center
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
          }, 
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(200, 200, 200, .2),
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Color.fromRGBO(200, 200, 200, .3)
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          icon: const Icon(Icons.chevron_left),
          label: const Text("Back"),

        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Container(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // const Text(
              //   "Sign in to UniTrade",
              //   style: TextStyle(
              //     fontSize: 40,
              //     fontWeight: FontWeight.w900
              //   ),
              // ),

              // Image.asset(
              //   AppImages.get('unitrade.png'),
              //   height: 150,
              //   width: 150,
              // ),
          
              // const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.get('unitrade.png'),
                    height: 80,
                    width: 80,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "UniTrade",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w900
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10,),

              const Text(
                "Sign in to your account",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(190, 190, 190, 1),
                ),
              ),

              SizedBox(height: 50,),
          
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
                    const Icon( Icons.info, size: 20, ),
                    const SizedBox(width: 5,),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                          children: <TextSpan>[
                            TextSpan(text: "Since you have chosen $collegeName, only emails ending with "),
                            TextSpan(text: "@$mail", style: const TextStyle( color: Color.fromARGB(255, 253, 159, 164), fontWeight: FontWeight.w600 )),
                            const TextSpan(text: " will be permitted."),
                          ]
                        ),
                      ),
                    ),
                  ],
                )
              ),
          
              const SizedBox(height: 50,),
              
              SignInButton(googleSignInProvider: _googleSignInProvider, print: print, mail: mail),
          
              const SizedBox(height: 50),
          
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'According to our policy, buying and selling are limited to within your college.',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 10,),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'We use your phone\'s location to ensure you\'re on campus, when buying or selling products.',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 10,),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'The content posted on the app is moderated. Any violation of our guidelines will result in a ban from the platform.',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}


class SignInButton extends StatefulWidget {


  final GoogleSignInProvider googleSignInProvider;
  final dynamic print;
  final String mail;

  // Constructor to receive the parameters
  const SignInButton({
    super.key,
    required this.googleSignInProvider,
    required this.print,
    required this.mail
  });


  @override
  _SignInButtonState createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> with TickerProviderStateMixin {
  final double _signInButtonHeight = 50;
  late bool isSigningIn = false;

  late AnimationController _signInButtonGradientController;
  late AnimationController _signInLoadingSpinnerController;
  late GoogleSignInProvider googleSignInProvider;
  late dynamic print;
  late String mail;

  @override
  void initState() {
    super.initState();
    googleSignInProvider = widget.googleSignInProvider;
    print = widget.print;
    mail = widget.mail;
    _signInButtonGradientController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _signInLoadingSpinnerController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(); //
  }

  @override
  void dispose() {
    _signInButtonGradientController.dispose();
    _signInLoadingSpinnerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Animated gradient container
        AnimatedBuilder(
          animation: _signInButtonGradientController,
          builder: (context, child) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: _signInButtonHeight,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(38)),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: const [
                    Color.fromRGBO(33, 150, 243, 1),
                    Color.fromRGBO(76, 175, 80, .3),
                    Color.fromRGBO(255, 235, 59, 1),
                    Color.fromRGBO(255, 29, 13, .9),
                  ],
                  // Rotate the gradient based on the animation
                  transform: GradientRotation(_signInButtonGradientController.value * 2 * math.pi),
                ),
              ),
            );
          },
        ),

        // Elevated Button on top
        SizedBox(
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
              if (isSigningIn) {
                return;
              }

              setState(() {
                isSigningIn = true;
              });
              var box = Hive.box('appPreferences');
                User? user = await googleSignInProvider.signInWithGoogle(context, mail);
                if (user != null) {
                  setState(() {
                    isSigningIn = false;
                  });
                  print.i("Google Sign in successful. Proceeding to main page.");
                  box.put('isLoggedIn', true);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                }
                else {
                  setState(() {
                    isSigningIn = false;
                  });
                  print.w("No user found after Google Login is closed.");
                }
            },
            child: 
              (!isSigningIn)
              ? const Text(
                  'Sign in with Google',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(
                    radius: 8,
                  ),
                  SizedBox(width: 8),
                  Text('Signing you in...', style: TextStyle(fontSize: 18, color: Colors.grey )),
                ],
              )
          ),
        ),
      ],
    );
  }
}
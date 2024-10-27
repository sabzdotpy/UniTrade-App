import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';

import "./pages/welcome_page.dart";
import './pages/choose_college_page.dart';
import "./pages/home_page.dart";

import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // check if app is in dev or prod
  if (kDebugMode) {
    print("App is in [DEBUG MODE]");
    await dotenv.load(fileName: ".env.dev");
  } else {
    await dotenv.load(fileName: ".env.prod");
  }

  
  await Hive.initFlutter();
  await Hive.openBox("appPreferences");
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: const AppInitializer(),

      theme: ThemeData(
        brightness: Brightness.dark, // Set the overall brightness to dark
        primaryColor: const Color.fromRGBO(20, 20, 20, 1),  // Set primary color to black
        scaffoldBackgroundColor: Colors.black, // Set background to black
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // Navbar background color
          foregroundColor: Colors.white, // Navbar text/icon color
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent, // Dark background for Bottom Nav Bar
          selectedItemColor: Colors.white, // Color for selected item (white)
          unselectedItemColor: Colors.white54 // Color for unselected items (faded white)
        ),
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  _AppInitializerState createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late bool isFirstLaunch;
  late bool isLoggedIn;

  final Logger print = Logger(); // Initialize logger

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLaunchState();
    });
  }

  void checkLaunchState() async {
    var box = Hive.box('appPreferences');

    isFirstLaunch = box.get('isFirstTime', defaultValue: true);
    isLoggedIn = box.get('isLoggedIn', defaultValue: false);

    if (isFirstLaunch) {
      print.i("First Time Opening the App. Showing Welcome page.");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomePage()),
      );
    } else if (isLoggedIn) {
      print.i("Already logged in. Showing the home page.");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      print.i("App opened but not logged in. Showing Login Page");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChooseCollegePage()),
      );
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Loading spinner while checking state
      ),
    );
  }
}
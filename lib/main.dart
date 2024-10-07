import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

import "./pages/home_page.dart";
import "./pages/login_page.dart";
import "./pages/welcome_page.dart";

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
  var box = await Hive.openBox("uniBox");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: AppInitializer(),

      theme: ThemeData(
        brightness: Brightness.dark, // Set the overall brightness to dark
        primaryColor: const Color.fromRGBO(20, 20, 20, 1),  // Set primary color to black
        scaffoldBackgroundColor: Colors.black, // Set background to black
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 15, 15, 15), // Navbar background color
          foregroundColor: Colors.white, // Navbar text/icon color
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 15, 15, 15), // Dark background for Bottom Nav Bar
          selectedItemColor: Colors.white, // Color for selected item (white)
          unselectedItemColor: Colors.white54 // Color for unselected items (faded white)
        ),
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  @override
  _AppInitializerState createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late bool isFirstLaunch;
  late bool isLoggedIn;

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLaunchState();
    });
  }

  void checkLaunchState() async {
    var box = Hive.box('uniBox');

    isFirstLaunch = box.get('isFirstTime', defaultValue: true);
    isLoggedIn = box.get('isLoggedIn', defaultValue: false);

    if (isFirstLaunch) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    } else if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Loading spinner while checking state
      ),
    );
  }
}
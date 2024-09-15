import 'package:flutter/material.dart';
import 'package:test_flutter/pages/buy_page.dart';
import 'package:test_flutter/pages/notifications_page.dart';
import 'package:test_flutter/pages/profile_page.dart';
import 'package:test_flutter/pages/sell_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String pageTitle = "";

  final List<Widget> _pages = [
    BuyPage(),
    SellPage(),
    NotificationsPage(),
    ProfilePage()
  ];

  final List<String> pagesTitle = [
    "UniTrade 🔵 BUY",
    "UniTrade 🔵 SELL",
    "Notifications",
    "Profile"
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      pageTitle = pagesTitle[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitle,
          style: TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Buy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell),
            label: 'Sell',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

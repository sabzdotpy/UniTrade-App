import 'package:flutter/material.dart';

import 'package:test_flutter/pages/buy_page.dart';
import 'package:test_flutter/pages/notifications_page.dart';
import 'package:test_flutter/pages/profile_page.dart';
import 'package:test_flutter/pages/sell_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late Widget pageTitle;

  final List<Widget> _pages = [
    const BuyPage(),
    const SellPage(),
    const NotificationsPage(),
    const ProfilePage()
  ];

  final List<Widget> pagesTitle = [
    const Row( children: [ Text("UniTrade"), SizedBox(width: 5,), Icon(Icons.circle, size: 16,), SizedBox(width: 5,), Text("BUY", style: TextStyle( fontWeight: FontWeight.w900 ),)], ),
    const Row( children: [ Text("UniTrade"), SizedBox(width: 5,), Icon(Icons.circle, size: 16,), SizedBox(width: 5,), Text("SELL", style: TextStyle( fontWeight: FontWeight.w900 ),)], ),
    const Text("Notifications", style: TextStyle( fontWeight: FontWeight.w900 ),),
    const Text("Profile", style: TextStyle( fontWeight: FontWeight.w900 ),),
  ];

  @override
  void initState() {
    super.initState();
    print("Init State");
    pageTitle = pagesTitle[_currentIndex];
  }

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
        title: pageTitle
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 1,
            color: const Color.fromRGBO(122, 122, 122, .5),
            margin: const EdgeInsets.only(bottom: 15),
          ),
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            items: const [
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
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:test_flutter/pages/buy_page.dart';
import 'package:test_flutter/pages/choose_college_page.dart';
import 'package:test_flutter/pages/liked_products_page.dart';
import 'package:test_flutter/pages/notifications_page.dart';
import 'package:test_flutter/pages/profile_page.dart';
import 'package:test_flutter/pages/sell_page.dart';
import 'package:test_flutter/utils/google_sign_in_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late Widget pageTitle = const Text("UniTrade");

  final List<Widget> _pages = [
    const BuyPage(),
    const SellPage(),
    const NotificationsPage(),
    ProfilePage()
  ];

  List<Widget> _getPagesTitle(BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Text("UniTrade"),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.circle,
                size: 16,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "BUY",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LikedProductsPage()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.message),
                onPressed: () {
                  // Implement search functionality
                },
              ),
            ],
          )
        ],
      ),
    const Row(
      children: [
        Text("UniTrade"),
        SizedBox(
          width: 5,
        ),
        Icon(
          Icons.circle,
          size: 16,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          "SELL",
          style: TextStyle(fontWeight: FontWeight.w900),
        )
      ],
    ),
    const Text(
      "Notifications",
      style: TextStyle(fontWeight: FontWeight.w900),
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Profile", style: TextStyle( fontWeight: FontWeight.w900 ),),
        Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () async {
                print("Logging out user.");
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logging you out.")),
                );

                try {
                  await FirebaseAuth.instance.signOut();
                  GoogleSignInProvider googleSignInProvider = GoogleSignInProvider();
                  googleSignInProvider.signOut();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ChooseCollegePage()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Error logging out. Please try again.")),
                  );
                }
              },
              child: const Icon(Icons.logout,),
            );
          },
        )
      ],
    ),
    ];
  }

  @override
  void initState() {
    super.initState();
    print("Init State");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        pageTitle = _getPagesTitle(context)[_currentIndex];
      });
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      pageTitle = _getPagesTitle(context)[index];
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

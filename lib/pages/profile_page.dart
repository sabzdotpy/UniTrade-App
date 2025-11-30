import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

import './choose_college_page.dart';
import '../utils/google_sign_in_provider.dart';
import 'product_page.dart';
import 'buy_page.dart';
import '../utils/fetch.dart';

import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Logger print = Logger(printer: PrettyPrinter());

  List<BuyPageProduct> products = [];
  bool isLoading = true;
  User? user;

  String? getName() => user?.displayName;
  String? getEmail() => user?.email;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    // getUsersProducts();
  }

  Future <void> getUsersProducts() async {
    try {
      setState(() {
        isLoading = true;
      });
      print.w("Getting products by user.");
      if (user?.email == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      if (user?.email != null) {
        List<dynamic> res = await fetchProductsByUser(user?.email ?? "fake@mail.com");
        List<BuyPageProduct> parsedProducts = [];

        res.forEach((product) {
          parsedProducts.add(
            BuyPageProduct(
              title: product['title'],
              description: product['description'],
              category: product['category'],
              price: product['price'],
              contact: product['contact'],
              postedAt: product['postedAt'],
              rating: product['rating'],
              productImages: product['productImages'],
              posterName: product['posterName'],
              posterEmail: product['posterEmail'],
              id: product['_id']

            )
          );
        },);
        
        setState(() {
          products = parsedProducts;
          isLoading = false;
        });
        print.i(res);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error fetching products for profile. Please try again."),
      ));
    }
    
  }

  // ignore: unused_element
  Future<void> _logout(BuildContext context) async {
    GoogleSignInProvider  googleSignInProvider = GoogleSignInProvider();

    try {
      await FirebaseAuth.instance.signOut();
      googleSignInProvider.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ChooseCollegePage()), // Navigate to the login page after logout
      );
    } catch (e) {
      print.i("Error during logout: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error logging out. Please try again."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (user) != null ?
       Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              spacing: 18,
              children: [
                SizedBox(width: 1),
                GestureDetector(
                  onDoubleTap: () async {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Logging you out."),
                    ));
                    GoogleSignInProvider  googleSignInProvider = GoogleSignInProvider();
                    try {
                      print.i("Logging out.");
                      await FirebaseAuth.instance.signOut();
                      googleSignInProvider.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ChooseCollegePage()),
                      );
                    } catch (e) {
                      print.i("Error during logout: $e");
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Error logging out. Please try again."),
                      ));
                    }
                  },
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: CachedNetworkImageProvider(
                      user?.photoURL ?? "https://ecointelligentgrowth.net/wp-content/uploads/2020/08/user-placeholder.jpg",
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      user?.displayName ?? "No user found.",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 2),
                    Text(user?.email ?? "No email found.", style: TextStyle(color: Colors.grey),),
                    const SizedBox(height: 16),
                    _buildReputationBox("Buyer Rep", "5"),
                    const SizedBox(height: 4),
                    _buildReputationBox("Seller Rep", "5"),
                  ]
                )
              ],
            ),
            const SizedBox(height: 24),
            const Divider(thickness: 1),
            const SizedBox(height: 16),
            const Text(
              "Posts",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductPage(product: product),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: const Color.fromRGBO(255, 255, 255, .5)),
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(product.productImages[0]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      )
      :
      const Text("Not logged in")
    );
  }

  Widget _buildReputationBox(String title, String value) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.only(left: 6, right: 12, top: 2, bottom: 2),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(76, 175, 80, .25),
              borderRadius: BorderRadius.circular(10)        
            ),
            child: Row(
              children: [
                Icon(Icons.star_rounded, color: Color.fromRGBO(76, 175, 80, .8), size: 14),
                const SizedBox(width: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, color: Color.fromRGBO(76, 175, 80, .8)),
                ),
              ]
            )
          ),
          
        ],
      ),
    );
  }
}

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

  // Future<void> _logout(BuildContext context) async {
  //   GoogleSignInProvider  googleSignInProvider = GoogleSignInProvider();

  //   try {
  //     await FirebaseAuth.instance.signOut();
  //     googleSignInProvider.signOut();
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const ChooseCollegePage()), // Navigate to the login page after logout
  //     );
  //   } catch (e) {
  //     print.i("Error during logout: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text("Error logging out. Please try again."),
  //     ));
  //   }
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           children: [
//             ElevatedButton(
              // onPressed: () async { 
              //   _logout(context);
              //   var box = await Hive.openBox("appPreferences");
              //   box.put('isLoggedIn', false);
              // },
//               child: const Text("Logout"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
                // User? user = FirebaseAuth.instance.currentUser;
                // if (user != null) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     SnackBar(
                //       content: Text("Logged in User: ${user.email}, UID: ${user.uid}"),
                //     ),
                //   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("No user is logged in."),
//                     ),
//                   );
//                 }
//               },
//               child: const Text("Print User")
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

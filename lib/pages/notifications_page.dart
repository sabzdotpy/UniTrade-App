import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/cupertino.dart";
import 'package:flutter/material.dart';
import "buy_page.dart";
import "../utils/fetch.dart";

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  var products = <BuyPageProduct>[];
  String status = "Loading...";

  @override
  void initState() {
    super.initState();
    print("Notifications Page Initialized");
    getNotifications();
  }

  void getNotifications() async {
    Map<dynamic, dynamic> data = await fetchNotifications();
    print("Fetched notifications data: $data");
    print("============================================");

    setState(() {
      status = "";
      products.clear();
      List all = data['notifications'];

      for (var product in all) {
        products.add(
          BuyPageProduct(
            title: product['title'] ?? "TEST Title", 
            description: product['description'] ?? "TEST Desciprtion",  
            category: product['category'] ?? "IOT Components", 
            price: product['price'] ?? 6969, 
            contact: product['contact'],
            postedAt: product['postedAt'] ?? "69 hours ago", 
            rating: product['rating'] ?? 4.0,  
            productImages: product['productImages'] ?? "https://www.google.com",
            posterName: product['posterName'] ?? "Anonymous",
            id: product['_id'] ?? "TEST_ID",
          )
        );
      }
    });

    print("Notifications Page Initialized with ${products.length} products.");

  }

  String extendedTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return "${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() > 1 ? 's' : ''} ago";
    } else if (difference.inDays > 30) {
      return "${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago";
    } else if (difference.inDays > 0) {
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago";
    } else if (difference.inSeconds > 0) {
      return "${difference.inSeconds} second${difference.inSeconds > 1 ? 's' : ''} ago";
    } else {
      return "just now";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            (products.isNotEmpty) ? Flexible(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: products[index].productImages[0],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          products[index].title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          (products[index].description.length > 50) ? "${products[index].description.substring(0, 50)}..." : products[index].description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(255, 255, 255, .4),
                          ),
                        ),
                        trailing: Text( 
                          extendedTimeAgo( DateTime.parse(products[index].postedAt) ), 
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(255, 255, 255, .4),
                          ),
                        ),
                    ),
                  );
                },
              ),
            ) 
            : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: () {
                      getNotifications();
                      print("Refreshing notifications.");
                    },
                    child: Text("No Notifications", style: TextStyle( fontSize: 30, fontWeight: FontWeight.w900),)),
                  SizedBox(height: 20,),
                  Text("You have no notifications yet.", style: TextStyle( fontSize: 20, fontWeight: FontWeight.w500),),
                ],
              ),
            )
          ],
        ),
    );
  }
}
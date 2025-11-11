import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:test_flutter/pages/buy_page.dart';
import 'package:test_flutter/pages/chat_page.dart';

class ProductPage extends StatefulWidget {
  final BuyPageProduct product;

  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with SingleTickerProviderStateMixin {
    bool isLiked = false;
    bool isCheckingLikeStatus = true;
    int likeCount = 0;
    late AnimationController _likeAnimationController;
    late Animation<double> _likeAnimation;
    final List<Map<String, dynamic>> items = [
      {"price": 400, "quantity": 2, "postedAt": DateTime.now().subtract(const Duration(days: 7)), "negotiable": true},
      {"price": 550, "quantity": 1, "postedAt": DateTime.now().subtract(const Duration(days: 3)), "negotiable": false},
      {"price": 300, "quantity": 5, "postedAt": DateTime.now().subtract(const Duration(days: 1)), "negotiable": true},
      {"price": 1200, "quantity": 3, "postedAt": DateTime.now().subtract(const Duration(days: 10)), "negotiable": false},
    ];

    User? user;

    @override
    void initState() {
      super.initState();
      user = FirebaseAuth.instance.currentUser;
      
      _likeAnimationController = AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      );
      
      _likeAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
        CurvedAnimation(
          parent: _likeAnimationController,
          curve: Curves.bounceIn,
        ),
      );
      
      _checkIfLiked();
      _getLikeCount();
    }

    @override
    void dispose() {
      _likeAnimationController.dispose();
      super.dispose();
    }

    String toTitleCase(String input) {
      return input.split(' ').map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join(' ');
    }

    Future<void> _checkIfLiked() async {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) return;

        final token = await user.getIdToken();
        final serverUrl = dotenv.env['SERVER_URL'] ?? 'http://localhost:6969';
        
        final response = await http.get(
          Uri.parse('$serverUrl/liked-products/check/${widget.product.id}'),
          headers: {
            'Authorization': token ?? '',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            isLiked = data['isLiked'] ?? false;
            isCheckingLikeStatus = false;
          });
        } else {
          setState(() {
            isCheckingLikeStatus = false;
          });
        }
      } catch (e) {
        setState(() {
          isCheckingLikeStatus = false;
        });
      }
    }

    Future<void> _getLikeCount() async {
      try {
        final serverUrl = dotenv.env['SERVER_URL'] ?? 'http://localhost:6969';
        
        final response = await http.get(
          Uri.parse('$serverUrl/liked-products/count/${widget.product.id}'),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            likeCount = data['count'] ?? 0;
          });
        }
      } catch (e) {
        // Silently fail for like count
      }
    }

    Future<void> _toggleLike() async {
      // Optimistic update
      final previousLikeState = isLiked;
      final previousLikeCount = likeCount;
      
      setState(() {
        isLiked = !isLiked;
        likeCount = isLiked ? likeCount + 1 : likeCount - 1;
      });
      
      _likeAnimationController.forward().then((_) {
        _likeAnimationController.reverse();
      });

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          throw Exception('User not authenticated');
        }

        final token = await user.getIdToken();
        final serverUrl = dotenv.env['SERVER_URL'] ?? 'http://localhost:6969';
        
        http.Response response;
        
        if (isLiked) {
          // Like the product
          response = await http.post(
            Uri.parse('$serverUrl/liked-products/like'),
            headers: {
              'Authorization': token ?? '',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'productId': widget.product.id}),
          );
        } else {
          // Unlike the product
          response = await http.delete(
            Uri.parse('$serverUrl/liked-products/unlike/${widget.product.id}'),
            headers: {
              'Authorization': token ?? '',
            },
          );
        }

        if (response.statusCode != 200) {
          // Revert on failure
          setState(() {
            isLiked = previousLikeState;
            likeCount = previousLikeCount;
          });
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update like status')),
            );
          }
        } else {
          // Refresh like count from server
          _getLikeCount();
        }
      } catch (e) {
        // Revert on error
        setState(() {
          isLiked = previousLikeState;
          likeCount = previousLikeCount;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }

    void _openChat() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            sellerName: widget.product.posterName,
            sellerProfilePic: user?.photoURL ?? "https://thumbs.dreamstime.com/t/creative-vector-illustration-default-avatar-profile-placeholder-isolated-background-art-design-grey-photo-blank-template-mo-118823351.jpg",
            sellerId: widget.product.id, // using product id for now, will need seller id later
          ),
        ),
      );
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Product Details"),
            elevation: 1,
        ),
        body: Column(
          children: [
            Expanded(
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,                
                    children: [
                        Container(
                          width: double.infinity,
                          height: 250,
                          child: SingleChildScrollView(
                            child: ImageSlideshow(
                              width: double.infinity,
                              height: 250,
                              isLoop: true,
                              indicatorColor: const Color.fromRGBO(255, 255, 255, 1),
                              indicatorBackgroundColor: const Color.fromRGBO(200, 230, 230, .6),
                              indicatorRadius: 4,
                              onPageChanged: (value) {
                                print('Page changed: $value');
                              },
                              autoPlayInterval: 5000,
                              children: [
                                ...widget.product.productImages.map((imageURL) {
                                  return CachedNetworkImage(
                                    imageUrl: imageURL,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url)  { 
                                      return Center(
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          child: CupertinoActivityIndicator(),
                                        ),
                                      );
                                    },
                                    errorWidget: (context, url, error) => Icon(Icons.warning),
                                  );
                                },)
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                child: Text(
                                    toTitleCase(widget.product.title),
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800
                                    ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                child: Text(
                                    "₹${widget.product.price.toString()}",
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 222, 255, 201),
                                    ),
                                ),
                              ),
                              Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: const Color.fromARGB(255, 89, 89, 89), 
                                      backgroundImage: CachedNetworkImageProvider(
                                        (user != null) ? user!.photoURL 
                                        ?? "https://thumbs.dreamstime.com/t/creative-vector-illustration-default-avatar-profile-placeholder-isolated-background-art-design-grey-photo-blank-template-mo-118823351.jpg"
                                        : "https://thumbs.dreamstime.com/t/creative-vector-illustration-default-avatar-profile-placeholder-isolated-background-art-design-grey-photo-blank-template-mo-118823351.jpg"
                                        ),
                                    ),
                                    Text(widget.product.posterName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, ),),
                                    Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(4)),
                                            color: Colors.green[800]
                                        ),
                                        padding: EdgeInsets.symmetric( horizontal: 6, vertical: 2 ),
                                        child: Text(widget.product.rating.toString()),
                                    )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Product Description from the seller", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                    Text(widget.product.description, style: TextStyle(color: Color.fromRGBO(255, 255, 255, .8)),),
                                    SizedBox(height: 30,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: isCheckingLikeStatus ? null : _toggleLike,
                                            icon: isCheckingLikeStatus
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CupertinoActivityIndicator(),
                                                )
                                              : ScaleTransition(
                                                  scale: _likeAnimation,
                                                  child: Icon(
                                                    isLiked ? Icons.favorite : Icons.favorite_border,
                                                    color: isLiked ? Colors.red : Colors.white,
                                                  ),
                                                ),
                                            label: Text(
                                              isCheckingLikeStatus 
                                                ? 'Loading...' 
                                                : (isLiked ? 'Liked${likeCount > 0 ? " ($likeCount)" : ""}' : 'Like${likeCount > 0 ? " ($likeCount)" : ""}'),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isLiked 
                                                ? const Color.fromARGB(255, 60, 30, 30)
                                                : const Color.fromRGBO(80, 80, 80, 1),
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton.icon(
                                            onPressed: _openChat,
                                            icon: const Icon(Icons.chat_bubble_outline),
                                            label: const Text(
                                              'Message',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color.fromARGB(255, 0, 122, 255),
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(vertical: 14),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ProductGrid(),
                    ],
                )
            ),
          ],
        ),
    );
  }
}

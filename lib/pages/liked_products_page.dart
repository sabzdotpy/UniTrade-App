import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import 'package:test_flutter/pages/buy_page.dart';
import 'package:test_flutter/pages/product_page.dart';

class LikedProductsPage extends StatefulWidget {
  const LikedProductsPage({super.key});

  @override
  State<LikedProductsPage> createState() => _LikedProductsPageState();
}

class _LikedProductsPageState extends State<LikedProductsPage> {
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  List<BuyPageProduct> likedProducts = [];
  int currentPage = 1;
  bool hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadLikedProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!isLoading && hasMore) {
        _loadMoreProducts();
      }
    }
  }

  Future<void> _loadLikedProducts() async {
    setState(() {
      isLoading = true;
      hasError = false;
      currentPage = 1;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final serverUrl = dotenv.env['SERVER_URL'] ?? 'http://localhost:6969';
      print(Uri.parse('$serverUrl/liked-products?email=${user.email}&page=$currentPage&limit=19'));
      final response = await http.get(
        Uri.parse('$serverUrl/liked-products?email=${user.email}&page=$currentPage&limit=19'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> productsJson = data['data'] ?? [];
        
        setState(() {
          likedProducts = productsJson.map((json) => BuyPageProduct(
            id: json['_id'] ?? '',
            title: json['title'] ?? '',
            description: json['description'] ?? '',
            category: json['category'] ?? '',
            price: json['price'] ?? 0,
            postedAt: json['postedAt'] ?? '',
            rating: json['rating'] ?? 0.0,
            contact: json['contact'] ?? '',
            posterName: json['posterName'] ?? '',
            posterEmail: json['posterEmail'] ?? '',
            productImages: json['productImages'] ?? [],
          )).toList();
          
          hasMore = productsJson.length >= 20;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load liked products: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = e.toString();
      });
      print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
      print(e);
      print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
    }
  }

  Future<void> _loadMoreProducts() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final serverUrl = dotenv.env['SERVER_URL'] ?? 'http://localhost:6969';
      final nextPage = currentPage + 1;
      
      final response = await http.get(
        Uri.parse('$serverUrl/liked-products?email=${user.email}&page=$nextPage&limit=20'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("~~~~~~~~~~~~~~~~~~~~~~~~ 🟢🟢🟢🟢 ~~~~~~~~~~~~~~~~~~~~~~~~~~");
        print(data);
        print("~~~~~~~~~~~~~~~~~~~~~~~~ 🟢🟢🟢🟢 ~~~~~~~~~~~~~~~~~~~~~~~~~~");
        final List<dynamic> productsJson = data['data'] ?? [];
        
        setState(() {
          likedProducts.addAll(productsJson.map((json) => BuyPageProduct(
            id: json['_id'] ?? '',
            title: json['title'] ?? '',
            description: json['description'] ?? '',
            category: json['category'] ?? '',
            price: json['price'] ?? 0,
            postedAt: json['postedAt'] ?? '',
            rating: json['rating'] ?? 0.0,
            contact: json['contact'] ?? '',
            posterName: json['posterName'] ?? '',
            posterEmail: json['posterEmail'] ?? '',
            productImages: json['productImages'] ?? [],
          )).toList());
          
          currentPage = nextPage;
          hasMore = productsJson.length >= 20;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _unlikeProduct(String productId, int index) async {
    // Optimistically remove from UI
    final removedProduct = likedProducts[index];
    setState(() {
      likedProducts.removeAt(index);
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final serverUrl = dotenv.env['SERVER_URL'] ?? 'http://localhost:6969';
      
      final response = await http.delete(
        Uri.parse('$serverUrl/liked-products/unlike/$productId?email=${user.email}'),
      );

      if (response.statusCode != 200) {
        setState(() {
          likedProducts.insert(index, removedProduct);
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to unlike product')),
          );
        }
      }
    } catch (e) {
      // Revert on error
      setState(() {
        likedProducts.insert(index, removedProduct);
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  String toTitleCase(String input) {
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Products'),
        elevation: 1,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading && likedProducts.isEmpty) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    if (hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                'Failed to load liked products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadLikedProducts,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (likedProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'No liked products yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start liking products to see them here',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLikedProducts,
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: likedProducts.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= likedProducts.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          final product = likedProducts[index];
          return _buildProductCard(product, index);
        },
      ),
    );
  }

  Widget _buildProductCard(BuyPageProduct product, int index) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(product: product),
          ),
        );
        // Refresh the list when coming back
        _loadLikedProducts();
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: product.productImages.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: product.productImages[0],
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CupertinoActivityIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        )
                      : Container(
                          color: Colors.grey[800],
                          child: const Icon(Icons.image, size: 50),
                        ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _unlikeProduct(product.id, index),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      toTitleCase(product.title),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${product.price}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 222, 255, 201),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

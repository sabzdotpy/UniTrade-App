import "dart:ui";
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:test_flutter/pages/product_page.dart';
import 'dart:developer';

import 'package:test_flutter/utils/fetch.dart';

class BuyPage extends StatefulWidget {
  const BuyPage({super.key});

  @override
  State<BuyPage> createState() => _BuyPageState();
}
          
class _BuyPageState extends State<BuyPage> {
  final TextEditingController searchController = TextEditingController();

  late Future<Map<String, dynamic>> dataList;
  late List<BuyPageProduct> allBuyPageItems = [];
  late List<BuyPageProduct> buyPageItems = [];

  Logger print = Logger(printer: PrettyPrinter());

  String status = "";
  bool refreshingAllProducts = false;

  String activeCategory = "All Categories";
  static List<String> categories = [
    "All Categories",
    "IOT Components",
    "Mobile Accessories",
    "Desktop Peripherals",
    "Daily Essentials",
    "Headphones",
    "Speakers"
  ];

  @override
  void initState() {
    super.initState();
    print.i("Buy Page Initialized.");
    fetchAllProducts();
  }

  void fetchAllProducts() async {
    try {
      print.i("Getting data from server.");
      setState(() {
        status = "Loading...";
        refreshingAllProducts = true;
      });
      
      Map<String, dynamic> data = await fetchData();
      setState(() {
        status = "";
        allBuyPageItems.clear();
        List all = data['products'];

        for (var product in all) {
          allBuyPageItems.add(
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

        if (activeCategory == "All Categories") {
          print.i("Found ${buyPageItems.length} items.");
          setState(() {
            buyPageItems = List.from(allBuyPageItems);
          });
        }
        else {
          filterProductsByCategory(activeCategory);
        }

        

        setState(() {
          refreshingAllProducts = false;
        });
      });
    } catch (e) {
      print.i('Error: $e');
      setState(() {
        refreshingAllProducts = false;
        if (e.toString() == "Connection timed out") {
          status = "Server is not responding. Please try again later.";
        } else if (e.toString() == "Connection failed") {
          status = "No internet connection. Could not establish connection to server.";
        } else {
          status = "Error while fetching products.";
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(status),
      ));
    }
  }

  ButtonStyle categoriesButtonStyle(String buttonText) {
    const Map buttonBorderColors = {
      "All Categories": Color.fromRGBO(255, 255, 255, .2),
      "IOT Components": Color.fromRGBO(255, 74, 74, 1),
      "Mobile Accessories": Color.fromRGBO(96, 255, 39, 1),
      "Desktop Peripherals": Color.fromRGBO(40, 126, 255, 1),
      "Daily Essentials": Color.fromRGBO(255, 30, 229, 1),
      "Headphones": Color.fromRGBO(255, 248, 39, 1),
    };

    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 0.1),
      foregroundColor: Colors.white,
      elevation: 0,
      minimumSize: Size.zero,
      padding: const EdgeInsets.fromLTRB(7, 5, 10, 5),
      textStyle: const TextStyle(fontSize: 12),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
              color: (activeCategory == buttonText)
                  ? buttonBorderColors[buttonText]
                  : buttonBorderColors["All Categories"],
              width: 0.5)),
    );

    return style;
  }

  List<Widget> _createCategoriesButtons() {
    List<Widget> buttonList = [];

    buttonList.add(
      ElevatedButton(
        style: categoriesButtonStyle("All Categories"),
        onPressed: () {
          showAllCategoriesDialog(context);
        },
        child: const Row(
          children: [
          SizedBox(
            width: 6,
          ),
          Text('All Categories'),
          Icon(Icons.arrow_drop_down_sharp)
          ],
        ),
      )
    );

    buttonList.add(const SizedBox(width: 10));

    // Dynamically add other buttons from buttonLabels list with SizedBox in between
    for (int i = 1; i < 5; i++) {
      buttonList.add(
        ElevatedButton(
            style: categoriesButtonStyle(categories[i]),
            onPressed: () => filterProductsByCategory(categories[i]),
            child: Row(
              children: [
                const Icon(Icons.circle),
                const SizedBox(
                  width: 10,
                ),
                Text(categories[i])
              ],
            )),
      );

		if (i != categories.length - 1) {
        buttonList.add(const SizedBox(width:  10));
      }
    }

    return buttonList;
  }

  void showAllCategoriesDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Modal',
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.5), // Darken overlay
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(80),
            child: Material(
              color: const Color.fromARGB(255, 35, 35, 35),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                      color: Color.fromRGBO(255, 255, 255, .2), width: 1)),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.category,
                            size: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Choose a category',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 0),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            categories[index],
                            style: const TextStyle(fontSize: 12),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            filterProductsByCategory(categories[index]);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), // Add blur effect
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  void filterProductsByCategory(String category) {
    print.i("Only show $category");

    setState(() {
      buyPageItems = allBuyPageItems;
      activeCategory = category;

      if (category != "All Categories") {
        activeCategory = category;
        var filtered = buyPageItems
            .where((product) => product.category.contains(category));
        buyPageItems = filtered.toList();
      }
    });
  }


  void _onSubmitted(String value) {
    if (value.isEmpty) {
        print.i("Search term is empty. Showing all products");
        setState(() {
          buyPageItems = allBuyPageItems;
        });      
    }
    else {
        print.i("Searching for $value");
        final filteredItems = allBuyPageItems.where((product) {
          final titleLower = product.title.toLowerCase();
          final searchLower = value.toLowerCase();
          return titleLower.contains(searchLower);
        }).toList();
        
        setState(() {
          buyPageItems = filteredItems;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: searchController,
                    onSubmitted:
                        _onSubmitted, // Callback for when the user presses "Done"
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color.fromARGB(150, 255, 255, 255),
                      ),
                      suffixIcon: (searchController.text.isNotEmpty) 
                                    ? IconButton(
                                        icon: const Icon(Icons.clear), 
                                        onPressed: () { 
                                          searchController.clear(); 
                                          _onSubmitted("");
                                        },)
                                    : null,
                      contentPadding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(200, 180, 232, 252),
                            width: 1.0), // Border color when focused
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1.0), // Border color when error occurs
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1.0), // Focused border when there's an error
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      filled: true,
                      hintStyle: const TextStyle(
                          color: Color.fromARGB(150, 255, 255, 255),
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      hintText: "search by product, or categories...",
                      fillColor: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _createCategoriesButtons()),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(13, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              fetchAllProducts();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                              backgroundColor: const Color.fromRGBO(255, 255, 255, .13),
                              foregroundColor: Colors.white, // White text
                              side: const BorderSide(color: Color.fromRGBO(200, 200, 200, .2)), // Grey border
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8), // 4px border radius
                              ),
                            ),
                            child: (!refreshingAllProducts) ? const Text("Refresh") : const CupertinoActivityIndicator()
                            //  Text( !refreshingAllProducts ? "Refresh" : "Loading"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(6, 10, 5, 7),
                    child: (buyPageItems.isNotEmpty)
                        ? ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 0),
                            itemCount: buyPageItems.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: BuyPageItem(
                                  product: buyPageItems[index],
                                ),
                              );
                            },
                          )
                        : (status == "Loading...") ?
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 40,),
                                    Text("Loading..."),
                                  ],
                                ),
                              ),
                            ) : 
                            Center(
                              child: (Text(
                                (status == "") ? "No products found. Request instead." : status,
                                style: const TextStyle(fontSize: 12),
                              )),
                            )))
              ],
            )
          )
      );
  }
}

class BuyPageItem extends StatelessWidget {
  BuyPageProduct product;

  BuyPageItem({
    required this.product,
    super.key,
  });

  final ratingColors = {
    "4": const Color.fromARGB(255, 0, 93, 19),
    "3": const Color.fromARGB(255, 94, 85, 5),
    "2": const Color.fromARGB(255, 134, 74, 18),
    "1": const Color.fromARGB(255, 105, 2, 2)
  };

  Logger print = Logger(printer: PrettyPrinter());

  
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
    return GestureDetector(
      onTap: () {
        inspect(product);
        
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ProductPage(
              product: product,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
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
      child: Container(
        height: 100,
        width: double.infinity, // Full width
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Color.fromRGBO(255, 255, 255, .1),
        ),
        child: Row(
          children: [
            // Image Section
            Container(
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Colors.transparent, Color.fromARGB(255, 20, 20, 20)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.2, 1],
                ),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: product.productImages[0],
                    width: 85,
                    height: 85,
                    fit: BoxFit.cover,
                  )
                  // Image.network(
                  //     product.imageURL,
                  //     width: 85,
                  //     height: 85,
                  //     fit: BoxFit.cover)
                      ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  4,
                  (index) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                        child: BuyPageItemSplitter(),
                      )),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.category,
                          style: TextStyle(
                              fontSize: 10, color: Colors.white.withValues(alpha: .4)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        extendedTimeAgo( DateTime.parse(product.postedAt) ),
                        style: TextStyle(
                            fontSize: 10, color: Colors.white.withValues(alpha: .4)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(3, 1, 5, 1),
                        decoration: BoxDecoration(
                          color: ratingColors[product.rating.toString()[0]],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(
                            Icons.star,
                            size: 12,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            product.rating.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      product.description,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color.fromRGBO(255, 155, 0, 1),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuyPageItemSplitter extends StatelessWidget {
  const BuyPageItemSplitter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 1.5,
      height: 10,
    );
  }
}

// --------------------------- CLASSES

class BuyPageProduct {
  final String title;
  final String description;
  final String category;
  final List<dynamic> productImages;
  final num rating; // supports both int and double, will be coerced to double during init.
  final num price;
  final String contact;
  final String posterName;
  final String postedAt;
  final String id;

  BuyPageProduct({
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.postedAt,
    required num rating,
    required this.contact,
    required this.posterName,
    required this.productImages,
    required this.id,
  }) : rating = rating.toDouble();
}

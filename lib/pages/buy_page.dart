import "dart:ui";

import 'package:flutter/material.dart';
import 'package:test_flutter/utils/AppImages.dart';

class BuyPage extends StatefulWidget {
  const BuyPage({super.key});

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  final TextEditingController searchController = TextEditingController();

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

  String activeCategory = "All Categories";

  static List<BuyPageProduct> allBuyPageItems = [
    BuyPageProduct(
        title: "Arduino UNO",
        imageURL: Appimages.get("arduino.png"),
        description: "lorem ipsum",
        category: "IOT Components",
        price: 599,
        rating: 4,
        postedAt: "2 hours ago"),
    BuyPageProduct(
        title: "Breadboard",
        description: "lorem ipsum",
        category: "IOT Components",
        price: 40,
        rating: 3.5,
        postedAt: "3 hours ago"),
    BuyPageProduct(
        title: "USB Cable (B type)",
        description: "lorem ipsum",
        category: "Mobile Accessories",
        price: 150,
        rating: 4,
        postedAt: "3 hours ago"),
  ];

  static List<String> categories = [
    "All Categories",
    "IOT Components",
    "Mobile Accessories",
    "Desktop Peripherals",
    "Daily Essentials",
    "Headphones",
    "Speakers"
  ];

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

    buttonList.add(SizedBox(width: 10));

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
        buttonList.add(SizedBox(width:  10));
      }
    }

    return buttonList;
  }

  static List<BuyPageProduct> buyPageItems = [
    BuyPageProduct(
        title: "Arduino UNO",
        imageURL: Appimages.get("arduino.png"),
        description: "lorem ipsum",
        category: "IOT Components",
        price: 599,
        rating: 4,
        postedAt: "2 hours ago"),
    BuyPageProduct(
        title: "Breadboard",
        description: "lorem ipsum",
        category: "IOT Components",
        price: 40,
        rating: 3.5,
        postedAt: "3 hours ago"),
    BuyPageProduct(
        title: "USB Cable (B type)",
        description: "lorem ipsum",
        category: "Mobile Accessories",
        price: 150,
        rating: 4,
        postedAt: "3 hours ago"),
  ];

  void addProduct() {
    print("Adding new item");
    setState(() {
      buyPageItems.add(BuyPageProduct(
          title: "Parker Pen",
          description: "rich pen",
          category: "Daily Essentials",
          price: 45,
          rating: 5,
          postedAt: "2 days ago"));
    });
  }

  void showAllCategoriesDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Modal',
      barrierColor: Colors.black.withOpacity(0.7), // Darken overlay
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
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
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
                            style: TextStyle(fontSize: 12),
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
    print("Only show $category");

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

  void _showToast(String message) {
    print("Showing toast.");
  }

  void _onSubmitted(String value) {
    final modifiedText = '$value>'; // Modify the text by adding ">"
    _showToast(modifiedText); // Show the toast with the modified text
  }

  void sayHi() {
    _showToast("Hello there!");
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
            onSubmitted:
                _onSubmitted, // Callback for when the user presses "Done"
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: Color.fromARGB(150, 255, 255, 255),
              ),
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
              fillColor: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Padding(
            padding: const EdgeInsets.only(left: 3),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _createCategoriesButtons()
                // [
                //   ElevatedButton(
                //       style: categoriesButtonStyle("All Categories"),
                //       onPressed: () {
                //         showAllCategoriesDialog(context);
                //       },
                //       child: const Row(
                //         children: [
                //           SizedBox(
                //             width: 6,
                //           ),
                //           Text('All Categories'),
                //           Icon(Icons.arrow_drop_down_sharp)
                //         ],
                //   ),
                //   ),
                //   const SizedBox(
                //     width: 10,
                //   ),
                //   ElevatedButton(
                //       style: categoriesButtonStyle("IOT Components"),
                //       onPressed: () =>
                //           filterProductsByCategory("IOT Components"),

                //       child: const Row(
                //         children: [
                //           Icon(Icons.circle),
                //           SizedBox(
                //             width: 10,
                //           ),
                //           Text('IOT Components')
                //         ],
                //       )),
                //   const SizedBox(
                //     width: 10,
                //   ),
                //   ElevatedButton(
                //       style: categoriesButtonStyle("Mobile Accessories"),
                //       onPressed: () =>
                //           filterProductsByCategory("Mobile Accessories"),
                //       child: const Row(
                //         children: [
                //           Icon(Icons.circle),
                //           SizedBox(
                //             width: 10,
                //           ),
                //           Text('Mobile Accessories')
                //         ],
                //       )),
                //   const SizedBox(
                //     width: 10,
                //   ),
                //   ElevatedButton(
                //       style: categoriesButtonStyle("Desktop Peripherals"),
                //       onPressed: () =>
                //           filterProductsByCategory("Desktop Peripherals"),
                //       child: const Row(
                //         children: [
                //           Icon(Icons.circle),
                //           SizedBox(
                //             width: 10,
                //           ),
                //           Text('Desktop Peripherals')
                //         ],
                //       )),
                //   const SizedBox(
                //     width: 10,
                //   ),
                //   ElevatedButton(
                //       style: categoriesButtonStyle("Daily Essentials"),
                //       onPressed: () =>
                //           filterProductsByCategory("Daily Essentials"),
                //       child: const Row(
                //         children: [
                //           Icon(Icons.circle),
                //           SizedBox(
                //             width: 10,
                //           ),
                //           Text('Daily Essentials')
                //         ],
                //       )),
                //   const SizedBox(
                //     width: 10,
                //   ),
                //   ElevatedButton(
                //       style: categoriesButtonStyle("Headphones"),
                //       onPressed: () => filterProductsByCategory("Headphones"),
                //       child: const Row(
                //         children: [
                //           Icon(Icons.circle),
                //           SizedBox(
                //             width: 10,
                //           ),
                //           Text('Headphones')
                //         ],
                //       )),
                //   const SizedBox(
                //     width: 10,
                //   ),
                // ]
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
                    : const Center(
                        child: (Text(
                          "No products found. Request instead.",
                          style: TextStyle(fontSize: 12),
                        )),
                      )))
      ],
    )));
  }
}

class BuyPageItem extends StatelessWidget {
  BuyPageProduct product;

  BuyPageItem({
    required this.product,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: Image.asset(
                    product.imageURL ?? Appimages.get('image-placeholder.jpg'),
                    width: 85,
                    height: 85,
                    fit: BoxFit.contain)),
          ),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                4,
                (index) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                      child: BuyPageItemSplitter(),
                    )),
          ),
          SizedBox(width: 10),
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
                            fontSize: 10, color: Colors.white.withOpacity(.4)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      product.postedAt,
                      style: TextStyle(
                          fontSize: 10, color: Colors.white.withOpacity(.4)),
                    ),
                  ],
                ),
                SizedBox(
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
                        color: const Color.fromARGB(255, 0, 93, 19),
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
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
                SizedBox(height: 5),
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
  final String? imageURL;
  final num
      rating; // supports both int and double, will be coerced to double during init.
  final double price;
  final String postedAt;

  BuyPageProduct(
      {required this.title,
      required this.description,
      required this.category,
      required this.price,
      required this.postedAt,
      required num rating,
      this.imageURL})
      : rating = rating.toDouble();
}

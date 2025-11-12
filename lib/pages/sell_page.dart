import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_flutter/pages/buy_page.dart';
import 'package:test_flutter/pages/product_page.dart';
import '../utils/fetch.dart';

class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {

  bool postingInProgress = false;

  late List<XFile> productImages = [];
  final ImagePicker imagePicker = ImagePicker();

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  int quantity = 1;
  bool priceNegotiable = false;
  String selectedCategory = "IOT Components";

  String userEmail = "";

  final Map<String, List<DropdownMenuItem>> subCategories = {
    "IOT Components": [
      const DropdownMenuItem(value: "Sensors", child: Text("Sensors"),),
      const DropdownMenuItem(value: "Actuators", child: Text("Actuators"),),
      const DropdownMenuItem(value: "Displays", child: Text("Displays"),),
      const DropdownMenuItem(value: "Connectors", child: Text("Connectors"),),
      const DropdownMenuItem(value: "Power Sources", child: Text("Power Sources"),),
    ],
    "Mobile Accessories": [
      const DropdownMenuItem(value: "Chargers", child: Text("Chargers"),),
      const DropdownMenuItem(value: "Power Banks", child: Text("Power Banks"),),
      const DropdownMenuItem(value: "Data Cable", child: Text("Data Cable"),),
      const DropdownMenuItem(value: "Backcase", child: Text("Backcase"),),
      const DropdownMenuItem(value: "Finger Sleeves", child: Text("Finger Sleeves"),),
    ],
    "Desktop Peripherals": [
      const DropdownMenuItem(value: "Mouse", child: Text("Mouse"),),
      const DropdownMenuItem(value: "Keyboard", child: Text("Keyboard"),),
      const DropdownMenuItem(value: "Pendrive", child: Text("Pendrives"),),
      const DropdownMenuItem(value: "Cables", child: Text("Cables"),),
      const DropdownMenuItem(value: "Adapters", child: Text("Adapters"),),
      const DropdownMenuItem(value: "Laptop Stand", child: Text("Laptop Stand"),),
    ],
    "Daily Essentials":  [
      const DropdownMenuItem(value: "Perfume", child: Text("Perfume"),),
      const DropdownMenuItem(value: "Beauty Accessories", child: Text("Beauty Accessories"),),
      const DropdownMenuItem(value: "Watches", child: Text("Watches"),),
      const DropdownMenuItem(value: "Classroom Accessories", child: Text("Classroom Accessories"),),
    ], 
    "Headphones": [
      const DropdownMenuItem(value: "In-Ear Earphones", child: Text("In-Ear Earphones"),),
      const DropdownMenuItem(value: "Headphones", child: Text("Headphones"),),
      const DropdownMenuItem(value: "Wireless Earbuds", child: Text("Wireless Earbuds"),),
    ], 
    "Speakers": [
      const DropdownMenuItem(value: "Wired Speakers", child: Text("Wired Speakers"),),
      const DropdownMenuItem(value: "Bluetooth Speakers", child: Text("Bluetooth Speakers"),),
    ], 
  };


  Logger print = Logger(printer: PrettyPrinter());

  @override
  void initState() {
    super.initState();
    print.i("Buy Page Initialized.");
    fetchAllProducts();
    
    // wait for firebase init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user?.email != null) {
        setState(() {
          userEmail = user!.email!;
        });
      } else {
        print.e("User is not found, and we are already in sell page.");
      }
    });
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await imagePicker.pickMultiImage(limit: 10);
    if ((productImages.length + images.length) <= 10) {
      setState(() {
        productImages.addAll(images);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum of 10 images allowed.')),
      );
    }   
  }

    // Function to delete an image from the list
  void _deleteImage(int index) {
    setState(() {
      productImages.removeAt(index);
    });
  }



  void fetchAllProducts() async {
  }

  
  Future<void> uploadImages() async {
    print.i(productImages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 6, left: 20, right: 20),
                  child: TextField(
                        controller: productNameController,
                        onSubmitted: (value) {},
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.sell,
                            size: 22,
                            color: Color.fromARGB(150, 255, 255, 255),
                          ),
                          contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                          filled: true,
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(150, 255, 255, 255),
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          hintText: "enter product title",
                          fillColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                  child: Container(
                    child: TextField(
                      minLines: 4,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          controller: productDescController,
                          onSubmitted: (value) {
                            
                          },
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                                Icons.format_align_left_rounded,
                                size: 22,
                                color: Color.fromARGB(150, 255, 255, 255),
                            ),
                            contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
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
                            filled: true,
                            hintStyle: const TextStyle(
                                color: Color.fromARGB(150, 255, 255, 255),
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                            hintText: "enter product description...",
                            fillColor: Colors.white.withOpacity(0.1),
                          ),
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color.fromRGBO(255, 255, 255, .1)
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 5,
                            child: Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Text(
                                "Quantity",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          
                          // 30% Quantity Selector
                          Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color.fromRGBO(255, 255, 255, .08)
                              ),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (quantity > 1) setState(() { quantity--; });;
                                      
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, .1),
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12),  bottomLeft: Radius.circular(12)),
                                      ),
                                      child: const Icon(Icons.remove),
                                    ),
                                  ),
                                  
                                  // Quantity Text
                                  Expanded(
                                    child: Text(
                                      quantity.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  
                                  // Increment Button
                                  InkWell(
                                    onTap: () {
                                      // Increment quantity logic
                                      quantity++;
                                      setState(() {}); // Update UI
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(255, 255, 255, .1),
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(12),  bottomRight: Radius.circular(12)),
                                      ),
                                      child: const Icon(Icons.add),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, .1),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Row(
                      children: [
                        // "Product Category" text (70% width)
                        const Expanded(
                          flex: 5,
                          child: Text(
                            'Product Category',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        // Dropdown (30% width)
                        Expanded(
                          flex: 5,
                          child: DropdownButtonFormField(
                            
                            value: "IOT Components",
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                              ),
                              contentPadding: const EdgeInsets.only(left: 12, right: 6),
                            ),
                            items: const [
                              DropdownMenuItem(value: 'IOT Components', child: Text('IoT Components')),
                              DropdownMenuItem(value: 'Mobile Accessories', child: Text('Mobile Accessories')),
                              DropdownMenuItem(value: 'Desktop Peripherals', child: Text('Desktop Peripherals')),
                              DropdownMenuItem(value: 'Daily Essentials', child: Text('Daily Essentials')),
                              DropdownMenuItem(value: 'Headphones', child: Text('Headphones')),
                              DropdownMenuItem(value: 'Speakers', child: Text('Speakers')),
                            ],
                            onChanged: (value) {
                              print.i("$value Selected.");
                              setState(() {
                                selectedCategory = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    )
                  )
                ),
            
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, .1),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Row(
                      children: [
                        // "Product Category" text (70% width)
                        const Expanded(
                          flex: 5,
                          child: Text(
                            'Product Subcategory',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        // Dropdown (30% width)
                        Expanded(
                          flex: 5,
                          child: DropdownButtonFormField(
                            value: subCategories[selectedCategory]!.first.value,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                              ),
                              contentPadding: const EdgeInsets.only(left: 12, right: 6),
                            ),
                            items: subCategories[selectedCategory],
                            onChanged: (value) {
                              print.i("$value subcategory selected under $selectedCategory.");
                            },
                          ),
                        ),
                      ],
                    )
                  )
                ),
            
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, .1),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Row(
                      children: [
                        // "Product Category" text (70% width)
                        const Expanded(
                          flex: 5,
                          child: Text(
                            'Price',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: TextField(
                            controller: productPriceController,
                            onSubmitted: (value) {},
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                              ),
                              filled: true,
                              hintStyle: const TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 0.5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                              hintText: "Enter your price",
                              fillColor: Colors.white.withOpacity(0.01),
                            ),
                          ),
                        ),
                      ],
                    )
                  )
                ),
            
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, .1),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 6,
                          child: Text(
                            'Contact Number',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        // Dropdown (30% width)
                        Expanded(
                          flex: 6,
                          child: TextField(
                            controller: contactController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                              ),
                              filled: true,
                              hintStyle: const TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 0.5),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                              hintText: "Enter your number",
                              fillColor: Colors.white.withOpacity(0.01),
                            ),
                          )
                        ),
                      ],
                    )
                  )
                ),
            
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Product Images",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ), 
                      ),
                      SizedBox(height: 10,),
                      // Show upload container if no images are added
                      if (productImages!.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Add product images', style: TextStyle(fontSize: 18)),
                              const SizedBox(height: 20),
                              IconButton(
                                icon: const Icon(Icons.add_circle, size: 60, color: Colors.blue),
                                onPressed: _pickImages,
                              ),
                            ],
                          ),
                        )
                      else
                        SizedBox(
                          height: 160,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: productImages!.length + 1,
                            itemBuilder: (context, index) {
                              if (index < productImages!.length) {
                                // Display images
                                return Stack(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      height: MediaQuery.of(context).size.height,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: const Color.fromRGBO(158, 158, 158, .4)),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(productImages![index].path),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    // Positioned delete button in the top-right corner
                                    Positioned(
                                      top: 5,
                                      right: 15,
                                      child: GestureDetector(
                                        onTap: () => _deleteImage(index),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(255, 156, 149, 1),
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.all(Radius.circular(4))
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.black,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return GestureDetector(
                                  onTap: _pickImages,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.3,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: const Color.fromRGBO(158, 158, 158, .4)),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add, size: 40, color: Color.fromARGB(255, 200, 200, 200)),
                                        Text('Add More'),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
            
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: const WidgetStatePropertyAll(Color.fromRGBO(255, 255, 255, .2)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                      side: const WidgetStatePropertyAll(BorderSide(
                        color: Color.fromRGBO(224, 224, 224, .4),
                        width: 1,
                      )),
                       padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        )),
                    ),
                    onPressed: () async {

                      try {
                        if (postingInProgress) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Posting in progress. Please wait...")),
                          );
                          return;
                        }

                        setState(() {
                          postingInProgress = true;
                        });
                        if (productImages.isNotEmpty)  {
                          dynamic res = await postProduct(
                            productNameController.text,
                            productDescController.text,
                            int.parse(productPriceController.text),
                            contactController.text,
                            selectedCategory,
                            userEmail,
                            productImages
                          );
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(content: Text("${res['message']} - ${res['product']}")),
                          // );
                          var product = res['product'];
                          Navigator.push(
                            context,  
                            MaterialPageRoute(
                              builder: (context) => ProductPage( 
                                product: BuyPageProduct(
                                  title: product['title'], 
                                  description: product['description'], 
                                  category: product['category'], 
                                  price: product['price'], 
                                  contact: product['contact'],
                                  postedAt: product['postedAt'], 
                                  rating: product['rating'], 
                                  posterName: product['posterName'], 
                                  productImages: product['productImages'], 
                                  posterEmail: product['posterEmail'],
                                  id: product['_id']
                                ), 
                              )
                            )
                          );
                          print.i(res);
                        }
                        else {
                          print.i("No images found. Cannot post.");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Add atleast one image of the product.')),
                          );
                        }
                        setState(() {
                          postingInProgress = false;
                        });
                      }
                      catch (err) {
                        setState(() {
                          postingInProgress = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("$err")),
                        );
                      }
                    },
                    child: 
                      (!postingInProgress)
                      ?
                      const Text(
                        'POST',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ) : const CupertinoActivityIndicator()
                  ),
                ),

                SizedBox(height: 40,)
            
              ]
            ),
          ),
        ),
    );
  }
}
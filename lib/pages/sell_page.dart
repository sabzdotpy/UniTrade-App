import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class SellPage extends StatefulWidget {
  const SellPage({super.key});

  @override
  State<SellPage> createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {


  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescController = TextEditingController();
  final TextEditingController productPriceController = TextEditingController();

  int quantity = 1;
  bool priceNegotiable = false;

  Logger print = Logger(printer: PrettyPrinter());

  @override
  void initState() {
    super.initState();
    print.i("Buy Page Initialized.");
    fetchAllProducts();
  }

  void fetchAllProducts() async {
  }

  
  void _onSubmitted(String value) {
    if (value.isEmpty) {
        print.i("Search term is empty. Showing all products");
    }
    else {
        print.i("Searching for $value");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 6, left: 20, right: 20),
                child: TextField(
                      controller: productNameController,
                      onSubmitted:
                          _onSubmitted,
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
                        onSubmitted:
                            _onSubmitted,
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
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 7,
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
                                    quantity--;
                                    setState(() {}); // Update UI
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
              
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
                        flex: 6,
                        child: Text(
                          'Product Category',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      // Dropdown (30% width)
                      Expanded(
                        flex: 4,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                            ),
                            contentPadding: EdgeInsets.only(left: 12, right: 6),
                          ),
                          items: [
                            DropdownMenuItem(child: Text('Electronics'), value: 'electronics'),
                            DropdownMenuItem(child: Text('IoT'), value: 'iot'),
                          ],
                          onChanged: (value) {
                            // Handle dropdown selection change
                          },
                        ),
                      ),
                    ],
                  )
                )
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
                        flex: 6,
                        child: Text(
                          'Product Subcategory',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      // Dropdown (30% width)
                      Expanded(
                        flex: 4,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                            ),
                            contentPadding: EdgeInsets.only(left: 12, right: 6),
                          ),
                          items: [
                            DropdownMenuItem(child: Text('Electronics'), value: 'electronics'),
                            DropdownMenuItem(child: Text('IoT'), value: 'iot'),
                          ],
                          onChanged: (value) {
                            // Handle dropdown selection change
                          },
                        ),
                      ),
                    ],
                  )
                )
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
                        flex: 6,
                        child: Text(
                          'Product Category',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      // Dropdown (30% width)
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: productPriceController,
                          onSubmitted:
                              _onSubmitted,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.1)),
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

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
                          'Price Negotiable?',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      // Dropdown (30% width)
                      Expanded(
                        flex: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              priceNegotiable = !priceNegotiable;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: priceNegotiable ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Text(
                              priceNegotiable ? 'Yes' : 'No',
                              style: TextStyle(
                                color: priceNegotiable ? Colors.white : Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      ),
                    ],
                  )
                )
              ),

              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(const Color.fromRGBO(255, 255, 255, .2)),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                    side: WidgetStatePropertyAll(BorderSide(
                      color: const Color.fromRGBO(224, 224, 224, .4),
                      width: 1,
                    )),
                     padding: WidgetStatePropertyAll(EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      )),
                  ),
                  onPressed: () {
                    // Handle button press
                  },
                  child: Text(
                    'POST',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              )

            ]
          ),
        ),
    );
  }
}

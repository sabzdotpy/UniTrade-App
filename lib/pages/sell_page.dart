import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';


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
  String selectedCategory = "iot";

  final Map<String, List<DropdownMenuItem>> subCategories = {
    "iot": [
      const DropdownMenuItem(value: "sensors", child: Text("Sensors"),),
      const DropdownMenuItem(value: "actuators", child: Text("Actuators"),),
      const DropdownMenuItem(value: "displays", child: Text("Displays"),),
      const DropdownMenuItem(value: "connectors", child: Text("Connectors"),),
      const DropdownMenuItem(value: "power_sources", child: Text("Power Sources"),),
    ],
    "mobile_accessories": [
      const DropdownMenuItem(value: "chargers", child: Text("Chargers"),),
      const DropdownMenuItem(value: "power_banks", child: Text("Power Banks"),),
      const DropdownMenuItem(value: "data_cable", child: Text("Data Cable"),),
      const DropdownMenuItem(value: "backcase", child: Text("Backcase"),),
      const DropdownMenuItem(value: "finger_sleeves", child: Text("Finger Sleeves"),),
    ],
    "desktop_peripherals": [
      const DropdownMenuItem(value: "mouse", child: Text("Mouse"),),
      const DropdownMenuItem(value: "keyboard", child: Text("Keyboard"),),
      const DropdownMenuItem(value: "pendrive", child: Text("Pendrives"),),
      const DropdownMenuItem(value: "cables", child: Text("Cables"),),
      const DropdownMenuItem(value: "adapters", child: Text("Adapters"),),
      const DropdownMenuItem(value: "laptop_stand", child: Text("Laptop Stand"),),
    ],
    "daily_essentials":  [
      const DropdownMenuItem(value: "perfume", child: Text("Perfume"),),
      const DropdownMenuItem(value: "beauty_accessories", child: Text("Beauty Accessories"),),
      const DropdownMenuItem(value: "watches", child: Text("Watches"),),
      const DropdownMenuItem(value: "classroom_accessories", child: Text("Classroom Accessories"),),
    ], 
    "headphones": [
      const DropdownMenuItem(value: "in_ear_earphones", child: Text("In-Ear Earphones"),),
      const DropdownMenuItem(value: "headphones1", child: Text("Headphones"),),
      const DropdownMenuItem(value: "wireless_earbuds", child: Text("Wireless Earbuds"),),
    ], 
    "speakers": [
      const DropdownMenuItem(value: "wired_speakers", child: Text("Wired Speakers"),),
      const DropdownMenuItem(value: "bluetooth_speakers", child: Text("Bluetooth Speakers"),),
    ], 
  };


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
                          value: "iot",
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
                            DropdownMenuItem(value: 'iot', child: Text('IoT Components')),
                            DropdownMenuItem(value: 'mobile_accessories', child: Text('Mobile Accessories')),
                            DropdownMenuItem(value: 'desktop_peripherals', child: Text('Desktop Peripherals')),
                            DropdownMenuItem(value: 'daily_essentials', child: Text('Daily Essentials')),
                            DropdownMenuItem(value: 'headphones', child: Text('Headphones')),
                            DropdownMenuItem(value: 'speakers', child: Text('Speakers')),
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

              Padding(
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

              Padding(
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
                        flex: 6,
                        child: Text(
                          'Price',
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

              Padding(
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
                          'Price Negotiable?',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      // Dropdown (30% width)
                      Expanded(
                        flex: 1,
                        child: Switch(
                          value: priceNegotiable,
                          onChanged: (bool value) {
                            setState(() {
                              priceNegotiable = value;
                            });
                          },
                          activeColor: const Color.fromARGB(255, 61, 160, 241),
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor: Colors.grey,
                           
                        ),
                      ),
                    ],
                  )
                )
              ),

              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll(Color.fromRGBO(255, 255, 255, .2)),
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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
                  onPressed: () {
                    // Handle button press
                  },
                  child: const Text(
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

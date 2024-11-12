import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test_flutter/pages/buy_page.dart';

class ProductPage extends StatefulWidget {
  final BuyPageProduct product;

  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
    final List<Map<String, dynamic>> items = [
      {"price": 400, "quantity": 2, "postedAt": DateTime.now().subtract(const Duration(days: 7)), "negotiable": true},
      {"price": 550, "quantity": 1, "postedAt": DateTime.now().subtract(const Duration(days: 3)), "negotiable": false},
      {"price": 300, "quantity": 5, "postedAt": DateTime.now().subtract(const Duration(days: 1)), "negotiable": true},
      {"price": 1200, "quantity": 3, "postedAt": DateTime.now().subtract(const Duration(days: 10)), "negotiable": false},
    ];
    
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
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 25, 25, 25),
                            ),
                            child: Center(child: Text("Product images here")),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                                child: Text(
                                    widget.product.title,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800
                                    ),
                                ),
                              ),
                              Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                children: [
                                    CircleAvatar(backgroundColor: Colors.white,),
                                    Text("Username", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, ),),
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

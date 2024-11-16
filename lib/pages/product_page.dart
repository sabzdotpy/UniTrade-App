import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
                              autoPlayInterval: 3000,
                              children: [
                                ...widget.product.productImages.map((imageURL) {
                                  return CachedNetworkImage(
                                    imageUrl: imageURL,
                                    placeholder: (context, url) => CircularProgressIndicator(),
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
                                    Text(
                                      "Contact: ${widget.product.contact}"
                                    )
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

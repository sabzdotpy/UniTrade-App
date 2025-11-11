import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:test_flutter/pages/buy_page.dart';
import 'package:url_launcher/url_launcher.dart';

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

    User? user;

    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        user = FirebaseAuth.instance.currentUser;
      });
    }

    String toTitleCase(String input) {
      return input.split(' ').map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join(' ');
    }

     void copyToClipboard(String contact) {
      Clipboard.setData(ClipboardData(text: contact));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied contact number to clipboard!')),
      );
    }

    // Future<void> openPhone(String contact) async {
    //   print("Opening phone");
    //   final Uri phoneUri = Uri(scheme: 'tel', path: contact);
    //   await launchUrl(phoneUri);
    // }

    // Future<void> openWhatsApp(String contact) async {
    //   print("Opening Whatsapp");
    //   final Uri whatsappUri = Uri.parse("https://wa.me/$contact");
    //   if (await canLaunchUrl(whatsappUri)) {
    //     print("Can open whatsapp");
    //   }
    //   else {
    //     print("Cannot open whatsapp");
    //   }
    // }



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
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(200, 200, 200, .1),
                                        borderRadius: BorderRadius.circular(2),
                                        border: Border.all(
                                          color: const Color.fromRGBO(255, 255, 255, .05),
                                          width: 1,
                                        )
                                      ),
                                      child: Flex(
                                        direction: Axis.horizontal,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Contact: ${widget.product.contact}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const SizedBox(width: 10),
                                              GestureDetector(
                                                onTap: () => copyToClipboard(widget.product.contact),
                                                child: Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                                  child: const Icon(Icons.copy, size: 20,)
                                                ),
                                              ),
                                              // GestureDetector(
                                              //   onTap: () => openPhone(widget.product.contact),
                                              //   child: Container(
                                              //     margin: const EdgeInsets.symmetric(horizontal: 5),
                                              //     child: const Icon(CupertinoIcons.phone, size: 20),
                                              //   ),
                                              // ),
                                              // GestureDetector(
                                              //   onTap: () => openWhatsApp(widget.product.contact),
                                              //   child: Container(
                                              //     margin: const EdgeInsets.symmetric(horizontal: 5),
                                              //     child: const Icon(Icons.chat_bubble, size: 20),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
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

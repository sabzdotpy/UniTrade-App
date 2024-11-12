import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

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
        body: Expanded(
            child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,                
                children: [
                    Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            border: Border.all(color: Colors.blue, width: 2)
                        ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                      child: Text(
                          "Arduino UNO v1",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                          ),
                      ),
                    ),
                    Row(
                        children: [
                            CircleAvatar(backgroundColor: Colors.white,),
                            Text("Username"),
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(4)),
                                    color: Colors.green[800]
                                ),
                                padding: EdgeInsets.symmetric( horizontal: 6, vertical: 2 ),
                                child: Text("4.8"),
                            )
                        ],
                    ),
                    Text("Lorem, ipsum dolor sit amet consectetur adipisicing elit. Quis non magnam facere in et nemo porro placeat? Eum in ex quidem dolor repudiandae consequuntur consequatur, dolore ipsum. Inventore perferendis adipisci tempore similique vel, distinctio enim ex laborum provident dolorem. Ducimus magni, consequuntur excepturi quas molestiae blanditiis impedit."),
                    // ProductGrid(),
                ],
            )
        ),
    );
  }
}

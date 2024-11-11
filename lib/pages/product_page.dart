import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Placeholder(
        child: Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 0, 0, 1)
            ),
        ),
    );
  }
}
import 'package:flutter/cupertino.dart';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProductPostingLoadingPage extends StatefulWidget {
  const ProductPostingLoadingPage({super.key});

  @override
  State<ProductPostingLoadingPage> createState() => _ProductPostingLoadingPageState();
}

class _ProductPostingLoadingPageState extends State<ProductPostingLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            CupertinoActivityIndicator(radius: 18),

            Text("Uploading your files..."),

            Text("Steps Complete 3/5 - Estimated Time Remaining: 14s")
          ],
        ),
      )
    );
  }
}
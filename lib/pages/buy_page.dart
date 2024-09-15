import 'package:flutter/material.dart';

class BuyPage extends StatelessWidget {
  const BuyPage({super.key});

  @override
  Widget build(BuildContext context) {
    void sayHi() {
      print("Hello there!");
    }

    return Scaffold(
        body: Center(
            child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[800], fontSize: 14),
              hintText: "Search by product name or categories...",
              fillColor: Colors.white70,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(onPressed: sayHi, child: Text("All categories")),
            ElevatedButton(onPressed: sayHi, child: Text("IOT Components")),
            ElevatedButton(onPressed: sayHi, child: Text("Mobile Accessories")),
            ElevatedButton(
                onPressed: sayHi, child: Text("Computer Peripherals")),
            ElevatedButton(onPressed: sayHi, child: Text("Headphones")),
            ElevatedButton(onPressed: sayHi, child: Text("Speakers")),
          ]),
        )
      ],
    )));
  }
}

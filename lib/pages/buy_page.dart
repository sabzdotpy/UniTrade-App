import 'package:flutter/material.dart';

class BuyPage extends StatefulWidget {
  const BuyPage({super.key});

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  final TextEditingController searchController = TextEditingController();
  
  final ButtonStyle categoriesButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromRGBO(255, 255, 255, 0.1),
    foregroundColor: Colors.white,
    elevation: 0,
    minimumSize: Size.zero,
    padding: EdgeInsets.fromLTRB(7, 5, 10, 5),
    textStyle: const TextStyle(
      fontSize: 12
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), // Rounded corners
      side: const BorderSide(color: Color.fromRGBO(255, 255, 255, .2), width: 1)
    ),
  );

   void _showToast(String message) {
    print("Showing toast.");
  }

  void _onSubmitted(String value) {
    final modifiedText = '$value>'; // Modify the text by adding ">"
    _showToast(modifiedText); // Show the toast with the modified text
  }

  void sayHi() {
    _showToast("Hello there!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            onSubmitted: _onSubmitted, // Callback for when the user presses "Done"
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Color.fromARGB(150, 255, 255, 255),),
              contentPadding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(200, 180, 232, 252), width: 1.0), // Border color when focused
                borderRadius: BorderRadius.circular(12.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 1.0), // Border color when error occurs
                borderRadius: BorderRadius.circular(12.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: 1.0), // Focused border when there's an error
                borderRadius: BorderRadius.circular(12.0),
              ),
              filled: true,
              hintStyle: const TextStyle(color: Color.fromARGB(150, 255, 255, 255), fontSize: 14, fontWeight: FontWeight.w400),
              hintText: "search by product, or categories...",
              fillColor: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
          child:
              Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                  children: [
                    ElevatedButton( 
                      style: categoriesButtonStyle, 
                      onPressed: sayHi, 
                      child: Row(
                        children: [SizedBox(width: 6,), Text('All Categories'), Icon(Icons.arrow_drop_down_sharp)],
                      )
                    ),
                    SizedBox(width: 10,),
                    ElevatedButton( 
                      style: categoriesButtonStyle, 
                      onPressed: sayHi, 
                      child: Row(
                        children: [Icon(Icons.circle), SizedBox(width: 10,), Text('IOT Components')],
                      )
                    ),
                    SizedBox(width: 10,),
                    ElevatedButton( 
                      style: categoriesButtonStyle, 
                      onPressed: sayHi, 
                      child: Row(
                        children: [Icon(Icons.circle), SizedBox(width: 10,), Text('Mobile Accessories')],
                      )
                    ),
                    SizedBox(width: 10,),
                    ElevatedButton( 
                      style: categoriesButtonStyle, 
                      onPressed: sayHi, 
                      child: Row(
                        children: [Icon(Icons.circle), SizedBox(width: 10,), Text('Desktop Peripherals')],
                      )
                    ),
                    SizedBox(width: 10,),
                    ElevatedButton( 
                      style: categoriesButtonStyle, 
                      onPressed: sayHi, 
                      child: Row(
                        children: [Icon(Icons.circle), SizedBox(width: 10,), Text('Daily Essentials')],
                      )
                    ),
                    SizedBox(width: 10,),
                    ElevatedButton( 
                      style: categoriesButtonStyle, 
                      onPressed: sayHi, 
                      child: Row(
                        children: [Icon(Icons.circle), SizedBox(width: 10,), Text('Headphones')],
                      )
                    ),
                    SizedBox(width: 10,),
                  ]),
              ),
        )
      ],
    )));
  }
}
